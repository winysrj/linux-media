Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34030 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350AbZJ3P2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 11:28:41 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Date: Fri, 30 Oct 2009 10:28:37 -0500
Subject: RE: [PATCH/RFC 9/9] mt9t031: make the use of the soc-camera client
 API optional
Message-ID: <A69FA2915331DC488A831521EAE36FE401557987F6@dlee06.ent.ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301442570.4378@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910301442570.4378@axis700.grange>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A69FA2915331DC488A831521EAE36FE401557987F6dlee06enttico_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A69FA2915331DC488A831521EAE36FE401557987F6dlee06enttico_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Guennadi,

Thanks for your time for updating this driver. But I still don't think
it is in a state to be re-used on TI's VPFE platform. Please see
below for my comments.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Friday, October 30, 2009 10:02 AM
>To: Linux Media Mailing List
>Cc: Hans Verkuil; Laurent Pinchart; Sakari Ailus; Karicheri, Muralidharan
>Subject: [PATCH/RFC 9/9] mt9t031: make the use of the soc-camera client AP=
I
>optional
>
>Now that we have moved most of the functions over to the v4l2-subdev API,
>only
>quering and setting bus parameters are still performed using the legacy
>soc-camera client API. Make the use of this API optional for mt9t031.
>
>Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>---
>
>Muralidharan, this one is for you to test. To differentiate between the
>soc-camera case and a generic user I check i2c client's platform data
>(client->dev.platform_data), so, you have to make sure your user doesn't
>use that field for something else.
>
Currently I am using this field for bus parameters such as pclk polarity.
If there is an API (bus parameter) to set this after probing the sensor, th=
at may work too. I will check your latest driver and let you know if=20
I see an issue in migrating to this version.

>One more note: I'm not sure about where v4l2_device_unregister_subdev()
>should be called. In soc-camera the core calls
>v4l2_i2c_new_subdev_board(), which then calls
>v4l2_device_register_subdev(). Logically, it's also the core that then
>calls v4l2_device_unregister_subdev(). Whereas I see many other client
>drivers call v4l2_device_unregister_subdev() internally. So, if your
>bridge driver does not call v4l2_device_unregister_subdev() itself and
>expects the client to call it, there will be a slight problem with that
>too.

In my bridge driver also v4l2_i2c_new_subdev_board() is called to load
up the sub device. When the bridge driver is removed (remove() call), it ca=
lls v4l2_device_unregister() which will unregister the v4l2 device and all
sub devices (in turn calls v4l2_device_unregister_subdev()). But most
of the sub devices also calls v4l2_device_unregister_subdev() in the
remove() function of the module (so also the version of the mt9t031
that I use). So even if that call is kept in the mt9t031 sensor driver (not=
 sure if someone use it as a standalone driver), it would just return since=
 the v4l2_dev ptr in sd ptr would have been set to null as a result of the =
bridge driver remove() call. What do you think?

See also some comments below..

>
> drivers/media/video/mt9t031.c |  146 ++++++++++++++++++++----------------=
-
>----
> 1 files changed, 70 insertions(+), 76 deletions(-)
>
>diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
>index c95c277..49357bd 100644
>--- a/drivers/media/video/mt9t031.c
>+++ b/drivers/media/video/mt9t031.c
>@@ -204,6 +204,59 @@ static unsigned long mt9t031_query_bus_param(struct
>soc_camera_device *icd)
> 	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
> }
>
>+static const struct v4l2_queryctrl mt9t031_controls[] =3D {
>+	{
>+		.id		=3D V4L2_CID_VFLIP,
>+		.type		=3D V4L2_CTRL_TYPE_BOOLEAN,
>+		.name		=3D "Flip Vertically",
>+		.minimum	=3D 0,
>+		.maximum	=3D 1,
>+		.step		=3D 1,
>+		.default_value	=3D 0,
>+	}, {
>+		.id		=3D V4L2_CID_HFLIP,
>+		.type		=3D V4L2_CTRL_TYPE_BOOLEAN,
>+		.name		=3D "Flip Horizontally",
>+		.minimum	=3D 0,
>+		.maximum	=3D 1,
>+		.step		=3D 1,
>+		.default_value	=3D 0,
>+	}, {
>+		.id		=3D V4L2_CID_GAIN,
>+		.type		=3D V4L2_CTRL_TYPE_INTEGER,
>+		.name		=3D "Gain",
>+		.minimum	=3D 0,
>+		.maximum	=3D 127,
>+		.step		=3D 1,
>+		.default_value	=3D 64,
>+		.flags		=3D V4L2_CTRL_FLAG_SLIDER,
>+	}, {
>+		.id		=3D V4L2_CID_EXPOSURE,
>+		.type		=3D V4L2_CTRL_TYPE_INTEGER,
>+		.name		=3D "Exposure",
>+		.minimum	=3D 1,
>+		.maximum	=3D 255,
>+		.step		=3D 1,
>+		.default_value	=3D 255,
>+		.flags		=3D V4L2_CTRL_FLAG_SLIDER,
>+	}, {
>+		.id		=3D V4L2_CID_EXPOSURE_AUTO,
>+		.type		=3D V4L2_CTRL_TYPE_BOOLEAN,
>+		.name		=3D "Automatic Exposure",
>+		.minimum	=3D 0,
>+		.maximum	=3D 1,
>+		.step		=3D 1,
>+		.default_value	=3D 1,
>+	}
>+};
>+
>+static struct soc_camera_ops mt9t031_ops =3D {
>+	.set_bus_param		=3D mt9t031_set_bus_param,
>+	.query_bus_param	=3D mt9t031_query_bus_param,
>+	.controls		=3D mt9t031_controls,
>+	.num_controls		=3D ARRAY_SIZE(mt9t031_controls),
>+};
>+

[MK] Why don't you implement queryctrl ops in core? query_bus_param
& set_bus_param() can be implemented as a sub device operation as well
right? I think we need to get the bus parameter RFC implemented and
this driver could be targeted for it's first use so that we could
work together to get it accepted. I didn't get a chance to study your bus i=
mage format RFC, but plan to review it soon and to see if it can be
used in my platform as well. For use of this driver in our platform,
all reference to soc_ must be removed. I am ok if the structure is
re-used, but if this driver calls any soc_camera function, it canot
be used in my platform.

BTW, I am attaching a version of the driver that we use in our kernel tree =
for your reference which will give you an idea of my requirement.

