Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:56327 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932088AbcLYSqm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:46:42 -0500
Subject: [PATCH 14/19] [media] uvc_video: Combine substrings for 22 messages
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <e99fe19a-ebeb-57c4-5fc0-2d33c9541ab2@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:46:33 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 17:54:05 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

* Thus fix the affected source code places.

* Improve indentation for passed parameters.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_video.c | 108 ++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 52 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 05b396f033ca..b7fc1762c3da 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -77,9 +77,9 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 	ret = __uvc_query_ctrl(dev, query, unit, intfnum, cs, data, size,
 				UVC_CTRL_CONTROL_TIMEOUT);
 	if (ret != size) {
-		uvc_printk(KERN_ERR, "Failed to query (%s) UVC control %u on "
-			"unit %u: %d (exp. %u).\n", uvc_query_name(query), cs,
-			unit, ret, size);
+		uvc_printk(KERN_ERR,
+			   "Failed to query (%s) UVC control %u on unit %u: %d (exp. %u).\n",
+			   uvc_query_name(query), cs, unit, ret, size);
 		return -EIO;
 	}
 
@@ -188,9 +188,9 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 		 * answer a GET_MIN or GET_MAX request with the wCompQuality
 		 * field only.
 		 */
-		uvc_warn_once(stream->dev, UVC_WARN_MINMAX, "UVC non "
-			"compliance - GET_MIN/MAX(PROBE) incorrectly "
-			"supported. Enabling workaround.\n");
+		uvc_warn_once(stream->dev,
+			      UVC_WARN_MINMAX,
+			      "UVC non compliance - GET_MIN/MAX(PROBE) incorrectly supported. Enabling workaround.\n");
 		memset(ctrl, 0, sizeof *ctrl);
 		ctrl->wCompQuality = le16_to_cpup((__le16 *)data);
 		ret = 0;
@@ -200,15 +200,15 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 		 * video probe control. Warn once and return, the caller will
 		 * fall back to GET_CUR.
 		 */
-		uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF, "UVC non "
-			"compliance - GET_DEF(PROBE) not supported. "
-			"Enabling workaround.\n");
+		uvc_warn_once(stream->dev,
+			      UVC_WARN_PROBE_DEF,
+			      "UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.\n");
 		ret = -EIO;
 		goto out;
 	} else if (ret != size) {
-		uvc_printk(KERN_ERR, "Failed to query (%u) UVC %s control : "
-			"%d (exp. %u).\n", query, probe ? "probe" : "commit",
-			ret, size);
+		uvc_printk(KERN_ERR,
+			   "Failed to query (%u) UVC %s control : %d (exp. %u).\n",
+			   query, probe ? "probe" : "commit", ret, size);
 		ret = -EIO;
 		goto out;
 	}
@@ -287,9 +287,9 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 		probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
 		size, uvc_timeout_param);
 	if (ret != size) {
-		uvc_printk(KERN_ERR, "Failed to set UVC %s control : "
-			"%d (exp. %u).\n", probe ? "probe" : "commit",
-			ret, size);
+		uvc_printk(KERN_ERR,
+			   "Failed to set UVC %s control : %d (exp. %u).\n",
+			   probe ? "probe" : "commit", ret, size);
 		ret = -EIO;
 	}
 
@@ -652,8 +652,8 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 
 	sof = y;
 
