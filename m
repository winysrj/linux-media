Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:35038 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754593AbeGIQMC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jul 2018 12:12:02 -0400
Date: Mon, 9 Jul 2018 18:11:59 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v3 1/2] i2c: add SCCB helpers
Message-ID: <20180709161159.ksdm5qr4azonrpnl@ninjato>
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
 <1531150874-4595-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aa63gyolfet235xv"
Content-Disposition: inline
In-Reply-To: <1531150874-4595-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aa63gyolfet235xv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

yes! From a first look this nails it for me. Thanks for doing it.

Minor comments follow...

> +#if 0
> +	/*
> +	 * sccb_xfer not needed yet, since there is no driver support currently.
> +	 * Just showing how it should be done if we ever need it.
> +	 */
> +	if (adap->algo->sccb_xfer)
> +		return true;
> +#endif

I think this should be a more generic comment in the header, like

/*
 * If we ever want support for hardware doing SCCB natively, we will
 * introduce a sccb_xfer() callback to struct i2c_algorithm and check
 * for it here.
 */

> +/**
> + * sccb_read_byte - Read data from SCCB slave device
> + * @client: Handle to slave device
> + * @addr: Register to be read from

I think 'addr' is too easy to confuse with client->addr. SMBus uses
'command' but I am also fine with 'reg' because we will deal with
registers.

> + * This executes the 2-phase write transmission cycle that is followed by a
> + * 2-phase read transmission cycle, returning negative errno else a data byte
> + * received from the device.
> + */

Nice docs!

> +/**
> + * sccb_write_byte - Write data to SCCB slave device
> + * @client: Handle to slave device
> + * @addr: Register to write to

'reg'?

Kind regards,

   Wolfram


--aa63gyolfet235xv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltDiU8ACgkQFA3kzBSg
KbYzrw/+JTGeBcrfzF1zjYV18SH7HTQX00exeyIzeEHYRLfCaKuGVKEN3gRAdNzx
L+4vfI6mdDgA/IrvWFpAOUjOubzxY7JCuafbHzi9voV7xLVYU7THp3eWIwToS3gi
dkm0rlS/bUDs7pvelPA+Lm8YwiJWEYPXdA5mW0aOQC15dYfSyw+WEhoaGv/GuoW1
DcM5M92ZCgG52Bcxk5g3o2EcEU4SNTBG3p8+3DLEyXPtSLtZuMaYvwJluBsVG6d2
Q/92E3B+d70u+lpYYpALlBFx6EAS6kpGEGFlhf8+kuxHwA/avCur1YlSUWIvlRW6
nEz7Zu2Kvz7hv/EtfnxFpZYEthjc3CsXKAzZqDfD0Mrcwos3D0MhzdiXohGrV+z4
BAjAeM+ZgmnQSF/Ov9LrOfo4inK9LZt5xEkagTh6Te9fNQMjTdndF4K/g50SXVdl
hIY0mZecyZxYbWriAeWJcwBMMGqMeHdswypuMii+qs+Gp/YoF7denTjQ1flXIaXS
yJIUhhEP12N1r1R0TxPAGpujhIvxEted8+JVuNlSBIjXwRV3e3ERYe3FtG+AeDpt
rHVwhtrO761QbHb2dHZWwBu9fSx93Bda3ejsr4DZw14Gh+sxowya2KXq2eda84iy
RlkqfzOPr5gc0aTTrjZ/l5JuyzMMLypGxK7IPiRTgaWbD9dg+Ls=
=ZZtx
-----END PGP SIGNATURE-----

--aa63gyolfet235xv--
