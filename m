Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:52023 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbeIYPc2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 11:32:28 -0400
Date: Tue, 25 Sep 2018 11:25:45 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Helmut Grohne <helmut.grohne@intenta.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH 1/1] v4l: Remove support for crop default target in
 subdev drivers
Message-ID: <20180925092545.GB3065@w540>
References: <20180924144227.31237-1-sakari.ailus@linux.intel.com>
 <20180925063329.vnes4q2rdzn4e7c7@laureti-dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <20180925063329.vnes4q2rdzn4e7c7@laureti-dev>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Helmut,

On Tue, Sep 25, 2018 at 08:33:29AM +0200, Helmut Grohne wrote:
> On Mon, Sep 24, 2018 at 04:42:27PM +0200, Sakari Ailus wrote:
> > --- a/drivers/media/i2c/mt9t112.c
> > +++ b/drivers/media/i2c/mt9t112.c
> > @@ -888,12 +888,6 @@ static int mt9t112_get_selection(struct v4l2_subdev *sd,
> >  		sel->r.width = MAX_WIDTH;
> >  		sel->r.height = MAX_HEIGHT;
> >  		return 0;
> > -	case V4L2_SEL_TGT_CROP_DEFAULT:
> > -		sel->r.left = 0;
> > -		sel->r.top = 0;
> > -		sel->r.width = VGA_WIDTH;
> > -		sel->r.height = VGA_HEIGHT;
> > -		return 0;
> >  	case V4L2_SEL_TGT_CROP:
> >  		sel->r = priv->frame;
> >  		return 0;
>
> Together with the change in soc_scale_crop.c, this constitutes an
> (unintentional?) behaviour change. It was formerly reporting 640x480 and
> will now be reporting 2048x1536. I cannot tell whether that is
> reasonable.
>
> > --- a/drivers/media/i2c/soc_camera/mt9t112.c
> > +++ b/drivers/media/i2c/soc_camera/mt9t112.c
> > @@ -884,12 +884,6 @@ static int mt9t112_get_selection(struct v4l2_subdev *sd,
> >  		sel->r.width = MAX_WIDTH;
> >  		sel->r.height = MAX_HEIGHT;
> >  		return 0;
> > -	case V4L2_SEL_TGT_CROP_DEFAULT:
> > -		sel->r.left = 0;
> > -		sel->r.top = 0;
> > -		sel->r.width = VGA_WIDTH;
> > -		sel->r.height = VGA_HEIGHT;
> > -		return 0;
> >  	case V4L2_SEL_TGT_CROP:
> >  		sel->r = priv->frame;
> >  		return 0;
>
> This one looks duplicate. Is there a good reason to have two drivers for
> mt9t112? This is lilely out of scope for the patch. Cced Jacopo Mondi as
> he introduced the copy.
>

This version is the one using te soc_camera framework which is
targeted for deprecation. The soc_camera based sensor drivers are
being ported to be regular v4l2 sensor drivers, hence the copy in
drivers/media/i2c/. The original versions in
drivers/media/i2c/soc_camera will be around for a little longer and
then possibly moved to staging or later removed.

Hope this clarifies.
Thanks
   j


> Other than your patch looks fine to me.
>
> Helmut

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbqf8ZAAoJEHI0Bo8WoVY8R54QAKk8M0q/v6QxW/rqjvfwWdVJ
RXxshCKbw3DhvmgMJEHiR1v4laZzQF42BUj7xifXOrzhG8QzwxAkbjpcO5iuG8kF
Sor1C77G/8wSZZqPXUC2vSVewIgpOY8lVoMHjzRzy8KSUzBiCDIij1Hk9+v91bWM
NE1l68x/m+/hK0lQbyUB4hphRLzQjWcxgUA/aNb0fvpIJebecZBh/WJx5qRnqF5Q
H6pczEifT7h/fCTJ5oCVlErk8wuJSkAxdlq9Vq0HD58cfWwzLK4AH4tYlMcqoxy+
/eR9Mtd07FUwRNnXn/hwaiV54Sg1MhtK6AghTp2ApQazBQrN4+9/P6FE/L/mv7Ph
c/OraPD02V8963OVKEdmIDZ/EykWBcWUEmu/fJ+qxCcJg3UeXGKmAjub1lffaKTN
Aeu2SI97yhnAtk9d4swL0i5PJ9A1QL4dkC773mon1/INWtL54O3eccdY/JzmnYVr
90OKpvTSzW2KQ+dL4c3wmqtMLUh4bwEdTPY0mGAQdVPG/1If2+eavfO9TzVTdHPs
aTmZgDe30soSAj/Fe+5a4Th1F0scjOf9unk2nU+nQpD/tPlTK/zvnnhzRzuA8I4P
Tx5CScbfq/m8vDcZb6sL5Q/geScrHcwiW906zTTnGmiV1ciDI8KumV9dOz2NH06i
TJ+y3x+MQHcIrjqD/Cky
=suvC
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
