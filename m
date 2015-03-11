Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39310 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbbCKSWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 14:22:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4] media: i2c: add support for omnivision's ov2659 sensor
Date: Wed, 11 Mar 2015 20:22:06 +0200
Message-ID: <2415294.49LTQe4m32@avalon>
In-Reply-To: <20150310013556.GF11954@valkosipuli.retiisi.org.uk>
References: <1425814407-22766-1-git-send-email-prabhakar.csengg@gmail.com> <20150310013556.GF11954@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 March 2015 03:35:57 Sakari Ailus wrote:
> On Sun, Mar 08, 2015 at 11:33:27AM +0000, Lad Prabhakar wrote:
> ...
> 
> > +static struct ov2659_platform_data *
> > +ov2659_get_pdata(struct i2c_client *client)
> > +{
> > +	struct ov2659_platform_data *pdata;
> > +	struct device_node *endpoint;
> > +	int ret;
> > +
> > +	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node) {
> > +		dev_err(&client->dev, "ov2659_get_pdata: DT Node found\n");
> > +		return client->dev.platform_data;
> > +	}
> > +
> > +	endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
> > +	if (!endpoint)
> > +		return NULL;
> > +
> > +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (!pdata)
> > +		goto done;
> > +
> > +	ret = of_property_read_u32(endpoint, "link-frequencies",
> > +				   &pdata->link_frequency);
> 
> This is actually documented as being a 64-bit array.

The main purpose of link-frequencies is to restrict the link frequencies 
acceptable in the system due to EMI requirements. One link frequency should be 
selected in the array based on the desired format and frame rate. This is 
usually done by exposing the frequency to userspace through a writable 
V4L2_CID_LINK_FREQ control, and exposing the resulting pixel rate as a read-
only V4L2_CID_PIXEL_RATE control.

V4L2_CID_PIXEL_RATE is mandatory to use the sensor with several drivers 
(including omap3isp and omap4iss), so it should really be implemented.

> The smiapp wasn't even reading it from the endpoint node. Oh well...

-- 
Regards,

Laurent Pinchart

