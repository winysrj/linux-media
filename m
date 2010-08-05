Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55906 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab0HESyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 14:54:00 -0400
Received: by vws3 with SMTP id 3so5356312vws.19
        for <linux-media@vger.kernel.org>; Thu, 05 Aug 2010 11:53:59 -0700 (PDT)
Message-ID: <4C5B08BE.8080709@brooks.nu>
Date: Thu, 05 Aug 2010 12:53:50 -0600
From: Lane Brooks <lane@brooks.nu>
MIME-Version: 1.0
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: OMAP3 Bridge Problems
References: <4C583538.8060504@gmail.com> <201008042257.13290.laurent.pinchart@ideasonboard.com> <4C5AE19B.50609@brooks.nu>
In-Reply-To: <4C5AE19B.50609@brooks.nu>
Content-Type: multipart/mixed;
 boundary="------------030709080309080601020200"
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030709080309080601020200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/05/2010 10:06 AM, Lane Brooks wrote:
> On 08/04/2010 02:57 PM, Laurent Pinchart wrote:
>> Hi Lane,
>>
>> On Tuesday 03 August 2010 17:26:48 Lane Brooks wrote:
> [snip]
>>
>>> My question:
>>>
>>> - Are there other things I need to when I enable the parallel bridge?
>>> For example, do I need to change a clock rate somewhere? From the TRM,
>>> it seems like it should just work without any changes, but maybe I am
>>> missing something.
>> Good question. ISP bridge and YUV modes support are not implemented in
>> the
>> driver, but you're probably already aware of that.
>>
>> I unfortunately have no straightforward answer. Try tracing the ISP
>> interrupts
>> and monitoring the CCDC SBL busy bits to see if the CCDC writes images to
>> memory correctly.
[snip]

Laurent,

I was able to get YUV CCDC capture mode working with rather minimal 
effort. Attached is a patch with the initial effort. Can you comment?

Thanks,
Lane

--------------030709080309080601020200
Content-Type: text/plain;
 name="ispyuv.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ispyuv.patch"

diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index 90bcc6c..cc91fa1 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -1563,6 +1563,15 @@ __ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
  * @pad: Pad number
  * @fmt: Format
  */
+
+static enum v4l2_mbus_pixelcode sink_fmts[] = {
+	V4L2_MBUS_FMT_SGRBG10_1X10,
+	V4L2_MBUS_FMT_YUYV16_1X16,
+	V4L2_MBUS_FMT_UYVY16_1X16,
+	V4L2_MBUS_FMT_YVYU16_1X16,
+	V4L2_MBUS_FMT_VYUY16_1X16,
+};
+
 static void
 ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
@@ -1571,14 +1580,22 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 	struct v4l2_mbus_framefmt *format;
 	unsigned int width = fmt->width;
 	unsigned int height = fmt->height;
-
+	int i;
 	switch (pad) {
 	case CCDC_PAD_SINK:
 		/* Check if the requested pixel format is supported.
 		 * TODO: If the CCDC output formatter pad is connected directly
 		 * to the resizer, only YUV formats can be used.
 		 */
-		fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		for(i=0; i<ARRAY_SIZE(sink_fmts); ++i) {
+			if(sink_fmts[i] == fmt->code) 
+				break;
+		}
+		/* if the requested type is not in the list of
+		 * supported types, then change it to the first format
+		 * code in the list of supported. */
+		if(i==ARRAY_SIZE(sink_fmts)) 
+			fmt->code = sink_fmts[0];
 
 		/* Clamp the input size. */
 		fmt->width = clamp_t(u32, width, 32, 4096);
@@ -1630,10 +1647,10 @@ static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_fh *fh,
 			       struct v4l2_subdev_pad_mbus_code_enum *code)
 {
-	if (code->index != 0)
+	if (code->index >= ARRAY_SIZE(sink_fmts))
 		return -EINVAL;
 
-	code->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	code->code = sink_fmts[code->index];
 
 	return 0;
 }
@@ -1719,6 +1736,45 @@ static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 
 	/* Propagate the format from sink to source */
 	if (pad == CCDC_PAD_SINK) {
+		u32 syn_mode, ispctrl_val;
+		struct isp_device *isp = to_isp_device(ccdc);
+		if (!isp_get(isp))
+			return -EBUSY;
+
+		syn_mode    = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, 
+					    ISPCCDC_SYN_MODE);
+		ispctrl_val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, 
+					    ISP_CTRL);
+		syn_mode    &= ISPCCDC_SYN_MODE_INPMOD_MASK;
+		ispctrl_val &= ~(ISPCTRL_PAR_BRIDGE_MASK 
+				 << ISPCTRL_PAR_BRIDGE_SHIFT);
+		switch(format->code) {
+		case V4L2_MBUS_FMT_YUYV16_1X16:
+		case V4L2_MBUS_FMT_UYVY16_1X16:
+		case V4L2_MBUS_FMT_YVYU16_1X16:
+		case V4L2_MBUS_FMT_VYUY16_1X16:
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+
+			/* TODO: In YCBCR16 mode, the bridge has to be
+			 * enabled, so we enable it here and force it
+			 * big endian. Whether to do big or little endian
+			 * should somehow come from the platform data.*/
+			ispctrl_val |= ISPCTRL_PAR_BRIDGE_BENDIAN 
+				<< ISPCTRL_PAR_BRIDGE_SHIFT;
+			break;
+		default:
+			syn_mode |= ISPCCDC_SYN_MODE_INPMOD_RAW;
+			ispctrl_val |= isp->pdata->parallel.bridge
+				<< ISPCTRL_PAR_BRIDGE_SHIFT;
+			break;
+		}
+		isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, 
+			       ISPCCDC_SYN_MODE);
+		isp_reg_writel(isp, ispctrl_val, OMAP3_ISP_IOMEM_MAIN, 
+			       ISP_CTRL);
+		isp_put(isp);
+
+
 		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SOURCE_OF, which);
 		memcpy(format, fmt, sizeof(*format));
 		ccdc_try_format(ccdc, fh, CCDC_PAD_SOURCE_OF, format, which);
diff --git a/drivers/media/video/isp/ispreg.h b/drivers/media/video/isp/ispreg.h
index 7efcfaa..4c191af 100644
--- a/drivers/media/video/isp/ispreg.h
+++ b/drivers/media/video/isp/ispreg.h
@@ -732,10 +732,10 @@
 #define ISPCTRL_PAR_SER_CLK_SEL_MASK		0xFFFFFFFC
 
 #define ISPCTRL_PAR_BRIDGE_SHIFT		2
-#define ISPCTRL_PAR_BRIDGE_DISABLE		(0x0 << 2)
-#define ISPCTRL_PAR_BRIDGE_LENDIAN		(0x2 << 2)
-#define ISPCTRL_PAR_BRIDGE_BENDIAN		(0x3 << 2)
-#define ISPCTRL_PAR_BRIDGE_MASK			(0x3 << 2)
+#define ISPCTRL_PAR_BRIDGE_DISABLE		0x0
+#define ISPCTRL_PAR_BRIDGE_LENDIAN		0x2
+#define ISPCTRL_PAR_BRIDGE_BENDIAN		0x3
+#define ISPCTRL_PAR_BRIDGE_MASK			0x3
 
 #define ISPCTRL_PAR_CLK_POL_SHIFT		4
 #define ISPCTRL_PAR_CLK_POL_INV			(1 << 4)

--------------030709080309080601020200--
