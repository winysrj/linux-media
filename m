Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:50242 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbeHHLCS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Aug 2018 07:02:18 -0400
Date: Wed, 8 Aug 2018 10:43:34 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCH 2/2] media: v4l2-common: simplify v4l2_i2c_subdev_init
        name generation
Message-ID: <20180808084333.GA21052@frolo.macqel>
References: <1533158457-15831-1-git-send-email-phdm@macqel.be> <1533158457-15831-2-git-send-email-phdm@macqel.be> <20180803124315.i4vcpdnha42nw3lh@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180803124315.i4vcpdnha42nw3lh@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 03, 2018 at 03:43:15PM +0300, Sakari Ailus wrote:
> Hi Philippe,
> 
> On Wed, Aug 01, 2018 at 11:20:57PM +0200, Philippe De Muyter wrote:
> > When v4l2_i2c_subdev_init is called, dev_name(&client->dev) has already
> > been set.  Use it to generate subdev's name instead of recreating it
> > with "%d-%04x".  This improves the similarity in subdev's name creation
> > between v4l2_i2c_subdev_init and v4l2_spi_subdev_init.
> > 
> > Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> > ---
> >  drivers/media/v4l2-core/v4l2-common.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> > index 5471c6d..b062111 100644
> > --- a/drivers/media/v4l2-core/v4l2-common.c
> > +++ b/drivers/media/v4l2-core/v4l2-common.c
> > @@ -121,9 +121,8 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
> >  	v4l2_set_subdevdata(sd, client);
> >  	i2c_set_clientdata(client, sd);
> >  	/* initialize name */
> > -	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
> > -		client->dev.driver->name, i2c_adapter_id(client->adapter),
> > -		client->addr);
> > +	snprintf(sd->name, sizeof(sd->name), "%s %s",
> > +		client->dev.driver->name, dev_name(&client->dev));
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
> >  
> 
> I like the patch in principle. But what's the effect of this on the actual
> sub-device (and entity) names? Looking at i2c_dev_set_name(), this will be
> different. We can't change the existing entity naming in drivers, this will
> break applications that expect them to be named in a certain way.

Does your comment also prevent patch 1/2
"media: v4l2-common: v4l2_spi_subdev_init : generate unique name"
to be accepted ?

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
