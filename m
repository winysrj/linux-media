Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48616 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753345AbeFOXNg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 19:13:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH v2] media: i2c: add SCCB helpers
Date: Sat, 16 Jun 2018 02:13:51 +0300
Message-ID: <2528868.S4lOAQh8Yk@avalon>
In-Reply-To: <20180614153357.vgz4umv2aqudghm3@ninjato>
References: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com> <20180614153357.vgz4umv2aqudghm3@ninjato>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, 14 June 2018 18:33:58 EEST Wolfram Sang wrote:
> On Wed, Jun 13, 2018 at 12:34:46AM +0900, Akinobu Mita wrote:
> > (This is 2nd version of SCCB helpers patch.  After 1st version was
> > submitted, I sent alternative patch titled "i2c: add I2C_M_FORCE_STOP".
> > But it wasn't accepted because it makes the I2C core code unreadable.
> > I couldn't find out a way to untangle it, so I returned to the original
> > approach.)
> > 
> > This adds Serial Camera Control Bus (SCCB) helper functions
> > (sccb_read_byte and sccb_write_byte) that are intended to be used by some
> > of Omnivision sensor drivers.
> > 
> > The ov772x driver is going to use these functions in order to make it work
> > with most i2c controllers.
> > 
> > As the ov772x device doesn't support repeated starts, this driver
> > currently requires I2C_FUNC_PROTOCOL_MANGLING that is not supported by
> > many i2c controller drivers.
> > 
> > With the sccb_read_byte() that issues two separated requests in order to
> > avoid repeated start, the driver doesn't require
> > I2C_FUNC_PROTOCOL_MANGLING.
> 
> From a first glance, this looks like my preferred solution so far.
> Thanks for doing it! Let me sleep a bit over it for a thorough review...
> 
> > --- /dev/null
> > +++ b/drivers/media/i2c/sccb.h
> 
> I'd prefer this file to be in the i2c realm. Maybe
> 'include/linux/i2c-sccb.h" or something. I will come back to this.

And while at it, I think we also need a .c file, the functions (and especially 
sccb_read_byte()) should not be static inline.

-- 
Regards,

Laurent Pinchart
