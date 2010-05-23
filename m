Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52483 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab0EWXIc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 19:08:32 -0400
Received: by bwz7 with SMTP id 7so719183bwz.19
        for <linux-media@vger.kernel.org>; Sun, 23 May 2010 16:08:30 -0700 (PDT)
Message-ID: <4BF9B56B.8020903@boichat.ch>
Date: Mon, 24 May 2010 01:08:27 +0200
From: Nicolas Boichat <nicolas@boichat.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Kernel oops with Avermedia Volar DVB-T USB Dongle with >= 2.6.23
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

I have an Avermedia Volar DVB-T USB Dongle (USB ID 07ca:b808). I use the 
firmware installed by Gentoo (media-tv/linuxtv-dvb-firmware-2009.09.19):
# md5sum /lib/firmware/dvb-usb-dib0700-1.20.fw
f42f86e2971fd994003186a055813237  /lib/firmware/dvb-usb-dib0700-1.20.fw

It used to work like a charm, but stopped working with kernels >= 
2.6.23: I get a kernel oops as soon as I try tuning to a channel (i.e. 
mplayer, or dvbscan). See below for the kernel oops (this is with a 
2.6.23-gentoo kernel, but it happens on 2.6.34-gentoo as well).

I quickly diffed the driver between 2.6.32 and 2.6.34, and I noticed 
something new about pid filtering, which happens to be in the backtrace 
of the oops (dib7000p_pid_filter_ctrl), so I simply disabled pid 
filtering for my device, and it works again, as before.

My patch to disable pid filtering is below, but this is clearly a 
kludge, and it would be better to fix the problem at the root.

Any hints on why this problem is happening, and a better solution, are 
welcome, and I can test some patches/firmwares if needed.

Thanks,

Best regards,

