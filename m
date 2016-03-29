Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:43569 "EHLO
	mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbcC2FEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 01:04:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx.mokrynskyi.com (Postfix) with ESMTP id 72CDF13EAC
	for <linux-media@vger.kernel.org>; Tue, 29 Mar 2016 04:58:21 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
	by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WEZ2qRai88Pl for <linux-media@vger.kernel.org>;
	Tue, 29 Mar 2016 04:58:20 +0000 (UTC)
Received: from [192.168.1.167] (unknown [37.57.231.109])
	by mx.mokrynskyi.com (Postfix) with ESMTPSA id 0478013EA4
	for <linux-media@vger.kernel.org>; Tue, 29 Mar 2016 04:58:18 +0000 (UTC)
To: linux-media@vger.kernel.org
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: Can't use USB sound card on 4.6-rc1, works fine on 4.5.0
Message-ID: <1ceab9c3-4bf1-5e35-f70b-d119f9d30d6a@mokrynskyi.com>
Date: Tue, 29 Mar 2016 07:58:17 +0300
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030307070702010006030409"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030307070702010006030409
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Originally reported here:=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D115301 but Greg=20
Kroah-Hartman suggested to redirect this to mailing list here.

When I attach USB sound card to USB hub following output appears in dmesg=
 output:

[   83.074063] usb 3-6: new high-speed USB device number 10 using xhci_hc=
d
[   83.239600] usb 3-6: New USB device found, idVendor=3D041e, idProduct=3D=
322c
[   83.239602] usb 3-6: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[   83.239603] usb 3-6: Product: SB Omni Surround 5.1
[   83.239604] usb 3-6: Manufacturer: Creative Technology Ltd
[   83.239605] usb 3-6: SerialNumber: 000000Q6
[   91.849418] usb 3-9.1: new high-speed USB device number 11 using xhci_=
hcd
[   91.924078] usb 3-9.1: New USB device found, idVendor=3D041e, idProduc=
t=3D322c
[   91.924081] usb 3-9.1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[   91.924083] usb 3-9.1: Product: SB Omni Surround 5.1
[   91.924084] usb 3-9.1: Manufacturer: Creative Technology Ltd
[   91.924086] usb 3-9.1: SerialNumber: 000000Q6
[   91.968105] usbhid 3-9.1:1.4: can't add hid device: -71
[   91.968117] usbhid: probe of 3-9.1:1.4 failed with error -71
[   92.195856] usb 3-9.1: USB disconnect, device number 11
[   92.362345] usb 3-9.1: new high-speed USB device number 12 using xhci_=
hcd
[   92.436872] usb 3-9.1: New USB device found, idVendor=3D041e, idProduc=
t=3D322c
[   92.436875] usb 3-9.1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[   92.436876] usb 3-9.1: Product: SB Omni Surround 5.1
[   92.436877] usb 3-9.1: Manufacturer: Creative Technology Ltd
[   92.436878] usb 3-9.1: SerialNumber: 000000Q6
[  103.716208] usbhid 3-6:1.4: can't add hid device: -110
[  103.716221] usbhid: probe of 3-6:1.4 failed with error -110
[  103.716287] usb 3-6: USB disconnect, device number 10
[  107.438265] hid-generic 0003:041E:322C.0005: usb_submit_urb(ctrl) fail=
ed: -1
[  107.438275] hid-generic 0003:041E:322C.0005: timeout initializing repo=
rts
[  107.438359] input: Creative Technology Ltd SB Omni Surround 5.1 as /de=
vices/pci0000:00/0000:00:14.0/usb3/3-9/3-9.1/3-9.1:1.4/0003:041E:322C.000=
5/input/input28
[  107.489481] hid-generic 0003:041E:322C.0005: input,hidraw4: USB HID v1=
=2E11 Keyboard [Creative Technology Ltd SB Omni Surround 5.1] on usb-0000=
:00:14.0-9.1/input4
[  107.510027] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000014
[  107.510056] IP: [<ffffffffa1511a1b>] usb_audio_probe+0x2bb/0x980 [snd_=
usb_audio]
[  107.510087] PGD 0
[  107.510095] Oops: 0000 [#1] SMP
[  107.510107] Modules linked in: snd_usb_audio(+) snd_usbmidi_lib vboxpc=
i(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) ccm xt_conntrack ipt_MASQ=
UERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv=
4 nf_nat_ipv4 xt_addrtype iptable_filter ip_tables x_tables nf_nat nf_con=
ntrack br_netfilter bridge stp llc bbswitch(OE) bnep zram lz4_compress bi=
nfmt_misc uvcvideo videobuf2_vmalloc btusb videobuf2_memops btrtl videobu=
f2_v4l2 btbcm videobuf2_core btintel bluetooth videodev media arc4 nvidia=
_uvm(POE) nls_iso8859_1 x86_pkg_temp_thermal intel_powerclamp snd_hda_cod=
ec_realtek coretemp snd_hda_codec_hdmi snd_hda_codec_generic kvm_intel kv=
m snd_hda_intel snd_hda_codec irqbypass crct10dif_pclmul snd_hwdep crc32_=
pclmul snd_hda_core ghash_clmulni_intel snd_pcm iwlmvm aesni_intel aes_x8=
6_64 glue_helper
[  107.510352]  lrw snd_seq_midi ablk_helper mac80211 snd_seq_midi_event =
cryptd joydev nvidia_drm(POE) nvidia_modeset(POE) serio_raw snd_rawmidi i=
wlwifi snd_seq nvidia(POE) cfg80211 snd_timer rtsx_pci_ms snd_seq_device =
lpc_ich mei_me memstick mei snd soundcore shpchp intel_smartconnect mac_h=
id mxm_wmi iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi tuxedo_wm=
i(OE) wmi parport_pc sunrpc ppdev lp parport usb_storage hid_generic usbh=
id hid rtsx_pci_sdmmc i915 i2c_algo_bit drm_kms_helper syscopyarea sysfil=
lrect sysimgblt fb_sys_fops psmouse firewire_ohci ahci drm firewire_core =
libahci r8169 rtsx_pci mii crc_itu_t video
[  107.510548] CPU: 4 PID: 3993 Comm: systemd-udevd Tainted: P           =
OE   4.6.0-rc1-haswell #1
[  107.510571] Hardware name: Notebook                         P15SM     =
                     /P15SM                          , BIOS 1.03.04PM v2 =
02/27/2014
[  107.510607] task: ffff880379f49d40 ti: ffff8803580a0000 task.ti: ffff8=
803580a0000
[  107.510626] RIP: 0010:[<ffffffffa1511a1b>]  [<ffffffffa1511a1b>] usb_a=
udio_probe+0x2bb/0x980 [snd_usb_audio]
[  107.510658] RSP: 0018:ffff8803580a3ab0  EFLAGS: 00010246
[  107.510672] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000=
0000000
[  107.510691] RDX: ffff88032cf9e1c0 RSI: ffff880415453338 RDI: ffff88032=
cf9e1c0
[  107.510709] RBP: ffff8803580a3b18 R08: 0000000000000000 R09: ffffffff8=
146f056
[  107.510728] R10: ffffea000f87ea00 R11: ffff8803c6566872 R12: ffff8800b=
e7c1b00
[  107.510747] R13: 0000000000000004 R14: ffff8800be7c1b54 R15: ffff88035=
8188409
[  107.510766] FS:  00007f92099738c0(0000) GS:ffff88042fb00000(0000) knlG=
S:0000000000000000
[  107.510787] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.510802] CR2: 0000000000000014 CR3: 000000035802f000 CR4: 000000000=
01406e0
[  107.510821] Stack:
[  107.510827]  ffff8803148da0c8 0000000000000000 ffff88035818b800 ffff88=
03148da0c8
[  107.510849]  00000000580a3b18 ffff880353d8a000 3a65313430425355 ffffff=
0063323233
[  107.510872]  ffff8803a18b4098 ffff8803a18b4000 ffffffffa152e188 ffff88=
035818b830
[  107.510895] Call Trace:
[  107.510907]  [<ffffffff8167c8fd>] usb_probe_interface+0x1bd/0x300
[  107.510925]  [<ffffffff815bde4c>] driver_probe_device+0x22c/0x440
[  107.510942]  [<ffffffff815be131>] __driver_attach+0xd1/0xf0
[  107.510960]  [<ffffffff815be060>] ? driver_probe_device+0x440/0x440
[  107.510977]  [<ffffffff815bba64>] bus_for_each_dev+0x64/0xa0
[  107.510993]  [<ffffffff815bd55e>] driver_attach+0x1e/0x20
[  107.511008]  [<ffffffff815bd02b>] bus_add_driver+0x1eb/0x280
[  107.511025]  [<ffffffff815bea60>] driver_register+0x60/0xe0
[  107.511040]  [<ffffffff8167b274>] usb_register_driver+0x84/0x140
[  107.511056]  [<ffffffffa14e4000>] ? 0xffffffffa14e4000
[  107.511074]  [<ffffffffa14e401e>] usb_audio_driver_init+0x1e/0x1000 [s=
nd_usb_audio]
[  107.511096]  [<ffffffff8100211b>] do_one_initcall+0xab/0x1d0
[  107.511112]  [<ffffffff811b4d81>] ? __vunmap+0x81/0xd0
[  107.511127]  [<ffffffff811d1ca6>] ? kmem_cache_alloc_trace+0x176/0x1e0=

