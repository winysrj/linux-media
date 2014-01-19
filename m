Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:23486 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaASEXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jan 2014 23:23:35 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZM001MRS79B070@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 18 Jan 2014 23:23:33 -0500 (EST)
Date: Sun, 19 Jan 2014 02:23:28 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: LMML <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: [ANNOUNCE EXPERIMENTAL] PCTV 80e driver
Message-id: <20140119022328.55f6a741@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Years ago, there were some efforts to merge the Devin's drx-j driver port.

For those that followed the discussions, there were several issues with drx-j
that were preventing its merge, even at the staging dir.

One of the major issues is that the drx-j firmware were enclosed inside the
source code, with is forbidden inside the Linux Kernel, as some lawyers believe
that such aggregation would require to also release the firmware source code
as GPL.

I tried to help on that time, but I couldn't do much, as I didn't have any
PCTV 80e board here, nor I had any ATSC signal on my region.

Well, the situation changed, as last year, Samsung bought me an universal
terrestrial and cable generator, and this year I finally got one PCTV 80e
device.

So, three days ago, I resurrected my work from this branch:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/drx-j

Rebasing it to the upstream version, and doing the required work for the
drx-j to minimally follow the required upstream rules.

The result is at:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/drx-j-new

Even with all changes, this driver is a way more complex that it would need,
as there are 3 abstraction layers between the Linux DVB subsystem and the
hardware:
	drx3xyj.c - talks with the subsystem;
	drx_driver.c - is a "generic" driver for drx-j;
	drxj.c - actually implements the functions that talk with the
		 hardware.

Such complexity makes it hard to debug and to fix, but it should work.

For those with such device that wants to give it a try:

The DRX-J firmware files should be downloaded from:
	http://linuxtv.org/downloads/firmware/#8

and added at /lib/firmware. Only dvb-fe-drxj-mc-1.0.8.fw firmware is
needed. The other two firmware files there aren't currently used, but I
decided to store them, as their usage might be needed later.

As already mentioned, the driver is at my experimental tree, at:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/drx-j-new

In order to test it, I recommend you to get the ATSC frequency tables from:
	http://git.linuxtv.org/dtv-scan-tables.git

and the newest version of the v4l-utils from:
	http://git.linuxtv.org/v4l-utils.git

In order to compile v4l-utils, use:
	autoreconf -vfi && ./configure && make && sudo make install 

The command to scan for the existing ATSC channels is:

	$ dvbv5-scan -I channel /usr/share/dvb/atsc/us-NTSC-center-frequencies-8VSB

Please notice that us-NTSC-center-frequencies-8VSB file is for the
terrestrial frequencies. There are other ATSC frequencies provided there,
used by cable operators.

In order to zap into a channel and see the program IDs:

	$ dvbv5-zap -I channel -c ~/atsc-test -m 473000000 

(assuming that atsc-test is a file with the existing frequencies,
and that 473 MHz is the frequency of some channel).

It should write, at the screen:

tuning to 473000000 Hz
       (0x00) Signal= 0.00% C/N= 0.03% UCB= 20 postBER= 0
Lock   (0x1f) Signal= 76.00% C/N= 0.45% UCB= 295 postBER= 0
  dvb_set_pesfilter to 0x2000

And, after a while:

 PID          FREQ         SPEED       TOTAL
0000      8.39 p/s     12.3 Kbps      539 KB
0f75    419.96 p/s    616.8 Kbps    26985 KB
0fff      8.78 p/s     12.9 Kbps      564 KB
1000      8.33 p/s     12.2 Kbps      535 KB
1683    420.27 p/s    617.3 Kbps    27005 KB
1ae4    419.68 p/s    616.4 Kbps    26967 KB
1fff      8.33 p/s     12.2 Kbps      535 KB
TOT    1334.12 p/s   1959.5 Kbps    85728 KB

Of course, other DVB applications should equally work.

PS.: at least here on my tests with dvbv5 apps at v4l-utils, there are some
instability at the driver: sometimes, it shows the full PID table, sometimes 
it shows only a subset of the existing PIDs, and sometimes, it doesn't show
anything.

That seems to be some sort of bug at PID filtering.

At this stage, I'm not sure where is the bug, as I just make the driver
to work.

Ah, I didn't work at the remote controller yet. I'll handle it after
doing more tests with the DVB functionality.

Those with PCTV 80e: please test, and provide some feedback.

Thanks!
Mauro
