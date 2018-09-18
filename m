Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:53663 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbeIRSHZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 14:07:25 -0400
Date: Tue, 18 Sep 2018 14:34:57 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c: adv748x: fix typo in comment for TXB CSI-2
 transmitter power down
Message-ID: <20180918123457.GR16851@w540>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <20180918014509.6394-4-niklas.soderlund+renesas@ragnatech.se>
 <cad3ca03-7741-bbc1-b276-115c4b58fe3f@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vEk28Nl/eckWL8CC"
Content-Disposition: inline
In-Reply-To: <cad3ca03-7741-bbc1-b276-115c4b58fe3f@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vEk28Nl/eckWL8CC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kieran,

On Tue, Sep 18, 2018 at 10:54:44AM +0100, Kieran Bingham wrote:
> Hi Niklas,
>
> Thank you for the patch,
>
> I don't think this conflicts with Jacopo's series at all does it ?

It does, and I think this series should have been (re)based, or the
other way around, but all these changes should probably go together,
don't they?

>
> Perhaps with the amount of adv748x churn currently I should create an
> integration/for-next branch :-)
>

Also, but we may be able to handle this a single series, once we have
Ebisu working.

Thanks
   j

> On 18/09/18 02:45, Niklas S=C3=B6derlund wrote:
> > Fix copy-and-past error in comment for TXB CSI-2 transmitter power down
> > sequence.
> >
> > Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatec=
h.se>
>
> This looks good and useful to me.
>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i=
2c/adv748x/adv748x-core.c
> > index 9a82cdf301bccb41..86cb38f4d7cc11c6 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > @@ -299,7 +299,7 @@ static const struct adv748x_reg_value adv748x_power=
_down_txb_1lane[] =3D {
> >
> >  	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> >  	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
> > -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 4-lane MIPI */
> > +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> >  	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> >  	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
>
>
>
> --
> Regards
> --
> Kieran

--vEk28Nl/eckWL8CC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJboPDxAAoJEHI0Bo8WoVY8E3IP/0Hcz9weYSGq4cA407x+hqHn
APVQC7dv5x41lejDmDb63BeJJft3ZleM5tKVuBCWO9UiJUn2qX7a5Cs2IYCQyx9Z
tlPBkvMsQIPQ7Tki2BSUOljkTJJvm2Hl5hfowwdKUFamorWGeyxVG4Fa7DvKi4vk
5dEzO5C8blb9o4Fjctn0pQH34zm5K9Ged4dByxi4TeAy+dRA2dpHT5w5NwKNx0FR
DrT+zLHVDWvhJIAIG6Wve5bYHOC8aMD8/OcJuRijNftZ2Q25lLC85XwzGftzBrcD
SVFdPcn3X5FxLw3JGtUY9YG1Lewsxq99TlklGnzbs8BCuU4v/isDFfDH/h/TOJtI
B88at/1Q0inQEuL886VQvIclv/To/TLKG3EVP9jKWyRizLGvZ8XvzQC3/ZsPbXbA
uVQ5kvoaGlF9702BRecaBlD/2Zfa+dsThv0Ug1PbWzKZiGQSmKiXLOBng8gOkmxV
yvhYOL1bh6vcTJbihsx9pcbTuxqlRbEImfEDoGY4/X8sOEl0jplSNbrbGSDKMBlN
/1jSXisKrR0vaf+OIFfakraWq+w80xkk568FYeXyUg76nXzn/1CEmYyVUsLpl45P
5UPPHKnvK3TaOcbo4YpjaFJWKnz6DizrNI//j6FL54YDkPv1S/U8+4uwU/ehl+HS
6Q5wjjKBvIzMI7VIk/QE
=fgxc
-----END PGP SIGNATURE-----

--vEk28Nl/eckWL8CC--
