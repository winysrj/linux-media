Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1554 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab3BLIam (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 03:30:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFCv2 PATCH 01/12] stk-webcam: the initial hflip and vflip setup was the wrong way around
Date: Tue, 12 Feb 2013 09:30:33 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl> <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302120930.33402.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun February 10 2013 18:52:42 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This resulted in an upside-down picture.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Arvydas Sidorenko <asido4@gmail.com>

As mentioned in this thread, this patch was wrong. It's now replaced by the
version below which includes the background information given by Hans de Goede.

Regards,

	Hans

[PATCH 01/12] stk-webcam: add ASUS F3JC to upside-down list.

And add an extensive comment relating the history of the upside-down
handling in this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Thanks-to: Hans de Goede <hdegoede@redhat.com>
Thanks-to: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |   40 +++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 4cbab08..b2a5ee4 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -63,7 +63,39 @@ static struct usb_device_id stkwebcam_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, stkwebcam_table);
 
-/* The stk webcam laptop module is mounted upside down in some laptops :( */
+/*
+ * The stk webcam laptop module is mounted upside down in some laptops :(
+ *
+ * Some background information (thanks to Hans de Goede for providing this):
+ *
+ * 1) Once upon a time the stkwebcam driver was written
+ *
+ * 2) The webcam in question was used mostly in Asus laptop models, including
+ * the laptop of the original author of the driver, and in these models, in
+ * typical Asus fashion (see the long long list for uvc cams inside v4l-utils),
+ * they mounted the webcam-module the wrong way up. So the hflip and vflip
+ * module options were given a default value of 1 (the correct value for
+ * upside down mounted models)
+ *
+ * 3) Years later I got a bug report from a user with a laptop with stkwebcam,
+ * where the module was actually mounted the right way up, and thus showed
+ * upside down under Linux. So now I was facing the choice of 2 options:
+ *
+ * a) Add a not-upside-down list to stkwebcam, which overrules the default.
+ *
+ * b) Do it like all the other drivers do, and make the default right for
+ *    cams mounted the proper way and add an upside-down model list, with
+ *    models where we need to flip-by-default.
+ *
+ * Despite knowing that going b) would cause a period of pain where we were
+ * building the table I opted to go for option b), since a) is just too ugly,
+ * and worse different from how every other driver does it leading to
+ * confusion in the long run. This change was made in kernel 3.6.
+ *
+ * So for any user report about upside-down images since kernel 3.6 ask them
+ * to provide the output of 'sudo dmidecode' so the laptop can be added in
+ * the table below.
+ */
 static const struct dmi_system_id stk_upside_down_dmi_table[] = {
 	{
 		.ident = "ASUS G1",
@@ -71,6 +103,12 @@ static const struct dmi_system_id stk_upside_down_dmi_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "G1")
 		}
+	}, {
+		.ident = "ASUS F3JC",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "F3JC")
+		}
 	},
 	{}
 };
-- 
1.7.10.4

