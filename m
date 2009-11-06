Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out114.alice.it ([85.37.17.114]:4189 "EHLO
	smtp-out114.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZKFR3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 12:29:14 -0500
Date: Fri, 6 Nov 2009 18:29:10 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Eric Miao <eric.y.miao@gmail.com>,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3 v2] ezx: Add camera support for A780 and A910 EZX
 phones
Message-Id: <20091106182910.a3b48c41.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0911061419220.4389@axis700.grange>
References: <f17812d70911040119g6eb1f254pa78dd8519afef61d@mail.gmail.com>
	<1257367650-15056-1-git-send-email-ospite@studenti.unina.it>
	<Pine.LNX.4.64.0911050040160.4837@axis700.grange>
	<20091105234429.ef855e2d.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0911061419220.4389@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Nov_2009_18_29_10_+0100_9F7cz5FM6iQvTNTW"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__6_Nov_2009_18_29_10_+0100_9F7cz5FM6iQvTNTW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Nov 2009 15:11:55 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Thu, 5 Nov 2009, Antonio Ospite wrote:
>=20
> > On Thu, 5 Nov 2009 00:53:46 +0100 (CET)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> >=20
> > > On Wed, 4 Nov 2009, Antonio Ospite wrote:
> > >=20
> > > > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> > > > Signed-off-by: Bart Visscher <bartv@thisnet.nl>
> > >=20
> > > Is this patch going via Bart? Or should this be an Acked-by?
> > >
> >=20
> > Bart did the initial research and wrote a first, partially working,
> > version of the patch for A780, then I made it work and refactored it,
> > adding code for A910. So I put two SOBs here as we are both the
> > authors, in a sense.
>=20
> Then, I think, his Sob should be the first.
>

Ok.

