Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:43941 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbeJPXsr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 19:48:47 -0400
Date: Tue, 16 Oct 2018 17:57:32 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v4 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20181016155732.GA11703@w540>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20181011092107.30715-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Maxime,

On Thu, Oct 11, 2018 at 11:20:55AM +0200, Maxime Ripard wrote:
> Hi,
>
> Here is a "small" series that mostly cleans up the ov5640 driver code,
> slowly getting rid of the big data array for more understandable code
> (hopefully).
>
> The biggest addition would be the clock rate computation at runtime,
> instead of relying on those arrays to setup the clock tree
> properly. As a side effect, it fixes the framerate that was off by
> around 10% on the smaller resolutions, and we now support 60fps.
>
> This also introduces a bunch of new features.
>
> Let me know what you think,

I'm sorry to report this breaks CSI-2 capture on my i.MX6 testing
platform.

I have been testing the whole afternoon with different configurations,
but I have not been able yet to find out the root of the problem.

In the meantime, I have some comments on the patches, and I'll reply
to them singularly.

Thanks
   j

> Maxime
>
> Changes from v3:
>   - Rebased on current Sakari tree
>   - Fixed an error when changing only the framerate
>
> Changes from v2:
>   - Rebased on latest Sakari PR
>   - Fixed the issues reported by Hugues: improper FPS returned for
>     formats, improper rounding of the FPS, some with his suggestions,
>     some by simplifying the logic.
>   - Expanded the clock tree comments based on the feedback from Samuel
>     Bobrowicz and Loic Poulain
>   - Merged some of the changes made by Samuel Bobrowicz to fix the
>     MIPI rate computation, fix the call sites of the
>     ov5640_set_timings function, the auto-exposure calculation call,
>     etc.
>   - Split the patches into smaller ones in order to make it more
>     readable (hopefully)
>
> Changes from v1:
>   - Integrated Hugues' suggestions to fix v4l2-compliance
>   - Fixed the bus width with JPEG
>   - Dropped the clock rate calculation loops for something simpler as
>     suggested by Sakari
>   - Cache the exposure value instead of using the control value
>   - Rebased on top of 4.17
>
> Maxime Ripard (12):
>   media: ov5640: Adjust the clock based on the expected rate
>   media: ov5640: Remove the clocks registers initialization
>   media: ov5640: Remove redundant defines
>   media: ov5640: Remove redundant register setup
>   media: ov5640: Compute the clock rate at runtime
>   media: ov5640: Remove pixel clock rates
>   media: ov5640: Enhance FPS handling
>   media: ov5640: Make the return rate type more explicit
>   media: ov5640: Make the FPS clamping / rounding more extendable
>   media: ov5640: Add 60 fps support
>   media: ov5640: Remove duplicate auto-exposure setup
>   ov5640: Enforce a mode change when changing the framerate
>
>  drivers/media/i2c/ov5640.c | 679 ++++++++++++++++++++-----------------
>  1 file changed, 374 insertions(+), 305 deletions(-)
>
> --
> 2.19.1
>

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbxgpsAAoJEHI0Bo8WoVY8WNAP/RV29xyJGnoIs6DiMu0OXnNN
arER1gB8kI4+U59YDjOzDNKWAEXhkpmGInm1cJX/iAIz+70x9MfY/K0FrUsTO603
TvZU30nF1Hk9waMlwhp4z79U/WpAr1ytTcXoalMOXbIjfN9qt+TfY8oUVkndaT/P
y+9aiRu091UQXsBZIlPKsNSajE+XTunYgPmf0vhj9Wby2xbH+9PnU5oX/nVHA6jd
d8V9BLWnr2dsKFSin/cFEbgxQEWxOAbQMy6eb1jUNGmOkrgMteYEP4FX0ewqvUbx
WcH/i4Eiu64TNF/GRsCYc3+8zetZwSc3vnW1m2i5iCBR+w4NgHMmfQtUxSvXYdn5
BWhK0Bka0HnutNz6dpRfPMxTsSTqDQX5gllO2/x9irebc5lXn+sV5q9z++yS10Rl
zKMaJ0gcl+C2LWqy4PtGbdI9r56aA2Z1p7nqGcA3StWgO1+dVxV46OERRQKpVfw0
V5g6aL668iomjSdHSAVeVJwkjlGu1lUy3vD9pOV6ffvcwmcYD3J3tuPoDqbVLl+Y
y8dA1sGH9+WJmTIQCa2Pmk1eIij/vdvllKrzuOgqKManu8FiSOia5yTeMRt+QkaT
kktVSn+ev+sdsELpooYg/5jfbql2Bo3gmy9DJMShwB4ax6izCMgUZhItgeqxtQqm
BW9aHBktGWbCc3b4oDqN
=nWvt
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
