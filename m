Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49348 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaHTHzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 03:55:22 -0400
Date: Wed, 20 Aug 2014 09:55:10 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH 2/2] usb: gadget: f_uvc: Move to video_ioctl2
Message-ID: <20140820075510.GA10389@pengutronix.de>
References: <1408381577-31901-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1408381577-31901-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <53F244DA.3090507@xs4all.nl>
 <1628101.uO8KrO9siZ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628101.uO8KrO9siZ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 18, 2014 at 11:16:36PM +0200, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 18 August 2014 18:24:26 Hans Verkuil wrote:
> > On 08/18/2014 05:06 PM, Laurent Pinchart wrote:
> > > Simplify ioctl handling by using video_ioctl2.
> > 
> > Are you able to test this on actual hardware? And if so, can you run
> > v4l2-compliance?
> 
> I'm afraid not. I don't have a platform with an up and running USB peripheral 
> controller at the moment.

You could test it with dummy_hcd gadget on an virtual or non usb machine.

Regards,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
