Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43989 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaHRVP6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 17:15:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Michael Grzeschik <mgr@pengutronix.de>
Subject: Re: [PATCH 2/2] usb: gadget: f_uvc: Move to video_ioctl2
Date: Mon, 18 Aug 2014 23:16:36 +0200
Message-ID: <1628101.uO8KrO9siZ@avalon>
In-Reply-To: <53F244DA.3090507@xs4all.nl>
References: <1408381577-31901-1-git-send-email-laurent.pinchart@ideasonboard.com> <1408381577-31901-3-git-send-email-laurent.pinchart@ideasonboard.com> <53F244DA.3090507@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 18 August 2014 18:24:26 Hans Verkuil wrote:
> On 08/18/2014 05:06 PM, Laurent Pinchart wrote:
> > Simplify ioctl handling by using video_ioctl2.
> 
> Are you able to test this on actual hardware? And if so, can you run
> v4l2-compliance?

I'm afraid not. I don't have a platform with an up and running USB peripheral 
controller at the moment.

-- 
Regards,

Laurent Pinchart

