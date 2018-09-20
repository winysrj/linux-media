Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732496AbeITU2s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 16:28:48 -0400
Date: Thu, 20 Sep 2018 11:44:53 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 5/6] media: isp: fix a warning about a wrong struct
 initializer
Message-ID: <20180920114453.54424b60@coco.lan>
In-Reply-To: <1547255.gQsGpOKB2G@avalon>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
        <cf5719a1cb77e6322d8dd4c679529aec4c07ee27.1533739965.git.mchehab+samsung@kernel.org>
        <1638882.BEPym44MaE@avalon>
        <1547255.gQsGpOKB2G@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 07 Sep 2018 14:46:34 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
>=20
> As maintainers should be held to the same level of obligations as develop=
ers,=20
> and to avoid demotivating reviewers, could you handle comments you receiv=
e=20
> before pushing your own patches to your tree ? There should be no maintai=
ner=20
> privilege here.

Sorry, yeah, this was improperly handled. Not sure what happened.

=46rom whatever reason, I ended by mishandling this and lost the
related emails. I had to do several e-mail changes at the beginning
of August, as I'm not using s-opensource.com anymore, and had to
reconfigure my inbox handling logic.

Do you want me to revert the patch?

>=20
> On Wednesday, 8 August 2018 18:45:49 EEST Laurent Pinchart wrote:
> > Hi Mauro,
> >=20
> > Thank you for the patch.
> >=20
> > The subject line should be "media: omap3isp: ...".
> >=20
> > On Wednesday, 8 August 2018 17:52:55 EEST Mauro Carvalho Chehab wrote: =
=20
> > > As sparse complains:
> > > 	drivers/media/platform/omap3isp/isp.c:303:39: warning: Using plain
> > > 	integer
> > >=20
> > > as NULL pointer
> > >=20
> > > when a struct is initialized with { 0 }, actually the first
> > > element of the struct is initialized with zeros, initializing the
> > > other elements recursively. That can even generate gcc warnings
> > > on nested structs.
> > >=20
> > > So, instead, use the gcc-specific syntax for that (with is used
> > > broadly inside the Kernel), initializing it with {};
> > >=20
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > ---
> > >=20
> > >  drivers/media/platform/omap3isp/isp.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/media/platform/omap3isp/isp.c
> > > b/drivers/media/platform/omap3isp/isp.c index 03354d513311..842e22350=
47d
> > > 100644
> > > --- a/drivers/media/platform/omap3isp/isp.c
> > > +++ b/drivers/media/platform/omap3isp/isp.c
> > > @@ -300,7 +300,7 @@ static struct clk *isp_xclk_src_get(struct
> > > of_phandle_args *clkspec, void *data) static int isp_xclk_init(struct
> > > isp_device *isp)
> > >=20
> > >  {
> > > =20
> > >  	struct device_node *np =3D isp->dev->of_node;
> > >=20
> > > -	struct clk_init_data init =3D { 0 };
> > > +	struct clk_init_data init =3D {}; =20
> >=20
> > How about =3D { NULL }; to avoid a gcc-specific syntax ?
> >  =20
> > >  	unsigned int i;
> > >  =09
> > >  	for (i =3D 0; i < ARRAY_SIZE(isp->xclks); ++i) =20
>=20
>=20



Thanks,
Mauro