> /* target must be _even_ */
> static u16 mt9t031_skip(s32 *source, s32 target, s32 max)
> {
>@@ -223,10 +276,9 @@ static u16 mt9t031_skip(s32 *source, s32 target, s32
>max)
> }
>
> /* rect is the sensor rectangle, the caller guarantees parameter validity
>*/
>-static int mt9t031_set_params(struct soc_camera_device *icd,
>+static int mt9t031_set_params(struct i2c_client *client,
> 			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
> {
>-	struct i2c_client *client =3D
>to_i2c_client(to_soc_camera_control(icd));
> 	struct mt9t031 *mt9t031 =3D to_mt9t031(client);
> 	int ret;
> 	u16 xbin, ybin;
>@@ -307,7 +359,7 @@ static int mt9t031_set_params(struct soc_camera_device
>*icd,
> 		if (ret >=3D 0) {
> 			const u32 shutter_max =3D MT9T031_MAX_HEIGHT + vblank;
> 			const struct v4l2_queryctrl *qctrl =3D
>-				soc_camera_find_qctrl(icd->ops,
>+				soc_camera_find_qctrl(&mt9t031_ops,
> 						      V4L2_CID_EXPOSURE);
> 			mt9t031->exposure =3D (shutter_max / 2 + (total_h - 1) *
> 				 (qctrl->maximum - qctrl->minimum)) /
>@@ -333,7 +385,6 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd,
>struct v4l2_crop *a)
> 	struct v4l2_rect rect =3D a->c;
> 	struct i2c_client *client =3D sd->priv;
> 	struct mt9t031 *mt9t031 =3D to_mt9t031(client);
>-	struct soc_camera_device *icd =3D client->dev.platform_data;
>
> 	rect.width =3D ALIGN(rect.width, 2);
> 	rect.height =3D ALIGN(rect.height, 2);
>@@ -344,7 +395,7 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd,
>struct v4l2_crop *a)
> 	soc_camera_limit_side(&rect.top, &rect.height,
> 		     MT9T031_ROW_SKIP, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT);
>
>-	return mt9t031_set_params(icd, &rect, mt9t031->xskip, mt9t031-
>>yskip);
>+	return mt9t031_set_params(client, &rect, mt9t031->xskip, mt9t031-
>>yskip);
> }
>
> static int mt9t031_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>@@ -391,7 +442,6 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
> {
> 	struct i2c_client *client =3D sd->priv;
> 	struct mt9t031 *mt9t031 =3D to_mt9t031(client);
>-	struct soc_camera_device *icd =3D client->dev.platform_data;
> 	u16 xskip, yskip;
> 	struct v4l2_rect rect =3D mt9t031->rect;
>
>@@ -403,7 +453,7 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
> 	yskip =3D mt9t031_skip(&rect.height, imgf->height, MT9T031_MAX_HEIGHT);
>
> 	/* mt9t031_set_params() doesn't change width and height */
>-	return mt9t031_set_params(icd, &rect, xskip, yskip);
>+	return mt9t031_set_params(client, &rect, xskip, yskip);
> }
>
> /*
>@@ -476,59 +526,6 @@ static int mt9t031_s_register(struct v4l2_subdev *sd,
> }
> #endif
>
>-static const struct v4l2_queryctrl mt9t031_controls[] =3D {
>-	{
>-		.id		=3D V4L2_CID_VFLIP,
>-		.type		=3D V4L2_CTRL_TYPE_BOOLEAN,
>-		.name		=3D "Flip Vertically",
>-		.minimum	=3D 0,
>-		.maximum	=3D 1,
>-		.step		=3D 1,
>-		.default_value	=3D 0,
>-	}, {
>-		.id		=3D V4L2_CID_HFLIP,
>-		.type		=3D V4L2_CTRL_TYPE_BOOLEAN,
>-		.name		=3D "Flip Horizontally",
>-		.minimum	=3D 0,
>-		.maximum	=3D 1,
>-		.step		=3D 1,
>-		.default_value	=3D 0,
>-	}, {
>-		.id		=3D V4L2_CID_GAIN,
>-		.type		=3D V4L2_CTRL_TYPE_INTEGER,
>-		.name		=3D "Gain",
>-		.minimum	=3D 0,
>-		.maximum	=3D 127,
>-		.step		=3D 1,
>-		.default_value	=3D 64,
>-		.flags		=3D V4L2_CTRL_FLAG_SLIDER,
>-	}, {
>-		.id		=3D V4L2_CID_EXPOSURE,
>-		.type		=3D V4L2_CTRL_TYPE_INTEGER,
>-		.name		=3D "Exposure",
>-		.minimum	=3D 1,
>-		.maximum	=3D 255,
>-		.step		=3D 1,
>-		.default_value	=3D 255,
>-		.flags		=3D V4L2_CTRL_FLAG_SLIDER,
>-	}, {
>-		.id		=3D V4L2_CID_EXPOSURE_AUTO,
>-		.type		=3D V4L2_CTRL_TYPE_BOOLEAN,
>-		.name		=3D "Automatic Exposure",
>-		.minimum	=3D 0,
>-		.maximum	=3D 1,
>-		.step		=3D 1,
>-		.default_value	=3D 1,
>-	}
>-};
>-
>-static struct soc_camera_ops mt9t031_ops =3D {
>-	.set_bus_param		=3D mt9t031_set_bus_param,
>-	.query_bus_param	=3D mt9t031_query_bus_param,
>-	.controls		=3D mt9t031_controls,
>-	.num_controls		=3D ARRAY_SIZE(mt9t031_controls),
>-};
>-
> static int mt9t031_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control
>*ctrl)
> {
> 	struct i2c_client *client =3D sd->priv;
>@@ -565,7 +562,6 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd,
>struct v4l2_control *ctrl)
> {
> 	struct i2c_client *client =3D sd->priv;
> 	struct mt9t031 *mt9t031 =3D to_mt9t031(client);
>-	struct soc_camera_device *icd =3D client->dev.platform_data;
> 	const struct v4l2_queryctrl *qctrl;
> 	int data;
>
>@@ -657,7 +653,8 @@ static int mt9t031_s_ctrl(struct v4l2_subdev *sd,
>struct v4l2_control *ctrl)
>
> 			if (set_shutter(client, total_h) < 0)
> 				return -EIO;
>-			qctrl =3D soc_camera_find_qctrl(icd->ops,
>V4L2_CID_EXPOSURE);
>+			qctrl =3D soc_camera_find_qctrl(&mt9t031_ops,
>+						      V4L2_CID_EXPOSURE);

[MK] Why do we still need this call? In my version of the sensor driver,
I just implement the queryctrl() operation in core_ops. This cannot work
since soc_camera_find_qctrl() is implemented only in SoC camera.

> 			mt9t031->exposure =3D (shutter_max / 2 + (total_h - 1) *
> 				 (qctrl->maximum - qctrl->minimum)) /
> 				shutter_max + qctrl->minimum;
>@@ -751,18 +748,16 @@ static int mt9t031_probe(struct i2c_client *client,
> 	struct mt9t031 *mt9t031;
> 	struct soc_camera_device *icd =3D client->dev.platform_data;
> 	struct i2c_adapter *adapter =3D to_i2c_adapter(client->dev.parent);
>-	struct soc_camera_link *icl;
> 	int ret;
>
>-	if (!icd) {
>-		dev_err(&client->dev, "MT9T031: missing soc-camera data!\n");
>-		return -EINVAL;
>-	}
>+	if (icd) {
>+		struct soc_camera_link *icl =3D to_soc_camera_link(icd);
>+		if (!icl) {
>+			dev_err(&client->dev, "MT9T031 driver needs platform
>data\n");
>+			return -EINVAL;
>+		}
>
>-	icl =3D to_soc_camera_link(icd);
>-	if (!icl) {
>-		dev_err(&client->dev, "MT9T031 driver needs platform data\n");
>-		return -EINVAL;
>+		icd->ops =3D &mt9t031_ops;
> 	}
>
> 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
>@@ -777,9 +772,6 @@ static int mt9t031_probe(struct i2c_client *client,
>
> 	v4l2_i2c_subdev_init(&mt9t031->subdev, client, &mt9t031_subdev_ops);
>
>-	/* Second stage probe - when a capture adapter is there */
>-	icd->ops		=3D &mt9t031_ops;
>-
> 	mt9t031->rect.left	=3D MT9T031_COLUMN_SKIP;
> 	mt9t031->rect.top	=3D MT9T031_ROW_SKIP;
> 	mt9t031->rect.width	=3D MT9T031_MAX_WIDTH;
>@@ -801,7 +793,8 @@ static int mt9t031_probe(struct i2c_client *client,
> 	mt9t031_disable(client);
>
> 	if (ret) {
>-		icd->ops =3D NULL;
>+		if (icd)
>+			icd->ops =3D NULL;
> 		i2c_set_clientdata(client, NULL);
> 		kfree(mt9t031);
> 	}
>@@ -814,7 +807,8 @@ static int mt9t031_remove(struct i2c_client *client)
> 	struct mt9t031 *mt9t031 =3D to_mt9t031(client);
> 	struct soc_camera_device *icd =3D client->dev.platform_data;
>
>-	icd->ops =3D NULL;
>+	if (icd)
>+		icd->ops =3D NULL;
> 	i2c_set_clientdata(client, NULL);
> 	client->driver =3D NULL;
> 	kfree(mt9t031);
>--
>1.6.2.4
>


--_002_A69FA2915331DC488A831521EAE36FE401557987F6dlee06enttico_
Content-Type: text/plain; name="mt9t031.c"
Content-Description: mt9t031.c
Content-Disposition: attachment; filename="mt9t031.c"; size=21193;
	creation-date="Fri, 30 Oct 2009 10:27:06 GMT";
	modification-date="Fri, 30 Oct 2009 10:27:06 GMT"
Content-Transfer-Encoding: base64

LyoKICogRHJpdmVyIGZvciBNVDlUMDMxIENNT1MgSW1hZ2UgU2Vuc29yIGZyb20gTWljcm9uCiAq
CiAqIENvcHlyaWdodCAoQykgMjAwOCwgR3Vlbm5hZGkgTGlha2hvdmV0c2tpLCBERU5YIFNvZnR3
YXJlIEVuZ2luZWVyaW5nIDxsZ0BkZW54LmRlPgogKgogKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBz
b2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQogKiBpdCB1bmRl
ciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIHZlcnNpb24gMiBh
cwogKiBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbi4KICovCgojaW5j
bHVkZSA8bGludXgvdmlkZW9kZXYyLmg+CiNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CiNpbmNsdWRl
IDxsaW51eC9pMmMuaD4KI2luY2x1ZGUgPGxpbnV4L2xvZzIuaD4KCiNpbmNsdWRlIDxtZWRpYS92
NGwyLWRldmljZS5oPgojaW5jbHVkZSA8bWVkaWEvdjRsMi1jb21tb24uaD4KI2luY2x1ZGUgPG1l
ZGlhL3Y0bDItY2hpcC1pZGVudC5oPgoKLyogbXQ5dDAzMSBpMmMgYWRkcmVzcyAweDVkCiAqIFRo
ZSBwbGF0Zm9ybSBoYXMgdG8gZGVmaW5lIGkyY19ib2FyZF9pbmZvCiAqIGFuZCBjYWxsIGkyY19y
ZWdpc3Rlcl9ib2FyZF9pbmZvKCkgKi8KCi8qIG10OXQwMzEgc2VsZWN0ZWQgcmVnaXN0ZXIgYWRk
cmVzc2VzICovCiNkZWZpbmUgTVQ5VDAzMV9DSElQX1ZFUlNJT04JCTB4MDAKI2RlZmluZSBNVDlU
MDMxX1JPV19TVEFSVAkJMHgwMQojZGVmaW5lIE1UOVQwMzFfQ09MVU1OX1NUQVJUCQkweDAyCiNk
ZWZpbmUgTVQ5VDAzMV9XSU5ET1dfSEVJR0hUCQkweDAzCiNkZWZpbmUgTVQ5VDAzMV9XSU5ET1df
V0lEVEgJCTB4MDQKI2RlZmluZSBNVDlUMDMxX0hPUklaT05UQUxfQkxBTktJTkcJMHgwNQojZGVm
aW5lIE1UOVQwMzFfVkVSVElDQUxfQkxBTktJTkcJMHgwNgojZGVmaW5lIE1UOVQwMzFfT1VUUFVU
X0NPTlRST0wJCTB4MDcKI2RlZmluZSBNVDlUMDMxX1NIVVRURVJfV0lEVEhfVVBQRVIJMHgwOAoj
ZGVmaW5lIE1UOVQwMzFfU0hVVFRFUl9XSURUSAkJMHgwOQojZGVmaW5lIE1UOVQwMzFfUElYRUxf
Q0xPQ0tfQ09OVFJPTAkweDBhCiNkZWZpbmUgTVQ5VDAzMV9GUkFNRV9SRVNUQVJUCQkweDBiCiNk
ZWZpbmUgTVQ5VDAzMV9TSFVUVEVSX0RFTEFZCQkweDBjCiNkZWZpbmUgTVQ5VDAzMV9SRVNFVAkJ
CTB4MGQKI2RlZmluZSBNVDlUMDMxX1JFQURfTU9ERV8xCQkweDFlCiNkZWZpbmUgTVQ5VDAzMV9S
RUFEX01PREVfMgkJMHgyMAojZGVmaW5lIE1UOVQwMzFfUkVBRF9NT0RFXzMJCTB4MjEKI2RlZmlu
ZSBNVDlUMDMxX1JPV19BRERSRVNTX01PREUJMHgyMgojZGVmaW5lIE1UOVQwMzFfQ09MVU1OX0FE
RFJFU1NfTU9ERQkweDIzCiNkZWZpbmUgTVQ5VDAzMV9HTE9CQUxfR0FJTgkJMHgzNQojZGVmaW5l
IE1UOVQwMzFfQ0hJUF9FTkFCTEUJCTB4RjgKCiNkZWZpbmUgTVQ5VDAzMV9NQVhfSEVJR0hUCQkx
NTM2CiNkZWZpbmUgTVQ5VDAzMV9NQVhfV0lEVEgJCTIwNDgKI2RlZmluZSBNVDlUMDMxX01JTl9I
RUlHSFQJCTIKI2RlZmluZSBNVDlUMDMxX01JTl9XSURUSAkJMgojZGVmaW5lIE1UOVQwMzFfSE9S
SVpPTlRBTF9CTEFOSwkxNDIKI2RlZmluZSBNVDlUMDMxX1ZFUlRJQ0FMX0JMQU5LCQkyNQojZGVm
aW5lIE1UOVQwMzFfQ09MVU1OX1NLSVAJCTMyCiNkZWZpbmUgTVQ5VDAzMV9ST1dfU0tJUAkJMjAK
I2RlZmluZSBNVDlUMDMxX0RFRkFVTFRfV0lEVEgJCTY0MAojZGVmaW5lIE1UOVQwMzFfREVGQVVM
VF9IRUlHSFQJCTQ4MAoKI2RlZmluZSBNVDlUMDMxX0JVU19QQVJBTQkoU09DQU1fUENMS19TQU1Q
TEVfUklTSU5HIHwJXAoJU09DQU1fUENMS19TQU1QTEVfRkFMTElORyB8IFNPQ0FNX0hTWU5DX0FD
VElWRV9ISUdIIHwJXAoJU09DQU1fVlNZTkNfQUNUSVZFX0hJR0ggfCBTT0NBTV9EQVRBX0FDVElW
RV9ISUdIIHwJXAoJU09DQU1fTUFTVEVSIHwgU09DQU1fREFUQVdJRFRIXzEwKQoKCi8qIERlYnVn
IGZ1bmN0aW9ucyAqLwpzdGF0aWMgaW50IGRlYnVnOwptb2R1bGVfcGFyYW0oZGVidWcsIGJvb2ws
IDA2NDQpOwpNT0RVTEVfUEFSTV9ERVNDKGRlYnVnLCAiRGVidWcgbGV2ZWwgKDAtMSkiKTsKCnN0
YXRpYyBjb25zdCBzdHJ1Y3QgdjRsMl9mbXRkZXNjIG10OXQwMzFfZm9ybWF0c1tdID0gewoJewoJ
CS5pbmRleCA9IDAsCgkJLnR5cGUgPSBWNEwyX0JVRl9UWVBFX1ZJREVPX0NBUFRVUkUsCgkJLmRl
c2NyaXB0aW9uID0gIkJheWVyIChzUkdCKSAxMCBiaXQiLAoJCS5waXhlbGZvcm1hdCA9IFY0TDJf
UElYX0ZNVF9TR1JCRzEwLAoJfSwKfTsKc3RhdGljIGNvbnN0IHVuc2lnbmVkIGludCBtdDl0MDMx
X251bV9mb3JtYXRzID0gQVJSQVlfU0laRShtdDl0MDMxX2Zvcm1hdHMpOwoKc3RhdGljIGNvbnN0
IHN0cnVjdCB2NGwyX3F1ZXJ5Y3RybCBtdDl0MDMxX2NvbnRyb2xzW10gPSB7Cgl7CgkJLmlkCQk9
IFY0TDJfQ0lEX1ZGTElQLAoJCS50eXBlCQk9IFY0TDJfQ1RSTF9UWVBFX0JPT0xFQU4sCgkJLm5h
bWUJCT0gIkZsaXAgVmVydGljYWxseSIsCgkJLm1pbmltdW0JPSAwLAoJCS5tYXhpbXVtCT0gMSwK
CQkuc3RlcAkJPSAxLAoJCS5kZWZhdWx0X3ZhbHVlCT0gMCwKCX0sIHsKCQkuaWQJCT0gVjRMMl9D
SURfSEZMSVAsCgkJLnR5cGUJCT0gVjRMMl9DVFJMX1RZUEVfQk9PTEVBTiwKCQkubmFtZQkJPSAi
RmxpcCBIb3Jpem9udGFsbHkiLAoJCS5taW5pbXVtCT0gMCwKCQkubWF4aW11bQk9IDEsCgkJLnN0
ZXAJCT0gMSwKCQkuZGVmYXVsdF92YWx1ZQk9IDAsCgl9LCB7CgkJLmlkCQk9IFY0TDJfQ0lEX0dB
SU4sCgkJLnR5cGUJCT0gVjRMMl9DVFJMX1RZUEVfSU5URUdFUiwKCQkubmFtZQkJPSAiR2FpbiIs
CgkJLm1pbmltdW0JPSAwLAoJCS5tYXhpbXVtCT0gMTI3LAoJCS5zdGVwCQk9IDEsCgkJLmRlZmF1
bHRfdmFsdWUJPSA2NCwKCQkuZmxhZ3MJCT0gVjRMMl9DVFJMX0ZMQUdfU0xJREVSLAoJfSwgewoJ
CS5pZAkJPSBWNEwyX0NJRF9FWFBPU1VSRSwKCQkudHlwZQkJPSBWNEwyX0NUUkxfVFlQRV9JTlRF
R0VSLAoJCS5uYW1lCQk9ICJFeHBvc3VyZSIsCgkJLm1pbmltdW0JPSAxLAoJCS5tYXhpbXVtCT0g
MjU1LAoJCS5zdGVwCQk9IDEsCgkJLmRlZmF1bHRfdmFsdWUJPSAyNTUsCgkJLmZsYWdzCQk9IFY0
TDJfQ1RSTF9GTEFHX1NMSURFUiwKCX0sIHsKCQkuaWQJCT0gVjRMMl9DSURfRVhQT1NVUkVfQVVU
TywKCQkudHlwZQkJPSBWNEwyX0NUUkxfVFlQRV9CT09MRUFOLAoJCS5uYW1lCQk9ICJBdXRvbWF0
aWMgRXhwb3N1cmUiLAoJCS5taW5pbXVtCT0gMCwKCQkubWF4aW11bQk9IDEsCgkJLnN0ZXAJCT0g
MSwKCQkuZGVmYXVsdF92YWx1ZQk9IDEsCgl9Cn07CnN0YXRpYyBjb25zdCB1bnNpZ25lZCBpbnQg
bXQ5dDAzMV9udW1fY29udHJvbHMgPSBBUlJBWV9TSVpFKG10OXQwMzFfY29udHJvbHMpOwoKc3Ry
dWN0IG10OXQwMzEgewoJc3RydWN0IHY0bDJfc3ViZGV2IHNkOwoJaW50IG1vZGVsOwkvKiBWNEwy
X0lERU5UX01UOVQwMzEqIGNvZGVzIGZyb20gdjRsMi1jaGlwLWlkZW50LmggKi8KCXVuc2lnbmVk
IGNoYXIgYXV0b2V4cG9zdXJlOwoJdTE2IHhza2lwOwoJdTE2IHlza2lwOwoJdTMyIHdpZHRoOwoJ
dTMyIGhlaWdodDsKCXVuc2lnbmVkIHNob3J0IHhfbWluOyAgICAgICAgICAgLyogQ2FtZXJhIGNh
cGFiaWxpdGllcyAqLwoJdW5zaWduZWQgc2hvcnQgeV9taW47Cgl1bnNpZ25lZCBzaG9ydCB4X2N1
cnJlbnQ7ICAgICAgIC8qIEN1cnJlbnQgd2luZG93IGxvY2F0aW9uICovCgl1bnNpZ25lZCBzaG9y
dCB5X2N1cnJlbnQ7Cgl1bnNpZ25lZCBzaG9ydCB3aWR0aF9taW47Cgl1bnNpZ25lZCBzaG9ydCB3
aWR0aF9tYXg7Cgl1bnNpZ25lZCBzaG9ydCBoZWlnaHRfbWluOwoJdW5zaWduZWQgc2hvcnQgaGVp
Z2h0X21heDsKCXVuc2lnbmVkIHNob3J0IHlfc2tpcF90b3A7ICAgICAgLyogTGluZXMgdG8gc2tp
cCBhdCB0aGUgdG9wICovCgl1bnNpZ25lZCBzaG9ydCBnYWluOwoJdW5zaWduZWQgc2hvcnQgZXhw
b3N1cmU7Cn07CgpzdGF0aWMgaW5saW5lIHN0cnVjdCBtdDl0MDMxICp0b19tdDl0MDMxKHN0cnVj
dCB2NGwyX3N1YmRldiAqc2QpCnsKCXJldHVybiBjb250YWluZXJfb2Yoc2QsIHN0cnVjdCBtdDl0
MDMxLCBzZCk7Cn0KCnN0YXRpYyBpbnQgcmVnX3JlYWQoc3RydWN0IGkyY19jbGllbnQgKmNsaWVu
dCwgY29uc3QgdTggcmVnKQp7CglzMzIgZGF0YTsKCglkYXRhID0gaTJjX3NtYnVzX3JlYWRfd29y
ZF9kYXRhKGNsaWVudCwgcmVnKTsKCXJldHVybiBkYXRhIDwgMCA/IGRhdGEgOiBzd2FiMTYoZGF0
YSk7Cn0KCnN0YXRpYyBpbnQgcmVnX3dyaXRlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsIGNv
bnN0IHU4IHJlZywKCQkgICAgIGNvbnN0IHUxNiBkYXRhKQp7CglyZXR1cm4gaTJjX3NtYnVzX3dy
aXRlX3dvcmRfZGF0YShjbGllbnQsIHJlZywgc3dhYjE2KGRhdGEpKTsKfQoKc3RhdGljIGludCBy
ZWdfc2V0KHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsIGNvbnN0IHU4IHJlZywKCQkgICBjb25z
dCB1MTYgZGF0YSkKewoJaW50IHJldDsKCglyZXQgPSByZWdfcmVhZChjbGllbnQsIHJlZyk7Cglp
ZiAocmV0IDwgMCkKCQlyZXR1cm4gcmV0OwoJcmV0dXJuIHJlZ193cml0ZShjbGllbnQsIHJlZywg
cmV0IHwgZGF0YSk7Cn0KCnN0YXRpYyBpbnQgcmVnX2NsZWFyKHN0cnVjdCBpMmNfY2xpZW50ICpj
bGllbnQsIGNvbnN0IHU4IHJlZywKCQkgICAgIGNvbnN0IHUxNiBkYXRhKQp7CglpbnQgcmV0OwoK
CXJldCA9IHJlZ19yZWFkKGNsaWVudCwgcmVnKTsKCWlmIChyZXQgPCAwKQoJCXJldHVybiByZXQ7
CglyZXR1cm4gcmVnX3dyaXRlKGNsaWVudCwgcmVnLCByZXQgJiB+ZGF0YSk7Cn0KCnN0YXRpYyBp
bnQgc2V0X3NodXR0ZXIoc3RydWN0IHY0bDJfc3ViZGV2ICpzZCwgY29uc3QgdTMyIGRhdGEpCnsK
CXN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQgPSB2NGwyX2dldF9zdWJkZXZkYXRhKHNkKTsKCWlu
dCByZXQ7CgoJcmV0ID0gcmVnX3dyaXRlKGNsaWVudCwgTVQ5VDAzMV9TSFVUVEVSX1dJRFRIX1VQ
UEVSLCBkYXRhID4+IDE2KTsKCglpZiAocmV0ID49IDApCgkJcmV0ID0gcmVnX3dyaXRlKGNsaWVu
dCwgTVQ5VDAzMV9TSFVUVEVSX1dJRFRILCBkYXRhICYgMHhmZmZmKTsKCglyZXR1cm4gcmV0Owp9
CgpzdGF0aWMgaW50IGdldF9zaHV0dGVyKHN0cnVjdCB2NGwyX3N1YmRldiAqc2QsIHUzMiAqZGF0
YSkKewoJaW50IHJldDsKCXN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQgPSB2NGwyX2dldF9zdWJk
ZXZkYXRhKHNkKTsKCglyZXQgPSByZWdfcmVhZChjbGllbnQsIE1UOVQwMzFfU0hVVFRFUl9XSURU
SF9VUFBFUik7CgkqZGF0YSA9IHJldCA8PCAxNjsKCglpZiAocmV0ID49IDApCgkJcmV0ID0gcmVn
X3JlYWQoY2xpZW50LCBNVDlUMDMxX1NIVVRURVJfV0lEVEgpOwoJKmRhdGEgfD0gcmV0ICYgMHhm
ZmZmOwoKCXJldHVybiByZXQgPCAwID8gcmV0IDogMDsKfQoKc3RhdGljIGludCBtdDl0MDMxX2lu
aXQoc3RydWN0IHY0bDJfc3ViZGV2ICpzZCwgdTMyIHZhbCkKewoJaW50IHJldDsKCXN0cnVjdCBp
MmNfY2xpZW50ICpjbGllbnQgPSB2NGwyX2dldF9zdWJkZXZkYXRhKHNkKTsKCgkvKiBEaXNhYmxl
IGNoaXAgb3V0cHV0LCBzeW5jaHJvbm91cyBvcHRpb24gdXBkYXRlICovCglyZXQgPSByZWdfd3Jp
dGUoY2xpZW50LCBNVDlUMDMxX1JFU0VULCAxKTsKCWlmIChyZXQgPj0gMCkKCQlyZXQgPSByZWdf
d3JpdGUoY2xpZW50LCBNVDlUMDMxX1JFU0VULCAwKTsKCWlmIChyZXQgPj0gMCkKCQlyZXQgPSBy
ZWdfY2xlYXIoY2xpZW50LCBNVDlUMDMxX09VVFBVVF9DT05UUk9MLCAyKTsKCglyZXR1cm4gcmV0
ID49IDAgPyAwIDogLUVJTzsKfQoKc3RhdGljIGludCBtdDl0MDMxX3Nfc3RyZWFtKHN0cnVjdCB2
NGwyX3N1YmRldiAqc2QsIGludCBlbmFibGUpCnsKCXN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQg
PSB2NGwyX2dldF9zdWJkZXZkYXRhKHNkKTsKCgkvKiBTd2l0Y2ggdG8gbWFzdGVyICJub3JtYWwi
IG1vZGUgKi8KCWlmIChlbmFibGUpIHsKCQlpZiAocmVnX3NldChjbGllbnQsIE1UOVQwMzFfT1VU
UFVUX0NPTlRST0wsIDIpIDwgMCkKCQkJcmV0dXJuIC1FSU87Cgl9IGVsc2UgewoJLyogU3dpdGNo
IHRvIG1hc3RlciAiIiBtb2RlICovCgkJaWYgKHJlZ19jbGVhcihjbGllbnQsIE1UOVQwMzFfT1VU
UFVUX0NPTlRST0wsIDIpIDwgMCkKCQkJcmV0dXJuIC1FSU87Cgl9CglyZXR1cm4gMDsKfQoKLyog
Um91bmQgdXAgbWluaW1hIGFuZCByb3VuZCBkb3duIG1heGltYSAqLwpzdGF0aWMgdm9pZCByZWNh
bGN1bGF0ZV9saW1pdHMoc3RydWN0IG10OXQwMzEgKm10OXQwMzEsCgkJCSAgICAgICB1MTYgeHNr
aXAsIHUxNiB5c2tpcCkKewoJbXQ5dDAzMS0+eF9taW4gPSAoTVQ5VDAzMV9DT0xVTU5fU0tJUCAr
IHhza2lwIC0gMSkgLyB4c2tpcDsKCW10OXQwMzEtPnlfbWluID0gKE1UOVQwMzFfUk9XX1NLSVAg
KyB5c2tpcCAtIDEpIC8geXNraXA7CgltdDl0MDMxLT53aWR0aF9taW4gPSAoTVQ5VDAzMV9NSU5f
V0lEVEggKyB4c2tpcCAtIDEpIC8geHNraXA7CgltdDl0MDMxLT5oZWlnaHRfbWluID0gKE1UOVQw
MzFfTUlOX0hFSUdIVCArIHlza2lwIC0gMSkgLyB5c2tpcDsKCW10OXQwMzEtPndpZHRoX21heCA9
IE1UOVQwMzFfTUFYX1dJRFRIIC8geHNraXA7CgltdDl0MDMxLT5oZWlnaHRfbWF4ID0gTVQ5VDAz
MV9NQVhfSEVJR0hUIC8geXNraXA7Cn0KCmNvbnN0IHN0cnVjdCB2NGwyX3F1ZXJ5Y3RybCAqbXQ5
dDAzMV9maW5kX3FjdHJsKHUzMiBpZCkKewoJaW50IGk7CgoJZm9yIChpID0gMDsgaSA8IG10OXQw
MzFfbnVtX2NvbnRyb2xzOyBpKyspIHsKCQlpZiAobXQ5dDAzMV9jb250cm9sc1tpXS5pZCA9PSBp
ZCkKCQkJcmV0dXJuICZtdDl0MDMxX2NvbnRyb2xzW2ldOwoJfQoJcmV0dXJuIE5VTEw7Cn0KCnN0
YXRpYyBpbnQgbXQ5dDAzMV9zZXRfcGFyYW1zKHN0cnVjdCB2NGwyX3N1YmRldiAqc2QsCgkJCSAg
ICAgIHN0cnVjdCB2NGwyX3JlY3QgKnJlY3QsIHUxNiB4c2tpcCwgdTE2IHlza2lwKQp7CglzdHJ1
Y3QgbXQ5dDAzMSAqbXQ5dDAzMSA9IHRvX210OXQwMzEoc2QpOwoJc3RydWN0IGkyY19jbGllbnQg
KmNsaWVudCA9IHY0bDJfZ2V0X3N1YmRldmRhdGEoc2QpOwoKCWludCByZXQ7Cgl1MTYgeGJpbiwg
eWJpbiwgd2lkdGgsIGhlaWdodCwgbGVmdCwgdG9wOwoJY29uc3QgdTE2IGhibGFuayA9IE1UOVQw
MzFfSE9SSVpPTlRBTF9CTEFOSywKCQl2YmxhbmsgPSBNVDlUMDMxX1ZFUlRJQ0FMX0JMQU5LOwoK
CS8qIE1ha2Ugc3VyZSB3ZSBkb24ndCBleGNlZWQgc2Vuc29yIGxpbWl0cyAqLwoJaWYgKHJlY3Qt
PmxlZnQgKyByZWN0LT53aWR0aCA+IG10OXQwMzEtPndpZHRoX21heCkKCQlyZWN0LT5sZWZ0ID0K
CQkobXQ5dDAzMS0+d2lkdGhfbWF4IC0gcmVjdC0+d2lkdGgpIC8gMiArIG10OXQwMzEtPnhfbWlu
OwoKCWlmIChyZWN0LT50b3AgKyByZWN0LT5oZWlnaHQgPiBtdDl0MDMxLT5oZWlnaHRfbWF4KQoJ
CXJlY3QtPnRvcCA9CgkJKG10OXQwMzEtPmhlaWdodF9tYXggLSByZWN0LT5oZWlnaHQpIC8gMiAr
IG10OXQwMzEtPnlfbWluOwoKCXdpZHRoID0gcmVjdC0+d2lkdGggKiB4c2tpcDsKCWhlaWdodCA9
IHJlY3QtPmhlaWdodCAqIHlza2lwOwoJbGVmdCA9IHJlY3QtPmxlZnQgKiB4c2tpcDsKCXRvcCA9
IHJlY3QtPnRvcCAqIHlza2lwOwoKCXhiaW4gPSBtaW4oeHNraXAsICh1MTYpMyk7Cgl5YmluID0g
bWluKHlza2lwLCAodTE2KTMpOwoKCXY0bDJfZGJnKDEsIGRlYnVnLCBzZCwgInhza2lwICV1LCB3
aWR0aCAldS8ldSwgeXNraXAgJXUsIgoJCSJoZWlnaHQgJXUvJXVcbiIsIHhza2lwLCB3aWR0aCwg
cmVjdC0+d2lkdGgsIHlza2lwLAoJCWhlaWdodCwgcmVjdC0+aGVpZ2h0KTsKCgkvKiBDb3VsZCBq
dXN0IGRvIHJvdW5kdXAocmVjdC0+bGVmdCwgW3h5XWJpbiAqIDIpOyBidXQgdGhpcyBpcyBjaGVh
cGVyICovCglzd2l0Y2ggKHhiaW4pIHsKCWNhc2UgMjoKCQlsZWZ0ID0gKGxlZnQgKyAzKSAmIH4z
OwoJCWJyZWFrOwoJY2FzZSAzOgoJCWxlZnQgPSByb3VuZHVwKGxlZnQsIDYpOwoJfQoKCXN3aXRj
aCAoeWJpbikgewoJY2FzZSAyOgoJCXRvcCA9ICh0b3AgKyAzKSAmIH4zOwoJCWJyZWFrOwoJY2Fz
ZSAzOgoJCXRvcCA9IHJvdW5kdXAodG9wLCA2KTsKCX0KCgkvKiBEaXNhYmxlIHJlZ2lzdGVyIHVw
ZGF0ZSwgcmVjb25maWd1cmUgYXRvbWljYWxseSAqLwoJcmV0ID0gcmVnX3NldChjbGllbnQsIE1U
OVQwMzFfT1VUUFVUX0NPTlRST0wsIDEpOwoJaWYgKHJldCA8IDApCgkJcmV0dXJuIHJldDsKCgkv
KiBCbGFua2luZyBhbmQgc3RhcnQgdmFsdWVzIC0gZGVmYXVsdC4uLiAqLwoJcmV0ID0gcmVnX3dy
aXRlKGNsaWVudCwgTVQ5VDAzMV9IT1JJWk9OVEFMX0JMQU5LSU5HLCBoYmxhbmspOwoJaWYgKHJl
dCA+PSAwKQoJCXJldCA9IHJlZ193cml0ZShjbGllbnQsIE1UOVQwMzFfVkVSVElDQUxfQkxBTktJ
TkcsIHZibGFuayk7CgoJaWYgKHlza2lwICE9IG10OXQwMzEtPnlza2lwIHx8IHhza2lwICE9IG10
OXQwMzEtPnhza2lwKSB7CgkJLyogQmlubmluZywgc2tpcHBpbmcgKi8KCQlpZiAocmV0ID49IDAp
CgkJCXJldCA9IHJlZ193cml0ZShjbGllbnQsIE1UOVQwMzFfQ09MVU1OX0FERFJFU1NfTU9ERSwK
CQkJCQkoKHhiaW4gLSAxKSA8PCA0KSB8ICh4c2tpcCAtIDEpKTsKCQlpZiAocmV0ID49IDApCgkJ
CXJldCA9IHJlZ193cml0ZShjbGllbnQsIE1UOVQwMzFfUk9XX0FERFJFU1NfTU9ERSwKCQkJCQko
KHliaW4gLSAxKSA8PCA0KSB8ICh5c2tpcCAtIDEpKTsKCX0KCXY0bDJfZGJnKDEsIGRlYnVnLCBz
ZCwgIm5ldyBwaHlzaWNhbCBsZWZ0ICV1LCB0b3AgJXVcbiIsIGxlZnQsIHRvcCk7CgoJLyogVGhl
IGNhbGxlciBwcm92aWRlcyBhIHN1cHBvcnRlZCBmb3JtYXQsIGFzIGd1YXJhbnRlZWQgYnkKCSAq
IGljZC0+dHJ5X2ZtdF9jYXAoKSwgc29jX2NhbWVyYV9zX2Nyb3AoKSBhbmQgc29jX2NhbWVyYV9j
cm9wY2FwKCkgKi8KCWlmIChyZXQgPj0gMCkKCQlyZXQgPSByZWdfd3JpdGUoY2xpZW50LCBNVDlU
MDMxX0NPTFVNTl9TVEFSVCwgbGVmdCk7CglpZiAocmV0ID49IDApCgkJcmV0ID0gcmVnX3dyaXRl
KGNsaWVudCwgTVQ5VDAzMV9ST1dfU1RBUlQsIHRvcCk7CglpZiAocmV0ID49IDApCgkJcmV0ID0g
cmVnX3dyaXRlKGNsaWVudCwgTVQ5VDAzMV9XSU5ET1dfV0lEVEgsIHdpZHRoIC0gMSk7CglpZiAo
cmV0ID49IDApCgkJcmV0ID0gcmVnX3dyaXRlKGNsaWVudCwgTVQ5VDAzMV9XSU5ET1dfSEVJR0hU
LAoJCQkJaGVpZ2h0ICsgbXQ5dDAzMS0+eV9za2lwX3RvcCAtIDEpOwoJaWYgKHJldCA+PSAwICYm
IG10OXQwMzEtPmF1dG9leHBvc3VyZSkgewoJCXJldCA9IHNldF9zaHV0dGVyKHNkLCBoZWlnaHQg
KyBtdDl0MDMxLT55X3NraXBfdG9wICsgdmJsYW5rKTsKCQlpZiAocmV0ID49IDApIHsKCQkJY29u
c3QgdTMyIHNodXR0ZXJfbWF4ID0gTVQ5VDAzMV9NQVhfSEVJR0hUICsgdmJsYW5rOwoJCQljb25z
dCBzdHJ1Y3QgdjRsMl9xdWVyeWN0cmwgKnFjdHJsID0KCQkJCW10OXQwMzFfZmluZF9xY3RybChW
NEwyX0NJRF9FWFBPU1VSRSk7CgkJCW10OXQwMzEtPmV4cG9zdXJlID0gKHNodXR0ZXJfbWF4IC8g
MiArIChoZWlnaHQgKwoJCQkJCSBtdDl0MDMxLT55X3NraXBfdG9wICsgdmJsYW5rIC0gMSkgKgoJ
CQkJCSAocWN0cmwtPm1heGltdW0gLSBxY3RybC0+bWluaW11bSkpIC8KCQkJCXNodXR0ZXJfbWF4
ICsgcWN0cmwtPm1pbmltdW07CgkJfQoJfQoKCS8qIFJlLWVuYWJsZSByZWdpc3RlciB1cGRhdGUs
IGNvbW1pdCBhbGwgY2hhbmdlcyAqLwoJaWYgKHJldCA+PSAwKSB7CgkJcmV0ID0gcmVnX2NsZWFy
KGNsaWVudCwgTVQ5VDAzMV9PVVRQVVRfQ09OVFJPTCwgMSk7CgkJLyogdXBkYXRlIHRoZSB2YWx1
ZXMgKi8KCQltdDl0MDMxLT53aWR0aAk9IHJlY3QtPndpZHRoLAoJCW10OXQwMzEtPmhlaWdodAk9
IHJlY3QtPmhlaWdodCwKCQltdDl0MDMxLT54X2N1cnJlbnQgPSByZWN0LT5sZWZ0OwoJCW10OXQw
MzEtPnlfY3VycmVudCA9IHJlY3QtPnRvcDsKCX0KCXJldHVybiByZXQgPCAwID8gcmV0IDogMDsK
fQoKc3RhdGljIGludCBtdDl0MDMxX3NldF9mbXQoc3RydWN0IHY0bDJfc3ViZGV2ICpzZCwKCQkJ
ICAgc3RydWN0IHY0bDJfZm9ybWF0ICpmKQp7CglzdHJ1Y3QgbXQ5dDAzMSAqbXQ5dDAzMSA9IHRv
X210OXQwMzEoc2QpOwoJaW50IHJldDsKCXUxNiB4c2tpcCwgeXNraXA7CglzdHJ1Y3QgdjRsMl9y
ZWN0IHJlY3QgPSB7CgkJLmxlZnQJPSBtdDl0MDMxLT54X2N1cnJlbnQsCgkJLnRvcAk9IG10OXQw
MzEtPnlfY3VycmVudCwKCQkud2lkdGgJPSBmLT5mbXQucGl4LndpZHRoLAoJCS5oZWlnaHQJPSBm
LT5mbXQucGl4LmhlaWdodCwKCX07CgoJLyoKCSAqIHRyeV9mbXQgaGFzIHB1dCByZWN0YW5nbGUg
d2l0aGluIGxpbWl0cy4KCSAqIFNfRk1UIC0gdXNlIGJpbm5pbmcgYW5kIHNraXBwaW5nIGZvciBz
Y2FsaW5nLCByZWNhbGN1bGF0ZQoJICogbGltaXRzLCB1c2VkIGZvciBjcm9wcGluZwoJICovCgkv
KiBJcyB0aGlzIG1vcmUgb3B0aW1hbCB0aGFuIGp1c3QgYSBkaXZpc2lvbj8gKi8KCWZvciAoeHNr
aXAgPSA4OyB4c2tpcCA+IDE7IHhza2lwLS0pCgkJaWYgKHJlY3Qud2lkdGggKiB4c2tpcCA8PSBN
VDlUMDMxX01BWF9XSURUSCkKCQkJYnJlYWs7CgoJZm9yICh5c2tpcCA9IDg7IHlza2lwID4gMTsg
eXNraXAtLSkKCQlpZiAocmVjdC5oZWlnaHQgKiB5c2tpcCA8PSBNVDlUMDMxX01BWF9IRUlHSFQp
CgkJCWJyZWFrOwoKCXJlY2FsY3VsYXRlX2xpbWl0cyhtdDl0MDMxLCB4c2tpcCwgeXNraXApOwoK
CXJldCA9IG10OXQwMzFfc2V0X3BhcmFtcyhzZCwgJnJlY3QsIHhza2lwLCB5c2tpcCk7CglpZiAo
IXJldCkgewoJCW10OXQwMzEtPnhza2lwID0geHNraXA7CgkJbXQ5dDAzMS0+eXNraXAgPSB5c2tp
cDsKCX0KCXJldHVybiByZXQ7Cn0KCnN0YXRpYyBpbnQgbXQ5dDAzMV90cnlfZm10KHN0cnVjdCB2
NGwyX3N1YmRldiAqc2QsCgkJCSAgIHN0cnVjdCB2NGwyX2Zvcm1hdCAqZikKewoJc3RydWN0IHY0
bDJfcGl4X2Zvcm1hdCAqcGl4ID0gJmYtPmZtdC5waXg7CgoJaWYgKHBpeC0+aGVpZ2h0IDwgTVQ5
VDAzMV9NSU5fSEVJR0hUKQoJCXBpeC0+aGVpZ2h0ID0gTVQ5VDAzMV9NSU5fSEVJR0hUOwoJaWYg
KHBpeC0+aGVpZ2h0ID4gTVQ5VDAzMV9NQVhfSEVJR0hUKQoJCXBpeC0+aGVpZ2h0ID0gTVQ5VDAz
MV9NQVhfSEVJR0hUOwoJaWYgKHBpeC0+d2lkdGggPCBNVDlUMDMxX01JTl9XSURUSCkKCQlwaXgt
PndpZHRoID0gTVQ5VDAzMV9NSU5fV0lEVEg7CglpZiAocGl4LT53aWR0aCA+IE1UOVQwMzFfTUFY
X1dJRFRIKQoJCXBpeC0+d2lkdGggPSBNVDlUMDMxX01BWF9XSURUSDsKCglwaXgtPndpZHRoICY9
IH4weDAxOyAvKiBoYXMgdG8gYmUgZXZlbiAqLwoJcGl4LT5oZWlnaHQgJj0gfjB4MDE7IC8qIGhh
cyB0byBiZSBldmVuICovCglyZXR1cm4gMDsKfQoKc3RhdGljIGludCBtdDl0MDMxX2dldF9jaGlw
X2lkKHN0cnVjdCB2NGwyX3N1YmRldiAqc2QsCgkJCSAgICAgICBzdHJ1Y3QgdjRsMl9kYmdfY2hp
cF9pZGVudCAqaWQpCnsKCXN0cnVjdCBtdDl0MDMxICptdDl0MDMxID0gdG9fbXQ5dDAzMShzZCk7
CglzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50ID0gdjRsMl9nZXRfc3ViZGV2ZGF0YShzZCk7OwoK
CWlmIChpZC0+bWF0Y2gudHlwZSAhPSBWNEwyX0NISVBfTUFUQ0hfSTJDX0FERFIpCgkJcmV0dXJu
IC1FSU5WQUw7CgoJaWYgKGlkLT5tYXRjaC5hZGRyICE9IGNsaWVudC0+YWRkcikKCQlyZXR1cm4g
LUVOT0RFVjsKCglpZC0+aWRlbnQJPSBtdDl0MDMxLT5tb2RlbDsKCWlkLT5yZXZpc2lvbgk9IDA7
CgoJcmV0dXJuIDA7Cn0KCiNpZmRlZiBDT05GSUdfVklERU9fQURWX0RFQlVHCnN0YXRpYyBpbnQg
bXQ5dDAzMV9nZXRfcmVnaXN0ZXIoc3RydWN0IHY0bDJfc3ViZGV2ICpzZCwKCQkJCXN0cnVjdCB2
NGwyX2RiZ19yZWdpc3RlciAqcmVnKQp7CglzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50ID0gdjRs
Ml9nZXRfc3ViZGV2ZGF0YShzZCk7OwoJc3RydWN0IG10OXQwMzEgKm10OXQwMzEgPSB0b19tdDl0
MDMxKHNkKTsKCglpZiAocmVnLT5tYXRjaC50eXBlICE9IFY0TDJfQ0hJUF9NQVRDSF9JMkNfQURE
UiB8fCByZWctPnJlZyA+IDB4ZmYpCgkJcmV0dXJuIC1FSU5WQUw7CgoJaWYgKHJlZy0+bWF0Y2gu
YWRkciAhPSBjbGllbnQtPmFkZHIpCgkJcmV0dXJuIC1FTk9ERVY7CgoJcmVnLT52YWwgPSByZWdf
cmVhZChjbGllbnQsIHJlZy0+cmVnKTsKCglpZiAocmVnLT52YWwgPiAweGZmZmYpCgkJcmV0dXJu
IC1FSU87CgoJcmV0dXJuIDA7Cn0KCnN0YXRpYyBpbnQgbXQ5dDAzMV9zZXRfcmVnaXN0ZXIoc3Ry
dWN0IHY0bDJfc3ViZGV2ICpzZCwKCQkJCXN0cnVjdCB2NGwyX2RiZ19yZWdpc3RlciAqcmVnKQp7
CglzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50ID0gdjRsMl9nZXRfc3ViZGV2ZGF0YShzZCk7Cglz
dHJ1Y3QgbXQ5dDAzMSAqbXQ5dDAzMSA9IHRvX210OXQwMzEoc2QpOwoKCWlmIChyZWctPm1hdGNo
LnR5cGUgIT0gVjRMMl9DSElQX01BVENIX0kyQ19BRERSIHx8IHJlZy0+cmVnID4gMHhmZikKCQly
ZXR1cm4gLUVJTlZBTDsKCglpZiAocmVnLT5tYXRjaC5hZGRyICE9IGNsaWVudC0+YWRkcikKCQly
ZXR1cm4gLUVOT0RFVjsKCglpZiAocmVnX3dyaXRlKGNsaWVudCwgcmVnLT5yZWcsIHJlZy0+dmFs
KSA8IDApCgkJcmV0dXJuIC1FSU87CgoJcmV0dXJuIDA7Cn0KI2VuZGlmCgoKc3RhdGljIGludCBt
dDl0MDMxX2dldF9jb250cm9sKHN0cnVjdCB2NGwyX3N1YmRldiAqLCBzdHJ1Y3QgdjRsMl9jb250
cm9sICopOwpzdGF0aWMgaW50IG10OXQwMzFfc2V0X2NvbnRyb2woc3RydWN0IHY0bDJfc3ViZGV2
ICosIHN0cnVjdCB2NGwyX2NvbnRyb2wgKik7CnN0YXRpYyBpbnQgbXQ5dDAzMV9xdWVyeWN0cmwo
c3RydWN0IHY0bDJfc3ViZGV2ICosIHN0cnVjdCB2NGwyX3F1ZXJ5Y3RybCAqKTsKCnN0YXRpYyBj
b25zdCBzdHJ1Y3QgdjRsMl9zdWJkZXZfY29yZV9vcHMgbXQ5dDAzMV9jb3JlX29wcyA9IHsKCS5n
X2NoaXBfaWRlbnQgPSBtdDl0MDMxX2dldF9jaGlwX2lkLAoJLmluaXQgPSBtdDl0MDMxX2luaXQs
CgkucXVlcnljdHJsID0gbXQ5dDAzMV9xdWVyeWN0cmwsCgkuZ19jdHJsCT0gbXQ5dDAzMV9nZXRf
Y29udHJvbCwKCS5zX2N0cmwJPSBtdDl0MDMxX3NldF9jb250cm9sLAojaWZkZWYgQ09ORklHX1ZJ
REVPX0FEVl9ERUJVRwoJLmdldF9yZWdpc3RlciA9IG10OXQwMzFfZ2V0X3JlZ2lzdGVyLAoJLnNl
dF9yZWdpc3RlciA9IG10OXQwMzFfc2V0X3JlZ2lzdGVyLAojZW5kaWYKfTsKCnN0YXRpYyBjb25z
dCBzdHJ1Y3QgdjRsMl9zdWJkZXZfdmlkZW9fb3BzIG10OXQwMzFfdmlkZW9fb3BzID0gewoJLnNf
Zm10ID0gbXQ5dDAzMV9zZXRfZm10LAoJLnRyeV9mbXQgPSBtdDl0MDMxX3RyeV9mbXQsCgkuc19z
dHJlYW0gPSBtdDl0MDMxX3Nfc3RyZWFtLAp9OwoKc3RhdGljIGNvbnN0IHN0cnVjdCB2NGwyX3N1
YmRldl9vcHMgbXQ5dDAzMV9vcHMgPSB7CgkuY29yZSA9ICZtdDl0MDMxX2NvcmVfb3BzLAoJLnZp
ZGVvID0gJm10OXQwMzFfdmlkZW9fb3BzLAp9OwoKc3RhdGljIGludCBtdDl0MDMxX3F1ZXJ5Y3Ry
bChzdHJ1Y3QgdjRsMl9zdWJkZXYgKnNkLAoJCQkgICAgc3RydWN0IHY0bDJfcXVlcnljdHJsICpx
Y3RybCkKewoJY29uc3Qgc3RydWN0IHY0bDJfcXVlcnljdHJsICp0ZW1wX3FjdHJsOwoKCXRlbXBf
cWN0cmwgPSBtdDl0MDMxX2ZpbmRfcWN0cmwocWN0cmwtPmlkKTsKCWlmICghdGVtcF9xY3RybCkg
ewoJCXY0bDJfZXJyKHNkLCAiY29udHJvbCBpZCAlZCBub3Qgc3VwcG9ydGVkIiwgcWN0cmwtPmlk
KTsKCQlyZXR1cm4gLUVJTlZBTDsKCX0KCW1lbWNweShxY3RybCwgdGVtcF9xY3RybCwgc2l6ZW9m
KCpxY3RybCkpOwoJcmV0dXJuIDA7Cn0KCnN0YXRpYyBpbnQgbXQ5dDAzMV9nZXRfY29udHJvbChz
dHJ1Y3QgdjRsMl9zdWJkZXYgKnNkLAoJCQkgICAgICAgc3RydWN0IHY0bDJfY29udHJvbCAqY3Ry
bCkKewoJc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCA9IHY0bDJfZ2V0X3N1YmRldmRhdGEoc2Qp
OwoJc3RydWN0IG10OXQwMzEgKm10OXQwMzEgPSB0b19tdDl0MDMxKHNkKTsKCWludCBkYXRhOwoK
CXN3aXRjaCAoY3RybC0+aWQpIHsKCWNhc2UgVjRMMl9DSURfVkZMSVA6CgkJZGF0YSA9IHJlZ19y
ZWFkKGNsaWVudCwgTVQ5VDAzMV9SRUFEX01PREVfMik7CgkJaWYgKGRhdGEgPCAwKQoJCQlyZXR1
cm4gLUVJTzsKCQljdHJsLT52YWx1ZSA9ICEhKGRhdGEgJiAweDgwMDApOwoJCWJyZWFrOwoJY2Fz
ZSBWNEwyX0NJRF9IRkxJUDoKCQlkYXRhID0gcmVnX3JlYWQoY2xpZW50LCBNVDlUMDMxX1JFQURf
TU9ERV8yKTsKCQlpZiAoZGF0YSA8IDApCgkJCXJldHVybiAtRUlPOwoJCWN0cmwtPnZhbHVlID0g
ISEoZGF0YSAmIDB4NDAwMCk7CgkJYnJlYWs7CgljYXNlIFY0TDJfQ0lEX0VYUE9TVVJFX0FVVE86
CgkJY3RybC0+dmFsdWUgPSBtdDl0MDMxLT5hdXRvZXhwb3N1cmU7CgkJYnJlYWs7Cgl9CglyZXR1
cm4gMDsKfQoKc3RhdGljIGludCBtdDl0MDMxX3NldF9jb250cm9sKHN0cnVjdCB2NGwyX3N1YmRl
diAqc2QsCgkJCSAgICAgICBzdHJ1Y3QgdjRsMl9jb250cm9sICpjdHJsKQp7CglzdHJ1Y3QgbXQ5
dDAzMSAqbXQ5dDAzMSA9IHRvX210OXQwMzEoc2QpOwoJY29uc3Qgc3RydWN0IHY0bDJfcXVlcnlj
dHJsICpxY3RybCA9IE5VTEw7CglpbnQgZGF0YTsKCXN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQg
PSB2NGwyX2dldF9zdWJkZXZkYXRhKHNkKTsKCglpZiAoTlVMTCA9PSBjdHJsKQoJCXJldHVybiAt
RUlOVkFMOwoKCXFjdHJsID0gbXQ5dDAzMV9maW5kX3FjdHJsKGN0cmwtPmlkKTsKCWlmICghcWN0
cmwpIHsKCQl2NGwyX2VycihzZCwgImNvbnRyb2wgaWQgJWQgbm90IHN1cHBvcnRlZCIsIGN0cmwt
PmlkKTsKCQlyZXR1cm4gLUVJTlZBTDsKCX0KCglzd2l0Y2ggKGN0cmwtPmlkKSB7CgljYXNlIFY0
TDJfQ0lEX1ZGTElQOgoJCWlmIChjdHJsLT52YWx1ZSkKCQkJZGF0YSA9IHJlZ19zZXQoY2xpZW50
LCBNVDlUMDMxX1JFQURfTU9ERV8yLCAweDgwMDApOwoJCWVsc2UKCQkJZGF0YSA9IHJlZ19jbGVh
cihjbGllbnQsIE1UOVQwMzFfUkVBRF9NT0RFXzIsIDB4ODAwMCk7CgkJaWYgKGRhdGEgPCAwKQoJ
CQlyZXR1cm4gLUVJTzsKCQlicmVhazsKCWNhc2UgVjRMMl9DSURfSEZMSVA6CgkJaWYgKGN0cmwt
PnZhbHVlKQoJCQlkYXRhID0gcmVnX3NldChjbGllbnQsIE1UOVQwMzFfUkVBRF9NT0RFXzIsIDB4
NDAwMCk7CgkJZWxzZQoJCQlkYXRhID0gcmVnX2NsZWFyKGNsaWVudCwgTVQ5VDAzMV9SRUFEX01P
REVfMiwgMHg0MDAwKTsKCQlpZiAoZGF0YSA8IDApCgkJCXJldHVybiAtRUlPOwoJCWJyZWFrOwoJ
Y2FzZSBWNEwyX0NJRF9HQUlOOgoJCWlmIChjdHJsLT52YWx1ZSA+IHFjdHJsLT5tYXhpbXVtIHx8
IGN0cmwtPnZhbHVlIDwgcWN0cmwtPm1pbmltdW0pCgkJCXJldHVybiAtRUlOVkFMOwoJCS8qIFNl
ZSBEYXRhc2hlZXQgVGFibGUgNywgR2FpbiBzZXR0aW5ncy4gKi8KCQlpZiAoY3RybC0+dmFsdWUg
PD0gcWN0cmwtPmRlZmF1bHRfdmFsdWUpIHsKCQkJLyogUGFjayBpdCBpbnRvIDAuLjEgc3RlcCAw
LjEyNSwgcmVnaXN0ZXIgdmFsdWVzIDAuLjggKi8KCQkJdW5zaWduZWQgbG9uZyByYW5nZSA9IHFj
dHJsLT5kZWZhdWx0X3ZhbHVlIC0gcWN0cmwtPm1pbmltdW07CgkJCWRhdGEgPSAoKGN0cmwtPnZh
bHVlIC0gcWN0cmwtPm1pbmltdW0pICogOCArIHJhbmdlIC8gMikgLyByYW5nZTsKCgkJCXY0bDJf
ZGJnKDEsIGRlYnVnLCBzZCwgIlNldHRpbmcgZ2FpbiAlZFxuIiwgZGF0YSk7CgkJCWRhdGEgPSBy
ZWdfd3JpdGUoY2xpZW50LCBNVDlUMDMxX0dMT0JBTF9HQUlOLCBkYXRhKTsKCQkJaWYgKGRhdGEg
PCAwKQoJCQkJcmV0dXJuIC1FSU87CgkJfSBlbHNlIHsKCQkJLyogUGFjayBpdCBpbnRvIDEuMTI1
Li4xMjggdmFyaWFibGUgc3RlcCwgcmVnaXN0ZXIgdmFsdWVzIDkuLjB4Nzg2MCAqLwoJCQkvKiBX
ZSBhc3N1bWUgcWN0cmwtPm1heGltdW0gLSBxY3RybC0+ZGVmYXVsdF92YWx1ZSAtIDEgPiAwICov
CgkJCXVuc2lnbmVkIGxvbmcgcmFuZ2UgPSBxY3RybC0+bWF4aW11bSAtIHFjdHJsLT5kZWZhdWx0
X3ZhbHVlIC0gMTsKCQkJLyogY2FsY3VsYXRlZCBnYWluOiBtYXAgNjUuLjEyNyB0byA5Li4xMDI0
IHN0ZXAgMC4xMjUgKi8KCQkJdW5zaWduZWQgbG9uZyBnYWluID0gKChjdHJsLT52YWx1ZSAtIHFj
dHJsLT5kZWZhdWx0X3ZhbHVlIC0gMSkgKgoJCQkJCSAgICAgICAxMDE1ICsgcmFuZ2UgLyAyKSAv
IHJhbmdlICsgOTsKCgkJCWlmIChnYWluIDw9IDMyKQoJCQkJLyogY2FsY3VsYXRlZCBnYWluIDku
LjMyIC0+IDkuLjMyICovCgkJCQlkYXRhID0gZ2FpbjsKCQkJZWxzZSBpZiAoZ2FpbiA8PSA2NCkK
CQkJCS8qIGNhbGN1bGF0ZWQgZ2FpbiAzMy4uNjQgLT4gMHg1MS4uMHg2MCAqLwoJCQkJZGF0YSA9
ICgoZ2FpbiAtIDMyKSAqIDE2ICsgMTYpIC8gMzIgKyA4MDsKCQkJZWxzZQoJCQkJLyoKCQkJCSAq
IGNhbGN1bGF0ZWQgZ2FpbiA2NS4uMTAyNCAtPiAoMS4uMTIwKSA8PCA4ICsKCQkJCSAqIDB4NjAK
CQkJCSAqLwoJCQkJZGF0YSA9ICgoKGdhaW4gLSA2NCArIDcpICogMzIpICYgMHhmZjAwKSB8IDB4
NjA7CgoJCQl2NGwyX2RiZygxLCBkZWJ1Zywgc2QsICJTZXR0aW5nIGdhaW4gZnJvbSAweCV4IHRv
IgoJCQkJICIweCV4XG4iLAoJCQkJIHJlZ19yZWFkKGNsaWVudCwgTVQ5VDAzMV9HTE9CQUxfR0FJ
TiksIGRhdGEpOwoKCQkJZGF0YSA9IHJlZ193cml0ZShjbGllbnQsIE1UOVQwMzFfR0xPQkFMX0dB
SU4sIGRhdGEpOwoJCQlpZiAoZGF0YSA8IDApCgkJCQlyZXR1cm4gLUVJTzsKCQl9CgoJCS8qIFN1
Y2Nlc3MgKi8KCQltdDl0MDMxLT5nYWluID0gY3RybC0+dmFsdWU7CgkJYnJlYWs7CgljYXNlIFY0
TDJfQ0lEX0VYUE9TVVJFOgoJCS8qIG10OXQwMzEgaGFzIG1heGltdW0gPT0gZGVmYXVsdCAqLwoJ
CWlmIChjdHJsLT52YWx1ZSA+IHFjdHJsLT5tYXhpbXVtIHx8CgkJICAgIGN0cmwtPnZhbHVlIDwg
cWN0cmwtPm1pbmltdW0pCgkJCXJldHVybiAtRUlOVkFMOwoJCWVsc2UgewoJCQljb25zdCB1bnNp
Z25lZCBsb25nIHJhbmdlID0KCQkJCXFjdHJsLT5tYXhpbXVtIC0gcWN0cmwtPm1pbmltdW07CgkJ
CWNvbnN0IHUzMiBzaHV0dGVyID0KCQkJCSgoY3RybC0+dmFsdWUgLSBxY3RybC0+bWluaW11bSkg
KiAxMDQ4ICsKCQkJCQlyYW5nZSAvIDIpIC8gcmFuZ2UgKyAxOwoJCQl1MzIgb2xkOwoKCQkJZ2V0
X3NodXR0ZXIoc2QsICZvbGQpOwoJCQl2NGwyX2RiZygxLCBkZWJ1Zywgc2QsCgkJCQkiU2V0dGlu
ZyBzaHV0dGVyIHdpZHRoIGZyb20gJXUgdG8gJXVcbiIsCgkJCQlvbGQsIHNodXR0ZXIpOwoJCQlp
ZiAoc2V0X3NodXR0ZXIoc2QsIHNodXR0ZXIpIDwgMCkKCQkJCXJldHVybiAtRUlPOwoJCQltdDl0
MDMxLT5leHBvc3VyZSA9IGN0cmwtPnZhbHVlOwoJCQltdDl0MDMxLT5hdXRvZXhwb3N1cmUgPSAw
OwoJCX0KCQlicmVhazsKCWNhc2UgVjRMMl9DSURfRVhQT1NVUkVfQVVUTzoKCQlpZiAoY3RybC0+
dmFsdWUpIHsKCQkJY29uc3QgdTE2IHZibGFuayA9IE1UOVQwMzFfVkVSVElDQUxfQkxBTks7CgkJ
CWNvbnN0IHUzMiBzaHV0dGVyX21heCA9IE1UOVQwMzFfTUFYX0hFSUdIVCArIHZibGFuazsKCQkJ
aWYgKHNldF9zaHV0dGVyKHNkLCBtdDl0MDMxLT5oZWlnaHQgKwoJCQkJCW10OXQwMzEtPnlfc2tp
cF90b3AgKyB2YmxhbmspIDwgMCkKCQkJCXJldHVybiAtRUlPOwoKCQkJcWN0cmwgPSBtdDl0MDMx
X2ZpbmRfcWN0cmwoVjRMMl9DSURfRVhQT1NVUkUpOwoJCQltdDl0MDMxLT5leHBvc3VyZSA9CgkJ
CQkoc2h1dHRlcl9tYXggLyAyICsgKG10OXQwMzEtPmhlaWdodCArCgkJCQltdDl0MDMxLT55X3Nr
aXBfdG9wICsgdmJsYW5rIC0gMSkgKgoJCQkJKHFjdHJsLT5tYXhpbXVtIC0gcWN0cmwtPm1pbmlt
dW0pKSAvCgkJCQlzaHV0dGVyX21heCArIHFjdHJsLT5taW5pbXVtOwoJCQltdDl0MDMxLT5hdXRv
ZXhwb3N1cmUgPSAxOwoJCX0gZWxzZQoJCQltdDl0MDMxLT5hdXRvZXhwb3N1cmUgPSAwOwoJCWJy
ZWFrOwoJfQoJcmV0dXJuIDA7Cn0KCi8qIEludGVyZmFjZSBhY3RpdmUsIGNhbiB1c2UgaTJjLiBJ
ZiBpdCBmYWlscywgaXQgY2FuIGluZGVlZCBtZWFuLCB0aGF0CiAqIHRoaXMgd2Fzbid0IG91ciBj
YXB0dXJlIGludGVyZmFjZSwgc28sIHdlIHdhaXQgZm9yIHRoZSByaWdodCBvbmUgKi8Kc3RhdGlj
IGludCBtdDl0MDMxX2RldGVjdChzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50LCBpbnQgKm1vZGVs
KQp7CglzMzIgZGF0YTsKCgkvKiBFbmFibGUgdGhlIGNoaXAgKi8KCWRhdGEgPSByZWdfd3JpdGUo
Y2xpZW50LCBNVDlUMDMxX0NISVBfRU5BQkxFLCAxKTsKCWRldl9kYmcoJmNsaWVudC0+ZGV2LCAi
d3JpdGU6ICVkXG4iLCBkYXRhKTsKCgkvKiBSZWFkIG91dCB0aGUgY2hpcCB2ZXJzaW9uIHJlZ2lz
dGVyICovCglkYXRhID0gcmVnX3JlYWQoY2xpZW50LCBNVDlUMDMxX0NISVBfVkVSU0lPTik7CgoJ
c3dpdGNoIChkYXRhKSB7CgljYXNlIDB4MTYyMToKCQkqbW9kZWwgPSBWNEwyX0lERU5UX01UOVQw
MzE7CgkJYnJlYWs7CglkZWZhdWx0OgoJCWRldl9lcnIoJmNsaWVudC0+ZGV2LAoJCQkiTm8gTVQ5
VDAzMSBjaGlwIGRldGVjdGVkLCByZWdpc3RlciByZWFkICV4XG4iLCBkYXRhKTsKCQlyZXR1cm4g
LUVOT0RFVjsKCX0KCglkZXZfaW5mbygmY2xpZW50LT5kZXYsICJEZXRlY3RlZCBhIE1UOVQwMzEg
Y2hpcCBJRCAleFxuIiwgZGF0YSk7CglyZXR1cm4gMDsKfQoKc3RhdGljIGludCBtdDl0MDMxX3By
b2JlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsCgkJCSBjb25zdCBzdHJ1Y3QgaTJjX2Rldmlj
ZV9pZCAqZGlkKQp7CglzdHJ1Y3QgbXQ5dDAzMSAqbXQ5dDAzMTsKCXN0cnVjdCB2NGwyX3N1YmRl
diAqc2Q7CglpbnQgcGNsa19wb2w7CglpbnQgcmV0OwoKCWlmICghaTJjX2NoZWNrX2Z1bmN0aW9u
YWxpdHkoY2xpZW50LT5hZGFwdGVyLAoJCQkJICAgICBJMkNfRlVOQ19TTUJVU19XT1JEX0RBVEEp
KSB7CgkJZGV2X3dhcm4oJmNsaWVudC0+ZGV2LAoJCQkgIkkyQy1BZGFwdGVyIGRvZXNuJ3Qgc3Vw
cG9ydCBJMkNfRlVOQ19TTUJVU19XT1JEXG4iKTsKCQlyZXR1cm4gLUVJTzsKCX0KCglpZiAoIWNs
aWVudC0+ZGV2LnBsYXRmb3JtX2RhdGEpIHsKCQlkZXZfZXJyKCZjbGllbnQtPmRldiwgIk5vIHBs
YXRmb3JtIGRhdGEhIVxuIik7CgkJcmV0dXJuIC1FTk9ERVY7Cgl9CgoJcGNsa19wb2wgPSAoaW50
KWNsaWVudC0+ZGV2LnBsYXRmb3JtX2RhdGE7CgoJbXQ5dDAzMSA9IGt6YWxsb2Moc2l6ZW9mKHN0
cnVjdCBtdDl0MDMxKSwgR0ZQX0tFUk5FTCk7CglpZiAoIW10OXQwMzEpCgkJcmV0dXJuIC1FTk9N
RU07CgoJcmV0ID0gbXQ5dDAzMV9kZXRlY3QoY2xpZW50LCAmbXQ5dDAzMS0+bW9kZWwpOwoJaWYg
KHJldCkKCQlnb3RvIGNsZWFuOwoKCW10OXQwMzEtPnhfbWluCQk9IE1UOVQwMzFfQ09MVU1OX1NL
SVA7CgltdDl0MDMxLT55X21pbgkJPSBNVDlUMDMxX1JPV19TS0lQOwoJbXQ5dDAzMS0+d2lkdGgJ
CT0gTVQ5VDAzMV9ERUZBVUxUX1dJRFRIOwoJbXQ5dDAzMS0+aGVpZ2h0CQk9IE1UOVQwMzFfREVG
QVVMVF9XSURUSDsKCW10OXQwMzEtPnhfY3VycmVudAk9IG10OXQwMzEtPnhfbWluOwoJbXQ5dDAz
MS0+eV9jdXJyZW50CT0gbXQ5dDAzMS0+eV9taW47CgltdDl0MDMxLT53aWR0aF9taW4JPSBNVDlU
MDMxX01JTl9XSURUSDsKCW10OXQwMzEtPndpZHRoX21heAk9IE1UOVQwMzFfTUFYX1dJRFRIOwoJ
bXQ5dDAzMS0+aGVpZ2h0X21pbgk9IE1UOVQwMzFfTUlOX0hFSUdIVDsKCW10OXQwMzEtPmhlaWdo
dF9tYXgJPSBNVDlUMDMxX01BWF9IRUlHSFQ7CgltdDl0MDMxLT55X3NraXBfdG9wCT0gMTA7Cglt
dDl0MDMxLT5hdXRvZXhwb3N1cmUgPSAxOwoJbXQ5dDAzMS0+eHNraXAgPSAxOwoJbXQ5dDAzMS0+
eXNraXAgPSAxOwoKCS8qIFJlZ2lzdGVyIHdpdGggVjRMMiBsYXllciBhcyBzbGF2ZSBkZXZpY2Ug
Ki8KCXNkID0gJm10OXQwMzEtPnNkOwoJdjRsMl9pMmNfc3ViZGV2X2luaXQoc2QsIGNsaWVudCwg
Jm10OXQwMzFfb3BzKTsKCWlmICghcGNsa19wb2wpCgkJcmVnX2NsZWFyKHY0bDJfZ2V0X3N1YmRl
dmRhdGEoc2QpLAoJCQkgIE1UOVQwMzFfUElYRUxfQ0xPQ0tfQ09OVFJPTCwgMHg4MDAwKTsKCWVs
c2UKCQlyZWdfc2V0KHY0bDJfZ2V0X3N1YmRldmRhdGEoc2QpLAoJCQlNVDlUMDMxX1BJWEVMX0NM
T0NLX0NPTlRST0wsIDB4ODAwMCk7CgoJdjRsMl9pbmZvKHNkLCAiJXMgZGVjb2RlciBkcml2ZXIg
cmVnaXN0ZXJlZCAhIVxuIiwgc2QtPm5hbWUpOwoJcmV0dXJuIDA7CgpjbGVhbjoKCWtmcmVlKG10
OXQwMzEpOwoJcmV0dXJuIHJldDsKfQoKc3RhdGljIGludCBtdDl0MDMxX3JlbW92ZShzdHJ1Y3Qg
aTJjX2NsaWVudCAqY2xpZW50KQp7CglzdHJ1Y3QgdjRsMl9zdWJkZXYgKnNkID0gaTJjX2dldF9j
bGllbnRkYXRhKGNsaWVudCk7CglzdHJ1Y3QgbXQ5dDAzMSAqbXQ5dDAzMSA9IHRvX210OXQwMzEo
c2QpOwoKCXY0bDJfZGV2aWNlX3VucmVnaXN0ZXJfc3ViZGV2KHNkKTsKCglrZnJlZShtdDl0MDMx
KTsKCXJldHVybiAwOwp9CgpzdGF0aWMgY29uc3Qgc3RydWN0IGkyY19kZXZpY2VfaWQgbXQ5dDAz
MV9pZFtdID0gewoJeyAibXQ5dDAzMSIsIDAgfSwKCXsgfQp9OwpNT0RVTEVfREVWSUNFX1RBQkxF
KGkyYywgbXQ5dDAzMV9pZCk7CgpzdGF0aWMgc3RydWN0IGkyY19kcml2ZXIgbXQ5dDAzMV9pMmNf
ZHJpdmVyID0gewoJLmRyaXZlciA9IHsKCQkubmFtZSA9ICJtdDl0MDMxIiwKCX0sCgkucHJvYmUJ
CT0gbXQ5dDAzMV9wcm9iZSwKCS5yZW1vdmUJCT0gbXQ5dDAzMV9yZW1vdmUsCgkuaWRfdGFibGUJ
PSBtdDl0MDMxX2lkLAp9OwoKc3RhdGljIGludCBfX2luaXQgbXQ5dDAzMV9tb2RfaW5pdCh2b2lk
KQp7CglyZXR1cm4gaTJjX2FkZF9kcml2ZXIoJm10OXQwMzFfaTJjX2RyaXZlcik7Cn0KCnN0YXRp
YyB2b2lkIF9fZXhpdCBtdDl0MDMxX21vZF9leGl0KHZvaWQpCnsKCWkyY19kZWxfZHJpdmVyKCZt
dDl0MDMxX2kyY19kcml2ZXIpOwp9Cgptb2R1bGVfaW5pdChtdDl0MDMxX21vZF9pbml0KTsKbW9k
dWxlX2V4aXQobXQ5dDAzMV9tb2RfZXhpdCk7CgpNT0RVTEVfREVTQ1JJUFRJT04oIk1pY3JvbiBN
VDlUMDMxIENhbWVyYSBkcml2ZXIiKTsKTU9EVUxFX0FVVEhPUigiR3Vlbm5hZGkgTGlha2hvdmV0
c2tpIDxsZ0BkZW54LmRlPiIpOwpNT0RVTEVfTElDRU5TRSgiR1BMIHYyIik7Cg==

--_002_A69FA2915331DC488A831521EAE36FE401557987F6dlee06enttico_--
