Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41402 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeAPVHI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 16:07:08 -0500
Received: from avalon.bb.dnainternet.fi (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 277E720272
        for <linux-media@vger.kernel.org>; Tue, 16 Jan 2018 22:06:16 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] uvcvideo: Drop extern keyword in function declarations
Date: Tue, 16 Jan 2018 23:07:04 +0200
Message-Id: <20180116210707.7727-2-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20180116210707.7727-1-laurent.pinchart@ideasonboard.com>
References: <20180116210707.7727-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The extern keyword isn't needed to declare functions in header files.
Drop it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvcvideo.h | 145 +++++++++++++++++++--------------------
 1 file changed, 71 insertions(+), 74 deletions(-)

diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 961d7c13b27b..aba0e74358bd 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -667,40 +667,39 @@ extern unsigned int uvc_hw_timestamps_param;
 /* Core driver */
 extern struct uvc_driver uvc_driver;
 
-extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
+struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
 
 /* Video buffers queue management. */
-extern int uvc_queue_init(struct uvc_video_queue *queue,
-		enum v4l2_buf_type type, int drop_corrupted);
-extern void uvc_queue_release(struct uvc_video_queue *queue);
-extern int uvc_request_buffers(struct uvc_video_queue *queue,
-		struct v4l2_requestbuffers *rb);
-extern int uvc_query_buffer(struct uvc_video_queue *queue,
-		struct v4l2_buffer *v4l2_buf);
-extern int uvc_create_buffers(struct uvc_video_queue *queue,
-		struct v4l2_create_buffers *v4l2_cb);
-extern int uvc_queue_buffer(struct uvc_video_queue *queue,
-		struct v4l2_buffer *v4l2_buf);
-extern int uvc_export_buffer(struct uvc_video_queue *queue,
-		struct v4l2_exportbuffer *exp);
-extern int uvc_dequeue_buffer(struct uvc_video_queue *queue,
-		struct v4l2_buffer *v4l2_buf, int nonblocking);
-extern int uvc_queue_streamon(struct uvc_video_queue *queue,
-			      enum v4l2_buf_type type);
-extern int uvc_queue_streamoff(struct uvc_video_queue *queue,
-			       enum v4l2_buf_type type);
-extern void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect);
-extern struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
-		struct uvc_buffer *buf);
-extern int uvc_queue_mmap(struct uvc_video_queue *queue,
-		struct vm_area_struct *vma);
-extern unsigned int uvc_queue_poll(struct uvc_video_queue *queue,
-		struct file *file, poll_table *wait);
+int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
+		  int drop_corrupted);
+void uvc_queue_release(struct uvc_video_queue *queue);
+int uvc_request_buffers(struct uvc_video_queue *queue,
+			struct v4l2_requestbuffers *rb);
+int uvc_query_buffer(struct uvc_video_queue *queue,
+		     struct v4l2_buffer *v4l2_buf);
+int uvc_create_buffers(struct uvc_video_queue *queue,
+		       struct v4l2_create_buffers *v4l2_cb);
+int uvc_queue_buffer(struct uvc_video_queue *queue,
+		     struct v4l2_buffer *v4l2_buf);
+int uvc_export_buffer(struct uvc_video_queue *queue,
+		      struct v4l2_exportbuffer *exp);
+int uvc_dequeue_buffer(struct uvc_video_queue *queue,
+		       struct v4l2_buffer *v4l2_buf, int nonblocking);
+int uvc_queue_streamon(struct uvc_video_queue *queue,
+		       enum v4l2_buf_type type);
+int uvc_queue_streamoff(struct uvc_video_queue *queue,
+			enum v4l2_buf_type type);
+void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect);
+struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
+					 struct uvc_buffer *buf);
+int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma);
+unsigned int uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
+			    poll_table *wait);
 #ifndef CONFIG_MMU
-extern unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
-		unsigned long pgoff);
+unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
+					  unsigned long pgoff);
 #endif
-extern int uvc_queue_allocated(struct uvc_video_queue *queue);
+int uvc_queue_allocated(struct uvc_video_queue *queue);
 static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
 {
 	return vb2_is_streaming(&queue->queue);
@@ -711,18 +710,18 @@ extern const struct v4l2_ioctl_ops uvc_ioctl_ops;
 extern const struct v4l2_file_operations uvc_fops;
 
 /* Media controller */
-extern int uvc_mc_register_entities(struct uvc_video_chain *chain);
-extern void uvc_mc_cleanup_entity(struct uvc_entity *entity);
+int uvc_mc_register_entities(struct uvc_video_chain *chain);
+void uvc_mc_cleanup_entity(struct uvc_entity *entity);
 
 /* Video */
-extern int uvc_video_init(struct uvc_streaming *stream);
-extern int uvc_video_suspend(struct uvc_streaming *stream);
-extern int uvc_video_resume(struct uvc_streaming *stream, int reset);
-extern int uvc_video_enable(struct uvc_streaming *stream, int enable);
-extern int uvc_probe_video(struct uvc_streaming *stream,
-		struct uvc_streaming_control *probe);
-extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
-		__u8 intfnum, __u8 cs, void *data, __u16 size);
+int uvc_video_init(struct uvc_streaming *stream);
+int uvc_video_suspend(struct uvc_streaming *stream);
+int uvc_video_resume(struct uvc_streaming *stream, int reset);
+int uvc_video_enable(struct uvc_streaming *stream, int enable);
+int uvc_probe_video(struct uvc_streaming *stream,
+		    struct uvc_streaming_control *probe);
+int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
+		   __u8 intfnum, __u8 cs, void *data, __u16 size);
 void uvc_video_clock_update(struct uvc_streaming *stream,
 			    struct vb2_v4l2_buffer *vbuf,
 			    struct uvc_buffer *buf);
