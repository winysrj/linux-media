Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m276JRUM025553
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 01:19:27 -0500
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.247])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m276IqKF002074
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 01:18:52 -0500
Received: by an-out-0708.google.com with SMTP id c31so103098ana.124
	for <video4linux-list@redhat.com>; Thu, 06 Mar 2008 22:18:49 -0800 (PST)
Message-ID: <331d2cab0803062218x663ad17ofb79928059a111b@mail.gmail.com>
Date: Fri, 7 Mar 2008 00:18:49 -0600
From: "Brandon Rader" <brandon.rader@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Trying to setup PCTV HD Card 800i
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

I bought the PCTV HD 800i tuner from woot.com, and waited until drivers had
been developed for it. I followed the guide from
LinuxTV<http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_%28800i%29>
.

My dmesg and lspci outputs are below. The dmesg output has some errors in
it, and the lspci looks like it is an entry short compared to some of the
other lspci outputs I've seen for this card. When I try to modprobe
cx88_dvb:

$ sudo modprobe cx88_dvb
FATAL: Error inserting cx88_dvb
(/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/cx88/cx88-dvb.ko):
No such device

lspci output:
lspci | grep -i cx
06:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [MPEG Port] (rev 05)
06:07.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio
Decoder [Audio Port] (rev 05)

dmesg output:
dmesg | grep -i cx

[   38.072800] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   38.072893] cx88[0]: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58,autodetected]
[   38.072896] cx88[0]: TV tuner type 76, Radio tuner type -1
[   38.134819] cx2388x alsa driver version 0.0.6 loaded
[   38.421908] input: cx88 IR (Pinnacle PCTV HD 800i) as
/class/input/input12
[   38.421949] cx88[0]/2: cx2388x 8802 Driver Manager
[   38.422389] cx88[0]/2: found at 0000:06:07.0, rev: 5, irq: 22, latency:
32, mmio: 0xd8000000
[   38.422575] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   38.534836] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   38.534841] cx88/2: registering cx8802 driver, type: dvb access: shared
[   38.534845] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58]
[   38.534848] cx88[0]/2: cx2388x based DVB/ATSC card
[   38.576833] cx88[0]/2: frontend initialization failed
[   38.576836] cx88[0]/2: dvb_register failed (err = -22)
[   38.576839] cx88[0]/2: cx8802 probe failed, err = -22
[  392.327689] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[  392.327698] cx88/2: registering cx8802 driver, type: dvb access: shared
[  392.327704] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58]
[  392.327709] cx88[0]/2: cx2388x based DVB/ATSC card
[  392.329827] cx88[0]/2: frontend initialization failed
[  392.329832] cx88[0]/2: dvb_register failed (err = -22)
[  392.329837] cx88[0]/2: cx8802 probe failed, err = -22
[  469.854170] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[  469.854177] cx88/2: registering cx8802 driver, type: dvb access: shared
[  469.854183] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58]
[  469.854187] cx88[0]/2: cx2388x based DVB/ATSC card
[  469.855350] cx88[0]/2: frontend initialization failed
[  469.855354] cx88[0]/2: dvb_register failed (err = -22)
[  469.855356] cx88[0]/2: cx8802 probe failed, err = -22
[  504.245556] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[  504.245563] cx88/2: registering cx8802 driver, type: dvb access: shared
[  504.245568] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58]
[  504.245571] cx88[0]/2: cx2388x based DVB/ATSC card
[  504.247237] cx88[0]/2: frontend initialization failed
[  504.247241] cx88[0]/2: dvb_register failed (err = -22)
[  504.247243] cx88[0]/2: cx8802 probe failed, err = -22
[ 3173.892400] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[ 3173.892410] cx88/2: registering cx8802 driver, type: dvb access: shared
[ 3173.892416] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58]
[ 3173.892423] cx88[0]/2: cx2388x based DVB/ATSC card
[ 3173.894673] cx88[0]/2: frontend initialization failed
[ 3173.894679] cx88[0]/2: dvb_register failed (err = -22)
[ 3173.894685] cx88[0]/2: cx8802 probe failed, err = -22


Thanks
Brandon
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
