Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49682 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZHaGyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 02:54:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RESEND][PATCH 1/2] v4l2: modify the webcam video standard handling
Date: Mon, 31 Aug 2009 08:58:24 +0200
Cc: =?iso-8859-1?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <4A52E897.8000607@freemail.hu> <4A910C42.5000001@freemail.hu> <20090830234114.16b90c36@pedra.chehab.org>
In-Reply-To: <20090830234114.16b90c36@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908310858.24763.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 31 August 2009 04:41:14 Mauro Carvalho Chehab wrote:
> Hi Németh,
>
> Em Sun, 23 Aug 2009 11:30:42 +0200
>
> Németh Márton <nm127@freemail.hu> escreveu:
> > From: Márton Németh <nm127@freemail.hu>
> >
> > Change the handling of the case when vdev->tvnorms == 0.
>
> This patch (together with a few others related to tvnorms and camera
> drivers) reopens an old discussion: should webcams report a tvnorm?
>
> There's no easy answer for it since:
>
> 1) removing support for VIDIOC_G_STD/VIDIOC_S_STD causes regressions, since
> some userspace apps stops working;

Then those applications don't work with the uvcvideo driver in the first 
place. This is getting less and less common :-)

> 2) It is a common scenario to use cameras connected to some capture only
> devices like several bttv boards used on surveillance systems. Those
> drivers report STD, since they are used also on TV;
>
> 3) There are even some devices that allows cameras to be connected to one
> input and TV on another input. This is another case were the driver will
> report a TV std;

TV standards are ill-named, they are actually analog standards. 
VIDIOC_[GS]_STD are perfectly valid for capture devices with analog inputs, 
even if they don't use a TV tuner.

> 4) Most webcam formats are based on ITU-T formats designed to be compatible
> with TV (formats like CIF and like 640x480 - and their
> multiple/sub-multiples);

Even HD formats still have roots in the analog TV world. It's a real mess. 
Nonetheless, even if the actual frame size is compatible with TV, there is 
simply no concept of PAL/NTSC for webcams.

> 5) There are formats that weren't originated from TV on some digital
> webcams, so, for those formats, it makes no sense to report an existing
> std.
>
> Once people proposed to create an special format for those cases
> (V4L2_STD_DIGITAL or something like that), but, after lots of discussions,
> no changes were done at API nor at the drivers.

TV standards only apply to analog video. Let's simply not use it for digital 
video. We don't expect drivers to implement VIDIOC_[GS]_JPEGCOMP with fake 
values when they don't support JPEG compression, so we should not expect them 
to implement VIDIOC_[GS]_STD when they don't support analog TV.

> While we don't have an agreement on this, I don't think we should apply a
> patch like this.

-- 
Regards,

Laurent Pinchart
