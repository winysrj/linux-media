Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37490 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731781AbeHCQIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 12:08:00 -0400
Date: Fri, 3 Aug 2018 17:11:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCH 2/2] media: v4l2-common: simplify v4l2_i2c_subdev_init
 name generation
Message-ID: <20180803141128.v2xsqdijrx7hrz6q@valkosipuli.retiisi.org.uk>
References: <1533158457-15831-1-git-send-email-phdm@macqel.be>
 <1533158457-15831-2-git-send-email-phdm@macqel.be>
 <20180803124315.i4vcpdnha42nw3lh@valkosipuli.retiisi.org.uk>
 <20180803134632.GA24977@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180803134632.GA24977@frolo.macqel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 03, 2018 at 03:46:32PM +0200, Philippe De Muyter wrote:
> Hi Sakari,
> 
> On Fri, Aug 03, 2018 at 03:43:15PM +0300, Sakari Ailus wrote:
> > Hi Philippe,
> > 
> > On Wed, Aug 01, 2018 at 11:20:57PM +0200, Philippe De Muyter wrote:
> > > When v4l2_i2c_subdev_init is called, dev_name(&client->dev) has already
> > > been set.  Use it to generate subdev's name instead of recreating it
> > > with "%d-%04x".  This improves the similarity in subdev's name creation
> > > between v4l2_i2c_subdev_init and v4l2_spi_subdev_init.
> > > 
> > > Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> > > ---
> > >  drivers/media/v4l2-core/v4l2-common.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> > > index 5471c6d..b062111 100644
> > > --- a/drivers/media/v4l2-core/v4l2-common.c
> > > +++ b/drivers/media/v4l2-core/v4l2-common.c
> > > @@ -121,9 +121,8 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
> > >  	v4l2_set_subdevdata(sd, client);
> > >  	i2c_set_clientdata(client, sd);
> > >  	/* initialize name */
> > > -	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
> > > -		client->dev.driver->name, i2c_adapter_id(client->adapter),
> > > -		client->addr);
> > > +	snprintf(sd->name, sizeof(sd->name), "%s %s",
> > > +		client->dev.driver->name, dev_name(&client->dev));
> > >  }
> > >  EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
> > >  
> > 
> > I like the patch in principle. But what's the effect of this on the actual
> > sub-device (and entity) names? Looking at i2c_dev_set_name(), this will be
> > different. We can't change the existing entity naming in drivers, this will
> > break applications that expect them to be named in a certain way.
> 
> Yeah.  I am 10 years too late.
> 
> Maybe adding for a long transition period a kernel message giving the new
> name and the old one if they are different ?

I think this information would be usable for the property API if we ever get
around defining it precisely and implementing it. That's long term stuff in
any case.

<URL:https://spinics.net/lists/linux-media/msg90160.html>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
