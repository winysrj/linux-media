Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FEGE4N032084
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 09:16:14 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1FEFhED007706
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 09:15:43 -0500
Date: Fri, 15 Feb 2008 15:15:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802151511540.16741@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH soc-camera] Replace NO_GPIO with gpio_is_valid()
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

Upon suggestion by David Brownell use a gpio_is_valid() predicate
instead of an explicit NO_GPIO macro. The respective patch to 
include/asm-generic/gpio.h has been accepted upstream.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

Mauro, following this I'm sending a fix for missing gpio.h

Thanks
Guennadi

 drivers/media/video/mt9m001.c |   10 +++++-----
 drivers/media/video/mt9v022.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 3c5867c..b65ff77 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -154,7 +154,7 @@ static int bus_switch_request(struct mt9m001 *mt9m001,
 	int ret;
 	unsigned int gpio = icl->gpio;
 
-	if (gpio != NO_GPIO) {
+	if (gpio_is_valid(gpio)) {
 		/* We have a data bus switch. */
 		ret = gpio_request(gpio, "mt9m001");
 		if (ret < 0) {
@@ -174,7 +174,7 @@ static int bus_switch_request(struct mt9m001 *mt9m001,
 
 	mt9m001->switch_gpio = gpio;
 #else
-	mt9m001->switch_gpio = NO_GPIO;
+	mt9m001->switch_gpio = -EINVAL;
 #endif
 	return 0;
 }
@@ -182,7 +182,7 @@ static int bus_switch_request(struct mt9m001 *mt9m001,
 static void bus_switch_release(struct mt9m001 *mt9m001)
 {
 #ifdef CONFIG_MT9M001_PCA9536_SWITCH
-	if (mt9m001->switch_gpio != NO_GPIO)
+	if (gpio_is_valid(mt9m001->switch_gpio))
 		gpio_free(mt9m001->switch_gpio);
 #endif
 }
@@ -190,7 +190,7 @@ static void bus_switch_release(struct mt9m001 *mt9m001)
 static int bus_switch_act(struct mt9m001 *mt9m001, int go8bit)
 {
 #ifdef CONFIG_MT9M001_PCA9536_SWITCH
-	if (mt9m001->switch_gpio == NO_GPIO)
+	if (!gpio_is_valid(mt9m001->switch_gpio))
 		return -ENODEV;
 
 	gpio_set_value_cansleep(mt9m001->switch_gpio, go8bit);
@@ -224,7 +224,7 @@ static int mt9m001_set_capture_format(struct soc_camera_device *icd,
 	    (mt9m001->datawidth != 9  && (width_flag == IS_DATAWIDTH_9)) ||
 	    (mt9m001->datawidth != 8  && (width_flag == IS_DATAWIDTH_8))) {
 		/* data width switch requested */
-		if (mt9m001->switch_gpio == NO_GPIO)
+		if (!gpio_is_valid(mt9m001->switch_gpio))
 			return -EINVAL;
 
 		/* Well, we actually only can do 10 or 8 bits... */
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 9b406e4..5fbeaa3 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -187,7 +187,7 @@ static int bus_switch_request(struct mt9v022 *mt9v022, struct soc_camera_link *i
 	int ret;
 	unsigned int gpio = icl->gpio;
 
-	if (gpio != NO_GPIO) {
+	if (gpio_is_valid(gpio)) {
 		/* We have a data bus switch. */
 		ret = gpio_request(gpio, "mt9v022");
 		if (ret < 0) {
@@ -206,7 +206,7 @@ static int bus_switch_request(struct mt9v022 *mt9v022, struct soc_camera_link *i
 
 	mt9v022->switch_gpio = gpio;
 #else
-	mt9v022->switch_gpio = NO_GPIO;
+	mt9v022->switch_gpio = -EINVAL;
 #endif
 	return 0;
 }
@@ -214,7 +214,7 @@ static int bus_switch_request(struct mt9v022 *mt9v022, struct soc_camera_link *i
 static void bus_switch_release(struct mt9v022 *mt9v022)
 {
 #ifdef CONFIG_MT9V022_PCA9536_SWITCH
-	if (mt9v022->switch_gpio != NO_GPIO)
+	if (gpio_is_valid(mt9v022->switch_gpio))
 		gpio_free(mt9v022->switch_gpio);
 #endif
 }
@@ -222,7 +222,7 @@ static void bus_switch_release(struct mt9v022 *mt9v022)
 static int bus_switch_act(struct mt9v022 *mt9v022, int go8bit)
 {
 #ifdef CONFIG_MT9V022_PCA9536_SWITCH
-	if (mt9v022->switch_gpio == NO_GPIO)
+	if (!gpio_is_valid(mt9v022->switch_gpio))
 		return -ENODEV;
 
 	gpio_set_value_cansleep(mt9v022->switch_gpio, go8bit);
@@ -303,7 +303,7 @@ static int mt9v022_set_capture_format(struct soc_camera_device *icd,
 	    (mt9v022->datawidth != 9  && (width_flag == IS_DATAWIDTH_9)) ||
 	    (mt9v022->datawidth != 8  && (width_flag == IS_DATAWIDTH_8))) {
 		/* data width switch requested */
-		if (mt9v022->switch_gpio == NO_GPIO)
+		if (!gpio_is_valid(mt9v022->switch_gpio))
 			return -EINVAL;
 
 		/* Well, we actually only can do 10 or 8 bits... */
-- 
1.5.3.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
