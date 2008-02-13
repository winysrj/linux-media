Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1D5KLGx010661
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 00:20:21 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.179])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1D5K0Ho016981
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 00:20:00 -0500
Received: by wa-out-1112.google.com with SMTP id j37so3613230waf.7
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 21:20:00 -0800 (PST)
Message-ID: <f17812d70802122120r3f8f2c29qa70342d1bda75658@mail.gmail.com>
Date: Wed, 13 Feb 2008 13:20:00 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0802111440230.4440@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802051830360.5882@axis700.grange>
	<20080211114129.GA10482@flint.arm.linux.org.uk>
	<Pine.LNX.4.64.0802111440230.4440@axis700.grange>
Cc: video4linux-list@redhat.com,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/6] V4L2 soc_camera driver for PXA27x processors
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

Yes, the PXA3xx has dedicated DMA channels. Yet I still think carry the
DRCMR register index into platform device's resource would be a better
idea both for readability (so that no comment necessary for these magic
numbers) and potential re-usability.

The driver looks good overall and I'm sorry that I didn't have enough
time to look into this recently. So here are some overall comments,
I hope I can spend more time to do a line-by-line review later

1. due to expected difference between pxa27x and pxa3xx quick capture
interface, I guess there will be dedicated code for pxa3xx, so naming
of functions/variables to "pxa_*" will leave less choices for later
processors, I suggest to use the prefix of "pxa27x_*", to indicate it
is the first processor that this controller appears.

2. I really hope changes could be made in this patch to remove those
QCI register definitions from pxa-regs.h to some where closer to this
driver, maybe pxa27x_camera.h or directly embedded into the driver,
and using ioremap() for the mmio access

3. by using only Y dma channel, the driver is dropping the capability
of the hardware to convert interleaved YCbCr data to planar format,
what is your plan for that capability?

4. it looks like the sensor framework is currently unable to provide
more information such as its connection type with the host (master or
slave, parallel or serial), along with the frequency, sync polarity,
otherwise, the fields in platform_data can be removed and setting of
those CICRx registers can be fully inferred. Still, I think we might
do better by naming the platform_data->platform_flags to some thing
like

	.ci_mode	= {MASTER, SLAVE}_{PARALLEL, SERIAL}
	.ci_width	= {8, 9, 10, 11, 12}
	.sync_polarity

5. I saw many places emphasize on the assumption that there is only
_one_ sensor attached, what if multiple sensors to be supported? I
know several boards with such design.

6. the naming of "pxa_is_xxx" reads like a boolean function to me
at first sight, and it is actually not, maybe we can come up with
a better name?

This is a good driver, I do want to see a well supported QCI driver
in the mainline. Thanks!

---
Cheers
- eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
