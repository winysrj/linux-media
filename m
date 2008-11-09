Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9N012q026802
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 18:00:01 -0500
Received: from smtp-out28.alice.it (smtp-out28.alice.it [85.33.2.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9Mxl5h029011
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 17:59:47 -0500
Date: Sun, 9 Nov 2008 23:59:40 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081109235940.4c009a68.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0811082119280.8956@axis700.grange>
References: <20081107125919.ddf028a6.ospite@studenti.unina.it>
	<874p2jbegl.fsf@free.fr>
	<Pine.LNX.4.64.0811082119280.8956@axis700.grange>
Mime-Version: 1.0
Cc: 
Subject: Re: [PATCH, RFC] mt9m111: allow data to be received on pixelclock
 falling edge?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0983284721=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0983284721==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Sun__9_Nov_2008_23_59_40_+0100_H8YfoiVOxPJLMjxF"

--Signature=_Sun__9_Nov_2008_23_59_40_+0100_H8YfoiVOxPJLMjxF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Nov 2008 21:36:46 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Fri, 7 Nov 2008, Robert Jarzmik wrote:
>=20
> > Antonio Ospite <ospite@studenti.unina.it> writes:
> >=20
> > > Now I have many questions:
> > >
> > > * Can the same sensor model have different default hardwired values?
> > >   I am referring to IO/Timings differences between mt9m111 on A910
> > >   and A780
> > Technically, yes.
> > Even the sensor can sometimes be configured to dump its date on falling=
 edge
> > rather than rising edge. See MT9M111 datasheet, register 0x13a (Output =
Format
> > Control 2), bit 9.
>=20
> Also register 0x00a is intersting...
>

Well, the two sensors have indeed almost the same factory config, in
particular are equal:

ROW_SPEED(0x00a): 0x0011
OUTPUT_FORMAT_CTRL2_A(0x13a): 0x0200
OUTPUT_FORMAT_CTRL2_B(0x19b): 0x0200

only some _reserved_ registers have different factory defaults. I can
provide mt9m111 registers dump of both phones if you are interested.

> > > * Should I change the sensor setup instead of changing its advertised
> > >   capabilities? Maybe modifying mt9m111 so it can use platform data?
> > Would't it be better to change format negociation instead : patch in mt=
9m111.c
> > the mt9m111_query_bus_param() function, add SOCAM_PCLK_SAMPLE_FALLING, =
and add
> > necessary handling in the mt9m111_set_bus_param() ? That would be a lit=
tle
> > extension of your attached patch ...
>=20
> Yes, that would be correct, but, it seems, it would then stop working=20
> again, see below.
>

I guess so.

> > > * Is the pxa-camera code dealing with PXA_CAMERA_PCP too conservative?
> > >   Shouldn't PXA_CAMERA_PCP be independent from the specific sensor
> > >   capabilities? it is a valid pxa-camera setting even if it produces
> > >   wrong results with the specific sensor.
> > Well, I don't understand something here : you have to configure the sen=
sor to
> > output data on rising edge, while the PXA is reading them on the fallin=
g edge,
> > am I right ? Would that mean the clock signal is inverted by the hardwa=
re ? I
> > don't really understand that part ...
>=20
> That's also the only explanation I can see here too... I was actually=20
> wondering as I was developing the framework, if anyone ever would come up=
=20
> with an idea to put inverters on any of sync / clock lines or any other=20
> additional logic. Ok, you can configure inverters with extra platform=20
> flags, but can we really add enough flags to support any possible=20
> camera-interface design?... I am not a hardware designer, so, I have no=20
> idea what other configurations one can think of here. Shall we really add=
=20
> flags for inverters on all interface lines and hope noone will ever=20
> engineer anything more complex than that?
>

A smarter solution would be preferred indeed.

> > > @@ -410,7 +410,8 @@ static int mt9m111_stop_capture(struct soc_camera=
_device *icd)
> > >
> > >  static unsigned long mt9m111_query_bus_param(struct soc_camera_devic=
e *icd)
> > >  {
> > > - return SOCAM_MASTER | SOCAM_PCLK_SAMPLE_RISING |
> > > + return SOCAM_MASTER |
> > > +   SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
> > >     SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
> > >     SOCAM_DATAWIDTH_8;
> > >  }
[...]
>=20
> I think, it currently works thanks to this code in pxa_camera.c:
>=20
> 	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
> 	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
> 		if (pcdev->platform_flags & PXA_CAMERA_PCP)
> 			common_flags &=3D ~SOCAM_PCLK_SAMPLE_RISING;
> 		else
> 			common_flags &=3D ~SOCAM_PCLK_SAMPLE_FALLING;
> 	}
>=20
> i.e., if both sensor and host support both polarities take what's=20
> suggested by the platform. That's, probably, why Antonio's patch helped.=
=20
> But, if you also add flag handling to mt9m111_set_bus_param(), it will=20
> invert the pixel clock too, and it will stop working again... It's a pity=
=20
> we'll, probably, never see schematics of the phone:-)
>

A real pity. I don't have access to those schematic either as you may
guess.

> So, shall we add inverter flags?
>

Would you accept this change instead?

--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -845,7 +845,7 @@ static int pxa_camera_set_bus_param(struct
soc_camera_device *icd, __u32 pixfmt) cicr4 |=3D CICR4_PCLK_EN;
  if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
    cicr4 |=3D CICR4_MCLK_EN;
- if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
+ if (pcdev->platform_flags & PXA_CAMERA_PCP)
    cicr4 |=3D CICR4_PCP;
  if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
    cicr4 |=3D CICR4_HSP;

and maybe for other cicr4 bits too, in the spirit of using the SOCAM_
defines only for icd set_bus_param() but still giving preference to
platform data for host settings.

It is kind of tricky I know, but it would allow to overcome unexpected
hardware setups.

Regards,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Sun__9_Nov_2008_23_59_40_+0100_H8YfoiVOxPJLMjxF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkXa1wACgkQ5xr2akVTsAG/twCfTHuLhzj3A4Tgb1GHCsr+g4aa
IB0An0E4nBDUsJFrC1TwS7qTjypEvFW1
=7mX2
-----END PGP SIGNATURE-----

--Signature=_Sun__9_Nov_2008_23_59_40_+0100_H8YfoiVOxPJLMjxF--


--===============0983284721==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0983284721==--
