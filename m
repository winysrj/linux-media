Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:48589 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753177AbdEDPOM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 11:14:12 -0400
Message-ID: <1493910850.2381.29.camel@pengutronix.de>
Subject: Re: [PATCH v3 2/2] [media] platform: add video-multiplexer
 subdevice driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 04 May 2017 17:14:10 +0200
In-Reply-To: <20170504142123.3hiblxfkdtbrvotb@earth>
References: <1493905137-27051-1-git-send-email-p.zabel@pengutronix.de>
         <1493905137-27051-2-git-send-email-p.zabel@pengutronix.de>
         <20170504142123.3hiblxfkdtbrvotb@earth>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

On Thu, 2017-05-04 at 16:21 +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Thu, May 04, 2017 at 03:38:57PM +0200, Philipp Zabel wrote:
> > This driver can handle SoC internal and external video bus multiplexers,
> > controlled by mux controllers provided by the mux controller framework,
> > such as MMIO register bitfields or GPIOs. The subdevice passes through
> > the mbus configuration of the active input to the output side.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> > ---
> > Changes since v2 [1]:
> >  - Extend vmux->lock to protect mbus format against simultaneous access
> >    from get/set_format calls.
> >  - Drop is_source_pad(), check pad->flags & MEDIA_PAD_FL_SOURCE directly.
> >  - Replace v4l2_of_parse_endpoint call with v4l2_fwnode_endpoint_parse,
> >    include media/v4l2-fwnode.h instead of media/v4l2-of.h.
> >  - Constify ops structures.
> > 
> > This was previously sent as part of Steve's i.MX media series [2].
> > Tested against
> > https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi-merge
> > 
> > [1] https://patchwork.kernel.org/patch/9708237/
> > [2] https://patchwork.kernel.org/patch/9647869/
> 
> Looks fine to me. Just one nitpick:
> 
> > +static int video_mux_probe(struct platform_device *pdev)
> > +{
> 
> [...]
> 
> > +	vmux->pads = devm_kzalloc(dev, sizeof(*vmux->pads) * num_pads,
> > +				  GFP_KERNEL);
> > +	vmux->format_mbus = devm_kzalloc(dev, sizeof(*vmux->format_mbus) *
> > +					 num_pads, GFP_KERNEL);
> > +	vmux->endpoint = devm_kzalloc(dev, sizeof(*vmux->endpoint) *
> > +				      (num_pads - 1), GFP_KERNEL);
> 
> devm_kcalloc(dev, num_pads, sizeof(*foo), GFP_KERNEL).

thank you, I'll fix this.

regards
Philipp
