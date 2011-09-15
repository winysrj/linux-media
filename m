Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37061 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab1IOGsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 02:48:05 -0400
Received: by qwj8 with SMTP id 8so722408qwj.33
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 23:48:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109150826560.11565@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
	<4E6FC8E8.70008@gmail.com>
	<CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>
	<4E70BA97.1090904@samsung.com>
	<CAHG8p1D1jnwRO0ie6xrXGL5Uhu+2YjoNdXzhnnBweZDPRyE1fw@mail.gmail.com>
	<Pine.LNX.4.64.1109150826560.11565@axis700.grange>
Date: Thu, 15 Sep 2011 14:48:04 +0800
Message-ID: <CAHG8p1CDQ-nFwTCXzJBBp76n+16Pz=mDat=dpdNy5N3jjNNvbQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/9/15 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Thu, 15 Sep 2011, Scott Jiang wrote:
>
>> accually this array is to convert mbus to pixformat. ppi supports any formats.
>
> You mean, it doesn't distinguish formats? It just packs bytes in RAM
> exactly as it ready them from the bus, and doesn't support any formats
> natively, i.e., doesn't offer any data processing?
>
yes, ppi means Parallel Peripheral Interface.

>> Ideally it should contain all formats in v4l2, but it is enough at
>> present for our platform.
>> If I find someone needs more, I will add it.
>> So return -EINVAL means this format is out of range, it can't be supported now.
>
> You might consider using
>
> drivers/media/video/soc_mediabus.c
>
> If your driver were using soc-camera, it could benefit from the
> dynamically built pixel translation table, see
>
> drivers/media/video/soc_camera.c::soc_camera_init_user_formats()
>
> and simpler examples like mx1_camera.c or more complex ones like
> sh_mobile_ceu_camera.c, pxa_camera.c or mx3_camera.c and the use of the
> soc_camera_xlate_by_fourcc() function in them.
>
I have considered using soc, but it can't support decoder when I began
to write this driver in 2.6.38.
