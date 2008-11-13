Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAD0mwXZ014159
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 19:48:58 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAD0lfrb028430
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 19:48:26 -0500
Received: by wf-out-1314.google.com with SMTP id 25so645687wfc.6
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 16:47:40 -0800 (PST)
Message-ID: <d7e40be30811121647k4b4c81fbgeae3121745e2ebd7@mail.gmail.com>
Date: Thu, 13 Nov 2008 11:47:40 +1100
From: "Ben Klein" <shacklein@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: cx88 sysfs name
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

I'm not sure if this is the right place to post this.

I've been having a LOT of trouble with my cx88-based card just now, but it
seems to be working now (possibly because I recompiled the kernel with the
proper dvb support, even though I was having trouble with the analogue
capture).

In my research in to my problem, I discovered something interesting about
the name reported in sysfs.

== /sys/class/video4linux/video1/name contents ==
cx88[0] video (KWorld/VStream X

== dmesg snippet ==
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
cx8800 0000:01:07.0: PCI INT A -> Link[LNKB] -> GSI 18 (level, low) -> IRQ
18
cx88[0]: subsystem: 17de:08a6, board: KWorld/VStream XPert DVB-T
[card=14,autodetected]
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
input: cx88 IR (KWorld/VStream XPert D as
/devices/pci0000:00/0000:00:08.0/0000:01:07.0/input/input5
cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 18, latency: 32, mmio:
0xf8000000
cx88[0]/0: registered device video1 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:01:07.2: PCI INT A -> Link[LNKB] -> GSI 18
(level, low) -> IRQ 18
cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 18, latency: 32, mmio:
0xf9000000
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 17de:08a6, board: KWorld/VStream XPert DVB-T [card=14]
cx88[0]/2: cx2388x based DVB/ATSC card
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Zarlink MT352 DVB-T)...

With the truncated name in sysfs, I'm wondering, could this be a buffer
overflow issue?
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
