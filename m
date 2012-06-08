Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33967 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2FHLc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 07:32:28 -0400
Received: by yhmm54 with SMTP id m54so1154378yhm.19
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2012 04:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120608092343.GU30400@pengutronix.de>
References: <CACKLOr2jQMnBPTaTFOcfLN_9J1n39tLx-ffDcVGuZ4ZB-odYfg@mail.gmail.com>
	<20120608072601.GD30137@pengutronix.de>
	<CACKLOr1OShoEnLxs8BP6q2TyZrOH0oCnpbKZJqyAo-yXKck9Zw@mail.gmail.com>
	<20120608084802.GS30400@pengutronix.de>
	<CACKLOr2wdF4tnovpnCO+ys7OMhbaKoruorSsj5hPfB26jGzQTA@mail.gmail.com>
	<CACKLOr1G+GBMhRoWSMJ17LoKuiUe0b+BXcuzEKh4OUKNaU_M8A@mail.gmail.com>
	<20120608092343.GU30400@pengutronix.de>
Date: Fri, 8 Jun 2012 13:32:27 +0200
Message-ID: <CACKLOr1Q1yxbaMmrFVsw-h-SmS3H4q_R+KY=DgnjM5WjaDW9Cg@mail.gmail.com>
Subject: Re: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, kernel@pengutronix.de,
	Fabio Estevam <festevam@gmail.com>,
	linux-media@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
	Dirk Behme <dirk.behme@googlemail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8 June 2012 11:23, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Fri, Jun 08, 2012 at 11:02:31AM +0200, javier Martin wrote:
>> Hi,
>> I've checked this matter with a colleague and we have several reasons
>> to doubt that the i.MX27 and the i.MX53 can share the same driver for
>> their Video Processing Units (VPU):
>>
>> 1. The VPU in the i.MX27 is a "codadx6" with support for H.264, H.263
>> and MPEG4-Part2 [1]. Provided Freescale is using the same IP provider
>> for i.MX53 and looking at the features that the VPU in this SoC
>> supports (1080p resolution, VP8) we are probably dealing with a "coda
>> 9 series" [2].
>>
>> 2. An important part of the functionality for controlling the
>> "codadx6" is implemented using software messages between the main CPU
>> and the VPU, this means that a different firmware loaded in the VPU
>> can substantially change the way it is handled. As previously stated,
>> i.MX27 and i.MX53 have different IP blocks and because of this, those
>> messages will be very different.
>>
>> For these reasons we suggest that we carry on developing different
>> drivers for the i.MX27 and the i.MX53. Though it's true that both
>> drivers could share some overhead given by the use of mem2mem
>> framework, I don't think this is a good enough reason the merge them.
>>
>> By the way, driver for the VPU in the i.MX27 will be called
>> "codadx6"[3], I suggest you call your driver "coda9" to avoid
>> confusion.
>
> Well, our driver works on i.MX27 and i.MX5. Yes, it needs some
> abstraction for different register layouts and different features, but
> the cores behave sufficiently similar that it makes sense to share the
> code in a single driver.

Hi Sascha,

>From our point of view the current situation is the following:
We have a very reliable driver for the VPU which is not mainline but
it's been used for two years in our products. This driver only
supports encoding in the i.MX27 chip.
In parallel, you have a a multichip driver in progress which is not
mainline either, not fully V4L2 compatible and not tested for i.MX27.
[1]
At the same time, we have a driver in progress for i.MX27 encoding
only which follows V4L2 mem2mem framework. [2].

The first thing to decide would be which of both drivers we take as a
base for final mainline developing.
In our view, cleaning up driver from Pengutronix [1] would imply a lot
of effort of maintaining code that we cannot really test (i.MX5,
i.MX6) whereas if we continue using [2] we would have something valid
for i.MX27 much faster. Support for decoding and other chips could be
added later.

The second thing would be whether we keep on developing or whether we
should wait for you to have something in mainline. We have already
allocated resources to the development of the driver and long-term
testing to achieve product level reliability. Pengutronix does not
seem to be committed to developing the features relevant to our
product (lack of YUV420 support for i.MX27 camera driver[6]) nor
committed to any deadline (lack of answers or development on dmaengine
for i.MX27[4][5]). Moreover, development effort is only 50% of the
cost and we would still have to spend a lot of time checking the video
stream manually in different real-rife conditions (only extensive
testing allowed us to catch the "P frame marked as IDR" bug [7]).

As a conclusion we propose that we keep on developing our driver for
encoding in the i.MX27 VPU under the following conditions:
- We will provide a more generic name for the driver than "codadx6",
maybe something as "imx_vpu".
- We will do an extra effort and will study your code in [1] in order
to provide a modular approach that makes adding new functionality (new
chips or decoding) as easy as possible while making obvious that
further patches do not break support for encoding in the i.MX27.

Does it sound reasonable for you?

Regards.

[1] git://git.pengutronix.de/git/imx/gst-plugins-fsl-vpu.git
[2] https://github.com/jmartinc/video_visstrim/tree/mx27-codadx6/drivers/media/video/codadx6
[3] http://www.spinics.net/lists/linux-media/msg37920.html
[4] http://www.spinics.net/lists/arm-kernel/msg159196.html
[5] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-March/087842.html
[6] http://patchwork.linuxtv.org/patch/8826/
[7] http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/49166

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
