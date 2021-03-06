open OUnit

let test_unmarshal_with_options () =
  let datagram = Cstruct.create 40 in
  Cstruct.blit_from_string ("\x46\xc0\x00\x28\x00\x00\x40\x00\x01\x02" ^
                            "\x42\x49\xc0\xa8\x01\x08\xe0\x00\x00\x16\x94\x04\x00\x00\x22" ^
                            "\x00\xfa\x02\x00\x00\x00\x01\x03\x00\x00\x00\xe0\x00\x00\xfb") 0 datagram 0 40;
  match Ipv4_packet.Unmarshal.of_cstruct datagram with
  | Result.Ok ({Ipv4_packet.options ; _}, payload) ->
      assert_equal (Cstruct.len options) 4;
      assert_equal (Cstruct.len payload) 16;
      Lwt.return_unit
  | _ ->
      Alcotest.fail "Fail to parse ip packet with options"


let test_unmarshal_without_options () =
  let datagram = Cstruct.create 40 in
  Cstruct.blit_from_string ("\x45\x00\x00\x28\x19\x29\x40\x00\x34\x06\x98\x75\x36\xb7" ^
                            "\x9c\xca\xc0\xa8\x01\x08\x00\x50\xca\xa6\x6f\x19\xf4\x76" ^
                            "\x00\x00\x00\x00\x50\x04\x00\x00\xec\x27\x00\x00") 0 datagram 0 40;
  match Ipv4_packet.Unmarshal.of_cstruct datagram with
  | Result.Ok ({Ipv4_packet.options ; _}, payload) ->
      assert_equal (Cstruct.len options) 0;
      assert_equal (Cstruct.len payload) 20;
      Lwt.return_unit
  | _ ->
      Alcotest.fail "Fail to parse ip packet with options"

let suite = [
  "unmarshal ip datagram with options", `Quick, test_unmarshal_with_options;
  "unmarshal ip datagram without options", `Quick, test_unmarshal_without_options
  ]
