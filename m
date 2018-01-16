Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41403 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751187AbeAPVHJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 16:07:09 -0500
Received: from avalon.bb.dnainternet.fi (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 6BCDD20394
        for <linux-media@vger.kernel.org>; Tue, 16 Jan 2018 22:06:16 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] uvcvideo: Use kernel integer types
Date: Tue, 16 Jan 2018 23:07:05 +0200
Message-Id: <20180116210707.7727-3-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20180116210707.7727-1-laurent.pinchart@ideasonboard.com>
References: <20180116210707.7727-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the uint_{8,16,32} types with the corresponding native kernel
types u{8,16,32}.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++--------
 drivers/media/usb/uvc/uvc_v4l2.c   |  2 +-
 drivers/media/usb/uvc/uvcvideo.h   |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index fd387bf3f02d..56d906dd7044 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -267,11 +267,11 @@ static __u32 uvc_colorspace(const __u8 primaries)
  * continued fraction decomposition. Using 8 and 333 for n_terms and threshold
  * respectively seems to give nice results.
  */
-void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
+void uvc_simplify_fraction(u32 *numerator, u32 *denominator,
 		unsigned int n_terms, unsigned int threshold)
 {
-	uint32_t *an;
-	uint32_t x, y, r;
+	u32 *an;
+	u32 x, y, r;
 	unsigned int i, n;
 
 	an = kmalloc(n_terms * sizeof *an, GFP_KERNEL);
@@ -318,21 +318,21 @@ void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
  * to compute numerator / denominator * 10000000 using 32 bit fixed point
  * arithmetic only.
  */
-uint32_t uvc_fraction_to_interval(uint32_t numerator, uint32_t denominator)
+u32 uvc_fraction_to_interval(u32 numerator, u32 denominator)
 {
-	uint32_t multiplier;
+	u32 multiplier;
 
 	/* Saturate the result if the operation would overflow. */
 	if (denominator == 0 ||
-	    numerator/denominator >= ((uint32_t)-1)/10000000)
-		return (uint32_t)-1;
+	    numerator/denominator >= ((u32)-1)/10000000)
+		return (u32)-1;
 
 	/* Divide both the denominator and the multiplier by two until
 	 * numerator * multiplier doesn't overflow. If anyone knows a better
 	 * algorithm please let me know.
 	 */
 	multiplier = 10000000;
-	while (numerator > ((uint32_t)-1)/multiplier) {
+	while (numerator > ((u32)-1)/multiplier) {
 		multiplier /= 2;
 		denominator /= 2;
 	}
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index e8db37937571..784796f9f2e1 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -336,7 +336,7 @@ static int uvc_v4l2_set_format(struct uvc_streaming *stream,
 static int uvc_v4l2_get_streamparm(struct uvc_streaming *stream,
 		struct v4l2_streamparm *parm)
 {
-	uint32_t numerator, denominator;
+	u32 numerator, denominator;
 
 	if (parm->type != stream->type)
 		return -EINVAL;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index aba0e74358bd..394c6dcdc85b 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -777,9 +777,9 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		      struct uvc_xu_control_query *xqry);
 
 /* Utility functions */
-void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
+void uvc_simplify_fraction(u32 *numerator, u32 *denominator,
 			   unsigned int n_terms, unsigned int threshold);
-uint32_t uvc_fraction_to_interval(uint32_t numerator, uint32_t denominator);
+u32 uvc_fraction_to_interval(u32 numerator, u32 denominator);
 struct usb_host_endpoint *uvc_find_endpoint(struct usb_host_interface *alts,
 					    __u8 epaddr);
 
-- 
Regards,

Laurent Pinchart
