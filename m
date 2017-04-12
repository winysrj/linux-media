Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52568 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752851AbdDLVMD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 17:12:03 -0400
Date: Wed, 12 Apr 2017 23:11:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        sakari.ailus@iki.fi, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: et8ek8 camera on Nokia N900: trying to understand what is going on
 with modes
Message-ID: <20170412211159.GA2313@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

5Mpix mode does not work on N900, which is something I'd like to
understand. et8ek8_mode contains huge tables of register settings and
parameter values, but it seems that they are not really independend.

To test that theory, I started with checking values against each
other.

This is the work so far, it is neither complete nor completely working
at the moment. Perhaps someone wants to play...

								Pavel

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/e=
t8ek8/et8ek8_driver.c
index 6296f6f..ca2f648 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -798,6 +798,8 @@ static void et8ek8_update_controls(struct et8ek8_sensor=
 *sensor)
 	u32 min, max, pixel_rate;
 	static const int S =3D 8;
=20
+	printk("Updating controls for %d x %d @ %d mode -- %s\n", mode->width, mo=
de->height, mode->pixel_clock, mode->name);
+
 	ctrl =3D sensor->exposure;
=20
 #ifdef COMPATIBLE
@@ -820,6 +822,127 @@ static void et8ek8_update_controls(struct et8ek8_sens=
or *sensor)
 	__v4l2_ctrl_s_ctrl_int64(sensor->pixel_rate, pixel_rate << S);
 }
