Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:47074 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933292AbcIALrR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 07:47:17 -0400
Date: Thu, 1 Sep 2016 13:47:11 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com, linux-samsung-soc@vger.kernel.org,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/4] exynos4-is: Clear isp-i2c adapter
 power.ignore_children flag
Message-ID: <20160901114711.GF2893@katana>
References: <1472729956-17475-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="O98KdSgI27dgYlM5"
Content-Disposition: inline
In-Reply-To: <1472729956-17475-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--O98KdSgI27dgYlM5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 01, 2016 at 01:39:16PM +0200, Sylwester Nawrocki wrote:
> Since commit 04f59143b571161d25315dd52d7a2ecc022cb71a
> ("i2c: let I2C masters ignore their children for PM")
> the power.ignore_children flag is set when registering an I2C
> adapter. Since I2C transfers are not managed by the fimc-isp-i2c
> driver its clients use pm_runtime_* calls directly to communicate
> required power state of the bus controller.
> However when the power.ignore_children flag is set that doesn't
> work, so clear that flag back after registering the adapter.
> While at it drop pm_runtime_enable() call on the i2c_adapter
> as it is already done by the I2C subsystem when registering
> I2C adapter.
>=20
> Cc: <stable@vger.kernel.org> # 4.7+
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

CCing the authors of the "offending" commit as well as linux-pm for more
PM expertise.

> ---
>  drivers/media/platform/exynos4-is/fimc-is-i2c.c | 25 ++++++++++++++++++-=
------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/me=
dia/platform/exynos4-is/fimc-is-i2c.c
> index 7521aa5..03b4246 100644
> --- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
> +++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
> @@ -55,26 +55,37 @@ static int fimc_is_i2c_probe(struct platform_device *=
pdev)
>  	i2c_adap->algo =3D &fimc_is_i2c_algorithm;
>  	i2c_adap->class =3D I2C_CLASS_SPD;
> =20
> +	platform_set_drvdata(pdev, isp_i2c);
> +	pm_runtime_enable(&pdev->dev);
> +
>  	ret =3D i2c_add_adapter(i2c_adap);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to add I2C bus %s\n",
>  						node->full_name);
> -		return ret;
> +		goto err_pm_dis;
>  	}
> =20
> -	platform_set_drvdata(pdev, isp_i2c);
> -
> -	pm_runtime_enable(&pdev->dev);
> -	pm_runtime_enable(&i2c_adap->dev);
> -
> +	/*
> +	 * Client drivers of this adapter don't do any I2C transfers as that
> +	 * is handled by the ISP firmware.  But we rely on the runtime PM
> +	 * state propagation from the clients up to the adapter driver so
> +	 * clear the ignore_children flags here.  PM rutnime calls are not
> +	 * used in probe() handler of clients of this adapter so there is
> +	 * no issues with clearing the flag right after registering the I2C
> +	 * adapter.
> +	 */
> +	pm_suspend_ignore_children(&i2c_adap->dev, false);
>  	return 0;
> +
> +err_pm_dis:
> +	pm_runtime_disable(&pdev->dev);
> +	return ret;
>  }
> =20
>  static int fimc_is_i2c_remove(struct platform_device *pdev)
>  {
>  	struct fimc_is_i2c *isp_i2c =3D platform_get_drvdata(pdev);
> =20
> -	pm_runtime_disable(&isp_i2c->adapter.dev);
>  	pm_runtime_disable(&pdev->dev);
>  	i2c_del_adapter(&isp_i2c->adapter);
> =20
> --=20
> 1.9.1
>=20

--O98KdSgI27dgYlM5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXyBU/AAoJEBQN5MwUoCm2jhIQAJAehQPpIzpfNX35v9iSxhy4
zTwVNuON+RTVj8njtJhTPSNZ9znu2jtIDxVegH9AJupJUEbJlz2mNcRn8YsxXeo6
cweoT6AyAppSNdLuMiimyb2x2j39gPccCWF9p5bY3E4Wi9b7TRlhdHIFYGIJ+apC
xKRqgtrOs4p3zwD3NtyCYMkDpWKEaGbJafNElBOlgUjL2k456EQwmf7ULqi5B+FH
AWz8WkieLPCoG0vicR3c/wCCgZkJX4cdLFhdLjgWVY8I24jClVHPoFcMqHZJ05F3
q3LcGIxR1KGSbPOO8jr9o6ZL0izlQlw6YI339wMx6RklSB8+bRaVbqyi7Gh05OxR
4v3KOgesfEWAbnwLlqju9UMviVfK/6A9pDetpPJLsOa21TgfD5duEUyOpkXIeewE
Hg/T8j3lLLWg/H9BgrP5NfaB6ETu9E7gB8NEpEyHh1+YeffC+c54S8TYlzim99IU
PMR7VjTmKkBRsUUUBLMSUkGCSoyjxemxUvKn7tGW4JAQOYqi9+yWti0Mg4Vj7qxO
ad0F+X9KH9PuMh5L9Id7VSoNskw2bVq63ZCQ3z7Se82Au5pjbT7B1BGlCsCPsXZz
aNnW09gbJ5fyNgIXfV0kDjRXk0HNqH9ZnHtdyPuLlf9etrj574lLCIlCkCFSou5B
R3pMeSVNbV8AHS1zG+kS
=5fHW
-----END PGP SIGNATURE-----

--O98KdSgI27dgYlM5--
