Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41016 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751982AbdGDFnq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Jul 2017 01:43:46 -0400
Date: Tue, 4 Jul 2017 08:43:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 09/19] media: camms: Add core files
Message-ID: <20170704054310.p66gqgczah4o4wjs@valkosipuli.retiisi.org.uk>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
 <1497883719-12410-10-git-send-email-todor.tomov@linaro.org>
 <20170629063328.l4j47ubhu2gy7txa@valkosipuli.retiisi.org.uk>
 <5abc06cc-d79d-bcda-a4ce-5b6effafeed9@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5abc06cc-d79d-bcda-a4ce-5b6effafeed9@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Jul 03, 2017 at 05:03:40PM +0300, Todor Tomov wrote:
> >> +	unsigned int i;
> >> +
> >> +	v4l2_of_parse_endpoint(node, &vep);
> >> +
> >> +	csd->interface.csiphy_id = vep.base.port;
> >> +
> >> +	mipi_csi2 = &vep.bus.mipi_csi2;
> >> +	lncfg->clk.pos = mipi_csi2->clock_lane;
> >> +	lncfg->clk.pol = mipi_csi2->lane_polarities[0];
> >> +	lncfg->num_data = mipi_csi2->num_data_lanes;
> >> +
> >> +	lncfg->data = devm_kzalloc(dev, lncfg->num_data * sizeof(*lncfg->data),
> >> +				   GFP_KERNEL);
> >> +	if (!lncfg->data)
> >> +		return -ENOMEM;
> >> +
> >> +	for (i = 0; i < lncfg->num_data; i++) {
> >> +		lncfg->data[i].pos = mipi_csi2->data_lanes[i];
> >> +		lncfg->data[i].pol = mipi_csi2->lane_polarities[i + 1];
> >> +	}
> >> +
> >> +	of_property_read_u32(node, "qcom,settle-cnt", settle_cnt);
> > 
> > Isn't this something that depends on the CSI-2 bus speed, for instance?
> > Could you calculate it instead of putting it to DT?
> 
> Actually, after some digging into this, yes, I can calculate it. I can
> calculate the CSI-2 bus speed based on the sensor's output pixel clock
> and then calculate the settle time and this settle count value.
> So I already have the code to get the sensor's pixel clock using the
> standard v4l2 control V4L2_CID_PIXEL_RATE.

What we have currently in documentation on this is here:

<URL:https://www.linuxtv.org/downloads/v4l-dvb-apis/kapi/csi2.html>

I.e. both should be implemented. The link frequency is rather more relevant
for CSI-2 albeit you can derive one from the other in case of CSI-2. The
pixel rate documentation should probably be rather elsewhere.

> Now the question is what to do if the sensor driver doesn't support this
> control? Just return an error and refuse to work with this "limited"
> sensor driver?

If the sensor driver does not provide enough information to work with a
receiver, it's only fair not to proceed with streaming. That said, it might
be possible to manage with some sensible defaults in some cases but then again
you could have only some units working with this configuration. It'd be
much safer to require the information: not doing so hides the error and
makes it (more) difficult to debug.

...

> >> +struct camss {
> >> +	struct v4l2_device v4l2_dev;
> >> +	struct v4l2_async_notifier notifier;
> >> +	struct media_device media_dev;
> >> +	struct device *dev;
> >> +	struct csiphy_device csiphy[CAMSS_CSIPHY_NUM];
> >> +	struct csid_device csid[CAMSS_CSID_NUM];
> >> +	struct ispif_device ispif;
> >> +	struct vfe_device vfe;
> >> +	atomic_t ref_count;

If this is refcount, then you should use refcount_t instead.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
