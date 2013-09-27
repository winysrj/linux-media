Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44393 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3I0SvL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Sep 2013 14:51:11 -0400
Received: by mail-pa0-f47.google.com with SMTP id kp14so3136049pab.6
        for <linux-media@vger.kernel.org>; Fri, 27 Sep 2013 11:51:10 -0700 (PDT)
From: Show Liu <show.liu@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, tom.gall@linaro.org,
	t.katayama@jp.fujitsu.com, vikas.sajjan@linaro.org,
	linaro-kernel@lists.linaro.org, tom.cooksey@arm.com,
	Show Liu <show.liu@linaro.org>
Subject: [PATCH/RFC v3 2/3] Add display entity and set VGA output(site MB) as default
Date: Sat, 28 Sep 2013 02:50:45 +0800
Message-Id: <1380307846-27479-3-git-send-email-show.liu@linaro.org>
In-Reply-To: <1380307846-27479-1-git-send-email-show.liu@linaro.org>
References: <1380307846-27479-1-git-send-email-show.liu@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/video/vexpress-dvi.c |   94 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 83 insertions(+), 11 deletions(-)

diff --git a/drivers/video/vexpress-dvi.c b/drivers/video/vexpress-dvi.c
index cbcb443..ca0e5bd 100644
--- a/drivers/video/vexpress-dvi.c
+++ b/drivers/video/vexpress-dvi.c
@@ -18,6 +18,12 @@
 #include <linux/of_device.h>
 #include <linux/vexpress.h>
 
+#include <linux/platform_device.h>
+#include <video/display.h>
+
+struct _mux_fpga {
+	 struct display_entity entity;
+};
 
 static struct vexpress_config_func *vexpress_dvimode_func;
 
@@ -146,6 +152,52 @@ static int vexpress_dvi_fb_event_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
+static int mux_fpga_set_state(struct display_entity *entity,
+							 enum display_entity_state state)
+{
+	struct media_pad *source;
+	source = media_entity_remote_pad(&entity->entity.pads[0]);
+	if (source == NULL)
+		return -EPIPE;
+	
+	switch (state) {
+	case DISPLAY_ENTITY_STATE_OFF:
+	case DISPLAY_ENTITY_STATE_STANDBY:
+			display_entity_set_stream(to_display_entity(source->entity),
+														source->index,
+														DISPLAY_ENTITY_STREAM_STOPPED);
+			break;
+	
+	case DISPLAY_ENTITY_STATE_ON:
+			display_entity_set_stream(to_display_entity(source->entity),
+														source->index,
+														DISPLAY_ENTITY_STREAM_CONTINUOUS);
+			break;
+	}
+	
+	return 0;
+}
+
+static int mux_fpga_get_params(struct display_entity *entity, unsigned int port,
+							  struct display_entity_interface_params *params)
+{
+	memset(params, 0, sizeof(*params));
+	
+	/* default using VGA interface type */
+	params->type = DISPLAY_ENTITY_INTERFACE_VGA;
+	
+	return 0;
+}
+
+static const struct display_entity_control_ops mux_fpga_control_ops = {
+		.set_state = mux_fpga_set_state,
+		.get_params = mux_fpga_get_params,
+};
+
+static const struct display_entity_ops mux_fpga_ops = {
+		.ctrl = &mux_fpga_control_ops,
+};
+
 static struct notifier_block vexpress_dvi_fb_notifier = {
 	.notifier_call = vexpress_dvi_fb_event_notify,
 };
@@ -170,7 +222,9 @@ static int vexpress_dvi_probe(struct platform_device *pdev)
 	enum vexpress_dvi_func func;
 	const struct of_device_id *match =
 			of_match_device(vexpress_dvi_of_match, &pdev->dev);
-	u32 site;
+	struct _mux_fpga	*mux_fpga = NULL;
+	
+	int ret = 0;
 
 	if (match)
 		func = (enum vexpress_dvi_func)match->data;
@@ -182,18 +236,36 @@ static int vexpress_dvi_probe(struct platform_device *pdev)
 		vexpress_muxfpga_func =
 				vexpress_config_func_get_by_dev(&pdev->dev);
 		device_create_file(&pdev->dev, &dev_attr_fb);
-		/* 	hard-coded for test DRM on RTSM 
-			Set default site = 0
-		*/
-		if (vexpress_dvi_fb < 0){
-			/*default site = 0*/
-			site = 0;
-			vexpress_config_write(vexpress_muxfpga_func, 0, site);
-			vexpress_dvi_fb = site;
-		}
+		
+		/* 	
+		 *	default using VEXPRESS_SITE_MB
+		 */
+		pr_info("Set Site MB as Default\n");
+		vexpress_config_write(vexpress_muxfpga_func, 0, VEXPRESS_SITE_MB);
+		vexpress_dvi_fb = VEXPRESS_SITE_MB;
+
+		/* initialize display entity */
+		mux_fpga = devm_kzalloc(&pdev->dev, sizeof(*mux_fpga), GFP_KERNEL);
+			if (mux_fpga == NULL)
+				return -ENOMEM;
+
+		mux_fpga->entity.dev = &pdev->dev;
+		mux_fpga->entity.ops = &mux_fpga_ops;
+		strlcpy(mux_fpga->entity.name, dev_name(&pdev->dev), sizeof(mux_fpga->entity.name));
+
+		ret = display_entity_init(&mux_fpga->entity, 1, 1);
+		if (ret < 0)
+			return ret;
+
+		ret = display_entity_add(&mux_fpga->entity);
+		if (ret < 0)
+			return ret;
+
+		platform_set_drvdata(pdev, mux_fpga);
 		break;
 	case FUNC_DVIMODE:
 		vexpress_dvimode_func =
+		
 				vexpress_config_func_get_by_dev(&pdev->dev);
 		break;
 	}
@@ -205,7 +277,7 @@ static int vexpress_dvi_probe(struct platform_device *pdev)
 
 	vexpress_dvi_fb_select(vexpress_dvi_fb);
 
-	return 0;
+	return ret;
 }
 
 static const struct platform_device_id vexpress_dvi_id_table[] = {
-- 
1.7.9.5

