Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54698 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755684AbdGSWmu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 18:42:50 -0400
Date: Thu, 20 Jul 2017 01:42:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/2] v4l2-flash-led-class: Create separate sub-devices
 for indicators
Message-ID: <20170719224246.2hmxu6ba7ihv3owv@valkosipuli.retiisi.org.uk>
References: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
 <20170718184107.10598-3-sakari.ailus@linux.intel.com>
 <20170719120246.GB23510@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170719120246.GB23510@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 19, 2017 at 02:02:46PM +0200, Pavel Machek wrote:
> On Tue 2017-07-18 21:41:07, Sakari Ailus wrote:
> > The V4L2 flash interface allows controlling multiple LEDs through a single
> > sub-devices if, and only if, these LEDs are of different types. This
> > approach scales badly for flash controllers that drive multiple flash LEDs
> > or for LED specific associations. Essentially, the original assumption of a
> > LED driver chip that drives a single flash LED and an indicator LED is no
> > longer valid.
> > 
> > Address the matter by registering one sub-device per LED.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks!

> 
> Does anything need to be done with drivers/media/i2c/adp1653.c ?

Well, it does expose the two LEDs through the same sub-device. I don't
think that'd really be an issue. The drivers/media/i2c/as3645a.c does the
same, I think it's fine to keep that.

Effectively only new drivers will have the new behaviour (apart from the
greybus staging driver).

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
