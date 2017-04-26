Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51054 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030384AbdDZVTg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 17:19:36 -0400
Date: Wed, 26 Apr 2017 23:19:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: [bug] omap3isp: missing support for ENUM_FMT
Message-ID: <20170426211933.GA13593@amd>
References: <20161228183036.GA13139@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170304153946.GA3220@valkosipuli.retiisi.org.uk>
 <2578197.Jc2St0chTa@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <2578197.Jc2St0chTa@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Currently, ispvideo.c does not support enum_format. This causes
problems for example for libv4l2.

Now, I'm pretty sure patch below is not the right fix. But it fixes
libv4l2 problem for me.

Pointer to right solution welcome.

Regards,
									Pavel

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/pla=
tform/omap3isp/ispvideo.c
index 218e6d7..2ce0327 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -772,6 +772,44 @@ isp_video_try_format(struct file *file, void *fh, stru=
ct v4l2_format *format)
 }
=20
 static int
+isp_video_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *fo=
rmat)
+{
+	struct isp_video *video =3D video_drvdata(file);
+	struct v4l2_subdev_format fmt;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	printk("ispvideo: enum_fmt\n");
+
+	subdev =3D isp_video_remote_subdev(video, &pad);
+	if (subdev =3D=3D NULL) {
+		printk("No subdev\n");
+		//return -EINVAL;
+	}
+
+	//isp_video_pix_to_mbus(&format->fmt.pix, &fmt.format);
+	if (format->index)
+		return -EINVAL;
+	format->type =3D video->type;
+	format->flags =3D 0;
+	strcpy(format->description, "subdev description");
+	format->pixelformat =3D V4L2_PIX_FMT_SGRBG10;
+
+	printk("Returning SRGBG10\n");
+#if 0=09
+	fmt.pad =3D pad;
+	fmt.which =3D V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret =3D v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
+	if (ret)
+		return ret =3D=3D -ENOIOCTLCMD ? -ENOTTY : ret;
+
+	isp_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
+#endif
+	return 0;
+}
+
+static int
 isp_video_get_selection(struct file *file, void *fh, struct v4l2_selection=
 *sel)
 {
 	struct isp_video *video =3D video_drvdata(file);
@@ -1276,6 +1314,7 @@ static const struct v4l2_ioctl_ops isp_video_ioctl_op=
s =3D {
 	.vidioc_g_fmt_vid_cap		=3D isp_video_get_format,
 	.vidioc_s_fmt_vid_cap		=3D isp_video_set_format,
 	.vidioc_try_fmt_vid_cap		=3D isp_video_try_format,
+	.vidioc_enum_fmt_vid_cap        =3D isp_video_enum_format,
 	.vidioc_g_fmt_vid_out		=3D isp_video_get_format,
 	.vidioc_s_fmt_vid_out		=3D isp_video_set_format,
 	.vidioc_try_fmt_vid_out		=3D isp_video_try_format,

On Sat 2017-03-04 20:44:50, Laurent Pinchart wrote:
> Hi Sakari,
>=20
> On Saturday 04 Mar 2017 17:39:46 Sakari Ailus wrote:
> > On Sat, Mar 04, 2017 at 03:03:18PM +0200, Sakari Ailus wrote:
> > > On Thu, Mar 02, 2017 at 01:38:48PM +0100, Pavel Machek wrote:
> > >>=20
> > >>>> Ok, how about this one?
> > >>>> omap3isp: add rest of CSI1 support
> > >>>>=20
> > >>>> CSI1 needs one more bit to be set up. Do just that.
> > >>>>=20
> > >>>> It is not as straightforward as I'd like, see the comments in the
> > >>>> code for explanation.
> > >>
> > >> ...
> > >>=20
> > >>>> +	if (isp->phy_type =3D=3D ISP_PHY_TYPE_3430) {
> > >>>> +		struct media_pad *pad;
> > >>>> +		struct v4l2_subdev *sensor;
> > >>>> +		const struct isp_ccp2_cfg *buscfg;
> > >>>> +
> > >>>> +		pad =3D media_entity_remote_pad(&ccp2
> > >>>> ->pads[CCP2_PAD_SINK]);
> > >>>> +		sensor =3D media_entity_to_v4l2_subdev(pad->entity);
> > >>>> +		/* Struct isp_bus_cfg has union inside */
> > >>>> +		buscfg =3D &((struct isp_bus_cfg *)sensor->host_priv)
> > >>>> ->bus.ccp2;
> > >>>> +
> > >>>> +		csiphy_routing_cfg_3430(&isp->isp_csiphy2,
> > >>>> +					ISP_INTERFACE_CCP2B_PHY1,
> > >>> > +					enable, !!buscfg->phy_layer,
> > >>> > +					buscfg->strobe_clk_pol);
> > >>>=20
> > >>> You should do this through omap3isp_csiphy_acquire(), and not call
> > >>> csiphy_routing_cfg_3430() directly from here.
> > >>=20
> > >> Well, unfortunately omap3isp_csiphy_acquire() does have csi2
> > >> assumptions hard-coded :-(.
> > >>=20
> > >> This will probably fail.
> > >>=20
> > >> 	        rval =3D omap3isp_csi2_reset(phy->csi2);
> > >> 	        if (rval < 0)
> > >> 		                goto done;
> > >=20
> > > Could you try to two patches I've applied on the ccp2 branch (I'll re=
move
> > > them if there are issues).
> > >=20
> > > That's compile tested for now only.
> >=20
> > One more thing. What's needed for configuring the PHY for CCP2?
> >=20
> > For instance, is the CSI-2 PHY regulator still needed in
> > omap3isp_csiphy_acquire()? One way to do this might go to see the origi=
nal
> > driver for N900; I don't have the TRM at hand right now.
>=20
> The OMAP34xx TRM and data manual both mention separate VDDS power supplie=
s for=20
> the CSIb and CSI2 I/O complexes.
>=20
> vdds_csi2		CSI2 Complex I/O
> vdds_csib		CSIb Complex I/O
>=20
> On OMAP36xx, we instead have
>=20
> vdda_csiphy1		Input power for camera PHY buffer
> vdda_csiphy2		Input power for camera PHY buffer
>=20
> We need to enable the vds_csib regulator to operate the CSI1/CCP2 PHY, bu=
t=20
> that regulator gets enabled in ispccp2.c as that module is powered by the=
=20
> vdds_csib supply on OMAP34xx. However, it won't hurt to do so, and the co=
de=20
> could be simpler if we manage the regulators the same way on OMAP34xx and=
=20
> OMAP36xx.
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkBDuUACgkQMOfwapXb+vK9IQCggzb0360brj7c09KbPZxk/rDB
XhEAoMLXRZpEeYlHZxYSVwiXoU37wh5e
=AI3J
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
