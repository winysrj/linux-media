Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ELrlCA032428
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 17:53:47 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9ELraSA006069
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 17:53:37 -0400
Date: Tue, 14 Oct 2008 23:53:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
In-Reply-To: <20081014183936.GB4710@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0810142335400.10458@axis700.grange>
References: <20081014183936.GB4710@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
	lethal@linux-sh.org, Magnus Damm <damm@igel.co.jp>
Subject: [PATCH] soc-camera: fix compile breakage on SH
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

Fix Migo-R compile breakage caused by incomplete merge.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

Hi Adrian,

please see, if the patch below fixes it. Completely untested. Magnus, 
could you please verify if it also works (of course, if it at least 
compiles:-)) If it doesn't, please fix it along these lines, if it suits 
your needs.

On Tue, 14 Oct 2008, Adrian Bunk wrote:

> Commit 81034663159f39d005316b5c139038459cd16721
> (V4L/DVB (8687): soc-camera: Move .power and .reset from
>  soc_camera host to sensor driver) causes the following build error:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/sh/boards/mach-migor/setup.o
> arch/sh/boards/mach-migor/setup.c:408: error: unknown field 'enable_camera' specified in initializer
> arch/sh/boards/mach-migor/setup.c:408: warning: excess elements in struct initializer
> arch/sh/boards/mach-migor/setup.c:408: warning: (near initialization for 'sh_mobile_ceu_info')
> arch/sh/boards/mach-migor/setup.c:409: error: unknown field 'disable_camera' specified in initializer
> arch/sh/boards/mach-migor/setup.c:409: warning: excess elements in struct initializer
> arch/sh/boards/mach-migor/setup.c:409: warning: (near initialization for 'sh_mobile_ceu_info')
> make[2]: *** [arch/sh/boards/mach-migor/setup.o] Error 1
> 
> <--  snip  -->


diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 714dce9..95459f3 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -312,6 +312,14 @@ static void camera_power_off(void)
 	ctrl_outb(ctrl_inb(PORT_PTDR) & ~0x08, PORT_PTDR);
 }
 
+static void camera_power(int mode)
+{
+	if (mode)
+		camera_power_on();
+	else
+		camera_power_off();
+}
+
 #ifdef CONFIG_I2C
 static unsigned char camera_ov772x_magic[] =
 {
@@ -391,6 +399,7 @@ static struct soc_camera_platform_info ov772x_info = {
 	},
 	.bus_param =  SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
 	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8,
+	.power = camera_power,
 	.set_capture = ov772x_set_capture,
 };
 
@@ -405,8 +414,6 @@ static struct platform_device migor_camera_device = {
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
 	.flags = SOCAM_MASTER | SOCAM_DATAWIDTH_8 | SOCAM_PCLK_SAMPLE_RISING \
 	| SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH,
-	.enable_camera = camera_power_on,
-	.disable_camera = camera_power_off,
 };
 
 static struct resource migor_ceu_resources[] = {
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 1adc257..5b08873 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -44,11 +44,21 @@ soc_camera_platform_get_info(struct soc_camera_device *icd)
 
 static int soc_camera_platform_init(struct soc_camera_device *icd)
 {
+	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+
+	if (p->power)
+		p->power(1);
+
 	return 0;
 }
 
 static int soc_camera_platform_release(struct soc_camera_device *icd)
 {
+	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+
+	if (p->power)
+		p->power(0);
+
 	return 0;
 }
 
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 851f182..7c81ad3 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -9,6 +9,7 @@ struct soc_camera_platform_info {
 	unsigned long format_depth;
 	struct v4l2_pix_format format;
 	unsigned long bus_param;
+	void (*power)(int);
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
 };
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
