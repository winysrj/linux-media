Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33170 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753018AbdIGIJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 04:09:04 -0400
Date: Thu, 7 Sep 2017 11:09:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v8 08/21] rcar-vin: Use generic parser for parsing fwnode
 endpoints
Message-ID: <20170907080900.nhjbaaacg4jrxpva@valkosipuli.retiisi.org.uk>
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-9-sakari.ailus@linux.intel.com>
 <a51aea1f-0a00-7a7b-8197-e0f5a0443a05@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a51aea1f-0a00-7a7b-8197-e0f5a0443a05@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Sep 06, 2017 at 09:44:32AM +0200, Hans Verkuil wrote:
> On 09/05/2017 03:05 PM, Sakari Ailus wrote:
> >  static int rvin_digital_graph_init(struct rvin_dev *vin)
> >  {
> > -	struct v4l2_async_subdev **subdevs = NULL;
> >  	int ret;
> >  
> > -	ret = rvin_digital_graph_parse(vin);
> > +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > +		vin->dev, &vin->notifier,
> > +		sizeof(struct rvin_graph_entity), rvin_digital_parse_v4l2);
> >  	if (ret)
> >  		return ret;
> >  
> > -	if (!vin->digital.asd.match.fwnode.fwnode) {
> > -		vin_dbg(vin, "No digital subdevice found\n");
> > -		return -ENODEV;
> > -	}
> > -
> > -	/* Register the subdevices notifier. */
> > -	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs), GFP_KERNEL);
> > -	if (subdevs == NULL)
> > -		return -ENOMEM;
> > -
> > -	subdevs[0] = &vin->digital.asd;
> > -
> > -	vin_dbg(vin, "Found digital subdevice %pOF\n",
> > -		to_of_node(subdevs[0]->match.fwnode.fwnode));
> > +	if (vin->notifier.num_subdevs > 0)
> > +		vin_dbg(vin, "Found digital subdevice %pOF\n",
> > +			to_of_node(
> > +				vin->notifier.subdevs[0]->match.fwnode.fwnode));
> 
> As mentioned in my review of patch 6/21, this violates the documentation of the
> v4l2_async_notifier_parse_fwnode_endpoints function.
> 
> However, I think the problem is with the documentation and not with this code,
> so:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks. I still don't like to encourage accessing the notifier fields
directly from drivers, and in this case there isn't a need to either. The
following changes work, too, and I'll use them in the next version:

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index bd551f0be213..d1e5909da087 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -177,10 +177,10 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	if (ret)
 		return ret;
 
-	if (vin->notifier.num_subdevs > 0)
+	if (vin->digital)
 		vin_dbg(vin, "Found digital subdevice %pOF\n",
 			to_of_node(
-				vin->notifier.subdevs[0]->match.fwnode.fwnode));
+				vin->digital->asd.match.fwnode.fwnode));
 
 	vin->notifier.bound = rvin_digital_notify_bound;
 	vin->notifier.unbind = rvin_digital_notify_unbind;

I also changed EPERM still used in this version to ENOTCONN.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
