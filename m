Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57792 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754152AbbDHWNk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 18:13:40 -0400
Date: Thu, 9 Apr 2015 01:13:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v3 4/4] smiapp: Use v4l2_of_alloc_parse_endpoint()
Message-ID: <20150408221334.GZ20756@valkosipuli.retiisi.org.uk>
References: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi>
 <1428361053-20411-5-git-send-email-sakari.ailus@iki.fi>
 <3264259.HtLEAUTuYM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3264259.HtLEAUTuYM@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Apr 07, 2015 at 01:10:20PM +0300, Laurent Pinchart wrote:
> > @@ -3022,34 +3026,30 @@ static struct smiapp_platform_data
> > *smiapp_get_pdata(struct device *dev) dev_dbg(dev, "reset %d, nvm %d, clk
> > %d, csi %d\n", pdata->xshutdown, pdata->nvm_size, pdata->ext_clk,
> > pdata->csi_signalling_mode);
> > 
> > -	rval = of_get_property(ep, "link-frequencies", &asize) ? 0 : -ENOENT;
> > -	if (rval) {
> > -		dev_warn(dev, "can't get link-frequencies array size\n");
> > +	if (!bus_cfg->nr_of_link_frequencies) {
> 
> Now that I see it being used, nr_of_link_frequencies feels a bit long. 
> num_link_freqs could be an alternative. I'll let you decide. But for this 
> patch,

It's long, I agree, but still used in only a small number of places in
drivers. I'd prefer to keep it as-is also as the name matches the name of
the property.

> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
