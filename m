Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38952 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751878AbeDRKl4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 06:41:56 -0400
Date: Wed, 18 Apr 2018 13:41:54 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 01/10] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180418104154.lyqj4qipa3d44jb4@valkosipuli.retiisi.org.uk>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-2-git-send-email-akinobu.mita@gmail.com>
 <20180418100549.GA17088@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180418100549.GA17088@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 18, 2018 at 12:05:49PM +0200, jacopo mondi wrote:
> Hi Akinobu,
> 
> On Mon, Apr 16, 2018 at 11:51:42AM +0900, Akinobu Mita wrote:
> > The ov772x driver only works when the i2c controller have
> > I2C_FUNC_PROTOCOL_MANGLING.  However, many i2c controller drivers don't
> > support it.
> >
> > The reason that the ov772x requires I2C_FUNC_PROTOCOL_MANGLING is that
> > it doesn't support repeated starts.
> >
> > This changes the reading ov772x register method so that it doesn't
> > require I2C_FUNC_PROTOCOL_MANGLING by calling two separated i2c messages.
> >
> > Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> > * v2
> > - Replace the implementation of ov772x_read() instead of adding an
> >   alternative method
> 
> I now wonder if my initial reply to this patch was wrong, and where
> possible we should try to use smbus operations...
> 
> From Documentation/i2c/smbus-protocol
> "If you write a driver for some I2C device, please try to use the SMBus
> commands if at all possible... " and that's because, according to
> documentation, most I2c adapters support smbus protocol but may not
> support the full i2c command set.
> 
> The fact this driver then restricts the supported adapters to the ones
> that support protocol mangling makes me think your change is fine,
> but as it often happens, I would scale this to more knowledgable
> people...

Do you actually need to use this on SMBus adapters? A lot of sensor drivers
just use I²C; if SMBus support is really needed it can be always added back
later on...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
