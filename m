Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:36860 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbbAFJ34 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jan 2015 04:29:56 -0500
Date: Tue, 6 Jan 2015 10:29:55 +0100 (CET)
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] [Patch] implement video driver for sur40
In-Reply-To: <549443C9.6090900@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1501061018580.3223@butterbrot>
References: <5492D7E8.504@butterbrot.org> <5492E091.1060404@xs4all.nl> <54943680.3020007@butterbrot.org> <549437DA.6090601@xs4all.nl> <54943CC2.6040803@butterbrot.org> <549443C9.6090900@xs4all.nl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-655671958-1420536595=:3223"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-655671958-1420536595=:3223
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Fri, 19 Dec 2014, Hans Verkuil wrote:
> drivers/media remains under heavy development, so for video capture drivers
> like yours you should always patch against either the mainline linux tree
> or (preferred) the media_tree.git repo (git://linuxtv.org/media_tree.git,
> master branch).
As per your suggestion, I've switched development to 3.18, and now I'm 
nearly there in terms of v4l2-compliance (also see attachment).

There's only one failing test left, which is this one:

Streaming ioctls:
 	test read/write: OK
 		fail: v4l2-test-buffers.cpp(284): g_field() == V4L2_FIELD_ANY
 		fail: v4l2-test-buffers.cpp(611): buf.check(q, last_seq)
 		fail: v4l2-test-buffers.cpp(884): captureBufs(node, q, m2m_q, frame_count, false)
 	test MMAP: FAIL
 	test USERPTR: OK (Not Supported)
 	test DMABUF: Cannot test, specify --expbuf-device

Total: 45, Succeeded: 44, Failed: 1, Warnings: 0

Could you give some hints on what this means?


On a different note, I'm getting occasional warnings in syslog when I run 
a regular video streaming application (e.g. cheese):

------------[ cut here ]------------
WARNING: CPU: 1 PID: 4995 at /home/apw/COD/linux/drivers/media/v4l2-core/videobuf2-core.c:2144 __vb2_queue_cancel+0x1d0/0x240 [videobuf2_core]()
Modules linked in: sur40(OE) videobuf2_dma_contig videobuf2_memops videobuf2_core v4l2_common videodev media dm_crypt wl(POE) snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel rfcomm bnep joydev input_polldev snd_hda_controller snd_hda_codec snd_hwdep kvm_amd kvm snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi edac_core snd_seq snd_seq_device serio_raw snd_timer sp5100_tco k10temp edac_mce_amd i2c_piix4 snd btusb soundcore bluetooth cfg80211 ipmi_si ppdev lp parport_pc ipmi_msghandler parport tpm_infineon mac_hid shpchp hid_apple usbhid hid uas usb_storage pata_acpi radeon i2c_algo_bit ttm psmouse drm_kms_helper pata_atiixp drm r8169 ahci mii libahci [last unloaded: sur40]
CPU: 1 PID: 4995 Comm: cheese Tainted: P           OE  3.17.1-031701-generic #201410150735
Hardware name: Samsung SUR40/SDNE-R78BA2-20, BIOS SDNE-R78BA2-2000 11/04/2011
0000000000000860 ffff8800c2c1bd28 ffffffff81796c37 0000000000000007
0000000000000000 ffff8800c2c1bd68 ffffffff81074a3c ffff8800c2c1bd58
fff8800c05904f8 ffff8800c05904d0 ffff8800abd65d38 ffff8800abd65d38
Call Trace:
[<ffffffff81796c37>] dump_stack+0x46/0x58
[<ffffffff81074a3c>] warn_slowpath_common+0x8c/0xc0
[<ffffffff81074a8a>] warn_slowpath_null+0x1a/0x20
[<ffffffffc05b7a10>] __vb2_queue_cancel+0x1d0/0x240 [videobuf2_core]
[<ffffffffc05bb3ee>] vb2_queue_release+0x1e/0x40 [videobuf2_core]
[<ffffffffc05bb481>] _vb2_fop_release+0x71/0xb0 [videobuf2_core]
[<ffffffffc05bb4ee>] vb2_fop_release+0x2e/0x50 [videobuf2_core]
[<ffffffffc0c1f491>] v4l2_release+0x41/0x90 [videodev]
[<ffffffff811eb34d>] __fput+0xbd/0x250
[<ffffffff811eb52e>] ____fput+0xe/0x10
[<ffffffff81091504>] task_work_run+0xc4/0xe0
[<ffffffff810776a6>] do_exit+0x196/0x470
[<ffffffff81082822>] ? zap_other_threads+0x82/0xa0
[<ffffffff81077a14>] do_group_exit+0x44/0xa0
[<ffffffff81077a87>] SyS_exit_group+0x17/0x20
[<ffffffff817a47ad>] system_call_fastpath+0x1a/0x1f
---[ end trace 451ed974170f6e44 ]---

Does this mean the driver consumes too much CPU resources?

Thanks for your help & best regards, Florian
-- 
"_Nothing_ brightens up my morning. Coffee simply provides a shade of
grey just above the pitch-black of the infinite depths of the _abyss_."
--8323329-655671958-1420536595=:3223
Content-Type: TEXT/plain; name=results.txt
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1501061029550.3223@butterbrot>
Content-Description: 
Content-Disposition: attachment; filename=results.txt

