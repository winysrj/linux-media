Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758502Ab2KAUJF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 16:09:05 -0400
Date: Thu, 1 Nov 2012 21:08:42 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v7 1/8] video: add display_timing struct and helpers
Message-ID: <20121101200842.GA13137@avionic-0098.mockup.avionic-design.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <1351675689-26814-2-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1351675689-26814-2-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 31, 2012 at 10:28:01AM +0100, Steffen Trumtrar wrote:
[...]
> +void timings_release(struct display_timings *disp)
> +{
> +	int i;
> +
> +	for (i = 0; i < disp->num_timings; i++)
> +		kfree(disp->timings[i]);
> +}
> +
> +void display_timings_release(struct display_timings *disp)
> +{
> +	timings_release(disp);
> +	kfree(disp->timings);
> +}

I'm not quite sure I understand how these are supposed to be used. The
only use-case where a struct display_timings is dynamically allocated is
for the OF helpers. In that case, wouldn't it be more useful to have a
function that frees the complete structure, including the struct
display_timings itself? Something like this, which has all of the above
rolled into one:

	void display_timings_free(struct display_timings *disp)
	{
		if (disp->timings) {
			unsigned int i;

			for (i = 0; i < disp->num_timings; i++)
				kfree(disp->timings[i]);
		}

		kfree(disp->timings);
		kfree(disp);
	}

Is there a use-case where a struct display_timings is not dynamically
allocated? The only one I can think of is where it is defined as
platform data, but in that case you don't want to be calling
display_timing_release() on it anyway.

Thierry

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQktbKAAoJEN0jrNd/PrOhRqIQAJto5l4A26U8q1YNvZK1MaEv
EuDvLFbR9zeRbL8/R+N1H0UXI2H8jpmrE2s3GddV41Xe124lJ7ps4gvjolFUiDFq
OAxu6mVnnM4epoSzk2CgfwzNW3M+5e9Gi9g9/vGtlSoFf4UjhnP1TagSO0JXCoSS
/tQB186aI9LU6KJGt4N7IlxDwllQm3w/SfH0PTK6QF5aCf8yRexkxuFcZZKvgw/R
DZzSMJlUdDyI806P+V32JIcvRFGD1HYa4M7JXlY7U+jZ4wZ0MaJJNUnc/vK75rtP
X6+RW7Kwe3bhbDUiHmWCfdO6LvpYuT7/ZRFY5NwtWmJUCrxlvd40xjBzVq2LmGQB
cpVvY9fi8vBOp+/6RsLcmRfKmr1PO+czM+DDlS4MyiEX/D7psQQcNAOYkZz66LMg
8teolpkyWmv/aAmx1HK+nW8siBDTNQk8I0t0DGl3PBobSkA/fBYnj8A1cTueqNvu
aqeceAMJ2zdtv58agTT12zXV9oZf8tocZvtKRrG4/V+wgqWOZg3qLRX8xChRlF3T
jG1LZOwgQufzQxAqqN+CKL+dBklK3WZ2q19CZhRdBePuY0eGvQ6kIVtpKINkRFgj
W3+8I3/AOr1EOa+wLoqMlzY8qWNEy85hr9hdgS7rLqvkGomTAurpKlWth0dGsLEU
EewZs/bEukAfWXwzHOxQ
=T5rS
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
