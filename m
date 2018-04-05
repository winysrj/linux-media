Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57387 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751447AbeDESe2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 14:34:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 03/16] media: omap3isp/isp: remove an unused static var
Date: Thu, 05 Apr 2018 21:34:26 +0300
Message-ID: <12694711.X0Vl9KULqr@avalon>
In-Reply-To: <12b6d82335f9b0ef03345d5ce51049f2c2bb9a2f.1522949748.git.mchehab@s-opensource.com>
References: <cover.1522949748.git.mchehab@s-opensource.com> <12b6d82335f9b0ef03345d5ce51049f2c2bb9a2f.1522949748.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday, 5 April 2018 20:54:03 EEST Mauro Carvalho Chehab wrote:
> The isp_xclk_init_data const data isn't used anywere.
>=20
> drivers/media/platform/omap3isp/isp.c:294:35: warning: =E2=80=98isp_xclk_=
init_data=E2=80=99
> defined but not used [-Wunused-const-variable=3D] static const struct
> clk_init_data isp_xclk_init_data =3D {
>                                    ^~~~~~~~~~~~~~~~~~

I believe you, no need for a compiler warning message to prove this :-)

> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I really wonder why my compiler has never warned me. The problem has been=20
there from the start :-/

You should add a fixes tag:

=46ixes: 9b28ee3c9122 ("[media] omap3isp: Use the common clock framework")

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I think Sakari is planning a pull request for the omap3isp driver so I'll l=
et=20
him handle this patch.

> ---
>  drivers/media/platform/omap3isp/isp.c | 7 -------
>  1 file changed, 7 deletions(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 2a11a709aa4f..9e4b5fb8a8b5
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -291,13 +291,6 @@ static const struct clk_ops isp_xclk_ops =3D {
>=20
>  static const char *isp_xclk_parent_name =3D "cam_mclk";
>=20
> -static const struct clk_init_data isp_xclk_init_data =3D {
> -	.name =3D "cam_xclk",
> -	.ops =3D &isp_xclk_ops,
> -	.parent_names =3D &isp_xclk_parent_name,
> -	.num_parents =3D 1,
> -};
> -
>  static struct clk *isp_xclk_src_get(struct of_phandle_args *clkspec, void
> *data) {
>  	unsigned int idx =3D clkspec->args[0];

=2D-=20
Regards,

Laurent Pinchart
