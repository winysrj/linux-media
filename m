Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48700 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752981AbbCRU47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 16:56:59 -0400
Date: Wed, 18 Mar 2015 22:56:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Carlos =?iso-8859-1?Q?Sanmart=EDn?= Bustos <carsanbu@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 2/2] v4l: mt9v032: Add OF support
Message-ID: <20150318205622.GJ11954@valkosipuli.retiisi.org.uk>
References: <1426345057-2752-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1426345057-2752-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20150315002107.GA11954@valkosipuli.retiisi.org.uk>
 <2768138.CXiK86JdWh@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2768138.CXiK86JdWh@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Mar 18, 2015 at 03:32:28PM +0200, Laurent Pinchart wrote:
...
> > > @@ -876,10 +879,59 @@ static const struct regmap_config
> > > mt9v032_regmap_config = {> 
> > >   * Driver initialization and probing
> > >   */
> > > 
> > > +static struct mt9v032_platform_data *
> > > +mt9v032_get_pdata(struct i2c_client *client)
> > > +{
> > > +	struct mt9v032_platform_data *pdata;
> > > +	struct v4l2_of_endpoint endpoint;
> > > +	struct device_node *np;
> > > +	struct property *prop;
> > > +
> > > +	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> > > +		return client->dev.platform_data;
> > > +
> > > +	np = of_graph_get_next_endpoint(client->dev.of_node, NULL);
> > > +	if (!np)
> > > +		return NULL;
> > > +
> > > +	if (v4l2_of_parse_endpoint(np, &endpoint) < 0)
> > > +		goto done;
> > > +
> > > +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> > > +	if (!pdata)
> > > +		goto done;
> > > +
> > > +	prop = of_find_property(np, "link-frequencies", NULL);
> > > +	if (prop) {
> > > +		size_t size = prop->length / 8;
> > > +		u64 *link_freqs;
> > > +
> > > +		link_freqs = devm_kzalloc(&client->dev,
> > > +					  size * sizeof(*link_freqs),
> > 
> > You could simply use prop->length here. I think that'd look nicer.
> 
> How about devm_kcalloc(&client->dev, size, sizeof(*link_freqs)) as this is 
> allocating an array ?

That's certainly fine as well, I think. Feel free to divide prop->length by
sizeof(*link_freqs) instead of plain 8.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
