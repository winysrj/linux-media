Return-path: <mchehab@localhost>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63454 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab1GFUoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 16:44:09 -0400
Received: by iwn6 with SMTP id 6so251898iwn.19
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2011 13:44:09 -0700 (PDT)
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 6 Jul 2011 20:43:49 +0000
Message-ID: <CAH9NwWc0s3ECLFjf502mwnytiXj5i26nZnv5b3c6mMP07LW36w@mail.gmail.com>
Subject: [REVIEW] adv7175 mbus support
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi all,

I have hacked together a patch, which adds support for mediabus in
adv7175 driver. I am not sending
this out as a patch series instead I show you one (big) patch with
questions about my code. Also
I want to note that I am not quite sure if I introduced the correct
formats and the documentation could
also be better, but I am not a format specialist.

The data sheet can be found here:
http://dxr3.sourceforge.net/download/hardware/ADV7175A_6A.pdf
In later patches I need to implement this functionality:

HSYNC to Pixel Data Adjust (TR17–TR16)
This enables the HSYNC to be adjusted with respect to the
pixel data. This allows the Cr and Cb components to be
swapped. This adjustment is available in both master and slave
timing modes.

See data sheet page 25. But at the moment I am not sure how to do this.


diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 49c532e..18e30b0 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2565,5 +2565,43 @@
 	</tgroup>
       </table>
     </section>
+
+    <section>
+      <title>YCrCb Formats</title>
+
+      <para>YCbCr represents colors as a combination of three values:
+      <itemizedlist>
+	<listitem><para>Y - the luminosity (roughly the brightness)</para></listitem>
+	<listitem><para>Cb - the chrominance of the blue primary</para></listitem>
+	<listitem><para>Cr - the chrominance of the red primary</para></listitem>
+      </itemizedlist>
+      </para>
+
+      <para>The following table lists existing YCrCb compressed formats.</para>
+
+      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-ycrcb">
+	<title>YCrCb Formats</title>
+	<tgroup cols="2">
+	  <colspec colname="id" align="left" />
+	  <colspec colname="code" align="left"/>
+	  <thead>
+	    <row>
+	      <entry>Identifier</entry>
+	      <entry>Code</entry>
+	    </row>
+	  </thead>
+	  <tbody valign="top">
+	    <row id="V4L2_MBUS_FMT_YCRCB_1X8">
+	      <entry>V4L2_MBUS_FMT_YCRCB_1X8</entry>
+	      <entry>0x5001</entry>
+	    </row>
+	    <row id="V4L2_MBUS_FMT_YCRCB_1X16">
+	      <entry>V4L2_MBUS_FMT_YCRCB_1X16</entry>
+	      <entry>0x5002</entry>
+	    </row>
+ 	  </tbody>
+ 	</tgroup>
+       </table>
+    </section>
   </section>
 </section>


What do you think about the doc?

diff --git a/drivers/media/video/adv7175.c b/drivers/media/video/adv7175.c
index d2327db..79ab5a3 100644
--- a/drivers/media/video/adv7175.c
+++ b/drivers/media/video/adv7175.c
@@ -51,6 +51,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 struct adv7175 {
 	struct v4l2_subdev sd;
 	v4l2_std_id norm;
+	enum v4l2_mbus_pixelcode pixelcode;
 	int input;
 };

@@ -61,6 +62,11 @@ static inline struct adv7175 *to_adv7175(struct
v4l2_subdev *sd)

 static char *inputs[] = { "pass_through", "play_back", "color_bar" };

+static enum v4l2_mbus_pixelcode adv7175_codes[] = {
+	V4L2_MBUS_FMT_YCRCB_1X8,
+	V4L2_MBUS_FMT_YCRCB_1X16,
+};
+
 /* ----------------------------------------------------------------------- */

 static inline int adv7175_write(struct v4l2_subdev *sd, u8 reg, u8 value)
@@ -296,6 +302,60 @@ static int adv7175_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }

+static int adv7175_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
+				enum v4l2_mbus_pixelcode *code)
+{
+	if (index >= ARRAY_SIZE(adv7175_codes))
+		return -EINVAL;
+
+	*code = adv7175_codes[index];
+	return 0;
+}
+
+static int adv7175_g_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *mf)
+{
+	struct adv7175 *encoder = to_adv7175(sd);
+
+	mf->code        = encoder->pixelcode;
+	mf->colorspace  = V4L2_COLORSPACE_SMPTE170M;
+	mf->width       = 0;
+	mf->height      = 0;


Do I need to set width and height? Cause the bridge driver knows these
values.

+	mf->field       = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int adv7175_s_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *mf)
+{
+	struct adv7175 *encoder = to_adv7175(sd);
+	u8 val = adv7175_read(sd, 0x7);
+	int ret;
+
+	switch (mf->code) {
+	case V4L2_MBUS_FMT_YCRCB_1X8:
+		val &= ~0x40;
+		break;
+
+	case V4L2_MBUS_FMT_YCRCB_1X16:
+		val |= 0x40;
+		break;
+
+	default:
+		v4l2_dbg(1, debug, sd,
+			"illegal v4l2_mbus_framefmt code: %d\n", mf->code);
+		return -EINVAL;
+	}
+
+	ret = adv7175_write(sd, 0x7, val);
+
+	if (ret == 0)
+		encoder->pixelcode = mf->code;
+
+	return ret;
+}
+
 static int adv7175_g_chip_ident(struct v4l2_subdev *sd, struct
v4l2_dbg_chip_ident *chip)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -324,6 +384,9 @@ static const struct v4l2_subdev_core_ops
adv7175_core_ops = {
 static const struct v4l2_subdev_video_ops adv7175_video_ops = {
 	.s_std_output = adv7175_s_std_output,
 	.s_routing = adv7175_s_routing,
+	.s_mbus_fmt = adv7175_s_fmt,
+	.g_mbus_fmt = adv7175_g_fmt,
+	.enum_mbus_fmt  = adv7175_enum_fmt,
 };

 static const struct v4l2_subdev_ops adv7175_ops = {
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5ea7f75..11b916d 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -92,6 +92,10 @@ enum v4l2_mbus_pixelcode {

 	/* JPEG compressed formats - next is 0x4002 */
 	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
+
+	/* YCrCb formats - next is 0x5003 */
+	V4L2_MBUS_FMT_YCRCB_1X8 = 0x5001,
+	V4L2_MBUS_FMT_YCRCB_1X16 = 0x5002,
 };



Thanks for your feedback
--
Christian Gmeiner, MSc