@@ -737,32 +736,32 @@ int uvc_register_video_device(struct uvc_device *dev,
 			      const struct v4l2_ioctl_ops *ioctl_ops);
 
 /* Status */
-extern int uvc_status_init(struct uvc_device *dev);
-extern void uvc_status_cleanup(struct uvc_device *dev);
-extern int uvc_status_start(struct uvc_device *dev, gfp_t flags);
-extern void uvc_status_stop(struct uvc_device *dev);
+int uvc_status_init(struct uvc_device *dev);
+void uvc_status_cleanup(struct uvc_device *dev);
+int uvc_status_start(struct uvc_device *dev, gfp_t flags);
+void uvc_status_stop(struct uvc_device *dev);
 
 /* Controls */
 extern const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops;
 
-extern int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
-		struct v4l2_queryctrl *v4l2_ctrl);
-extern int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
-		struct v4l2_querymenu *query_menu);
-
-extern int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
-		const struct uvc_control_mapping *mapping);
-extern int uvc_ctrl_init_device(struct uvc_device *dev);
-extern void uvc_ctrl_cleanup_device(struct uvc_device *dev);
-extern int uvc_ctrl_restore_values(struct uvc_device *dev);
-
-extern int uvc_ctrl_begin(struct uvc_video_chain *chain);
-extern int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
-			const struct v4l2_ext_control *xctrls,
-			unsigned int xctrls_count);
+int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
+			struct v4l2_queryctrl *v4l2_ctrl);
+int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
+			struct v4l2_querymenu *query_menu);
+
+int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
+			 const struct uvc_control_mapping *mapping);
+int uvc_ctrl_init_device(struct uvc_device *dev);
+void uvc_ctrl_cleanup_device(struct uvc_device *dev);
+int uvc_ctrl_restore_values(struct uvc_device *dev);
+
+int uvc_ctrl_begin(struct uvc_video_chain *chain);
+int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
+		      const struct v4l2_ext_control *xctrls,
+		      unsigned int xctrls_count);
 static inline int uvc_ctrl_commit(struct uvc_fh *handle,
-			const struct v4l2_ext_control *xctrls,
-			unsigned int xctrls_count)
+				  const struct v4l2_ext_control *xctrls,
+				  unsigned int xctrls_count)
 {
 	return __uvc_ctrl_commit(handle, 0, xctrls, xctrls_count);
 }
@@ -771,25 +770,23 @@ static inline int uvc_ctrl_rollback(struct uvc_fh *handle)
 	return __uvc_ctrl_commit(handle, 1, NULL, 0);
 }
 
-extern int uvc_ctrl_get(struct uvc_video_chain *chain,
-		struct v4l2_ext_control *xctrl);
-extern int uvc_ctrl_set(struct uvc_video_chain *chain,
-		struct v4l2_ext_control *xctrl);
+int uvc_ctrl_get(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl);
+int uvc_ctrl_set(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl);
 
-extern int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
-		struct uvc_xu_control_query *xqry);
+int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
+		      struct uvc_xu_control_query *xqry);
 
 /* Utility functions */
-extern void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
-		unsigned int n_terms, unsigned int threshold);
-extern uint32_t uvc_fraction_to_interval(uint32_t numerator,
-		uint32_t denominator);
-extern struct usb_host_endpoint *uvc_find_endpoint(
-		struct usb_host_interface *alts, __u8 epaddr);
+void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
+			   unsigned int n_terms, unsigned int threshold);
+uint32_t uvc_fraction_to_interval(uint32_t numerator, uint32_t denominator);
+struct usb_host_endpoint *uvc_find_endpoint(struct usb_host_interface *alts,
+					    __u8 epaddr);
 
 /* Quirks support */
 void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
-		struct uvc_buffer *buf, struct uvc_buffer *meta_buf);
+			     struct uvc_buffer *buf,
+			     struct uvc_buffer *meta_buf);
 
 /* debugfs and statistics */
 void uvc_debugfs_init(void);
-- 
Regards,

Laurent Pinchart
