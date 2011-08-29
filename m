Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51259 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1H2KkC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 06:40:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Subject: Re: omap3isp and tvp5150 hangs
Date: Mon, 29 Aug 2011 12:40:25 +0200
Cc: linux-media@vger.kernel.org
References: <CA+2YH7tJjssZs6-tQibHGYZw_t0xdu9d0PJBKkMaXn79=VFJ8g@mail.gmail.com> <4E577AE3.5020304@mlbassoc.com> <CA+2YH7ucxV9ywh96C2ehfrUi+_5v8eT94aNK+v03rYVvTPvyiA@mail.gmail.com>
In-Reply-To: <CA+2YH7ucxV9ywh96C2ehfrUi+_5v8eT94aNK+v03rYVvTPvyiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291240.26279.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Friday 26 August 2011 17:02:59 Enrico wrote:
> On Fri, Aug 26, 2011 at 12:52 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> > On 2011-08-26 04:42, Enrico wrote:
> >> Hi,
> >> 
> >> i need some help to debug a kernel hang on an igep board (+ expansion)
> >>  when using omap3-isp and tvp5150 video capture. Kernel version is
> >> mainline 3.0.1
> > 
> > I found that this driver is not compatible with the [new] v4l2_subdev
> > setup. In particular, it does not define any "pads" and the call to
> > media_entity_create_link()
> > in omap3isp/isp.c:1803 fires a BUG_ON() for this condition.
> 
> So basically what is needed is to implement pad functions and do
> something like this:
> 
> static struct v4l2_subdev_pad_ops mt9v032_subdev_pad_ops = {
>         .enum_mbus_code = mt9v032_enum_mbus_code,
>         .enum_frame_size = mt9v032_enum_frame_size,
>         .get_fmt = mt9v032_get_format,
>         .set_fmt = mt9v032_set_format,
>         .get_crop = mt9v032_get_crop,
>         .set_crop = mt9v032_set_crop,
> };
> 
> and add media init/cleanup functions? Can someone confirm this? Is
> someone already working on this?

That's more or less it, yes. I'm not aware of anyone working on this.

-- 
Regards,

Laurent Pinchart
