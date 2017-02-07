Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:40439 "EHLO pokefinder.org"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751526AbdBGLUn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 06:20:43 -0500
Date: Tue, 7 Feb 2017 12:20:40 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com
Subject: Re: [PATCH 00/11] media: rcar-vin: fix OPS and format/pad index
 issues
Message-ID: <20170207112040.iicu2whtmkjmld7e@ninjato>
References: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="c2zyb4sq36mzkzdt"
Content-Disposition: inline
In-Reply-To: <20170131154016.15526-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--c2zyb4sq36mzkzdt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Patch 10-11 fix a OPS when unbinding/binding the video source subdevice.

I can happily confirm that this series finally makes the I2C demuxer
work on the I2C bus with the HDMI clients because rebinding works now!
Note that I didn't test inputting any actual video but only the
rebinding capabilites. But since rebinding was a major motivation for
this series to be factored out of a bigger one:

Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--c2zyb4sq36mzkzdt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAliZrYQACgkQFA3kzBSg
KbZr5w/+KuhuY/nyCK3i9t5kgpFMHp2RHjM8iBeGePvecR7SevRUmuEY8CN8+sa2
RxNCfJaYrtPAEeU6/ywV4GcqQODzDjsFNVKokED5J6LM2QAd/VNSLl9/TkxQOuVx
E8KlLGXRRgjKgZwuHdZVnwzBLMFlZd7h+UfLXmvl4yOVcKCRHwks7cDDYmDsILKl
bWt6FZhMyA27PAF1xyxbhzp4OauaOt/fV1KA1nWNq1lKKNXeWnfx/FJYJM7Yamvb
Ahxf2JdNbnyHSOU03pug0dVpPwQOsMi5d/qcqVQuTCmsORXR3pdx/cDpu9x7EqLQ
2khEQkrymwwK+WVJgfOvB3NwXdiC5ziu+wBcoosDW060IH38X8RvzrKZX+BHKbhz
mT0dtqozKBa7avfDk68TuhH33sUjnCC9R3g46Q65TH7GeUdFwe6o+4hv7UDjprhS
sx0EE9P+eciTEAl8W/g/sGvUYZnv+bkDZivm1YniTBQ2sgYOXv1Xt1YwvFXi3LXx
uekMzVk2iBdm44dUK21F2C44wbsXMDy25MAaXketLkn9gqHJH48PFy0Ui6TrYYot
Pgq/WG0EujyqYY/2psX95rtAylHiMszHTOknuTYeIEowvuUtKmldlSeHMxym2gWt
828o6iujNXFUiQP4ucQTP+ULC2xi24bBoV2FLJr/gXSk5PJyeAk=
=orWe
-----END PGP SIGNATURE-----

--c2zyb4sq36mzkzdt--