> > [...]=20
> > > > +/* camera */
> > > > +static int a780_pxacamera_init(struct device *dev)
> > > > +{
> > > > +	int err;
> > > > +
> > > > +	/*
> > > > +	 * GPIO50_nCAM_EN is active low
> > > > +	 * GPIO19_GEN1_CAM_RST is active high
> > > > +	 */
[...]
> > > > +	gpio_direction_output(GPIO50_nCAM_EN, 0);
> > > > +	gpio_direction_output(GPIO19_GEN1_CAM_RST, 1);
> > >=20
[...]
> > The reset happens when bringing the signal from low to high, so
> > holding it high or low it's basically the same here, and given how=20
> > a780_pxacamera_reset() works I decided to keep it high.
>=20
> Then it is not level- but edge-sensitive. Maybe put reset - rising edge t=
o=20
> activate, or something like that.
>

You mean I fix the comment, right?

> > I also need to put CAM_EN active in init(), because of how
> > soc_camera_probe() works, adding some debug I get this call sequence
> > (with CAM_EN not active):
> >=20
> > Linux video capture interface: v2.00
> > pxa27x-camera pxa27x-camera.0: Limiting master clock to 26000000
> > pxa27x-camera pxa27x-camera.0: LCD clock 104000000Hz, target freq 26000=
000Hz, divisor 1
> > pxa27x-camera pxa27x-camera.0: got DMA channel 1
> > pxa27x-camera pxa27x-camera.0: got DMA channel (U) 2
> > pxa27x-camera pxa27x-camera.0: got DMA channel (V) 3
> > camera 0-0: Probing 0-0
> > camera 0-0: soc_camera_probe: power 1
> > --> a780_pxacamera_power: called. on: 1  !on: 0
> > camera 0-0: soc_camera_probe: reset
> > --> a780_pxacamera_reset: called
> > pxa27x-camera pxa27x-camera.0: Registered platform device at cc8a5380 d=
ata c03a40a8
> > pxa27x-camera pxa27x-camera.0: pxa_camera_activate: Init gpios
> > --> a780_pxacamera_init: called
> > pxa27x-camera pxa27x-camera.0: PXA Camera driver attached to camera 0
> > camera 0-0: mt9m111_video_probe: called
> > i2c: error: exhausted retries
> > i2c: msg_num: 0 msg_idx: -2000 msg_ptr: 0
> > i2c: ICR: 000007e0 ISR: 00000002
> > i2c: log: [00000446:000007e0]=20
> > mt9m111 0-005d: read  reg.00d -> ffffff87
> > mt9m111 0-005d: mt9m11x init failed: -121
> > mt9m111: probe of 0-005d failed with error -121
> > pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0
> > camera 0-0: soc_camera_probe: power 0
> > a780_pxacamera_power: called. on: 0  !on: 1
> > camera: probe of 0-0 failed with error -12
> >=20
> > See? It's power(), reset(), init().
> > Maybe the problem is in soc_camera_probe()?
>=20
> Sorry, you'd have to elaborate more on this. So, what's wrong with that=20
> sequence? it doesn't make sense to reset a powered down device or reset=20
> after init or whatever...
>

I mean, when probing (or even opening) the device, pxacamera.init()
is now called *after* the power ON and reset. If I kept disabled (high)
nCAM_EN in init(), as it should've been, this would have overridden
the previous power(1) call.

Isn't init() in pxacamera platform data meant to initialize the device
before it can be powered ON? In fact I am requesting the gpios in
a780_pxacamera_init, and if power() or reset() are called before it, then
they will be invalid, because the gpios have not been requested yet.

Moreover, pxacamera.init() is called in pxa_camera_activate, which is
called in pxa_camera_add_device, which in turn is invoked by
soc_camera_open() every time.
Shouldn't the init() method, where I request gpios, be called
only on probe?

Let me be more schematic, when probing the camera we have:

soc_camera_probe()         /* same in soc_camera_open! */
|-	icl->power(1)
|-	icl->reset()
|-	icd->ops->add()
	|-	pxacamera.init()  /* requesting gpios here! */
|-	video_dev_create(icd)
|-	...

Maybe we should have something like:

pxacamera.init()           /* request gpios only once! on probe. */
soc_camera_probe()         /* same in soc_camera_open */
|-	icl->power(1)
|-	icl->reset()
|-	icd->ops->add()
|-	video_dev_create(icd)
|-	...

Or, I'm missing what init() is supposed to do :)
Does a patch like this make sense to you?
(I've read the other mail about removing .init just before hitting Send,
this can be an alternative to removing it, having GPIOs setup in the
user driver seems clearer to me.)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_cam=
era.c
index 6952e96..3101bcb 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -881,18 +882,8 @@ static void recalculate_fifo_timeout(struct pxa_camera=
_dev *pcdev,
=20
 static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 {
-	struct pxacamera_platform_data *pdata =3D pcdev->pdata;
-	struct device *dev =3D pcdev->soc_host.v4l2_dev.dev;
 	u32 cicr4 =3D 0;
=20
-	dev_dbg(dev, "Registered platform device at %p data %p\n",
-		pcdev, pdata);
-
-	if (pdata && pdata->init) {
-		dev_dbg(dev, "%s: Init gpios\n", __func__);
-		pdata->init(dev);
-	}
-
 	/* disable all interrupts */
 	__raw_writel(0x3ff, pcdev->base + CICR0);
=20
@@ -1651,6 +1644,17 @@ static int __devinit pxa_camera_probe(struct platfor=
m_device *pdev)
 	pcdev->res =3D res;
=20
 	pcdev->pdata =3D pdev->dev.platform_data;
+
+	dev_dbg(&pdev->dev, "Registered platform device at %p data %p\n",
+		pcdev, pcdev->pdata);
+
+	if (pcdev->pdata && pcdev->pdata->init) {
+		dev_dbg(&pdev->dev, "%s: Init gpios\n", __func__);
+		err =3D pcdev->pdata->init(&pdev->dev);
+		if (err)
+			goto exit_clk;
+	}
+
 	pcdev->platform_flags =3D pcdev->pdata->flags;
 	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
 			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Fri__6_Nov_2009_18_29_10_+0100_9F7cz5FM6iQvTNTW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr0XOYACgkQ5xr2akVTsAFQ4gCfZUYH/O81su/9JCoBePHlFMUV
P3AAnRjLREReOl8Zie6p8x2V94nDvAz+
=o6hy
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Nov_2009_18_29_10_+0100_9F7cz5FM6iQvTNTW--
