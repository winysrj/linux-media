Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58163 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2L1AES (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 19:04:18 -0500
Date: Fri, 28 Dec 2012 01:04:04 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Clark <rob.clark@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
Message-ID: <20121228000404.GY26326@pengutronix.de>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com>
 <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
 <9690842.n93imGlCHA@avalon>
 <CAF6AEGt+gwUq-xGze5bTgrKUMRijSBo_ORreq=Ot1RMD-WrbYQ@mail.gmail.com>
 <20121227191859.GX26326@pengutronix.de>
 <CAF6AEGtWOoNjKuUgu=AaZn3Jj8g_D807Ycyjtu5bro8ZLL1NNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGtWOoNjKuUgu=AaZn3Jj8g_D807Ycyjtu5bro8ZLL1NNg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 27, 2012 at 01:57:56PM -0600, Rob Clark wrote:
> On Thu, Dec 27, 2012 at 1:18 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Thu, Dec 27, 2012 at 09:54:55AM -0600, Rob Clark wrote:
> >> On Mon, Dec 24, 2012 at 7:37 AM, Laurent Pinchart
> >
> > This implies that the master driver knows all potential subdevices,
> > something which is not true for SoCs which have external i2c encoders
> > attached to unrelated i2c controllers.
> 
> well, it can be brute-forced..  ie. drm driver calls common
> register_all_panels() fxn, which, well, registers all the
> panel/display subdev's based on their corresponding CONFIG_FOO_PANEL
> defines.  If you anyways aren't building the panels as separate
> modules, that would work.  Maybe not the most *elegant* approach, but
> simple and functional.
> 
> I guess it partly depends on the structure in devicetree.  If you are
> assuming that the i2c encoder belongs inside the i2c bus, like:
> 
>   &i2cN {
>     foo-i2c-encoder {
>       ....
>     };
>   };
> 
> and you are letting devicetree create the devices, then it doesn't
> quite work.  I'm not entirely convinced you should do it that way.
> Really any device like that is going to be hooked up to at least a
> couple busses..  i2c, some sort of bus carrying pixel data, maybe some
> gpio's, etc.  So maybe makes more sense for a virtual drm/kms bus, and
> then use phandle stuff to link it to the various other busses it
> needs:
> 
>   mydrmdev {
>     foo-i2c-encoder {
>        i2c = <&i2cN>;
>        gpio = <&gpioM 2 3>
>        ...
>     };
>   };

This seems to shift initialization order problem to another place.
Here we have to make sure the controller is initialized before the drm
driver. Same with suspend/resume.

It's not only i2c devices, also platform devices. On i.MX for example we
have a hdmi transmitter which is somewhere on the physical address
space.

I think grouping the different units together in a devicetree blob
because we think they might form a logical virtual device is not going
to work. It might make it easier from a drm perspective, but I think
doing this will make for a lot of special cases. What will happen for
example if you have two encoder devices in a row to configure? The
foo-i2c-encoder would then get another child node.

Right now the devicetree is strictly ordered by (control-, not data-)
bus topology. Linux has great helper code to support this model. Giving
up this help to brute force a different topology and then trying to fit
the result back into the Linux Bus hierarchy doesn't sound like a good
idea to me.

> 
> ok, admittedly that is a bit different from other proposals about how
> this all fits in devicetree.. but otoh, I'm not a huge believer in
> letting something that is supposed to make life easier (DT), actually
> make things harder or more complicated.  Plus this CDF stuff all needs
> to also work on platforms not using OF/DT.

Right, but every other platform I know of is also described by its bus
topology, be it platform device based or PCI or maybe even USB based.

CDF has to solve the same problem as ASoC and soc-camera: subdevices for
a virtual device can come from many different corners of the system. BTW
one example for a i2c encoder would be the SiI9022 which could not only
be part of a drm device, but also of an ASoC device.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
