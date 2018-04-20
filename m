Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49197 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751012AbeDTTAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 15:00:37 -0400
Date: Fri, 20 Apr 2018 21:00:35 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-media@vger.kernel.org, slongerbeam@gmail.com,
        mchehab@kernel.org
Subject: Re: [PATCH 2/3] media: ov5640: add PIXEL_RATE and LINK_FREQ controls
Message-ID: <20180420190035.bahliwck7rplqvtc@flea>
References: <20180420094419.11267-1-daniel@zonque.org>
 <20180420094419.11267-2-daniel@zonque.org>
 <20180420141528.ethp34p6czomokpi@flea>
 <5d51bdb7-936a-3a6c-bc6d-168cd5221e4d@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5d51bdb7-936a-3a6c-bc6d-168cd5221e4d@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 04:29:42PM +0200, Daniel Mack wrote:
> Hi,
> 
> On Friday, April 20, 2018 04:15 PM, Maxime Ripard wrote:
> > On Fri, Apr 20, 2018 at 11:44:18AM +0200, Daniel Mack wrote:
> 
> >>  struct ov5640_ctrls {
> >>  	struct v4l2_ctrl_handler handler;
> >> +	struct {
> >> +		struct v4l2_ctrl *link_freq;
> >> +		struct v4l2_ctrl *pixel_rate;
> >> +	};
> >>  	struct {
> >>  		struct v4l2_ctrl *auto_exp;
> >>  		struct v4l2_ctrl *exposure;
> >> @@ -732,6 +752,8 @@ static const struct ov5640_mode_info ov5640_mode_init_data = {
> >>  	.dn_mode	= SUBSAMPLING,
> >>  	.width		= 640,
> >>  	.height		= 480,
> >> +	.pixel_rate	= 27766666,
> >> +	.link_freq_idx	= OV5640_LINK_FREQ_111,
> > 
> > I'm not sure where this is coming from, but on a parallel sensor I
> > have a quite different pixel rate.
> 
> Ah, interesting. What exactly do you mean by 'parallel'? What kind of
> module is that, and what are your pixel rates?

An RGB bus, or MIPI-DPI, or basically a pixel clock + 1 line for each
bit. The sensor can operate using both that bus and a MIPI-CSI2 one.

You have the list of pixel rates in the patch I've linked before:
https://patchwork.linuxtv.org/patch/48710/

There's one pixel sent per clock cycle, so the pixel rate is the same
than the clock rate.

Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