[  107.511145]  [<ffffffff811d2f01>] ? kfree+0x151/0x160
[  107.511162]  [<ffffffff8116fb08>] do_init_module+0x5f/0x1df
[  107.511178]  [<ffffffff810f98da>] load_module+0x221a/0x2890
[  107.511194]  [<ffffffff810f6200>] ? __symbol_put+0x40/0x40
[  107.511210]  [<ffffffff810fa183>] SYSC_finit_module+0xc3/0xf0
[  107.511226]  [<ffffffff810fa1ce>] SyS_finit_module+0xe/0x10
[  107.511242]  [<ffffffff81003c89>] do_syscall_64+0x69/0x110
[  107.511258]  [<ffffffff818661e5>] entry_SYSCALL64_slow_path+0x25/0x25
[  107.511282] Code: 02 00 4c 89 e7 8b 75 bc e8 93 73 00 00 85 c0 89 c1 0=
f 88 9b 00 00 00 49 8b 7c 24 10 e8 0f 2f e8 fe 85 c0 89 c1 0f 88 87 00 00=
 00 <80> 7b 14 00 0f 85 47 04 00 00 49 63 04 24 4c 89 24 c5 c0 1a 53
[  107.511365] RIP  [<ffffffffa1511a1b>] usb_audio_probe+0x2bb/0x980 [snd=
_usb_audio]
[  107.511385]  RSP <ffff8803580a3ab0>
[  107.511393] CR2: 0000000000000014
[  107.516696] ---[ end trace 3056620be95ce868 ]---

