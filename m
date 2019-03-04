Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0B3C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3197F2070B
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfCDMf7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 07:35:59 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:33948 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726095AbfCDMf5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Mar 2019 07:35:57 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x24CQgsd020023;
        Mon, 4 Mar 2019 13:35:51 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2r0ju8m17a-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 04 Mar 2019 13:35:51 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B30E031;
        Mon,  4 Mar 2019 12:35:50 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 91B822A3C;
        Mon,  4 Mar 2019 12:35:50 +0000 (GMT)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by SAFEX1HUBCAS23.st.com
 (10.75.90.46) with Microsoft SMTP Server (TLS) id 14.3.361.1; Mon, 4 Mar 2019
 13:35:50 +0100
Received: from localhost (10.201.23.19) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.361.1; Mon, 4 Mar 2019 13:35:49
 +0100
From:   Hugues Fruchet <hugues.fruchet@st.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC:     <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Hugues Fruchet" <hugues.fruchet@st.com>
Subject: [PATCH] media: uvcvideo: Read support
Date:   Mon, 4 Mar 2019 13:35:25 +0100
Message-ID: <1551702925-7739-2-git-send-email-hugues.fruchet@st.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551702925-7739-1-git-send-email-hugues.fruchet@st.com>
References: <1551702925-7739-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.19]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-04_05:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support of read() call from userspace by implementing
uvc_v4l2_read() with vb2_read() helper.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 15 ++++++++++++++-
 drivers/media/usb/uvc/uvc_v4l2.c  | 11 ++++++++---
 drivers/media/usb/uvc/uvcvideo.h  |  2 ++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 682698e..0c8a0a8 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -227,7 +227,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	int ret;
 
 	queue->queue.type = type;
-	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
+	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 	queue->queue.drv_priv = queue;
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
@@ -361,6 +361,19 @@ int uvc_queue_streamoff(struct uvc_video_queue *queue, enum v4l2_buf_type type)
 	return ret;
 }
 
+ssize_t uvc_queue_read(struct uvc_video_queue *queue, struct file *file,
+		       char __user *buf, size_t count, loff_t *ppos)
+{
+	ssize_t ret;
+
+	mutex_lock(&queue->mutex);
+	ret = vb2_read(&queue->queue, buf, count, ppos,
+		       file->f_flags & O_NONBLOCK);
+	mutex_unlock(&queue->mutex);
+
+	return ret;
+}
+
 int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 {
 	return vb2_mmap(&queue->queue, vma);
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 84be596..3866832 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -594,7 +594,8 @@ static int uvc_ioctl_querycap(struct file *file, void *fh,
 	strscpy(cap->driver, "uvcvideo", sizeof(cap->driver));
 	strscpy(cap->card, vdev->name, sizeof(cap->card));
 	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
+	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING |
+			    V4L2_CAP_READWRITE
 			  | chain->caps;
 
 	return 0;
@@ -1434,8 +1435,12 @@ static long uvc_v4l2_compat_ioctl32(struct file *file,
 static ssize_t uvc_v4l2_read(struct file *file, char __user *data,
 		    size_t count, loff_t *ppos)
 {
-	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_read: not implemented.\n");
-	return -EINVAL;
+	struct uvc_fh *handle = file->private_data;
+	struct uvc_streaming *stream = handle->stream;
+
+	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_read\n");
+
+	return uvc_queue_read(&stream->queue, file, data, count, ppos);
 }
 
 static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index c7c1baa..5d0515c 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -766,6 +766,8 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 					 struct uvc_buffer *buf);
 struct uvc_buffer *uvc_queue_get_current_buffer(struct uvc_video_queue *queue);
 void uvc_queue_buffer_release(struct uvc_buffer *buf);
+ssize_t uvc_queue_read(struct uvc_video_queue *queue, struct file *file,
+		       char __user *buf, size_t count, loff_t *ppos);
 int uvc_queue_mmap(struct uvc_video_queue *queue,
 		   struct vm_area_struct *vma);
 __poll_t uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
-- 
2.7.4

