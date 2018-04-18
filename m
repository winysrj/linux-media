Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:47879 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbeDRKNR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 06:13:17 -0400
Date: Wed, 18 Apr 2018 12:13:10 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 02/10] media: ov772x: add checks for register read
 errors
Message-ID: <20180418101310.GB17088@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <1523847111-12986-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Mon, Apr 16, 2018 at 11:51:43AM +0900, Akinobu Mita wrote:
> This change adds checks for register read errors and returns correct
> error code.
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

> ---
> * v2
> - Assign the ov772x_read() return value to pid and ver directly
> - Do the same for MIDH and MIDL
>
>  drivers/media/i2c/ov772x.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 7e79da0..8badd6f 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -1146,7 +1146,7 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
>  static int ov772x_video_probe(struct ov772x_priv *priv)
>  {
>  	struct i2c_client  *client = v4l2_get_subdevdata(&priv->subdev);
> -	u8                  pid, ver;
> +	int		    pid, ver, midh, midl;
>  	const char         *devname;
>  	int		    ret;
>
> @@ -1156,7 +1156,11 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>
>  	/* Check and show product ID and manufacturer ID. */
>  	pid = ov772x_read(client, PID);
> +	if (pid < 0)
> +		return pid;
>  	ver = ov772x_read(client, VER);
> +	if (ver < 0)
> +		return ver;
>
>  	switch (VERSION(pid, ver)) {
>  	case OV7720:
> @@ -1172,13 +1176,17 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>  		goto done;
>  	}
>
> +	midh = ov772x_read(client, MIDH);
> +	if (midh < 0)
> +		return midh;
> +	midl = ov772x_read(client, MIDL);
> +	if (midl < 0)
> +		return midl;
> +
>  	dev_info(&client->dev,
>  		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
> -		 devname,
> -		 pid,
> -		 ver,
> -		 ov772x_read(client, MIDH),
> -		 ov772x_read(client, MIDL));
> +		 devname, pid, ver, midh, midl);
> +
>  	ret = v4l2_ctrl_handler_setup(&priv->hdl);
>
>  done:
> --
> 2.7.4
>

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1xo2AAoJEHI0Bo8WoVY8hesQAJelkn+j2a3Wez+EybhYpO3l
qDc3Kgs67xBVT8c3OKmCe5P1ube6DnDsO3xZvAIOt59FqN/C/IfMkgvwqU2vp0Jw
42WW8hYGNQzX9Uebt+0gEhU5ZC2cpUSPDKt9c/Pk1PF1vorzNsdRf1nDjDkKVmgS
ncgiMe6XYMiwCz/1ck4JmcVcyhKtPVlKOyTej9lJ3WpKDNAU3N5w93q/RitlsCNO
baT1iI/jCncCpikNQkd/2Z3rTTPmSAoG4qznke7SQ9r6dupMQv9aw1YH8ostjPrT
nbGuBleCWAYOdTF+wu+kEzbKar730gvM3nE9Dh+gMpLfy0ZPp+RqSmCJIFSmiZ65
qaCaz6qkmp8IyIUEOAC9YI5VikWFEklr6b0a4k2uZI1O4trWNkIyuots53ADjWWU
DCIvedgqRIsOMfPA5rnux4HMNuiFr6dUKrMLs8/ScFYH0JTllUcK68Hqq2R/sFzK
o2qaCNFh343kYCckKEptMNGFTyDpxiCXdwjgMkJpjrbO8Zdyy8eQV+re65o5klah
5zF3TtrP9IYQBcMSFbcH3squaOqexMmaWN5lvquWJElfIuBv/SdAKFpBN2vTgAgI
YzJQKch349JFLF9F3W3Leyng1xC/AyK7o7YjSC6KBiH/DmKSLwmwRRkRSYbxtvdV
FqU/3f9dLjRi3lOr06of
=FeLK
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