RHJpdmVyIEluZm86DQoJRHJpdmVyIG5hbWUgICA6IHN1cjQwDQoJQ2FyZCB0
eXBlICAgICA6IFNhbXN1bmcgU1VSNDANCglCdXMgaW5mbyAgICAgIDogdXNi
LTAwMDA6MDA6MTMuMi0xDQoJRHJpdmVyIHZlcnNpb246IDMuMTcuMQ0KCUNh
cGFiaWxpdGllcyAgOiAweDg1MjAwMDAxDQoJCVZpZGVvIENhcHR1cmUNCgkJ
UmVhZC9Xcml0ZQ0KCQlTdHJlYW1pbmcNCgkJRXh0ZW5kZWQgUGl4IEZvcm1h
dA0KCQlEZXZpY2UgQ2FwYWJpbGl0aWVzDQoJRGV2aWNlIENhcHMgICA6IDB4
MDUyMDAwMDENCgkJVmlkZW8gQ2FwdHVyZQ0KCQlSZWFkL1dyaXRlDQoJCVN0
cmVhbWluZw0KCQlFeHRlbmRlZCBQaXggRm9ybWF0DQoNCkNvbXBsaWFuY2Ug
dGVzdCBmb3IgZGV2aWNlIC9kZXYvdmlkZW8wIChub3QgdXNpbmcgbGlidjRs
Mik6DQoNClJlcXVpcmVkIGlvY3RsczoNCgl0ZXN0IFZJRElPQ19RVUVSWUNB
UDogT0sNCg0KQWxsb3cgZm9yIG11bHRpcGxlIG9wZW5zOg0KCXRlc3Qgc2Vj
b25kIHZpZGVvIG9wZW46IE9LDQoJdGVzdCBWSURJT0NfUVVFUllDQVA6IE9L
DQoJdGVzdCBWSURJT0NfRy9TX1BSSU9SSVRZOiBPSw0KDQpEZWJ1ZyBpb2N0
bHM6DQoJdGVzdCBWSURJT0NfREJHX0cvU19SRUdJU1RFUjogT0sgKE5vdCBT
dXBwb3J0ZWQpDQoJdGVzdCBWSURJT0NfTE9HX1NUQVRVUzogT0sgKE5vdCBT
dXBwb3J0ZWQpDQoNCklucHV0IGlvY3RsczoNCgl0ZXN0IFZJRElPQ19HL1Nf
VFVORVIvRU5VTV9GUkVRX0JBTkRTOiBPSyAoTm90IFN1cHBvcnRlZCkNCgl0
ZXN0IFZJRElPQ19HL1NfRlJFUVVFTkNZOiBPSyAoTm90IFN1cHBvcnRlZCkN
Cgl0ZXN0IFZJRElPQ19TX0hXX0ZSRVFfU0VFSzogT0sgKE5vdCBTdXBwb3J0
ZWQpDQoJdGVzdCBWSURJT0NfRU5VTUFVRElPOiBPSyAoTm90IFN1cHBvcnRl
ZCkNCgl0ZXN0IFZJRElPQ19HL1MvRU5VTUlOUFVUOiBPSw0KCXRlc3QgVklE
SU9DX0cvU19BVURJTzogT0sgKE5vdCBTdXBwb3J0ZWQpDQoJSW5wdXRzOiAx
IEF1ZGlvIElucHV0czogMCBUdW5lcnM6IDANCg0KT3V0cHV0IGlvY3RsczoN
Cgl0ZXN0IFZJRElPQ19HL1NfTU9EVUxBVE9SOiBPSyAoTm90IFN1cHBvcnRl
ZCkNCgl0ZXN0IFZJRElPQ19HL1NfRlJFUVVFTkNZOiBPSyAoTm90IFN1cHBv
cnRlZCkNCgl0ZXN0IFZJRElPQ19FTlVNQVVET1VUOiBPSyAoTm90IFN1cHBv
cnRlZCkNCgl0ZXN0IFZJRElPQ19HL1MvRU5VTU9VVFBVVDogT0sgKE5vdCBT
dXBwb3J0ZWQpDQoJdGVzdCBWSURJT0NfRy9TX0FVRE9VVDogT0sgKE5vdCBT
dXBwb3J0ZWQpDQoJT3V0cHV0czogMCBBdWRpbyBPdXRwdXRzOiAwIE1vZHVs
YXRvcnM6IDANCg0KSW5wdXQvT3V0cHV0IGNvbmZpZ3VyYXRpb24gaW9jdGxz
Og0KCXRlc3QgVklESU9DX0VOVU0vRy9TL1FVRVJZX1NURDogT0sgKE5vdCBT
dXBwb3J0ZWQpDQoJdGVzdCBWSURJT0NfRU5VTS9HL1MvUVVFUllfRFZfVElN
SU5HUzogT0sgKE5vdCBTdXBwb3J0ZWQpDQoJdGVzdCBWSURJT0NfRFZfVElN
SU5HU19DQVA6IE9LIChOb3QgU3VwcG9ydGVkKQ0KCXRlc3QgVklESU9DX0cv
U19FRElEOiBPSyAoTm90IFN1cHBvcnRlZCkNCg0KVGVzdCBpbnB1dCAwOg0K
DQoJQ29udHJvbCBpb2N0bHM6DQoJCXRlc3QgVklESU9DX1FVRVJZX0VYVF9D
VFJML1FVRVJZTUVOVTogT0sgKE5vdCBTdXBwb3J0ZWQpDQoJCXRlc3QgVklE
SU9DX1FVRVJZQ1RSTDogT0sgKE5vdCBTdXBwb3J0ZWQpDQoJCXRlc3QgVklE
SU9DX0cvU19DVFJMOiBPSyAoTm90IFN1cHBvcnRlZCkNCgkJdGVzdCBWSURJ
T0NfRy9TL1RSWV9FWFRfQ1RSTFM6IE9LIChOb3QgU3VwcG9ydGVkKQ0KCQl0
ZXN0IFZJRElPQ18oVU4pU1VCU0NSSUJFX0VWRU5UL0RRRVZFTlQ6IE9LIChO
b3QgU3VwcG9ydGVkKQ0KCQl0ZXN0IFZJRElPQ19HL1NfSlBFR0NPTVA6IE9L
IChOb3QgU3VwcG9ydGVkKQ0KCQlTdGFuZGFyZCBDb250cm9sczogMCBQcml2
YXRlIENvbnRyb2xzOiAwDQoNCglGb3JtYXQgaW9jdGxzOg0KCQl0ZXN0IFZJ
RElPQ19FTlVNX0ZNVC9GUkFNRVNJWkVTL0ZSQU1FSU5URVJWQUxTOiBPSw0K
CQl0ZXN0IFZJRElPQ19HL1NfUEFSTTogT0sgKE5vdCBTdXBwb3J0ZWQpDQoJ
CXRlc3QgVklESU9DX0dfRkJVRjogT0sgKE5vdCBTdXBwb3J0ZWQpDQoJCXRl
c3QgVklESU9DX0dfRk1UOiBPSw0KCQl0ZXN0IFZJRElPQ19UUllfRk1UOiBP
Sw0KCQl0ZXN0IFZJRElPQ19TX0ZNVDogT0sNCgkJdGVzdCBWSURJT0NfR19T
TElDRURfVkJJX0NBUDogT0sgKE5vdCBTdXBwb3J0ZWQpDQoJCXRlc3QgQ3Jv
cHBpbmc6IE9LIChOb3QgU3VwcG9ydGVkKQ0KCQl0ZXN0IENvbXBvc2luZzog
T0sgKE5vdCBTdXBwb3J0ZWQpDQoJCXRlc3QgU2NhbGluZzogT0sgKE5vdCBT
dXBwb3J0ZWQpDQoNCglDb2RlYyBpb2N0bHM6DQoJCXRlc3QgVklESU9DXyhU
UllfKUVOQ09ERVJfQ01EOiBPSyAoTm90IFN1cHBvcnRlZCkNCgkJdGVzdCBW
SURJT0NfR19FTkNfSU5ERVg6IE9LIChOb3QgU3VwcG9ydGVkKQ0KCQl0ZXN0
IFZJRElPQ18oVFJZXylERUNPREVSX0NNRDogT0sgKE5vdCBTdXBwb3J0ZWQp
DQoNCglCdWZmZXIgaW9jdGxzOg0KCQl0ZXN0IFZJRElPQ19SRVFCVUZTL0NS
RUFURV9CVUZTL1FVRVJZQlVGOiBPSw0KCQl0ZXN0IFZJRElPQ19FWFBCVUY6
IE9LDQoNClN0cmVhbWluZyBpb2N0bHM6DQoJdGVzdCByZWFkL3dyaXRlOiBP
Sw0KCQlmYWlsOiB2NGwyLXRlc3QtYnVmZmVycy5jcHAoMjg0KTogZ19maWVs
ZCgpID09IFY0TDJfRklFTERfQU5ZDQoJCWZhaWw6IHY0bDItdGVzdC1idWZm
ZXJzLmNwcCg2MTEpOiBidWYuY2hlY2socSwgbGFzdF9zZXEpDQoJCWZhaWw6
IHY0bDItdGVzdC1idWZmZXJzLmNwcCg4ODQpOiBjYXB0dXJlQnVmcyhub2Rl
LCBxLCBtMm1fcSwgZnJhbWVfY291bnQsIGZhbHNlKQ0KCXRlc3QgTU1BUDog
RkFJTA0KCXRlc3QgVVNFUlBUUjogT0sgKE5vdCBTdXBwb3J0ZWQpDQoJdGVz
dCBETUFCVUY6IENhbm5vdCB0ZXN0LCBzcGVjaWZ5IC0tZXhwYnVmLWRldmlj
ZQ0KDQpUb3RhbDogNDUsIFN1Y2NlZWRlZDogNDQsIEZhaWxlZDogMSwgV2Fy
bmluZ3M6IDANCg==

--8323329-655671958-1420536595=:3223--