=20
+static int read_8(struct i2c_client *client, unsigned long addr)
+{
+	int val;
+	et8ek8_i2c_read_reg(client, ET8EK8_REG_8BIT, addr, &val);
+	return val;
+}
+
+static int read_16(struct i2c_client *client, unsigned long addr)
+{
+	return read_8(client, addr);
+}
+
+static void assert_value(struct i2c_client *client, unsigned long addr, un=
signed long val)
+{
+	int val2 =3D read_8(client, addr);
+	if (val !=3D val2)
+		printk("et8ek8: assertion check %lx / should be %lx is %lx\n", addr, val=
, val2);
+}
+
+static void assert(struct i2c_client *client, int v, char *msg)
+{
+	if (!v)
+		printk("et8ek8: assertion: %s\n", msg);
+}
+
+static void assert_eq(struct i2c_client *client, int v1, int v2, char *msg)
+{
+	if (v1 !=3D v2)
+		printk("et8ek8: assertion: %d =3D=3D %d %s\n", v1, v2, msg);
+}
+
+static void et8ek8_check(struct et8ek8_sensor *sensor)
+{
+	/*
+	  1239 4F       # CKVAR_DIV
+	  1238 02       # CKVAR_DIV[8] CKREF_DIV
+	  123B 70       # MRCK_DIV LVDSCK_DIV
+	  123A 05       # VCO_DIV SPCK_DIV
+	  121B 63       # PIC_SIZE MONI_MODE
+	  1220 85       # H_COUNT
+	  1221 00       # H_COUNT[10:8]
+	  1222 58       # V_COUNT
+	  1223 00       # V_COUNT[12:8]
+	  121D 63       # H_SIZE H_INTERMIT
+	  125D 83       # CCP_LVDS_MODE/ _/ _/ _/ _/ CCP_COMP_MODE[2-0]
+	*/
+	struct et8ek8_reglist *r =3D sensor->current_reglist;
+	struct v4l2_subdev *subdev =3D &sensor->subdev;
+	struct i2c_client *client =3D v4l2_get_subdevdata(subdev);
+	int vco;
+=09
+	printk("Mode validation:\n");
+
+	assert_value(client, 0x1220, (r->mode.width / 24) & 0xff);
+	assert_value(client, 0x1221, (r->mode.width / 24) >> 8);
+	=09
+	assert_value(client, 0x1222, (r->mode.height / 24) & 0xff);
+	assert_value(client, 0x1223, (r->mode.height / 24) >> 8);
+
+	{
+		int ckref_div =3D read_16(client, 0x1238) & 0xf;
+		int ckvar_div =3D ((read_16(client, 0x1238) & 0x80) >> 7) | (read_16(cli=
ent, 0x1239) << 1);
+		int vco_div =3D read_16(client, 0x123A) >> 4;
+		int spck_div =3D read_16(client, 0x123A) & 0xf;
+		int mrck_div =3D read_16(client, 0x123B) >> 4;
+		int lvdsck_div =3D read_16(client, 0x123B) & 0xf;
+
+		vco =3D (r->mode.ext_clock * ckvar_div) / (ckref_div + 1);
+		printk("Vco is %d, %d %d %d\n", vco, r->mode.ext_clock, ckvar_div, ckref=
_div);
+		int ccp2 =3D vco / ((lvdsck_div + 1) * (vco_div + 1));
+		int spck =3D vco / ((spck_div + 1) * (vco_div + 1));
+
+		assert_eq(client, r->mode.pixel_clock, spck, "spck");
+	}
+
+	assert_eq(client, r->mode.max_exp, r->mode.height - 4, "max_exp");
+
+	assert(client, !(r->mode.sensor_window_width % r->mode.window_width), "wi=
ndow_width");
+	switch(r->mode.sensor_window_width / r->mode.window_width) {
+	case 1: assert_value(client, 0x121d, 0x64);
+		break;
+	case 2: assert_value(client, 0x121d, 0x63);
+		break;
+	case 3: assert_value(client, 0x121d, 0x62);
+		break;
+	default:
+		assert(client, 0, "bad window_width");
+	}
+
+	assert(client, !(r->mode.sensor_window_height % r->mode.window_height), "=
window_width");
+	switch(r->mode.sensor_window_height / r->mode.window_height) {
+	case 1: assert_value(client, 0x121b, 0x64);
+		break;
+	case 2: assert_value(client, 0x121b, 0x63);
+		break;
+	case 3: assert_value(client, 0x121b, 0x62);
+		break;
+	default:
+		assert(client, 0, "bad window_height");
+	}
+
+	//assert(r->mode.height * r->mode.width * fps =3D=3D r->mode.pixel_clock);
+
+	switch (r->mode.bus_format) {
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+		assert_value(client, 0x125D, 0x88);
+		assert_eq(client, vco, r->mode.pixel_clock * 8, "vco_clock");
+		break;
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+		assert_value(client, 0x125D, 0x83);
+		assert_eq(client, vco, r->mode.pixel_clock * 6, "vco_clock");	=09
+		break;
+	default:
+		assert(client, 0, "unexpected bus format");
+
+		/* There are more possibilities, see=20
+		   https://github.com/maemo-foss/omap3camera-firmware/blob/master/makemo=
des-et8ek8.pl
+		*/
+	}
+}
+
 static int et8ek8_configure(struct et8ek8_sensor *sensor)
 {
 	struct v4l2_subdev *subdev =3D &sensor->subdev;
@@ -872,6 +995,8 @@ static int et8ek8_s_stream(struct v4l2_subdev *subdev, =
int streaming)
 	if (ret < 0)
 		return ret;
=20
+	et8ek8_check(sensor);
+
 	return et8ek8_stream_on(sensor);
 }
=20
diff --git a/drivers/media/i2c/et8ek8/et8ek8_mode.c b/drivers/media/i2c/et8=
ek8/et8ek8_mode.c
index a79882a..045d361 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_mode.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_mode.c
@@ -22,6 +22,11 @@
  * Stingray sensor mode settings for Scooby
  */
=20
+/* https://github.com/maemo-foss/omap3camera-firmware/blob/master/makemode=
s-et8ek8.pl
+
+   /data/l/maemo/kernel-power/kernel-power-2.6.28/drivers/media/video/et8e=
k8-modes.h
+*/
+
 /* Mode1_poweron_Mode2_16VGA_2592x1968_12.07fps */
 static struct et8ek8_reglist mode1_poweron_mode2_16vga_2592x1968_12_07fps =
=3D {
 /* (without the +1)
@@ -39,18 +44,20 @@ static struct et8ek8_reglist mode1_poweron_mode2_16vga_=
2592x1968_12_07fps =3D {
  */
 	.type =3D ET8EK8_REGLIST_POWERON,
 	.mode =3D {
-		.sensor_width =3D 2592,
-		.sensor_height =3D 1968,
+	.name =3D "mode1_poweron_mode2_16vga_2592x1968_12_07fps",
+	=09
+		.sensor_width =3D 259,
+		.sensor_height =3D 196,
 		.sensor_window_origin_x =3D 0,
 		.sensor_window_origin_y =3D 0,
-		.sensor_window_width =3D 2592,
-		.sensor_window_height =3D 1968,
-		.width =3D 3288,
-		.height =3D 2016,
+		.sensor_window_width =3D 259,
+		.sensor_window_height =3D 196,
+		.width =3D 328,
+		.height =3D 201,
 		.window_origin_x =3D 0,
 		.window_origin_y =3D 0,
-		.window_width =3D 2592,
-		.window_height =3D 1968,
+		.window_width =3D 259,
+		.window_height =3D 196,
 		.pixel_clock =3D 80000000,
 		.ext_clock =3D 9600000,
 		.timeperframe =3D {
@@ -108,6 +115,65 @@ static struct et8ek8_reglist mode1_poweron_mode2_16vga=
_2592x1968_12_07fps =3D {
 		{ ET8EK8_REG_8BIT, 0x1648, 0x00 },
 		{ ET8EK8_REG_8BIT, 0x113E, 0x01 },
 		{ ET8EK8_REG_8BIT, 0x113F, 0x22 },
+		/* Settings from here on seem to for the 2592x1968 mode. */
+		{ ET8EK8_REG_8BIT, 0x1239, 0x64 },
+		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },
+		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },
+		{ ET8EK8_REG_8BIT, 0x123A, 0x07 },
+		{ ET8EK8_REG_8BIT, 0x121B, 0x64 },
+		{ ET8EK8_REG_8BIT, 0x121D, 0x64 },
+		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },
+		{ ET8EK8_REG_8BIT, 0x1220, 0x89 },
+		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
+		{ ET8EK8_REG_8BIT, 0x1222, 0x54 },
+		{ ET8EK8_REG_8BIT, 0x125D, 0x88 }, /* CCP_LVDS_MODE/  */
+		{ ET8EK8_REG_TERM, 0, 0}
+	}
+};
+
+static struct et8ek8_reglist mode2_16vga_2592x1968_12_07fps =3D {
+/* (without the +1)
+ * SPCK       =3D 80 MHz
+ * CCP2       =3D 640 MHz
+ * VCO        =3D 640 MHz
+ * VCOUNT     =3D 84 (2016)
+ * HCOUNT     =3D 137 (3288)
+ * CKREF_DIV  =3D 2
+ * CKVAR_DIV  =3D 200
+ * VCO_DIV    =3D 0
+ * SPCK_DIV   =3D 7
+ * MRCK_DIV   =3D 7
+ * LVDSCK_DIV =3D 0
+ */
+	.type =3D ET8EK8_REGLIST_MODE,
+	.mode =3D {
+	.name =3D "mode2_16vga_2592x1968_12_07fps",
+	=09
+		.sensor_width =3D 2592,
+		.sensor_height =3D 1968,
+		.sensor_window_origin_x =3D 0,
+		.sensor_window_origin_y =3D 0,
+		.sensor_window_width =3D 2592,
+		.sensor_window_height =3D 1968,
+		.width =3D 3288,
+		.height =3D 2016,
+		.window_origin_x =3D 0,
+		.window_origin_y =3D 0,
+		.window_width =3D 2592,
+		.window_height =3D 1968,
+		.pixel_clock =3D 80000000,
+		.ext_clock =3D 9600000,
+		.timeperframe =3D {
+			.numerator =3D 100,
+			.denominator =3D 1207
+		},
+		.max_exp =3D 2012,
+		/* .max_gain =3D 0, */
+		.bus_format =3D MEDIA_BUS_FMT_SGRBG10_1X10,
+		.sensitivity =3D 65536
+	},
+	.regs =3D {
+		/* Settings from here on seem to for the 2592x1968 mode. */
 		{ ET8EK8_REG_8BIT, 0x1239, 0x64 },
 		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },
 		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },
@@ -123,6 +189,7 @@ static struct et8ek8_reglist mode1_poweron_mode2_16vga_=
2592x1968_12_07fps =3D {
 	}
 };
