Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab1IRUNj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 16:13:39 -0400
Date: Sun, 18 Sep 2011 22:13:36 +0200
From: martin@neutronstar.dyndns.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] arm: omap3evm: Add support for an MT9M032 based
 camera board.
References: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
 <4E751870.5080605@gmail.com>
 <201109180008.21254.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109180008.21254.laurent.pinchart@ideasonboard.com>
Message-Id: <1316376816.669188.9350@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 18, 2011 at 12:08:20AM +0200, Laurent Pinchart wrote:
> On Sunday 18 September 2011 00:00:16 Sylwester Nawrocki wrote:
> > On 09/17/2011 11:34 AM, Martin Hostettler wrote:
> > > Adds board support for an MT9M032 based camera to omap3evm.
> > 
> > ...
> > 
> > > +
> > > +static int __init camera_init(void)
> > > +{
> > > +	int ret = -EINVAL;
> > > +
> > > +	omap_mux_init_gpio(nCAM_VD_SEL, OMAP_PIN_OUTPUT);
> > > +	if (gpio_request(nCAM_VD_SEL, "nCAM_VD_SEL")<  0) {
> > > +		pr_err("omap3evm-camera: Failed to get GPIO nCAM_VD_SEL(%d)\n",
> > > +		       nCAM_VD_SEL);
> > > +		goto err;
> > > +	}
> > > +	if (gpio_direction_output(nCAM_VD_SEL, 1)<  0) {
> > > +		pr_err("omap3evm-camera: Failed to set GPIO nCAM_VD_SEL(%d)
> > > direction\n", +		       nCAM_VD_SEL);
> > > +		goto err_vdsel;
> > > +	}
> > 
> > How about replacing gpio_request + gpio_direction_output with:
> > 
> > 	gpio_request_one(nCAM_VD_SEL, GPIOF_OUT_INIT_HIGH, "nCAM_VD_SEL");
> 
> I'd even propose gpio_request_array().
> 

Nice interface. Apart from a bit less detailed error reporting it nicely
simplifies the code. I'll make a new patch using that soon.

 - Martin Hostettler
