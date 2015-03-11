Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39404 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbbCKUOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 16:14:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] media: i2c: add support for omnivision's ov2659 sensor
Date: Wed, 11 Mar 2015 22:14:52 +0200
Message-ID: <1868898.q0gy7fiiPL@avalon>
In-Reply-To: <CA+V-a8tHrUS-=s8sas-yHy6Pnwbh+wu6KxyHDTfARopguqYL2g@mail.gmail.com>
References: <1425814407-22766-1-git-send-email-prabhakar.csengg@gmail.com> <2415294.49LTQe4m32@avalon> <CA+V-a8tHrUS-=s8sas-yHy6Pnwbh+wu6KxyHDTfARopguqYL2g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Wednesday 11 March 2015 19:40:13 Lad, Prabhakar wrote:
> On Wed, Mar 11, 2015 at 6:22 PM, Laurent Pinchart wrote:
> > On Tuesday 10 March 2015 03:35:57 Sakari Ailus wrote:
> >> On Sun, Mar 08, 2015 at 11:33:27AM +0000, Lad Prabhakar wrote:
> >> ...
> >> 
> >> > +static struct ov2659_platform_data *
> >> > +ov2659_get_pdata(struct i2c_client *client)
> >> > +{
> >> > +   struct ov2659_platform_data *pdata;
> >> > +   struct device_node *endpoint;
> >> > +   int ret;
> >> > +
> >> > +   if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node) {
> >> > +           dev_err(&client->dev, "ov2659_get_pdata: DT Node found\n");
> >> > +           return client->dev.platform_data;
> >> > +   }
> >> > +
> >> > +   endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
> >> > +   if (!endpoint)
> >> > +           return NULL;
> >> > +
> >> > +   pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> >> > +   if (!pdata)
> >> > +           goto done;
> >> > +
> >> > +   ret = of_property_read_u32(endpoint, "link-frequencies",
> >> > +                              &pdata->link_frequency);
> >> 
> >> This is actually documented as being a 64-bit array.
> > 
> > The main purpose of link-frequencies is to restrict the link frequencies
> > acceptable in the system due to EMI requirements. One link frequency
> > should be selected in the array based on the desired format and frame
> > rate. This is usually done by exposing the frequency to userspace through
> > a writable V4L2_CID_LINK_FREQ control, and exposing the resulting pixel
> > rate as a read- only V4L2_CID_PIXEL_RATE control.
> > 
> > V4L2_CID_PIXEL_RATE is mandatory to use the sensor with several drivers
> > (including omap3isp and omap4iss), so it should really be implemented.
> 
> Even if the sensor supports only one frequency the control needs to be
> implemented ?

The V4L2_CID_PIXEL_RATE must be implemented even for sensors supporting a 
single pixel rate, yes. The reason is that the receiver needs to know the 
sensor pixel rate in order to configure its clocking.

-- 
Regards,

Laurent Pinchart