Nicolas Boichat (please cc me, I'm not subscribed on this list)

Kernel oops log:
..... Here I plug the device ....
[   41.231856] usb usb2: usb resume
[   41.231867] ehci_hcd 0000:00:1d.7: resume root hub
[   41.280264] hub 2-0:1.0: hub_resume
[   41.280306] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
[   41.280316] hub 2-0:1.0: port 3: status 0501 change 0001
[   41.384286] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000
[   41.384312] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[   41.441287] ehci_hcd 0000:00:1d.7: port 3 high speed
[   41.441302] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[   41.496238] usb 2-3: new high speed USB device using ehci_hcd and address 3
[   41.552289] ehci_hcd 0000:00:1d.7: port 3 high speed
[   41.552303] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[   41.629276] usb 2-3: default language 0x0409
[   41.629837] usb 2-3: udev 3, busnum 2, minor = 130
[   41.629843] usb 2-3: New USB device found, idVendor=07ca, idProduct=b808
[   41.629850] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   41.629856] usb 2-3: Product: A808
[   41.629861] usb 2-3: Manufacturer: AVerMedia
[   41.629866] usb 2-3: SerialNumber: 500575801072
[   41.630017] usb 2-3: uevent
[   41.630060] usb 2-3: usb_probe_device
[   41.630069] usb 2-3: configuration #1 chosen from 1 choice
[   41.630207] usb 2-3: adding 2-3:1.0 (config #1, interface 0)
[   41.630255] usb 2-3:1.0: uevent
[   41.630392] drivers/usb/core/inode.c: creating file '003'
[   41.632415] usb 2-3: uevent
[   41.946894] dib0700: loaded with support for 14 different device-types
[   41.946991] dvb_usb_dib0700 2-3:1.0: usb_probe_interface
[   41.946998] dvb_usb_dib0700 2-3:1.0: usb_probe_interface - got id
[   41.947322] dvb-usb: found a 'AVerMedia AVerTV DVB-T Volar' in cold state, will try to load a firmware
[   41.947332] usb 2-3: firmware: requesting dvb-usb-dib0700-1.20.fw
[   41.959377] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[   42.160957] dib0700: firmware started successfully.
[   42.665409] dvb-usb: found a 'AVerMedia AVerTV DVB-T Volar' in warm state.
[   42.665510] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   42.665632] DVB: registering new adapter (AVerMedia AVerTV DVB-T Volar)
[   43.032580] DVB: registering adapter 0 frontend 0 (DiBcom 7000MA/MB/PA/PB/MC)...
[   43.070121] MT2060: successfully identified (IF1 = 1220)
[   43.608594] dvb-usb: AVerMedia AVerTV DVB-T Volar successfully initialized and connected.
[   43.609473] usbcore: registered new interface driver dvb_usb_dib0700
..... Here I start mplayer ....
[   53.777257] BUG: unable to handle kernel NULL pointer dereference at 0000000000000012
[   53.778643] IP: [<ffffffff81363337>] i2c_transfer+0x1f/0xd9
[   53.779391] PGD 11c2f3067 PUD 11ee5d067 PMD 0
[   53.780325] Oops: 0000 [#1] PREEMPT SMP
[   53.781140] last sysfs file: /sys/devices/virtual/thermal/thermal_zone0/temp
[   53.781140] CPU 1
[   53.781140] Pid: 6306, comm: mplayer Tainted: P           2.6.33-gentoo #3 0U695R/Latitude E6400
[   53.781140] RIP: 0010:[<ffffffff81363337>]  [<ffffffff81363337>] i2c_transfer+0x1f/0xd9
[   53.781140] RSP: 0018:ffff88011c059b28  EFLAGS: 00010296
[   53.781140] RAX: 00000000ffffffa1 RBX: 0000000000000002 RCX: ffff8800df0042a0
[   53.781140] RDX: 0000000000000002 RSI: ffff88011c059b78 RDI: 0000000000000002
[   53.781140] RBP: ffff88011c059b68 R08: ffff8800df004240 R09: 000000000e008d80
[   53.781140] R10: dead000000200200 R11: dead000000100100 R12: 0000000000000000
[   53.781140] R13: ffffc900041bc000 R14: ffff88011c059b78 R15: 0000000000000002
[   53.781140] FS:  00007fea04b9b7c0(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
[   53.781140] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   53.781140] CR2: 0000000000000012 CR3: 000000011c00a000 CR4: 00000000000406e0
[   53.781140] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   53.781140] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   53.781140] Process mplayer (pid: 6306, threadinfo ffff88011c058000, task ffff88011af056f0)
[   53.781140] Stack:
[   53.781140]  ffff88011c059b88 00000000000000d2 0000000000000000 00000000000000eb
[   53.781140]<0>  0000000000000000 ffffc900041bc000 0000000000000001 ffff88011c5a4920
[   53.781140]<0>  ffff88011c059bc8 ffffffffa0bed10d 000000020000000c ffff88011c059ba8
[   53.781140] Call Trace:
[   53.781140]  [<ffffffffa0bed10d>] dib7000p_read_word+0x68/0xb7 [dib7000p]
[   53.781140]  [<ffffffff8133020b>] ? usb_submit_urb+0x327/0x345
[   53.781140]  [<ffffffffa0bedf53>] dib7000p_pid_filter_ctrl+0x28/0x8a [dib7000p]
[   53.781140]  [<ffffffffa0bf8fa4>] stk70x0p_pid_filter_ctrl+0x14/0x18 [dvb_usb_dib0700]
[   53.781140]  [<ffffffffa0bdf156>] dvb_usb_ctrl_feed+0xce/0x117 [dvb_usb]
[   53.781140]  [<ffffffffa0bdf1ba>] dvb_usb_start_feed+0xe/0x10 [dvb_usb]
[   53.781140]  [<ffffffffa0bc987f>] dmx_ts_feed_start_filtering+0x78/0xcc [dvb_core]
[   53.781140]  [<ffffffffa0bc6aa2>] dvb_dmxdev_start_feed+0xc2/0xf0 [dvb_core]
[   53.781140]  [<ffffffffa0bc7c39>] dvb_dmxdev_filter_start+0x2b8/0x30c [dvb_core]
[   53.781140]  [<ffffffffa0bc8423>] dvb_demux_do_ioctl+0x248/0x499 [dvb_core]
[   53.781140]  [<ffffffff81000e6e>] ? __switch_to+0x201/0x213
[   53.781140]  [<ffffffffa0bc6488>] dvb_usercopy+0xcc/0x13d [dvb_core]
[   53.781140]  [<ffffffffa0bc81db>] ? dvb_demux_do_ioctl+0x0/0x499 [dvb_core]
[   53.781140]  [<ffffffff81053265>] ? lock_hrtimer_base+0x25/0x4a
[   53.781140]  [<ffffffff8142ec6d>] ? _raw_spin_unlock_irqrestore+0x27/0x32
[   53.781140]  [<ffffffff81053305>] ? hrtimer_try_to_cancel+0x3c/0x46
[   53.781140]  [<ffffffffa0bc70c7>] dvb_demux_ioctl+0x10/0x12 [dvb_core]
[   53.781140]  [<ffffffff810de5a4>] vfs_ioctl+0x75/0xa1
[   53.781140]  [<ffffffff810dea5c>] do_vfs_ioctl+0x415/0x45b
[   53.781140]  [<ffffffff81052a9f>] ? hrtimer_wakeup+0x0/0x21
[   53.781140]  [<ffffffff810deae4>] sys_ioctl+0x42/0x65
[   53.781140]  [<ffffffff8100212b>] system_call_fastpath+0x16/0x1b
[   53.781140] Code: c2 e5 2f 36 81 e8 53 04 f5 ff c9 c3 55 b8 a1 ff ff ff 48 89 e5 41 57 41 89 d7 41 56 49 89 f6 41 55 41 54 53 48 89 fb 48 83 ec 18<48>  8b 57 10 48 83 3a 00 0f 84 9d 00 00 00 65 48 8b 14 25 48 b5
[   53.781140] RIP  [<ffffffff81363337>] i2c_transfer+0x1f/0xd9
[   53.781140]  RSP<ffff88011c059b28>
[   53.781140] CR2: 0000000000000012
[   53.826980] ---[ end trace 243c7faaf4f3d962 ]---

--

diff --git a/drivers/media/dvb/dib0700_devices.c b/drivers/media/dvb/dib0700_devices.c
index 34eab05..5c9cef7 100644
--- a/drivers/media/dvb/dib0700_devices.c
+++ b/drivers/media/dvb/dib0700_devices.c
@@ -2105,7 +2105,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
  				{ NULL },
  			},
  			{   "AVerMedia AVerTV DVB-T Volar",
-				{&dib0700_usb_id_table[5],&dib0700_usb_id_table[10] },
+				{&dib0700_usb_id_table[5] },
  				{ NULL },
  			},
  			{   "Compro Videomate U500",
@@ -2136,6 +2136,30 @@ struct dvb_usb_device_properties dib0700_devices[] = {
  		.rc_query         = dib0700_rc_query
  	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,

+		.num_adapters = 1,
+		.adapter = {
+			{
+				.frontend_attach  = stk7700p_frontend_attach,
+				.tuner_attach     = stk7700p_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
+			},
+		},
+
+		.num_device_descs = 1,
+		.devices = {
+			{   "AVerMedia AVerTV DVB-T Volar (B808)",
+				{&dib0700_usb_id_table[10] },
+				{ NULL },
+			}
+		},
+
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = dib0700_rc_keys,
+		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_query         = dib0700_rc_query
+	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+
  		.num_adapters = 2,
  		.adapter = {
  			{


