Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37586 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932504AbcHKVJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:09:39 -0400
Date: Fri, 12 Aug 2016 00:09:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
	linux-media@vger.kernel.org
Subject: Re: Sony imx219 driver?
Message-ID: <20160811210905.GV3182@valkosipuli.retiisi.org.uk>
References: <57911245.1010500@destevenson.freeserve.co.uk>
 <5c425f34-d044-f228-65a4-f67430d55941@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c425f34-d044-f228-65a4-f67430d55941@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Dave,

On Fri, Jul 22, 2016 at 11:46:59AM +0200, Hans Verkuil wrote:
> > On a related note, if putting together a system with IMX219 or similar 
> > producing Bayer raw 10, the data on the CSI2 bus is one of the 
> > V4L2_PIX_FMT_SRGGB10P formats. What's the correct way to reflect that 
> > from the sensor subdevice in an MEDIA_BUS_FMT_ enum?
> > The closest is MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE (or LE), but the data 
> > isn't padded (the Pi CSI2 receiver can do the unpacking and padding, but 
> > that just takes up more memory).|||| Or is it MEDIA_BUS_FMT_SBGGR10_1X10 
> > to describe the data on the bus correctly as 10bpp Bayer, and the odd 
> > packing is ignored. Or do we need new enums?
> 
> Just add new enums to media-bus-format.h. It should be clear from comments and/or
> the naming of the enum what the exact format it, so you'll need to think about
> that carefully. Otherwise it's no big deal to add new formats there.

The existing drivers that use 10-bit raw bayer formats on serial busses
(such as CSI-2) use 1X10 variants of the media bus formats. That's perhaps
not the neatest possible way to solve that, but that's what existing drivers
do. And doing differently breaks things.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
