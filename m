Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45736 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaHTRDg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 13:03:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Grzeschik <mgr@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH 2/2] usb: gadget: f_uvc: Move to video_ioctl2
Date: Wed, 20 Aug 2014 19:04:16 +0200
Message-ID: <1727644.isLCCA1H9e@avalon>
In-Reply-To: <20140820075510.GA10389@pengutronix.de>
References: <1408381577-31901-1-git-send-email-laurent.pinchart@ideasonboard.com> <1628101.uO8KrO9siZ@avalon> <20140820075510.GA10389@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Wednesday 20 August 2014 09:55:10 Michael Grzeschik wrote:
> On Mon, Aug 18, 2014 at 11:16:36PM +0200, Laurent Pinchart wrote:
> > On Monday 18 August 2014 18:24:26 Hans Verkuil wrote:
> > > On 08/18/2014 05:06 PM, Laurent Pinchart wrote:
> > > > Simplify ioctl handling by using video_ioctl2.
> > > 
> > > Are you able to test this on actual hardware? And if so, can you run
> > > v4l2-compliance?
> > 
> > I'm afraid not. I don't have a platform with an up and running USB
> > peripheral controller at the moment.
> 
> You could test it with dummy_hcd gadget on an virtual or non usb machine.

Thank you for pointing this out.

-- 
Regards,

Laurent Pinchart

