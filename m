Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bld-mail06.adl2.internode.on.net ([203.16.214.70]
	helo=mail.internode.on.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <short_rz@internode.on.net>) id 1Jn4lT-0006s4-EH
	for linux-dvb@linuxtv.org; Sat, 19 Apr 2008 06:33:30 +0200
Received: from [192.168.2.10] (unverified [121.45.15.110])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	13983751-1927428
	for <linux-dvb@linuxtv.org>; Sat, 19 Apr 2008 14:03:14 +0930 (CST)
Message-ID: <480977B6.5070304@internode.on.net>
Date: Sat, 19 Apr 2008 14:10:22 +0930
From: Andrew Jeffery <short_rz@internode.on.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] FusionHDTV Dual Digital 4 Segfault
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,

Bought myself a Dual Digital 4 the other day and I'm trying to get it up
and running - bumped into a segfault though :(

htpc v4l-dvb # lsmod
Module                  Size  Used by
snd_seq                51936  0
snd_pcm_oss            43424  0
snd_mixer_oss          18688  1 snd_pcm_oss
ehci_hcd               32652  0
uhci_hcd               26400  0
usbcore               128808  3 ehci_hcd,uhci_hcd
nvidia               8844612  0
i2c_core               24832  1 nvidia
e1000                 120384  0
snd_hda_intel         333860  0
snd_pcm                77448  2 snd_pcm_oss,snd_hda_intel
snd_timer              23560  2 snd_seq,snd_pcm
snd                    53864  6
snd_seq,snd_pcm_oss,snd_mixer_oss,snd_hda_intel,snd_pcm,snd_timer
snd_page_alloc         12304  2 snd_hda_intel,snd_pcm
htpc v4l-dvb # modprobe tuner-xc2028
htpc v4l-dvb # modprobe zl10353
htpc v4l-dvb # modprobe dvb_usb_cxusb
Segmentation fault
htpc v4l-dvb # dmesg
*** snip ***
dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
dvb-usb: recv bulk message failed: -110
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
general protection fault: 0000 [1] SMP
CPU 1
Modules linked in: dvb_usb_cxusb dvb_usb dvb_core zl10353 tuner_xc2028
snd_seq snd_pcm_oss snd_mixer_oss ehci_hcd uhci_hcd usbcore nvidia(P)
i2c_core e1000 snd_hda_intel snd_pcm snd_timer snd snd_page_alloc
Pid: 12926, comm: modprobe Tainted: P        2.6.23-gentoo-r8 #1
RIP: 0010:[<ffffffff88950949>]  [<ffffffff88950949>]
:tuner_xc2028:xc2028_attach+0x19d/0x1e7
RSP: 0018:ffff81003ca93c18  EFLAGS: 00010206
RAX: 0020000000a08c00 RBX: ffffffff88954590 RCX: 0000000000000080
RDX: 00000000ffffffff RSI: ffffffff88952940 RDI: ffff81003dcac278
RBP: ffff81003ca93c48 R08: ffff81003ca92000 R09: ffff810001012820
R10: ffff81003c4e7918 R11: 0000000000000009 R12: 0000000000000000
R13: ffff81003dcac008 R14: ffff81003ba08040 R15: 0000000000000001
FS:  00002ae8822d6b00(0000) GS:ffff81003f0dacc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002ac26dd940a8 CR3: 000000003104a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 12926, threadinfo ffff81003ca92000, task
ffff81003e7070c0)
Stack:  0000000000000001 ffff81003ba08d70 ffff81003ba08000 0000000000000000
~ ffffffff8897d428 ffffffff88977b78 ffff81003ba08a28 0000000000000061
~ 0000000000000000 0000000000000000 ffffffff88977818 ffff81003ba08000
Call Trace:
~ [<ffffffff88977b78>]
:dvb_usb_cxusb:cxusb_dvico_xc3028_tuner_attach+0x5e/0xab
~ [<ffffffff88977818>]
:dvb_usb_cxusb:dvico_bluebird_xc2028_callback+0x0/0x91
~ [<ffffffff88970ead>] :dvb_usb:dvb_usb_adapter_frontend_init+0xd4/0xf5
~ [<ffffffff889708e6>] :dvb_usb:dvb_usb_device_init+0x470/0x582
~ [<ffffffff88977115>] :dvb_usb_cxusb:cxusb_probe+0xdf/0x134
~ [<ffffffff88925c1f>] :usbcore:usb_probe_interface+0x8b/0xc1
~ [<ffffffff8035237d>] driver_probe_device+0xf6/0x17f
~ [<ffffffff8035251c>] __driver_attach+0x6f/0xaf
~ [<ffffffff803524ad>] __driver_attach+0x0/0xaf
~ [<ffffffff803524ad>] __driver_attach+0x0/0xaf
~ [<ffffffff80351758>] bus_for_each_dev+0x43/0x6e
~ [<ffffffff80351ad0>] bus_add_driver+0x7b/0x19d
~ [<ffffffff88925723>] :usbcore:usb_register_driver+0x7e/0xe1
~ [<ffffffff8808401b>] :dvb_usb_cxusb:cxusb_module_init+0x1b/0x35
~ [<ffffffff802506ca>] sys_init_module+0x1524/0x168a
~ [<ffffffff8020bb6e>] system_call+0x7e/0x83


Code: 8b 90 c8 02 00 00 48 8b 73 28 31 c0 0f b6 c9 49 c7 c0 47 2d
RIP  [<ffffffff88950949>] :tuner_xc2028:xc2028_attach+0x19d/0x1e7
~ RSP <ffff81003ca93c18>

- --
"Encouraging innovation by restricting the spread & use of information
seems highly counterintuitive to me." - Slashdot comment
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFICXe2/5R+ugbygqQRAlJqAJ40nEWBKmobVnuSS70ivv+urypIOQCdFomD
jok+iU2vCJc0sgUAXR0tYv0=
=9NcT
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
