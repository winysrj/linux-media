Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout11.t-online.de ([194.25.134.85]:48166 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaBBFS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Feb 2014 00:18:26 -0500
From: "Andreas Witte" <andreaz@t-online.de>
To: <linux-media@vger.kernel.org>
Subject: PCTV 200Xe Tuning (get a lock, but no data)
Date: Sun, 2 Feb 2014 06:18:24 +0100
Message-ID: <004601cf1fd6$32753c00$975fb400$@de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello List,

i done a new installation of my box. I am on gentoo, kernel 3.10.25.

The problem is: I can tune to a station, it tunes and locks to it, but i get
not any
data (stream) from the device.

When i bootup, i get following message from the device:

[   19.359539] ------------[ cut here ]------------
[   19.359546] WARNING: at drivers/usb/core/urb.c:435
usb_submit_urb+0x141/0x4c0()
[   19.359549] Device: usb
BOGUS urb xfer, pipe 3 != type 1
[   19.359551] Modules linked in: mt352(O) dvb_bt8xx(O) bt878(O) mt2266(O)
rc_imon_pad(O) rc_avermedia_dvbt(O) bttv(O) imon(O) dvb_usb_dib0700(O+)
dib3000mc(O) dib9000(O) tveeprom(O) dib8000(O) btcx_risc(O) dvb_usb(O)
videobuf_dma_sg(O) videobuf_core(O) dib0070(O) dib7000m(O) dib0090(O)
dib7000p(O) v4l2_common(O) videodev(O) media(O) dvb_core(O)
dibx000_common(O) rc_core(O) nvidia(PO) asus_atk0110
[   19.359571] CPU: 0 PID: 3135 Comm: udevd Tainted: P           O
3.10.25-gentoo #16
[   19.359572] Hardware name: System manufacturer P5E/P5E, BIOS 1201   
02/19/2009
[   19.359574]  f4f67ca0 f4f67ca0 f4f67c68 c180bbac f4f67c90 c103084f
c19e3bf8 f4f67cbc
[   19.359578]  000001b3 c1580f11 c1580f11 f4e7f880 00000003 00000001
f4f67ca8 c10308ee
[   19.359581]  00000009 f4f67ca0 c19e3bf8 f4f67cbc f4f67cf0 c1580f11
c19c5302 000001b3
[   19.359585] Call Trace:
[   19.359591]  [<c180bbac>] dump_stack+0x16/0x18
[   19.359594]  [<c103084f>] warn_slowpath_common+0x5f/0x80
[   19.359597]  [<c1580f11>] ? usb_submit_urb+0x141/0x4c0
[   19.359599]  [<c1580f11>] ? usb_submit_urb+0x141/0x4c0
[   19.359602]  [<c10308ee>] warn_slowpath_fmt+0x2e/0x30
[   19.359604]  [<c1580f11>] usb_submit_urb+0x141/0x4c0
[   19.359611]  [<faba17d7>] dib0700_rc_setup+0x97/0xf0 [dvb_usb_dib0700]
[   19.359616]  [<faba18d5>] dib0700_probe+0xa5/0x100 [dvb_usb_dib0700]
[   19.359619]  [<c1584a31>] usb_probe_interface+0xe1/0x1d0
[   19.359623]  [<c14b5136>] driver_probe_device+0x56/0x1f0
[   19.359626]  [<c14b5359>] __driver_attach+0x89/0x90
[   19.359629]  [<c14b52d0>] ? driver_probe_device+0x1f0/0x1f0
[   19.359632]  [<c14b3972>] bus_for_each_dev+0x42/0x80
[   19.359635]  [<c14b4d29>] driver_attach+0x19/0x20
[   19.359637]  [<c14b52d0>] ? driver_probe_device+0x1f0/0x1f0
[   19.359654]  [<c14b4964>] bus_add_driver+0xd4/0x220
[   19.359657]  [<c14b58f5>] driver_register+0x65/0x160
[   19.359661]  [<c10ff357>] ? kmem_cache_alloc_trace+0x27/0x100
[   19.359664]  [<c180f953>] ? mutex_lock+0x13/0x40
[   19.359668]  [<c10a68dc>] ? tracepoint_module_notify+0x4c/0x190
[   19.359671]  [<c1583f32>] usb_register_driver+0x62/0x150
[   19.359674]  [<c10a6955>] ? tracepoint_module_notify+0xc5/0x190
[   19.359676]  [<fabb8000>] ? 0xfabb7fff
[   19.359680]  [<fabb8017>] dib0700_driver_init+0x17/0x19 [dvb_usb_dib0700]
[   19.359683]  [<c10001ca>] do_one_initcall+0xda/0x130
[   19.359687]  [<c1054ff7>] ? __blocking_notifier_call_chain+0x47/0x60
[   19.359690]  [<c1084ef8>] load_module+0x1668/0x1e50
[   19.359694]  [<c10857fc>] SyS_finit_module+0x6c/0x90
[   19.359699]  [<c1818b7a>] sysenter_do_call+0x12/0x22
[   19.359701] ---[ end trace d33d74f167a41384 ]---

Anyways, both adapters are registered. And i can speak to them. But it seems
they wont
talk back to me.. :)
Stick out and back in the usb stick will erase that message, but the tuner
is still not 
functional. I tried it with vlc, mplayer, mythtv. 

