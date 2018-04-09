Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:57527 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbeDIHgY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 03:36:24 -0400
Date: Mon, 9 Apr 2018 09:36:17 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 2/6] media: ov772x: add checks for register read errors
Message-ID: <20180409073614.GV20945@w540>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
 <1523116090-13101-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/qNnUp0NPtZJWkzn"
Content-Disposition: inline
In-Reply-To: <1523116090-13101-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--/qNnUp0NPtZJWkzn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Sun, Apr 08, 2018 at 12:48:06AM +0900, Akinobu Mita wrote:
> This change adds checks for register read errors and returns correct
> error code.
>

I feel like error conditions are anyway captured by the switch()
default case, but I understand there may be merits in returning the
actual error code.

> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/ov772x.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 283ae2c..c56f910 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -1169,8 +1169,15 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>  		return ret;
>
>  	/* Check and show product ID and manufacturer ID. */
> -	pid = ov772x_read(client, PID);
> -	ver = ov772x_read(client, VER);
> +	ret = ov772x_read(client, PID);
> +	if (ret < 0)
> +		return ret;
> +	pid = ret;
> +
> +	ret = ov772x_read(client, VER);
> +	if (ret < 0)
> +		return ret;
> +	ver = ret;

You can assign the ov772x_read() return value to pid and ver directly
and save two assignments.

>
>  	switch (VERSION(pid, ver)) {
>  	case OV7720:

If we want to check for return values here, which is always a good
thing, could you do the same for MIDH and MIDL below?

Nit: You can also fix the dev_info() parameters alignment to span to
the whole line length while at there. Ie.

	dev_info(&client->dev,
		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
		 devname, pid, ver, ov772x_read(client, MIDH),
		 ov772x_read(client, MIDL));

Thanks
   j


> --
> 2.7.4
>

--/qNnUp0NPtZJWkzn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJayxfxAAoJEHI0Bo8WoVY800EP/A+XSz3HZ3Xey2eQ7B0a/k8W
mYTUseI0i4sPmtZ2mExKznlhdhFbaoxNEo9j3KhT+VZx2/Cn0J6DpFz5EDMAllQM
2UzQLSsl9y/YNi7HXpEHW3pVP/Hh9pERVJVTsq/OB3p3R0SA3/xsTtgEI41kViVV
Lf+ypaujEAQKh5EB4yt3iZxOBWsgejJcomZSlKvSdKjDGDPSl6qidvXwwbCMbOjD
Ptns5lR44men3ugnYYhHeMPf7srNY80kF3pktZRCO25AD8FgN7H2a4bdbnt2Azc8
EAhvzy4ixyoA9YKqgOYYHFKBx0D8lvrd8+XOPF0+qfL/ILISrdO+5uwSYzyGD40Q
0uzvEEr2M6w6APF83XBwl2BVI3Zc0wEhau2C5r4VlaSjmbKlrJEtDp5hVgsGi3Xt
+z2vPVOrSpIHSOWdkaiqMEi/FpDrJxreF+m1w8+wEXA/3/EGMPYXtLfod4RzMPfx
lmziCbr5RtmEiS5dRXSzjfTL3kG1v0y8UKqoB2Rh4pIcqWQ7t8eYPXi9A6B5q6je
YCT+8RK4S/1MhnJHrFjV1AEELG4irswwrlzCXaiUAOBN0EbCnh09SAlNOteGDo2o
dwo/GG4YoyL3ZRApcjMEApKMbvWqWHrEb6WMgPOsitgIjwEUNiV65Adhn5dDxpM3
MNvF3qIJPKHMjP7VQL1E
=Ti6c
-----END PGP SIGNATURE-----

--/qNnUp0NPtZJWkzn--
