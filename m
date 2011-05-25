Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2530 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1EYKKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 06:10:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: v4l2_mbus_framefmt and v4l2_pix_format
Date: Wed, 25 May 2011 12:10:44 +0200
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org
References: <BANLkTikPGEgWH-ExjnSuH8-n0f2q54EJGQ@mail.gmail.com>
In-Reply-To: <BANLkTikPGEgWH-ExjnSuH8-n0f2q54EJGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105251210.45058.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, May 25, 2011 11:56:23 Scott Jiang wrote:
> Hi Hans and Laurent,
> 
> I got fmt info from a video data source subdev, I thought there should
> be a helper function to convert these two format enums.
> However, v4l2_fill_pix_format didn't do this, why? Should I do this in
> bridge driver one by one?
> I think these codes are common use, I prefer adding them in
> v4l2_fill_pix_format.

Only the bridge driver knows how these two enums relate. The mediabus enum
as used by subdevs describes the format of the video data as is transferred
over the physical bus between the subdev and the bridge. The V4L2_PIX_FMT*
formats describe what the video data looks like in memory. Depending on the
DMA engine those may or may not have a simple one on one mapping.

In other words, it is indeed the bridge driver that has to do the mapping.

That said, soc_camera has such a mapping. If it turns out that it can be
reused elsewhere for certain bridges, then that code should probably be
made a generic helper function. (See soc_mediabus.c/h)

Regards,

	Hans
