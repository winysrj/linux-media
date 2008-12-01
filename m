Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1KsOG9003088
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 15:54:24 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB1KsKYM002589
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 15:54:22 -0500
Date: Mon, 1 Dec 2008 21:54:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
In-Reply-To: <20081112192746.f59ee94d.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0812012148060.3915@axis700.grange>
References: <20081107125919.ddf028a6.ospite@studenti.unina.it>
	<874p2jbegl.fsf@free.fr>
	<Pine.LNX.4.64.0811082119280.8956@axis700.grange>
	<20081109235940.4c009a68.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0811101946200.8315@axis700.grange>
	<878wrr9z9h.fsf@free.fr>
	<20081112192746.f59ee94d.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH, RFC] mt9m111: allow data to be received on pixelclock
 falling edge?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Antonio,

On Wed, 12 Nov 2008, Antonio Ospite wrote:

> On Mon, 10 Nov 2008 20:06:34 +0100
> Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> 
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> > 
> > > I would prefer not to disregard camera flags. If we don't find a better 
> > > solution, I would introduce platform inverter flags, and, I think, we 
> > > better put them in camera platform data - not host platform data, to 
> > > provide a finer granularity. In the end, inverters can also be located on 
> > > camera boards, then you plug-in a different camera and, if your 
> > > inverter-flags were in host platform data, it doesn't work again.
> >
> > I'm of the same opinion.
> > 
> > I was thinking of another case : imagine the host needs to be configured on
> > rising edge, and camera on falling edge. Your patch wouldn't cover that devious
> > case.
> > 
> > I can't think of a better solution than an inverter flag as well. As this would
> > be very board specific, let it go in something board code sets up.
> > 
> > That's how it's already done for inverted gpio Vbus sensing in the USB stack for
> > the pxa for example.
> > 
> 
> Ok, I hope you'll find time to add the proper solution some day, since I
> don't think I can do it correctly with my current knowledge.

Could you test the patch below? It applies on top of all my patches I 
pushed today plus a couple more that are still to be pushed... But maybe 
you can apply it to linux-next manually. You just need the parts for 
soc_camera.h and for mt9m111. And then you need to add to your struct 
soc_camera_link in platform data:

	.flags = SOCAM_SENSOR_INVERT_PCLK,

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer


diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 0bcfef7..b58f0f8 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -272,17 +272,16 @@ static int mt9m001_set_bus_param(struct soc_camera_device *icd,
 static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 {
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	unsigned int width_flag = SOCAM_DATAWIDTH_10;
+	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+	/* MT9M001 has all capture_format parameters fixed */
+	unsigned long flags = SOCAM_DATAWIDTH_10 | SOCAM_PCLK_SAMPLE_RISING |
+		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
+		SOCAM_MASTER;
 
 	if (bus_switch_possible(mt9m001))
-		width_flag |= SOCAM_DATAWIDTH_8;
+		flags |= SOCAM_DATAWIDTH_8;
 
-	/* MT9M001 has all capture_format parameters fixed */
-	return SOCAM_PCLK_SAMPLE_RISING |
-		SOCAM_HSYNC_ACTIVE_HIGH |
-		SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_MASTER |
-		width_flag;
+	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
 static int mt9m001_set_fmt(struct soc_camera_device *icd,
@@ -578,6 +577,7 @@ static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_contro
 static int mt9m001_video_probe(struct soc_camera_device *icd)
 {
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
 	s32 data;
 	int ret;
 
@@ -600,7 +600,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 	case 0x8421:
 		mt9m001->model = V4L2_IDENT_MT9M001C12ST;
 		icd->formats = mt9m001_colour_formats;
-		if (mt9m001->client->dev.platform_data)
+		if (gpio_is_valid(icl->gpio))
 			icd->num_formats = ARRAY_SIZE(mt9m001_colour_formats);
 		else
 			icd->num_formats = 1;
@@ -608,7 +608,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 	case 0x8431:
 		mt9m001->model = V4L2_IDENT_MT9M001C12STM;
 		icd->formats = mt9m001_monochrome_formats;
-		if (mt9m001->client->dev.platform_data)
+		if (gpio_is_valid(icl->gpio))
 			icd->num_formats = ARRAY_SIZE(mt9m001_monochrome_formats);
 		else
 			icd->num_formats = 1;
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index b4a238f..b0e6046 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -415,9 +415,13 @@ static int mt9m111_stop_capture(struct soc_camera_device *icd)
 
 static unsigned long mt9m111_query_bus_param(struct soc_camera_device *icd)
 {
-	return SOCAM_MASTER | SOCAM_PCLK_SAMPLE_RISING |
+	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
+	unsigned long flags = SOCAM_MASTER | SOCAM_PCLK_SAMPLE_RISING |
 		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
 		SOCAM_DATAWIDTH_8;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
 static int mt9m111_set_bus_param(struct soc_camera_device *icd, unsigned long f)
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 3a39f02..3b3a6a0 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -273,6 +273,7 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
 	unsigned int width_flag = flags & SOCAM_DATAWIDTH_MASK;
 	int ret;
 	u16 pixclk = 0;
@@ -296,6 +297,8 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 		mt9v022->datawidth = width_flag == SOCAM_DATAWIDTH_8 ? 8 : 10;
 	}
 
+	flags = soc_camera_apply_sensor_flags(icl, flags);
+
 	if (flags & SOCAM_PCLK_SAMPLE_RISING)
 		pixclk |= 0x10;
 
@@ -690,6 +693,7 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
 static int mt9v022_video_probe(struct soc_camera_device *icd)
 {
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
 	s32 data;
 	int ret;
 
@@ -725,7 +729,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
 		icd->formats = mt9v022_colour_formats;
-		if (mt9v022->client->dev.platform_data)
+		if (gpio_is_valid(icl->gpio))
 			icd->num_formats = ARRAY_SIZE(mt9v022_colour_formats);
 		else
 			icd->num_formats = 1;
@@ -733,7 +737,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATM;
 		icd->formats = mt9v022_monochrome_formats;
-		if (mt9v022->client->dev.platform_data)
+		if (gpio_is_valid(icl->gpio))
 			icd->num_formats = ARRAY_SIZE(mt9v022_monochrome_formats);
 		else
 			icd->num_formats = 1;
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index c3e7139..0209462 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -706,12 +706,12 @@ static int ov772x_set_bus_param(struct soc_camera_device *icd,
 static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
 {
 	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
-
-	return  SOCAM_PCLK_SAMPLE_RISING |
-		SOCAM_HSYNC_ACTIVE_HIGH  |
-		SOCAM_VSYNC_ACTIVE_HIGH  |
-		SOCAM_MASTER             |
+	struct soc_camera_link *icl = priv->client->dev.platform_data;
+	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
 		priv->info->buswidth;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
 static int ov772x_get_chip_id(struct soc_camera_device *icd,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index d1f7241..549d0c2 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -81,11 +81,19 @@ struct soc_camera_host_ops {
 	unsigned int (*poll)(struct file *, poll_table *);
 };
 
+#define SOCAM_SENSOR_INVERT_PCLK	(1 << 0)
+#define SOCAM_SENSOR_INVERT_MCLK	(1 << 1)
+#define SOCAM_SENSOR_INVERT_HSYNC	(1 << 2)
+#define SOCAM_SENSOR_INVERT_VSYNC	(1 << 3)
+#define SOCAM_SENSOR_INVERT_DATA	(1 << 4)
+
 struct soc_camera_link {
 	/* Camera bus id, used to match a camera and a bus */
 	int bus_id;
 	/* GPIO number to switch between 8 and 10 bit modes */
 	unsigned int gpio;
+	/* Per camera SOCAM_SENSOR_* bus flags */
+	unsigned long flags;
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
@@ -206,4 +214,26 @@ static inline unsigned long soc_camera_bus_param_compatible(
 	return (!hsync || !vsync || !pclk) ? 0 : common_flags;
 }
 
+/**
+ * Return flags modified according to SOCAM_SENSOR_* platform configuration
+ *
+ * @icl:	camera platform parameters
+ * @flags:	flags to be inverted according to platform configuration
+ * @return:	resulting flags
+ */
+static inline unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
+							  unsigned long flags)
+{
+	if (icl->flags & SOCAM_SENSOR_INVERT_HSYNC)
+		flags ^= SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW;
+
+	if (icl->flags & SOCAM_SENSOR_INVERT_VSYNC)
+		flags ^= SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW;
+
+	if (icl->flags & SOCAM_SENSOR_INVERT_PCLK)
+		flags ^= SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING;
+
+	return flags;
+}
+
 #endif

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
