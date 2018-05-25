Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52972 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S936015AbeEYNxB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 09:53:01 -0400
Date: Fri, 25 May 2018 16:52:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        andy.yeh@intel.com
Subject: Re: [PATCH v2 2/2] smiapp: Support the "upside-down" property
Message-ID: <20180525135259.3d6ps76tkvztrrxg@valkosipuli.retiisi.org.uk>
References: <20180525122726.3409-1-sakari.ailus@linux.intel.com>
 <20180525122726.3409-3-sakari.ailus@linux.intel.com>
 <20180525134159.ju7dz3dp7wtveswc@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525134159.ju7dz3dp7wtveswc@earth.universe>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 03:41:59PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Fri, May 25, 2018 at 03:27:26PM +0300, Sakari Ailus wrote:
> > Use the "upside-down" property to tell that the sensor is mounted upside
> > down. This reverses the behaviour of the VFLIP and HFLIP controls as well
> > as the pixel order.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> 
> Patch subject and description should be s/"upside-down"/"rotation"/g ?
> 
> >  .../devicetree/bindings/media/i2c/nokia,smia.txt         |  2 ++
> >  drivers/media/i2c/smiapp/smiapp-core.c                   | 16 ++++++++++++++++
> >  2 files changed, 18 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > index 33f10a94c381..6f509657470e 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > @@ -29,6 +29,8 @@ Optional properties
> >  - reset-gpios: XSHUTDOWN GPIO
> >  - flash-leds: See ../video-interfaces.txt
> >  - lens-focus: See ../video-interfaces.txt
> > +- rotation: Integer property; valid values are 0 (sensor mounted upright)
> > +	    and 180 (sensor mounted upside down).
> >  
> >  
> >  Endpoint node mandatory properties
> > diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> > index e1f8208581aa..32286df6ab43 100644
> > --- a/drivers/media/i2c/smiapp/smiapp-core.c
> > +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> > @@ -2764,6 +2764,7 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
> >  	struct v4l2_fwnode_endpoint *bus_cfg;
> >  	struct fwnode_handle *ep;
> >  	struct fwnode_handle *fwnode = dev_fwnode(dev);
> > +	u32 rotation;
> >  	int i;
> >  	int rval;
> >  
> > @@ -2800,6 +2801,21 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
> >  
> >  	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
> >  
> > +	rval = fwnode_property_read_u32(fwnode, "upside-down", &rotation);
> 
> "rotation"

Thanks. Both fixed in v2.2.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