-	uvc_trace(UVC_TRACE_CLOCK, "%s: PTS %u y %llu.%06llu SOF %u.%06llu "
-		  "(x1 %u x2 %u y1 %u y2 %u SOF offset %u)\n",
+	uvc_trace(UVC_TRACE_CLOCK,
+		  "%s: PTS %u y %llu.%06llu SOF %u.%06llu (x1 %u x2 %u y1 %u y2 %u SOF offset %u)\n",
 		  stream->dev->name, buf->pts,
 		  y >> 16, div_u64((y & 0xffff) * 1000000, 65536),
 		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
@@ -694,8 +694,8 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 		ts.tv_nsec -= NSEC_PER_SEC;
 	}
 
-	uvc_trace(UVC_TRACE_CLOCK, "%s: SOF %u.%06llu y %llu ts %llu "
-		  "buf ts %llu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
+	uvc_trace(UVC_TRACE_CLOCK,
+		  "%s: SOF %u.%06llu y %llu ts %llu buf ts %llu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
 		  stream->dev->name,
 		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
 		  y, timespec_to_ns(&ts), vbuf->vb2_buf.timestamp,
@@ -829,9 +829,8 @@ static void uvc_video_stats_update(struct uvc_streaming *stream)
 {
 	struct uvc_stats_frame *frame = &stream->stats.frame;
 
-	uvc_trace(UVC_TRACE_STATS, "frame %u stats: %u/%u/%u packets, "
-		  "%u/%u/%u pts (%searly %sinitial), %u/%u scr, "
-		  "last pts/stc/sof %u/%u/%u\n",
+	uvc_trace(UVC_TRACE_STATS,
+		  "frame %u stats: %u/%u/%u packets, %u/%u/%u pts (%searly %sinitial), %u/%u scr, last pts/stc/sof %u/%u/%u\n",
 		  stream->sequence, frame->first_data,
 		  frame->nb_packets - frame->nb_empty, frame->nb_packets,
 		  frame->nb_pts_diffs, frame->last_pts_diff, frame->nb_pts,
@@ -1002,8 +1001,8 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 
 	/* Mark the buffer as bad if the error bit is set. */
 	if (data[1] & UVC_STREAM_ERR) {
-		uvc_trace(UVC_TRACE_FRAME, "Marking buffer as bad (error bit "
-			  "set).\n");
+		uvc_trace(UVC_TRACE_FRAME,
+			  "Marking buffer as bad (error bit set).\n");
 		buf->error = 1;
 	}
 
@@ -1019,8 +1018,8 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		struct timespec ts;
 
 		if (fid == stream->last_fid) {
-			uvc_trace(UVC_TRACE_FRAME, "Dropping payload (out of "
-				"sync).\n");
+			uvc_trace(UVC_TRACE_FRAME,
+				  "Dropping payload (out of sync).\n");
 			if ((stream->dev->quirks & UVC_QUIRK_STREAM_NO_FID) &&
 			    (data[1] & UVC_STREAM_EOF))
 				stream->last_fid ^= UVC_STREAM_FID;
@@ -1053,8 +1052,8 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	 * previous payload had the EOF bit set.
 	 */
 	if (fid != stream->last_fid && buf->bytesused != 0) {
-		uvc_trace(UVC_TRACE_FRAME, "Frame complete (FID bit "
-				"toggled).\n");
+		uvc_trace(UVC_TRACE_FRAME,
+			  "Frame complete (FID bit toggled).\n");
 		buf->state = UVC_BUF_STATE_READY;
 		return -EAGAIN;
 	}
@@ -1166,8 +1165,9 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 
 	for (i = 0; i < urb->number_of_packets; ++i) {
 		if (urb->iso_frame_desc[i].status < 0) {
-			uvc_trace(UVC_TRACE_FRAME, "USB isochronous frame "
-				"lost (%d).\n", urb->iso_frame_desc[i].status);
+			uvc_trace(UVC_TRACE_FRAME,
+				  "USB isochronous frame lost (%d).\n",
+				  urb->iso_frame_desc[i].status);
 			/* Mark the buffer as faulty. */
 			if (buf != NULL)
 				buf->error = 1;
@@ -1328,8 +1328,9 @@ static void uvc_video_complete(struct urb *urb)
 		break;
 
 	default:
-		uvc_printk(KERN_WARNING, "Non-zero status (%d) in video "
-			"completion handler.\n", urb->status);
+		uvc_printk(KERN_WARNING,
+			   "Non-zero status (%d) in video completion handler.\n",
+			   urb->status);
 
 	case -ENOENT:		/* usb_kill_urb() called. */
 		if (stream->frozen)
@@ -1424,15 +1425,16 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 		}
 
 		if (i == UVC_URBS) {
-			uvc_trace(UVC_TRACE_VIDEO, "Allocated %u URB buffers "
-				"of %ux%u bytes each.\n", UVC_URBS, npackets,
-				psize);
+			uvc_trace(UVC_TRACE_VIDEO,
+				  "Allocated %u URB buffers of %ux%u bytes each.\n",
+				  UVC_URBS, npackets, psize);
 			return npackets;
 		}
 	}
 
-	uvc_trace(UVC_TRACE_VIDEO, "Failed to allocate URB buffers (%u bytes "
-		"per packet).\n", psize);
+	uvc_trace(UVC_TRACE_VIDEO,
+		  "Failed to allocate URB buffers (%u bytes per packet).\n",
+		  psize);
 	return 0;
 }
 
@@ -1623,12 +1625,13 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		bandwidth = stream->ctrl.dwMaxPayloadTransferSize;
 
 		if (bandwidth == 0) {
-			uvc_trace(UVC_TRACE_VIDEO, "Device requested null "
-				"bandwidth, defaulting to lowest.\n");
+			uvc_trace(UVC_TRACE_VIDEO,
+				  "Device requested null bandwidth, defaulting to lowest.\n");
 			bandwidth = 1;
 		} else {
-			uvc_trace(UVC_TRACE_VIDEO, "Device requested %u "
-				"B/frame bandwidth.\n", bandwidth);
+			uvc_trace(UVC_TRACE_VIDEO,
+				  "Device requested %u B/frame bandwidth.\n",
+				  bandwidth);
 		}
 
 		for (i = 0; i < intf->num_altsetting; ++i) {
@@ -1651,14 +1654,14 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		}
 
 		if (best_ep == NULL) {
-			uvc_trace(UVC_TRACE_VIDEO, "No fast enough alt setting "
-				"for requested bandwidth.\n");
+			uvc_trace(UVC_TRACE_VIDEO,
+				  "No fast enough alt setting for requested bandwidth.\n");
 			return -EIO;
 		}
 
-		uvc_trace(UVC_TRACE_VIDEO, "Selecting alternate setting %u "
-			"(%u B/frame bandwidth).\n", altsetting, best_psize);
-
+		uvc_trace(UVC_TRACE_VIDEO,
+			  "Selecting alternate setting %u (%u B/frame bandwidth).\n",
+			  altsetting, best_psize);
 		ret = usb_set_interface(stream->dev->udev, intfnum, altsetting);
 		if (ret < 0)
 			return ret;
@@ -1681,8 +1684,9 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 	for (i = 0; i < UVC_URBS; ++i) {
 		ret = usb_submit_urb(stream->urb[i], gfp_flags);
 		if (ret < 0) {
-			uvc_printk(KERN_ERR, "Failed to submit URB %u "
-					"(%d).\n", i, ret);
+			uvc_printk(KERN_ERR,
+				   "Failed to submit URB %u (%d).\n",
+				   i, ret);
 			uvc_uninit_video(stream, 1);
 			return ret;
 		}
@@ -1816,8 +1820,8 @@ int uvc_video_init(struct uvc_streaming *stream)
 	}
 
 	if (format->nframes == 0) {
-		uvc_printk(KERN_INFO, "No frame descriptor found for the "
-			"default format.\n");
+		uvc_printk(KERN_INFO,
+			   "No frame descriptor found for the default format.\n");
 		return -EINVAL;
 	}
 
@@ -1851,8 +1855,8 @@ int uvc_video_init(struct uvc_streaming *stream)
 		if (stream->intf->num_altsetting == 1)
 			stream->decode = uvc_video_encode_bulk;
 		else {
-			uvc_printk(KERN_INFO, "Isochronous endpoints are not "
-				"supported for video output devices.\n");
+			uvc_printk(KERN_INFO,
+				   "Isochronous endpoints are not supported for video output devices.\n");
 			return -EINVAL;
 		}
 	}
-- 
2.11.0

