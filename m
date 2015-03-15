Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44664 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751477AbbCOXRQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 19:17:16 -0400
Date: Mon, 16 Mar 2015 01:16:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v1.1 3/3] v4l: of: Add link-frequencies array to struct
 v4l2_of_endpoint
Message-ID: <20150315231639.GC11954@valkosipuli.retiisi.org.uk>
References: <CA+V-a8u3o7fouVF5=cD=jsVdg0HGzP-ibU34mDW=q81ERknAaQ@mail.gmail.com>
 <1426193354-17830-1-git-send-email-sakari.ailus@iki.fi>
 <Pine.LNX.4.64.1503151739530.13027@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1503151739530.13027@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Many thanks for the comments!

On Sun, Mar 15, 2015 at 06:15:27PM +0100, Guennadi Liakhovetski wrote:
> Hi Sakari,
> 
> Thanks for the patches.
> 
> On Thu, 12 Mar 2015, Sakari Ailus wrote:
> 
> > Parse and read the link-frequencies property in v4l2_of_parse_endpoint().
> > The property is an u64 array of undefined length, thus the memory allocation
> > may fail, leading
> > 
> > - v4l2_of_parse_endpoint() to return an error in such a case (as well as
> >   when failing to parse the property) and
> > - to requiring releasing the memory reserved for the array
> >   (v4l2_of_release_endpoint()).
> > 
> > If a driver does not need to access properties that require memory
> > allocation (such as link-frequencies), it may choose to call
> > v4l2_of_release_endpoint() right after calling v4l2_of_parse_endpoint().
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > ---
> > since v1:
> > 
> > - Set the link_frequencies pointer to NULL and set nr_of_link_frequencies to
> >   zero if link-frequencies property cannot be found by changing memset
> >   arguments. Thanks to Prabhakar for spotting this!
> > 
> >  drivers/media/i2c/adv7604.c                    |    1 +
> >  drivers/media/i2c/s5c73m3/s5c73m3-core.c       |    1 +
> >  drivers/media/i2c/s5k5baf.c                    |    1 +
> >  drivers/media/i2c/smiapp/smiapp-core.c         |   32 +++++++--------
> >  drivers/media/i2c/tvp514x.c                    |    1 +
> >  drivers/media/i2c/tvp7002.c                    |    1 +
> >  drivers/media/platform/am437x/am437x-vpfe.c    |    1 +
> >  drivers/media/platform/exynos4-is/media-dev.c  |    1 +
> >  drivers/media/platform/exynos4-is/mipi-csis.c  |    1 +
> >  drivers/media/platform/soc_camera/atmel-isi.c  |    1 +
> >  drivers/media/platform/soc_camera/pxa_camera.c |    1 +
> >  drivers/media/platform/soc_camera/rcar_vin.c   |    1 +
> 
> You'll find a couple of notes below, but none of them is critical, so you 
> can have my
> 
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> for soc-camera drivers above.

Thanks --- but I think I've somewhat reworked the patch already. I'll send a
new version. I think the changes should answer to at least some of the
concerns you've had.

> >  drivers/media/v4l2-core/v4l2-of.c              |   51 +++++++++++++++++++++++-
> >  include/media/v4l2-of.h                        |    9 +++++
> >  14 files changed, 84 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> > index aaab9c9..9c6c2a5 100644
> > --- a/drivers/media/i2c/adv7604.c
> > +++ b/drivers/media/i2c/adv7604.c
> > @@ -2624,6 +2624,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
> >  		return -EINVAL;
> >  
> >  	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> > +	v4l2_of_release_endpoint(&bus_cfg);
> >  	of_node_put(endpoint);
> >  
> >  	flags = bus_cfg.bus.parallel.flags;
> 
> This is a general comment - for this and all other "trivial" cases below: 
> I understand that none of them use your new dynamically-allocated field, 
> but still a sequence like
> 
> 	release(&x);
> 	y = x.z;
> 
> looks like an invitation for future bugs to me. You can check all patches 
> locations and put release() after the last use of the endpoint, but, well, 
> I'm not sure how really important this is.

I didn't much like the construct either, I have to admit. Instead, I thought
of adding two more interface functions, v4l2_of_endpoint_get() and
v4l2_of_endpoint_put(). The former is v4l2_of_parse_endpoint() amended with
parsing variable size nodes (without small maximum size), and the latter is
what v4l2_of_release_endpoint() was in this patch.

The naming probably could be improved, but this way the existing users don't
need to start caring about acquiring or releasing resources they do not
need.

> > diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> > index ecae76b..2b3cd9e 100644
> > --- a/drivers/media/i2c/smiapp/smiapp-core.c
> > +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> > @@ -2977,7 +2977,7 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
> >  	struct smiapp_platform_data *pdata;
> >  	struct v4l2_of_endpoint bus_cfg;
> >  	struct device_node *ep;
> > -	uint32_t asize;
> > +	int i;
> >  	int rval;
> >  
> >  	if (!dev->of_node)
> > @@ -2987,12 +2987,14 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
> >  	if (!ep)
> >  		return NULL;
> >  
> > +	rval = v4l2_of_parse_endpoint(ep, &bus_cfg);
> > +	if (rval < 0)
> > +		goto out_err;
> > +
> >  	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> >  	if (!pdata)
> >  		goto out_err;
> >  
> > -	v4l2_of_parse_endpoint(ep, &bus_cfg);
> > -
> >  	switch (bus_cfg.bus_type) {
> >  	case V4L2_MBUS_CSI2:
> >  		pdata->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
> > @@ -3022,34 +3024,30 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
> >  	dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", pdata->xshutdown,
> >  		pdata->nvm_size, pdata->ext_clk, pdata->csi_signalling_mode);
> >  
> > -	rval = of_get_property(ep, "link-frequencies", &asize) ? 0 : -ENOENT;
> > -	if (rval) {
> > -		dev_warn(dev, "can't get link-frequencies array size\n");
> > +	if (!bus_cfg.nr_of_link_frequencies) {
> > +		dev_warn(dev, "no link frequencies defined\n");
> >  		goto out_err;
> >  	}
> >  
> > -	pdata->op_sys_clock = devm_kzalloc(dev, asize, GFP_KERNEL);
> > +	pdata->op_sys_clock = devm_kmalloc_array(
> > +		dev, bus_cfg.nr_of_link_frequencies + 1 /* guardian */,
> > +		sizeof(*bus_cfg.link_frequencies), GFP_KERNEL);
> 
> You probably want "sizeof(*pdata->op_sys_clock)"

Yes. Fixed.

> >  	if (!pdata->op_sys_clock) {
> >  		rval = -ENOMEM;
> >  		goto out_err;
> >  	}
> >  
> > -	asize /= sizeof(*pdata->op_sys_clock);
> > -	rval = of_property_read_u64_array(
> > -		ep, "link-frequencies", pdata->op_sys_clock, asize);
> > -	if (rval) {
> > -		dev_warn(dev, "can't get link-frequencies\n");
> > -		goto out_err;
> > +	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++) {
> > +		pdata->op_sys_clock[i] = bus_cfg.link_frequencies[i];
> > +		dev_dbg(dev, "freq %d: %lld\n", i, pdata->op_sys_clock[i]);
> >  	}

^

This one was missing assigning the value at last index to zero... ouch.

> >  
> > -	for (; asize > 0; asize--)
> > -		dev_dbg(dev, "freq %d: %lld\n", asize - 1,
> > -			pdata->op_sys_clock[asize - 1]);
> > -
> > +	v4l2_of_release_endpoint(&bus_cfg);
> >  	of_node_put(ep);
> >  	return pdata;
> >  
> >  out_err:
> > +	v4l2_of_release_endpoint(&bus_cfg);
> >  	of_node_put(ep);
> >  	return NULL;
> >  }
> 
> [snip]
> 
> > diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> > index b4ed9a9..9043eea 100644
> > --- a/drivers/media/v4l2-core/v4l2-of.c
> > +++ b/drivers/media/v4l2-core/v4l2-of.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> > +#include <linux/slab.h>
> >  #include <linux/string.h>
> >  #include <linux/types.h>
> >  
> > @@ -109,6 +110,26 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
> >  }
> >  
> >  /**
> > + * v4l2_of_release_endpoint() - release resources acquired by
> > + * v4l2_of_parse_endpoint()
> > + * @endpoint - the endpoint the resources of which are to be released
> > + *
> > + * It is safe to call this function on an endpoint which is not parsed or
> > + * and endpoint the parsing of which failed. However in the former case the
> > + * argument must point to a struct the memory of which has been set to zero.
> > + *
> > + * Values in the struct v4l2_of_endpoint that are not connected to resources
> > + * acquired by v4l2_of_parse_endpoint() are guaranteed to remain untouched.
> > + */
> > +void v4l2_of_release_endpoint(struct v4l2_of_endpoint *endpoint)
> > +{
> > +	kfree(endpoint->link_frequencies);
> > +	endpoint->link_frequencies = NULL;
> > +	endpoint->nr_of_link_frequencies = 0;
> > +}
> > +EXPORT_SYMBOL(v4l2_of_parse_endpoint);
> 
> You want to swap "EXPORT_SYMBOL()" calls here and below :)

Fixed.

> > +
> > +/**
> >   * v4l2_of_parse_endpoint() - parse all endpoint node properties
> >   * @node: pointer to endpoint device_node
> >   * @endpoint: pointer to the V4L2 OF endpoint data structure
> > @@ -122,14 +143,40 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
> >   * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
> >   * The caller should hold a reference to @node.
> >   *
> > + * An endpoint parsed using v4l2_of_parse_endpoint() must be released using
> > + * v4l2_of_release_endpoint().
> > + *
> >   * Return: 0.
> >   */
> >  int v4l2_of_parse_endpoint(const struct device_node *node,
> >  			   struct v4l2_of_endpoint *endpoint)
> >  {
> > +	int len;
> > +
> >  	of_graph_parse_endpoint(node, &endpoint->base);
> >  	endpoint->bus_type = 0;
> > -	memset(&endpoint->bus, 0, sizeof(endpoint->bus));
> > +	/* Zero fields from bus to until head (excluding) */
> > +	memset(&endpoint->bus, 0, offsetof(typeof(*endpoint), head) -
> > +	       offsetof(typeof(*endpoint), bus));
> 
> You can move fields around in struct v4l2_of_endpoint to avoid this risky 
> arithmetic. If you move it to the beginning, you'll only have one 
> offsetof(). OTOH, maybe it's better to play safe and zero out each field 
> explicitly.

I've thought about different options and I think my preference is to keep it
as-is (or close to that), with perhaps adding a comment on the matter.

When additional fields are added to the struct, they would need to be taken
into account in multiple places. Now there's just where to allocate and
release them (setting pointers to NULL can be achieved by using memset,
too).

I'll resend, please tell me what's your opinion. I'm open to other options,
too.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
