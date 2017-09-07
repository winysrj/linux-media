Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34682 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754740AbdIGK1A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 06:27:00 -0400
Date: Thu, 7 Sep 2017 13:26:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, javier@dowhile0.org,
        jacek.anaszewski@gmail.com
Subject: Re: [PATCH v3 2/3] leds: as3645a: Add LED flash class driver
Message-ID: <20170907102657.stoqw5e7glbkbz2z@valkosipuli.retiisi.org.uk>
References: <20170823081100.11733-1-sakari.ailus@linux.intel.com>
 <20170823081100.11733-3-sakari.ailus@linux.intel.com>
 <20170828110451.GB492@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828110451.GB492@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Mon, Aug 28, 2017 at 01:04:51PM +0200, Pavel Machek wrote:
> On Wed 2017-08-23 11:10:59, Sakari Ailus wrote:
> > Add a LED flash class driver for the as3654a flash controller. A V4L2 flash
> > driver for it already exists (drivers/media/i2c/as3645a.c), and this driver
> > is based on that.
> 
> We do not want to have two drivers for same hardware... how is that
> supposed to work?

No, we don't. The intent is to remove the other driver later on, as it's
implemented as a V4L2 sub-device driver. It also lacks DT support.

> 
> Yes, we might want to have both LED and v4l2 interface for a single
> LED, because v4l2 is just too hairy to use, but we should not
> duplicate drivers for that.
> 
> We _might_ want to do some helpers; as these LED drivers are all quite
> similar, it should be possible to have "flash led driver" and just
> link it to v4l2 and LED interfaces...

This is what the new LED (flash) class driver does. Feature-wise it's a
superset of the old one. There's a minor matter left, though, which is
querying the flash strobe status which the old driver did and the new one
does not do yet. I don't know if anyone ever even used that feature though.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
