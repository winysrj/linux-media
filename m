Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35725 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaBBKUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Feb 2014 05:20:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH] [media] uvcvideo: Enable VIDIOC_CREATE_BUFS
Date: Sun, 02 Feb 2014 11:21:13 +0100
Message-ID: <3803281.g9jSrV8SES@avalon>
In-Reply-To: <52EB6214.9030806@xs4all.nl>
References: <1391012032-19600-1-git-send-email-p.zabel@pengutronix.de> <1474634.xnVfC2yuQa@avalon> <52EB6214.9030806@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 31 January 2014 09:43:00 Hans Verkuil wrote:
> I think you might want to add a check in uvc_queue_setup to verify the
> fmt that create_bufs passes. The spec says that: "Unsupported formats
> will result in an error". In this case I guess that the format basically
> should match the current selected format.
> 
> I'm unhappy with the current implementations of create_bufs (see also this
> patch:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg70796.html).
> 
> Nobody is actually checking the format today, which isn't good.
> 
> The fact that the spec says that the fmt field isn't changed by the driver
> isn't helping as it invalidated my patch from above, although that can be
> fixed.
> 
> I need to think about this some more, but for this particular case you can
> just do a memcmp of the v4l2_pix_format against the currently selected
> format and return an error if they differ. Unless you want to support
> different buffer sizes as well?

Isn't the whole point of VIDIOC_CREATE_BUFS being able to create buffers of 
different resolutions than the current active resolution ?

-- 
Regards,

Laurent Pinchart

