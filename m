Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54640 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933858AbeEIK5Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 06:57:24 -0400
Date: Wed, 9 May 2018 12:57:19 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH] media: i2c: add SCCB helpers
Message-ID: <20180509105719.bydr4rla23okvlbf@earth.universe>
References: <1524759212-10941-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vp2f7cbv3yvkhsd2"
Content-Disposition: inline
In-Reply-To: <1524759212-10941-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vp2f7cbv3yvkhsd2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Fri, Apr 27, 2018 at 01:13:32AM +0900, Akinobu Mita wrote:
> diff --git a/drivers/media/i2c/sccb.c b/drivers/media/i2c/sccb.c
> new file mode 100644
> index 0000000..80a3fb7
> --- /dev/null
> +++ b/drivers/media/i2c/sccb.c
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/i2c.h>
> +
> +int sccb_read_byte(struct i2c_client *client, u8 addr)
> +{
> +	int ret;
> +	u8 val;
> +
> +	/* Issue two separated requests in order to avoid repeated start */
> +
> +	ret = i2c_master_send(client, &addr, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = i2c_master_recv(client, &val, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	return val;
> +}
> +EXPORT_SYMBOL_GPL(sccb_read_byte);
> +
> +int sccb_write_byte(struct i2c_client *client, u8 addr, u8 data)
> +{
> +	int ret;
> +	unsigned char msgbuf[] = { addr, data };
> +
> +	ret = i2c_master_send(client, msgbuf, 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(sccb_write_byte);
> diff --git a/drivers/media/i2c/sccb.h b/drivers/media/i2c/sccb.h
> new file mode 100644
> index 0000000..68da0e9
> --- /dev/null
> +++ b/drivers/media/i2c/sccb.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * SCCB helper functions
> + */
> +
> +#ifndef __SCCB_H__
> +#define __SCCB_H__
> +
> +#include <linux/i2c.h>
> +
> +int sccb_read_byte(struct i2c_client *client, u8 addr);
> +int sccb_write_byte(struct i2c_client *client, u8 addr, u8 data);
> +
> +#endif /* __SCCB_H__ */

The functions look very simple. Have you considered moving them into
sccb.h as static inline?

-- Sebastian

--vp2f7cbv3yvkhsd2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlry1AwACgkQ2O7X88g7
+ppZiQ/+IOg8QZJE7UEh/JQSIT2A3UfR/KZy+EeTGmvr9QnVkm+xa6wMWXyKfxv5
CQM/l2+f0iZkcx9sGFstdMCyUz6q0XGlck6BUAM9yltI30Fz1xBldYriyYyAAs+2
2r3ao/hAeRxrT3/PxduzXBTJASM+56vJaP2O3YitV3MfyowmOuKu4HDYPTzSkgoC
j1hHOkYP02p/rVUR2i7/7BNuomx9Z4TJeDo3Y26F61TDdGeYvbrDeSRyRwXiNIzm
b2C6RMSd0Udkhd9DluZAg4OhOEKscsh35shhTcFAh3BNBs8WivQEjVeivb3ZVu/s
i+wHwggWudbarEqUE5oB0T8zhd5lbKybSzRVaU5qldbBJFdjdWchhhcfnZNuRVFe
lR4pYth+3o19cz21g9UKM5b4lfV4UVEEDn8hP6J3L94R/4MTagBgEykTdk2M4Nss
F/AdJwiMMKX/2y6FwcfbJf/lniCdiKlpt2HQKwzOXMQN9O/KzHe393HNEVYCPk8L
ioYcAj0V4Af8yCuoHMP+FKOAw67SbondY1W+VO5+IqjFXU7Zd1bZQcrpTklHhFO9
Re1+kq3bvV9PHI07JykCf+RDVpgW+GgnFxxHOJV/Xsy9NBwDzpnNLQI2R5cDuQmm
F1fW87mMwg941Q6OnnFh9tPVXOYBWHZSbwXZSxBu8xeMMiXgdHI=
=daai
-----END PGP SIGNATURE-----

--vp2f7cbv3yvkhsd2--