=20
+
 /* Mode1_16VGA_2592x1968_13.12fps_DPCM10-8 */
 static struct et8ek8_reglist mode1_16vga_2592x1968_13_12fps_dpcm10_8 =3D {
 /* (without the +1)
@@ -140,6 +207,7 @@ static struct et8ek8_reglist mode1_16vga_2592x1968_13_1=
2fps_dpcm10_8 =3D {
  */
 	.type =3D ET8EK8_REGLIST_MODE,
 	.mode =3D {
+	.name =3D "mode1_16vga_2592x1968_13_12fps_dpcm10_8",
 		.sensor_width =3D 2592,
 		.sensor_height =3D 1968,
 		.sensor_window_origin_x =3D 0,
@@ -196,6 +264,7 @@ static struct et8ek8_reglist mode3_4vga_1296x984_29_99f=
ps_dpcm10_8 =3D {
  */
 	.type =3D ET8EK8_REGLIST_MODE,
 	.mode =3D {
+	.name =3D "mode3_4vga_1296x984_29_99fps_dpcm10_8",
 		.sensor_width =3D 2592,
 		.sensor_height =3D 1968,
 		.sensor_window_origin_x =3D 0,
@@ -252,6 +321,7 @@ static struct et8ek8_reglist mode4_svga_864x656_29_88fp=
s =3D {
  */
 	.type =3D ET8EK8_REGLIST_MODE,
 	.mode =3D {
+	.name =3D "mode4_svga_864x656_29_88fps",
 		.sensor_width =3D 2592,
 		.sensor_height =3D 1968,
 		.sensor_window_origin_x =3D 0,
@@ -308,6 +378,7 @@ static struct et8ek8_reglist mode5_vga_648x492_29_93fps=
 =3D {
  */
 	.type =3D ET8EK8_REGLIST_MODE,
 	.mode =3D {
+	.name =3D "mode5_vga_648x492_29_93fps",
 		.sensor_width =3D 2592,
 		.sensor_height =3D 1968,
 		.sensor_window_origin_x =3D 0,
@@ -364,6 +435,7 @@ static struct et8ek8_reglist mode2_16vga_2592x1968_3_99=
fps =3D {
  */
 	.type =3D ET8EK8_REGLIST_MODE,
 	.mode =3D {
+	.name =3D "mode2_16vga_2592x1968_3_99fps",
 		.sensor_width =3D 2592,
 		.sensor_height =3D 1968,
 		.sensor_window_origin_x =3D 0,
@@ -398,6 +470,7 @@ static struct et8ek8_reglist mode2_16vga_2592x1968_3_99=
fps =3D {
 		{ ET8EK8_REG_8BIT, 0x1220, 0x89 },
 		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
 		{ ET8EK8_REG_8BIT, 0x1222, 0xFE },
+		{ ET8EK8_REG_8BIT, 0x125D, 0x88 }, /* CCP_LVDS_MODE/  */
 		{ ET8EK8_REG_TERM, 0, 0}
 	}
 };
@@ -419,6 +492,7 @@ static struct et8ek8_reglist mode_648x492_5fps =3D {
  */
 	.type =3D ET8EK8_REGLIST_MODE,
 	.mode =3D {
+	.name =3D "mode_648x492_5fps",
 		.sensor_width =3D 2592,
 		.sensor_height =3D 1968,
 		.sensor_window_origin_x =3D 0,
@@ -475,6 +549,7 @@ static struct et8ek8_reglist mode3_4vga_1296x984_5fps =
=3D {
  */
 	.type =3D ET8EK8_REGLIST_MODE,
 	.mode =3D {
+	.name =3D "mode3_4vga_1296x984_5fps",
 		.sensor_width =3D 2592,
 		.sensor_height =3D 1968,
 		.sensor_window_origin_x =3D 0,
@@ -531,6 +606,7 @@ static struct et8ek8_reglist mode_4vga_1296x984_25fps_d=
pcm10_8 =3D {
  */
 	.type =3D ET8EK8_REGLIST_MODE,
 	.mode =3D {
+	.name =3D "mode_4vga_1296x984_25fps_dpcm10_8",
 		.sensor_width =3D 2592,
 		.sensor_height =3D 1968,
 		.sensor_window_origin_x =3D 0,
@@ -573,15 +649,23 @@ static struct et8ek8_reglist mode_4vga_1296x984_25fps=
_dpcm10_8 =3D {
 struct et8ek8_meta_reglist meta_reglist =3D {
 	.version =3D "V14 03-June-2008",
 	.reglist =3D {
+		/* power on mode; strange & special */
 		{ .ptr =3D &mode1_poweron_mode2_16vga_2592x1968_12_07fps },
-		{ .ptr =3D &mode1_16vga_2592x1968_13_12fps_dpcm10_8 },
-		{ .ptr =3D &mode3_4vga_1296x984_29_99fps_dpcm10_8 },
-		{ .ptr =3D &mode4_svga_864x656_29_88fps },
-		{ .ptr =3D &mode5_vga_648x492_29_93fps },
-		{ .ptr =3D &mode2_16vga_2592x1968_3_99fps },
-		{ .ptr =3D &mode_648x492_5fps },
-		{ .ptr =3D &mode3_4vga_1296x984_5fps },
+		/* dpcm10/8 modes */
+#if 0
+		{ .ptr =3D &mode1_16vga_2592x1968_13_12fps_dpcm10_8 }, /* No luck */
+		{ .ptr =3D &mode3_4vga_1296x984_29_99fps_dpcm10_8 }, /* No luck */
 		{ .ptr =3D &mode_4vga_1296x984_25fps_dpcm10_8 },
+#endif
+		/* "normal" modes */
+#if 1
+		{ .ptr =3D &mode2_16vga_2592x1968_12_07fps }, /* My hacks. */
+		{ .ptr =3D &mode4_svga_864x656_29_88fps }, /* Works, AFAICT */
+		{ .ptr =3D &mode5_vga_648x492_29_93fps }, /* Does not seem to work ? */
+//		{ .ptr =3D &mode2_16vga_2592x1968_3_99fps }, /* Does not seem to work:=
 scrolling */
+		{ .ptr =3D &mode_648x492_5fps }, /* Does not seem to work ? */
+		{ .ptr =3D &mode3_4vga_1296x984_5fps }, /* Works, AFAICT */
+#endif
 		{ .ptr =3D NULL }
 	}
 };
diff --git a/drivers/media/i2c/et8ek8/et8ek8_reg.h b/drivers/media/i2c/et8e=
k8/et8ek8_reg.h
index 07f1873..60ab305 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_reg.h
+++ b/drivers/media/i2c/et8ek8/et8ek8_reg.h
@@ -37,19 +37,21 @@ struct et8ek8_mode {
 	u16 sensor_window_height;
=20
 	/* Image data coming from sensor (after scaling) */
-	u16 width;
+	u16 width;			/* u */
 	u16 height;
 	u16 window_origin_x;
 	u16 window_origin_y;
-	u16 window_width;
-	u16 window_height;
+	u16 window_width;		/* u */
+	u16 window_height;		/* u */
=20
-	u32 pixel_clock;		/* in Hz */
-	u32 ext_clock;			/* in Hz */
-	struct v4l2_fract timeperframe;
-	u32 max_exp;			/* Maximum exposure value */
-	u32 bus_format;			/* MEDIA_BUS_FMT_ */
+	u32 pixel_clock;		/* u in Hz */
+	u32 ext_clock;			/* u in Hz */
+	struct v4l2_fract timeperframe; /* u */
+	u32 max_exp;			/* u Maximum exposure value */
+	u32 bus_format;			/* u MEDIA_BUS_FMT_ */
 	u32 sensitivity;		/* 16.16 fixed point */
+
+	char *name;
 };
=20
 #define ET8EK8_REG_8BIT			1

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljumB8ACgkQMOfwapXb+vL45gCdFzM7BbPINhpRikkR2pp7W/37
AhYAnieAsRX9BNCY80Q1dxpjaL1QUd/2
=PfuD
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
