Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48334 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932102AbdIROt0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 10:49:26 -0400
Date: Mon, 18 Sep 2017 17:49:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, jacek.anaszewski@gmail.com
Subject: Re: [RESEND PATCH v2 4/6] dt: bindings: as3645a: Improve label
 documentation, DT example
Message-ID: <20170918144923.dnhrxkirle3fvdfo@valkosipuli.retiisi.org.uk>
References: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
 <20170918102349.8935-5-sakari.ailus@linux.intel.com>
 <20170918105655.GA14591@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918105655.GA14591@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Mon, Sep 18, 2017 at 12:56:55PM +0200, Pavel Machek wrote:
> Hi!
> 
> > Specify the exact label used if the label property is omitted in DT, as
> > well as use label in the example that conforms to LED device naming.
> > 
> > @@ -69,11 +73,11 @@ Example
> >  			flash-max-microamp = <320000>;
> >  			led-max-microamp = <60000>;
> >  			ams,input-max-microamp = <1750000>;
> > -			label = "as3645a:flash";
> > +			label = "as3645a:white:flash";
> >  		};
> >  		indicator@1 {
> >  			reg = <0x1>;
> >  			led-max-microamp = <10000>;
> > -			label = "as3645a:indicator";
> > +			label = "as3645a:red:indicator";
> >  		};
> >  	};
> 
> Ok, but userspace still has no chance to determine if this is flash
> from main camera or flash for front camera; todays smartphones have
> flashes on both cameras.
> 
> So.. Can I suggset as3645a:white:main_camera_flash or main_flash or
> ....?

If there's just a single one in the device, could you use that?

Even if we name this so for N9 (and N900), the application still would only
work with the two devices.

My suggestion would be to look for a flash LED, and perhaps the maximum
current as well. That should generally work better than assumptions on the
label.

For association with a particular camera --- in the long run I'd propose to
use Media controller / property API for that in the long run. We don't have
that yet though.

Cc Jacek, too.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
