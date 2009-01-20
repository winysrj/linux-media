Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0KDSGtX005786
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 08:28:16 -0500
Received: from mail-fx0-f29.google.com (mail-fx0-f29.google.com
	[209.85.220.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0KDS1J3030963
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 08:28:02 -0500
Received: by fxm10 with SMTP id 10so796380fxm.3
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 05:28:01 -0800 (PST)
Message-ID: <2e6cfdb70901200528w5feb473bi7bae7ecbbb70a035@mail.gmail.com>
Date: Tue, 20 Jan 2009 18:28:01 +0500
From: "me myself" <burgerbisquit@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Fedora 10, TeVii S420, cx88[0]/2: cx8802 probe failed, err = -22
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

Hi.

I have some troubles with the latest v4l-dvb cx88 driver and I really
don`t know where should I post this bug.

Sorry.

I have Fedora 10, TeVii S420 dvb card and 2.6.27.5-117.fc10.i686 kernel.

I have read this post http://patchwork.kernel.org/patch/1821/ and yes,
this patch fixes kernel oops, but I still can`t get my card working.

But even with the latest revision of v4l-dvb i  can`t get my card working.

Is it a bug or what?

dmesg:
Linux video capture interface: v2.00
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]: subsystem: d420:9022, board: TeVii S420 DVB-S
[card=73,autodetected], frontend(s): 1
cx88[0]: TV tuner type -1, Radio tuner type -1
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
tuner' 3-0062: chip found @ 0xc4 (cx88[0])
tuner' 3-0068: chip found @ 0xd0 (cx88[0])
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:01:01.2: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
cx88[0]/2: found at 0000:01:01.2, rev: 5, irq: 17, latency: 64, mmio:
0xde000000
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
HDA Intel 0000:00:1b.0: setting latency timer to 64
cx8800 0000:01:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
cx88[0]/0: found at 0000:01:01.0, rev: 5, irq: 17, latency: 64, mmio:
0xdd000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
tuner' 3-0062: tuner type not set
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: d420:9022, board: TeVii S420 DVB-S [card=73]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
device-mapper: multipath: version 1.0.5 loaded
cx88[0]/2: dvb_register failed (err = -22)
cx88[0]/2: cx8802 probe failed, err = -22

boot.log:
modprobe: FATAL: Error inserting cx88_dvb
(/lib/modules/2.6.27.5-117.fc10.i686/kernel/drivers/media/video/cx88/cx88-dvb.ko):
No such device.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
