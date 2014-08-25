Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35647 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaHYOAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 10:00:13 -0400
Date: Mon, 25 Aug 2014 15:59:57 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-usb@vger.kernel.org, balbi@ti.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCH v2 2/3] usb: gadget/uvc: also handle v4l2 ioctl ENUM_FMT
Message-ID: <20140825135957.GG22481@pengutronix.de>
References: <1407512339-8433-1-git-send-email-m.grzeschik@pengutronix.de>
 <2635639.TQ5HekBxN8@avalon>
 <53F402BE.2010206@xs4all.nl>
 <7518802.YGX5leEVlJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7518802.YGX5leEVlJ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Aug 20, 2014 at 07:05:30PM +0200, Laurent Pinchart wrote:
> Hi Hans and Michael,
> 
> On Wednesday 20 August 2014 02:06:54 Hans Verkuil wrote:
> > On 08/19/2014 05:01 PM, Laurent Pinchart wrote:
> > > Hi Michael,
> > > 
> > > Thank you for the patch.
> > > 
> > > (CC'ing Hans Verkuil and the linux-media mailing list)
> > > 
> > > On Friday 08 August 2014 17:38:58 Michael Grzeschik wrote:
> > >> This patch adds ENUM_FMT as possible ioctl to the uvc v4l2 device.
> > >> That makes userspace applications with a generic IOCTL calling
> > >> convention make also use of it.
> > >> 
> > >> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > >> ---
> > >> 
> > >> v1 -> v2:
> > >>  - changed first switch case to simple if
> > >>  - added separate function
> > >>  - added description field
> > >>  - bail out on array boundaries
> > >>  
> > >>  drivers/usb/gadget/uvc_v4l2.c | 30 ++++++++++++++++++++++++++++--
> > >>  1 file changed, 28 insertions(+), 2 deletions(-)
> > >> 
> > >> diff --git a/drivers/usb/gadget/uvc_v4l2.c
> > >> b/drivers/usb/gadget/uvc_v4l2.c
> > >> index ad48e81..58633bf 100644
> > >> --- a/drivers/usb/gadget/uvc_v4l2.c
> > >> +++ b/drivers/usb/gadget/uvc_v4l2.c
> > >> @@ -55,14 +55,30 @@ struct uvc_format
> > >>  {
> > >>  	u8 bpp;
> > >>  	u32 fcc;
> > >> +	char *description;
> > >>  };
> > >>  
> > >>  static struct uvc_format uvc_formats[] = {
> > >> -	{ 16, V4L2_PIX_FMT_YUYV  },
> > >> -	{ 0,  V4L2_PIX_FMT_MJPEG },
> > >> +	{ 16, V4L2_PIX_FMT_YUYV, "YUV 4:2:2" },
> > >> +	{ 0,  V4L2_PIX_FMT_MJPEG, "MJPEG" },
> > > 
> > > Format descriptions are currently duplicated in every driver, causing
> > > higher memory usage and different descriptions for the same format
> > > depending on the driver. Hans, should we try to fix this ?
> > 
> > Yes, we should. It's been on my todo list for ages, but at a very low
> > priority. I'm not planning to work on this in the near future, but if
> > someone else wants to work on this, then just go ahead.
> 
> Michael, would you like to give this a try, or should I do it ?

It seems Philipp is already taking the chance! :)

Regards,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
