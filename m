Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56070 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1IOH0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 03:26:21 -0400
Received: by qwj8 with SMTP id 8so739214qwj.33
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2011 00:26:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109150912570.11565@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
	<4E6FC8E8.70008@gmail.com>
	<CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>
	<4E70BA97.1090904@samsung.com>
	<CAHG8p1D1jnwRO0ie6xrXGL5Uhu+2YjoNdXzhnnBweZDPRyE1fw@mail.gmail.com>
	<Pine.LNX.4.64.1109150826560.11565@axis700.grange>
	<CAHG8p1CDQ-nFwTCXzJBBp76n+16Pz=mDat=dpdNy5N3jjNNvbQ@mail.gmail.com>
	<Pine.LNX.4.64.1109150912570.11565@axis700.grange>
Date: Thu, 15 Sep 2011 15:26:20 +0800
Message-ID: <CAHG8p1D+NskH5cLT3t9QrtQNGdRH3xj23aiSxDsCGO4r0O7sAQ@mail.gmail.com>
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

>> I have considered using soc, but it can't support decoder when I began
>> to write this driver in 2.6.38.
>
> soc_mediabus.c is a stand-alone module, it has no dependencies on
> soc-camera.
>
> Out of interest - what kind of decoder you mean? A tv-decoder? We do have
> a tv-decoder driver tw9910 under soc-camera.
>
static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
{
     if (i > 0)
        return -EINVAL;

    return 0;
}
I don't think most of tv-decoders only support one input.