lx_andreaz ~ # dmesg|grep adapter
[   18.416319] DVB: registering new adapter (Pinnacle PCTV 2000e)
[   18.618253] usb 2-4: DVB: registering adapter 0 frontend 0 (DiBcom
7000PC)...
[   19.071198] DVB: registering new adapter (Pinnacle PCTV 2000e)
[   19.092057] DVB: registering new adapter (bttv0)
[   19.099280] bt878 0000:05:01.1: DVB: registering adapter 2 frontend 0
(Zarlink MT352 DVB-T)...
[   19.099321] DVB: registering new adapter (bttv1)
[   19.099952] bt878 0000:05:02.1: DVB: registering adapter 3 frontend 0
(Zarlink MT352 DVB-T)...
[   19.207628] usb 2-4: DVB: registering adapter 1 frontend 0 (DiBcom
7000PC)...

Here i try if the tuner lock to a given station, it will:

lx_andreaz ~ # tzap -a 0 -c /home/andreaz/channels.conf ZDF
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/andreaz/channels.conf'
tuning to 570000000 Hz
video pid 0x0221, audio pid 0x0222
status 00 | signal ffff | snr 034c | ber 001fffff | unc 00000000 |
status 0e | signal ffff | snr 00ae | ber 001fffff | unc 00000000 |
status 1e | signal ffff | snr 00d8 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00da | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00d4 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00d5 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00d9 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00d5 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00d4 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00d6 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00d1 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00da | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00d1 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1e | signal ffff | snr 00d6 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK

Sometimes, the first tuning after un- and reloading the dvb-usb-dib0700
module
is succesfull, i got my videostream, but after a channelchange, all is at
the old 
state again. 

The different parameters in /etc/modprobe.d/options.conf i tried alrady in
all
combinations:

options dvb_usb disable_rc_polling=1
options dvb_usb_dib0700 force_lna_activation=1
#options usbcore autosuspend=1

The stick worked nicely before, on a 2.6.xx anything kernel, without any
hassle 
in the same antenna configuration like it is now. Except from the stick, i
also got
2 Avermedia 771 Cards inside this pc, they work flawless on the same
Antenna.

Is there anything i can do about? I nearly tried all. The normal kernel
drivers in
3.10.25, the media-build, nothing changes the behavior. Im at the end of my 
knowledge and wonder, what have changed in the meantime?

Hope anyone can help me with that?

Regards,
Andreas

(Sorry for the long post, but i tried to be as concrete as i can)

