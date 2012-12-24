Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43977 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2LXRaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 12:30:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	dri-devel@lists.freedesktop.org, Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 24 Dec 2012 18:31:38 +0100
Message-ID: <15959881.0MpnSJbCPa@avalon>
In-Reply-To: <50D1D846.6010005@ti.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <87pq26ay2z.fsf@intel.com> <50D1D846.6010005@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6852939.JPy7NdAMtI"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart6852939.JPy7NdAMtI
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Wednesday 19 December 2012 17:07:50 Tomi Valkeinen wrote:
> On 2012-12-19 16:57, Jani Nikula wrote:
> > It just seems to me that, at least from a DRM/KMS perspective, adding
> > another layer (=CDF) for HDMI or DP (or legacy outputs) would be
> > overengineering it. They are pretty well standardized, and I don't see
> > there would be a need to write multiple display drivers for them. Each
> > display controller has one, and can easily handle any chip specific
> > requirements right there. It's my gut feeling that an additional
> > framework would just get in the way. Perhaps there could be more common
> > HDMI/DP helper style code in DRM to reduce overlap across KMS drivers,
> > but that's another thing.
> > 
> > So is the HDMI/DP drivers using CDF a more interesting idea from a
> > non-DRM perspective? Or, put another way, is it more of an alternative
> > to using DRM? Please enlighten me if there's some real benefit here that
> > I fail to see!
> 
> The use of CDF is an option, not something that has to be done. A DRM
> driver developer may use it if it gives benefit for him for that
> particular driver.
> 
> I don't know much about desktop display hardware, but I guess that using
> CDF would not really give much there. In some cases it could, if the IPs
> used on the graphics card are something that are used elsewhere also
> (sounds quite unlikely, though). In that case there could be separate
> drivers for the IPs.
> 
> And note that CDF is not really about the dispc side, i.e. the part that
> creates the video stream from pixels in the memory. It's more about the
> components after that, and how to connect those components.
> 
> > For DSI panels (or DSI-to-whatever bridges) it's of course another
> > story. You typically need a panel specific driver. And here I see the
> > main point of the whole CDF: decoupling display controllers and the
> > panel drivers, and sharing panel (and converter chip) specific drivers
> > across display controllers. Making it easy to write new drivers, as
> > there would be a model to follow. I'm definitely in favour of coming up
> > with some framework that would tackle that.
> 
> Right. But if you implement drivers for DSI panels with CDF for, say,
> OMAP, I think it's simpler to use CDF also for HDMI/DP on OMAP.
> Otherwise it'll be a mishmash with two different models.

I second your point here, using CDF for encoders should be simpler, but it 
will not be enforced. A display controller driver developer who wants to 
control the on-SoC encoder without conforming to the CDF model will be totally 
free to do so and won't be blamed.

-- 
Regards,

Laurent Pinchart

--nextPart6852939.JPy7NdAMtI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQ2JF/AAoJEIkPb2GL7hl1wnkH/08WR9n1HJoPar0SRrZYW4fc
XtLgayuitZsWQQf0i+lj7Pqr5I6ToNnjwt9pfy1+oGwfrX4fOYvEhmuT381gjxFr
oS50jPRoP8+rD8/DB9QuUYBkYX+KXqzP3QpZtVDhRhoaZxZ1dBB3cP+RnXuGBhQ1
Ycl/qrnm4npRzdMU06Qf0RuqdQdW6DCkcFQXgWLIOl7pRKytSJSZC3vpaFHRmOxC
0/wQxYgFaOsQqlqhRl6R6o8gIv4Pkyv19x+1rXU6qk0jASl8kpZZAKnPj3Ac5LUu
s6c8bM6AkjKIbU4dKnn2Qt2nfxOdHLjqDgGo03c5yLaM9beW//0cxH/n9oan+e8=
=e4z8
-----END PGP SIGNATURE-----

--nextPart6852939.JPy7NdAMtI--