Also my laptop has 3 USB 3.0 ports and 1 USB 2.0 port and that 2.0 port s=
topped working in 4.6.0-rc1, which I think is related, when I plug sound =
card there LED on it doesn't even flashing.

I'm not on mailing list, so send me copy when answering, please.

--=20
Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Skype: nazar-pc
Diaspora: nazarpc@diaspora.mokrynskyi.com
Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8E=
F5261249



--------------ms030307070702010006030409
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: Кріптографічний підпис S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuMwggT5MIID4aADAgECAhBk6v6TVth6hqLyl5xsFf+NMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTUxMjIyMDYwNTUxWhcNMTYxMjIyMDYwNTUxWjBEMR0wGwYDVQQDDBRuYXph
ckBtb2tyeW5za3lpLmNvbTEjMCEGCSqGSIb3DQEJARYUbmF6YXJAbW9rcnluc2t5aS5jb20w
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCugsLCcazI+Sjl29kaCHer/z6I0aPy
cKYqk4Bk0jUE6CcfQLX98E8b1sc2kbBjwd+jPPvWtqSGHzLUKLL1jfXJC6X5At+UHNdWiU6n
xaKnCiWiV0NZK6AVfrr+KdP+f1gYfMryPp/JkzcRDquML+YSz0BJ3ODaU538lDtC2sPeH7hY
nTiuMBfL6h2c680MF9UrIUqvqJ94QEillrDShGxaMHIWZepLxydmACnI9Sga8dZPjG84hV//
JKGRmdlQ1fA7g0LUE2hZcY/zdB6Qey87ctNkND/bQfghbArOdJZK2/cal0xJ6znrPAyqs7wj
2HVz8/coOlXPPsV4OkoA9X1PAgMBAAGjggG0MIIBsDALBgNVHQ8EBAMCBLAwHQYDVR0lBBYw
FAYIKwYBBQUHAwIGCCsGAQUFBwMEMAkGA1UdEwQCMAAwHQYDVR0OBBYEFCfmAiR7cI5aUj1L
5j5v0+wVzVy1MB8GA1UdIwQYMBaAFCSBbDlhvkkPj7cbRivJKLUnSG1oMG8GCCsGAQUFBwEB
BGMwYTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDkGCCsGAQUFBzAC
hi1odHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9zY2EuY2xpZW50MS5jcnQwOAYDVR0f
BDEwLzAtoCugKYYnaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2NhLWNsaWVudDEuY3JsMB8G
A1UdEQQYMBaBFG5hemFyQG1va3J5bnNreWkuY29tMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBGBgNVHSAEPzA9MDsGCysGAQQBgbU3AQIEMCwwKgYIKwYBBQUHAgEW
Hmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0BAQsFAAOCAQEAkIZk
GJPfY91CrJnZzsF0+qviIsqRCWqdT64E5ttyODEvfo9TVccBvwTgVZzKJY2e+ALaDNX0dBH+
9YXMUg5pNfXGHauhQjGan8bdKsaLhvqaq3g0CO1oZU38pqizWTzQYbzu62414VeIDauHMbFD
pdRD0Egx/iY8R7JAO9k+hciD0W/L7FPRU7UTtz1vPqrKO54mYNFMn6EUhR2poM1j0dmwZH4W
Cly6N88RT6zhncbgDnjKr6+IHCxSP0E75uf+6kgbYRtwHnLydUIZdkEESlHhKdgJJFoL7nHr
PU3kWyAMrRdf2YtCwDa5USI5mE9v6sf0ynMrThlXbkb12Dz9wzCCBeIwggPKoAMCAQICEGun
in0K14jWUQr5WeTntOEwDQYJKoZIhvcNAQELBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE1
MTIxNjAxMDAwNVoXDTMwMTIxNjAxMDAwNVowdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0
YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5
MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAL192vfDon2D9luC/dtbX64eG3XAtRmvmCSsu1d52DXsCR58zJQb
CtB2/A5uFqNxWacpXGGtTCRk9dEDBlmixEd8QiLkUfvHpJX/xKnmVkS6Iye8wUbYzMsDzgnp
azlPg19dnSqfhM+Cevdfa89VLnUztRr2cgmCfyO9Otrh7LJDPG+4D8ZnAqDtVB8MKYJL6QgK
yVhhaBc4y3bGWxKyXEtx7QIZZGxPwSkzK3WIN+VKNdkiwTubW5PIdopmykwvIjLPqbJK7yPw
FZYekKE015OsW6FV+s4DIM8UlVS8pkIsoGGJtMuWjLL4tq2hYQuuN0jhrxK1ljz50hH23gA9
cbMCAwEAAaOCAWQwggFgMA4GA1UdDwEB/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIBADAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8v
Y3JsLnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmwwZgYIKwYBBQUHAQEEWjBYMCQGCCsGAQUFBzAB
hhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wMAYIKwYBBQUHMAKGJGh0dHA6Ly9haWEuc3Rh
cnRzc2wuY29tL2NlcnRzL2NhLmNydDAdBgNVHQ4EFgQUJIFsOWG+SQ+PtxtGK8kotSdIbWgw
HwYDVR0jBBgwFoAUTgvvGqRAW6UXaYcwyjRoQ9BBrvIwPwYDVR0gBDgwNjA0BgRVHSAAMCww
KgYIKwYBBQUHAgEWHmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0B
AQsFAAOCAgEAi+P3h+wBi4StDwECW5zhIycjBL008HACblIf26HY0JdOruKbrWDsXUsiI0j/
7Crft9S5oxvPiDtVqspBOB/y5uzSns1lZwh7sG96bYBZpcGzGxpFNjDmQbcM3yl3WFIRS4Wh
NrsOY14V7y2IrUGsvetsD+bjyOngCIVeC/GmsmtbuLOzJ606tEc9uRbhjTu/b0x2Fo+/e7Uk
QvKzNeo7OMhijixaULyINBfCBJb+e29bLafgu6JqjOUJ9eXXj20p6q/CW+uVrZiSW57+q5an
2P2i7hP85jQJcy5j4HzA0rSiF3YPhKGAWUxKPMAVGgcYoXzWydOvZ3UDsTDTagXpRDIKQLZo
02wrlxY6iMFqvlzsemVf1odhQJmi7Eh5TbxI40kDGcBOBHhwnaOumZhLP+SWJQnjpLpSlUOj
95uf1zo9oz9e0NgIJoz/tdfrBzez76xtDsK0KfUDHt1/q59BvDI7RX6gVr0fQoCyMczNzCTc
RXYHY0tq2J0oT+bsb6sH2b4WVWAiJKnSYaWDjdA70qHX4mq9MIjO/ZskmSY8wtAk24orAc0v
wXgYanqNsBX5Yv4sN4Z9VyrwMdLcusP7HJgRdAGKpkR2I9U4zEsNJQJewM7S4Jalo1DyPrLp
L2nTET8ZrSl5Utp1UeGp/2deoprGevfnxWB+vHNQiu85o6MxggPMMIIDyAIBATCBiTB1MQsw
CQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEpMCcGA1UECxMgU3RhcnRDb20g
Q2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0Q29tIENsYXNzIDEgQ2xp
ZW50IENBAhBk6v6TVth6hqLyl5xsFf+NMA0GCWCGSAFlAwQCAQUAoIICEzAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjAzMjkwNDU4MTdaMC8GCSqGSIb3
DQEJBDEiBCDD5J8mgDnjfnHZemc1O+tTziQqPOFUnt1zANPsMpG7OTBsBgkqhkiG9w0BCQ8x
XzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwIC
AgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3
EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNV
BAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENv
bSBDbGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTCBnAYLKoZIhvcNAQkQAgsx
gYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsT
IFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBD
bGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTANBgkqhkiG9w0BAQEFAASCAQAk
Ygs95bQRboZHKhtT99bGGrNd8jAHQ4cH8Pw2XYQI+rOS/okkiibJWtZShVuojRsHbC4rZmLF
eNGa1IO7gLvZqN2SLmM4FLc118vc3TUha14vhzar7GQwdeSzB1XS3iweGWd0pdykvTM3uwFR
Acd/DYs/p7b+NnoqDGXPcCWQkHDAv2/5/0zr+gyv0K7MtOOnWWFbImdpyX4Y3tzvl3XPkrfI
mHluaRos9AO9IhHdg4JZXLUi/SYBD6OkNSHsJwxwOaPpWpf2wRHksmMLQRyyHkEJff65jJjs
s9xgkNGu9c/3vRa7D2OIKa0GRGHU8bRjfUcrgIYvYNIglFwF8eVMAAAAAAAA
--------------ms030307070702010006030409--
