Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDC5C169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 06:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D8F0218AC
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 06:44:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rbJcIMWE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfAaGos (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 01:44:48 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43975 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfAaGos (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 01:44:48 -0500
Received: by mail-wr1-f66.google.com with SMTP id r10so1935440wrs.10
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 22:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=35kYapY5d8ZO5sbhcg+ZFSC1FnH4K88VnQH4MVL2S5w=;
        b=rbJcIMWEixNNcVplsIV0conh9TF7ULIyPcU5AvI1Ua/uwbRrE+n5w7gnxH5gbSvQbt
         UDX74ad2l8mDapOax/z4BRimPS7hEZj4Ohmpmx70a2usacmhLxMRcK1kiv10TSv3qb/M
         A8UyFLu6j+N0mvGYlK8vPPOZMqd30NTTk00WHEFNxxnIbg2Fj2NIATn8lB9cNMQURNOb
         +Jd/J2Mp/2jmO3EdI1j3HcGwVySZ22CxRD6V1uDtNhVisNfoOesfh9TUykdwOUhpFE3o
         gscCK8sNvX8uERUBKGCaYoOAChU/W8oErM1rqoGoD5AnDfSanSeyWTKsVEddnKDdOyaG
         zVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=35kYapY5d8ZO5sbhcg+ZFSC1FnH4K88VnQH4MVL2S5w=;
        b=BVqBpUjG5+AGNP3egJc6zZ2LnajZTDxbvaty6c5P1cU9RWYuP5je95QcIU/e0G6ltL
         IWpNGxkPnOt7toAhDEIY5iCV3YM/u5MZwKjh7wL4k+ORDIjTlFOw0n3xGsG1Dwg0CoYT
         LlZvo3c67/59QAGkGHpVrrBPBgCnsKzQqr20Xe9qISq4X7HtoWtdKhEggnkDYlix25W8
         jrtAUI3pkvduJ+3gUsrsKIcWD6fL2775DweTac8OWlxWbMQs3hG7LWXm+VfNa3DyFWRz
         ey20rIi1cLC/rPSATvt7kWA60vb+xS7I34CTUt7pl+GopBXihGmMllB/T0qnBuyItgC1
         4nZQ==
X-Gm-Message-State: AJcUukdIGWtujGGqPX8kNl0LtprmpgPDUyNstgRrrOx+luj1DYYZ32rc
        bgAobE8gP2mT0+PrhIgOWOx8XvrQs0s=
X-Google-Smtp-Source: ALg8bN4RLdoLgk5kHGLgKYjERacS2E8MjQAi+d+9l3ds9coNkh24nsiQOz73aX+FFEiW40iZcWa9Sg==
X-Received: by 2002:adf:e383:: with SMTP id e3mr32043233wrm.31.1548917085325;
        Wed, 30 Jan 2019 22:44:45 -0800 (PST)
Received: from localhost.localdomain ([87.69.88.129])
        by smtp.gmail.com with ESMTPSA id y13sm2164135wrn.73.2019.01.30.22.44.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 22:44:44 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3] v4l2-ctl: add function vidcap_get_and_update_fmt
Date:   Wed, 30 Jan 2019 22:44:26 -0800
Message-Id: <20190131064426.43042-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add a function vidcap_get_and_update_fmt to set
the format from cmd params. Use it in capture_setup.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
Changes from v2:
move get_cap_compose_rect to after s_fmt in capture_setup

 utils/v4l2-ctl/v4l2-ctl-streaming.cpp |  15 ++-
 utils/v4l2-ctl/v4l2-ctl-vidcap.cpp    | 134 ++++++++++++++------------
 utils/v4l2-ctl/v4l2-ctl.h             |   1 +
 3 files changed, 89 insertions(+), 61 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index d6c3f6a9..766872b5 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1894,7 +1894,6 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in, cv4l_fd *exp_fd)
 		fprintf(stderr, "%s: fd.streamoff error\n", __func__);
 		return -1;
 	}
-	get_cap_compose_rect(fd);
 
 	/* release any buffer allocated */
 	if (in.reqbufs(&fd)) {
@@ -1902,17 +1901,31 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in, cv4l_fd *exp_fd)
 		return -1;
 	}
 
+	if (options[OptSetVideoFormat]) {
+		cv4l_fmt fmt;
+
+		if (vidcap_get_and_update_fmt(fd, fmt)) {
+			fprintf(stderr, "%s: vidcap_get_and_update_fmt error\n",
+				__func__);
+			return -1;
+		}
+		fd.s_fmt(fmt, in.g_type());
+	}
+	get_cap_compose_rect(fd);
+
 	if (in.reqbufs(&fd, reqbufs_count_cap)) {
 		fprintf(stderr, "%s: in.reqbufs %u error\n", __func__,
 			reqbufs_count_cap);
 		return -1;
 	}
+
 	if (exp_fd && in.export_bufs(exp_fd, exp_fd->g_type()))
 		return -1;
 	if (in.obtain_bufs(&fd) || in.queue_all(&fd)) {
 		fprintf(stderr, "%s: in.obtain_bufs error\n", __func__);
 		return -1;
 	}
+
 	if (fd.streamon(in.g_type())) {
 		fprintf(stderr, "%s: fd.streamon error\n", __func__);
 		return -1;
diff --git a/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp b/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
index dc17a868..1e32fd2a 100644
--- a/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
@@ -153,74 +153,88 @@ void vidcap_cmd(int ch, char *optarg)
 	}
 }
 
-void vidcap_set(cv4l_fd &_fd)
+int vidcap_get_and_update_fmt(cv4l_fd &_fd, struct v4l2_format &vfmt)
 {
 	int fd = _fd.g_fd();
 	int ret;
 
-	if (options[OptSetVideoFormat] || options[OptTryVideoFormat]) {
-		struct v4l2_format vfmt;
+	memset(&vfmt, 0, sizeof(vfmt));
+	vfmt.fmt.pix.priv = priv_magic;
+	vfmt.type = vidcap_buftype;
 
-		memset(&vfmt, 0, sizeof(vfmt));
-		vfmt.fmt.pix.priv = priv_magic;
-		vfmt.type = vidcap_buftype;
+	ret = doioctl(fd, VIDIOC_G_FMT, &vfmt);
+	if (ret)
+		return ret;
 
-		if (doioctl(fd, VIDIOC_G_FMT, &vfmt) == 0) {
-			if (is_multiplanar) {
-				if (set_fmts & FmtWidth)
-					vfmt.fmt.pix_mp.width = width;
-				if (set_fmts & FmtHeight)
-					vfmt.fmt.pix_mp.height = height;
-				if (set_fmts & FmtPixelFormat) {
-					vfmt.fmt.pix_mp.pixelformat = pixfmt;
-					if (vfmt.fmt.pix_mp.pixelformat < 256) {
-						vfmt.fmt.pix_mp.pixelformat =
-							find_pixel_format(fd, vfmt.fmt.pix_mp.pixelformat,
-									false, true);
-					}
-				}
-				if (set_fmts & FmtField)
-					vfmt.fmt.pix_mp.field = field;
-				if (set_fmts & FmtFlags)
-					vfmt.fmt.pix_mp.flags = flags;
-				if (set_fmts & FmtBytesPerLine) {
-					for (unsigned i = 0; i < VIDEO_MAX_PLANES; i++)
-						vfmt.fmt.pix_mp.plane_fmt[i].bytesperline =
-							bytesperline[i];
-				} else {
-					/* G_FMT might return bytesperline values > width,
-					 * reset them to 0 to force the driver to update them
-					 * to the closest value for the new width. */
-					for (unsigned i = 0; i < vfmt.fmt.pix_mp.num_planes; i++)
-						vfmt.fmt.pix_mp.plane_fmt[i].bytesperline = 0;
-				}
-			} else {
-				if (set_fmts & FmtWidth)
-					vfmt.fmt.pix.width = width;
-				if (set_fmts & FmtHeight)
-					vfmt.fmt.pix.height = height;
-				if (set_fmts & FmtPixelFormat) {
-					vfmt.fmt.pix.pixelformat = pixfmt;
-					if (vfmt.fmt.pix.pixelformat < 256) {
-						vfmt.fmt.pix.pixelformat =
-							find_pixel_format(fd, vfmt.fmt.pix.pixelformat,
-									false, false);
-					}
-				}
-				if (set_fmts & FmtField)
-					vfmt.fmt.pix.field = field;
-				if (set_fmts & FmtFlags)
-					vfmt.fmt.pix.flags = flags;
-				if (set_fmts & FmtBytesPerLine) {
-					vfmt.fmt.pix.bytesperline = bytesperline[0];
-				} else {
-					/* G_FMT might return a bytesperline value > width,
-					 * reset this to 0 to force the driver to update it
-					 * to the closest value for the new width. */
-					vfmt.fmt.pix.bytesperline = 0;
-				}
+	if (is_multiplanar) {
+		if (set_fmts & FmtWidth)
+			vfmt.fmt.pix_mp.width = width;
+		if (set_fmts & FmtHeight)
+			vfmt.fmt.pix_mp.height = height;
+		if (set_fmts & FmtPixelFormat) {
+			vfmt.fmt.pix_mp.pixelformat = pixfmt;
+			if (vfmt.fmt.pix_mp.pixelformat < 256) {
+				vfmt.fmt.pix_mp.pixelformat =
+					find_pixel_format(fd, vfmt.fmt.pix_mp.pixelformat,
+							  false, true);
+			}
+		}
+		if (set_fmts & FmtField)
+			vfmt.fmt.pix_mp.field = field;
+		if (set_fmts & FmtFlags)
+			vfmt.fmt.pix_mp.flags = flags;
+		if (set_fmts & FmtBytesPerLine) {
+			for (unsigned i = 0; i < VIDEO_MAX_PLANES; i++)
+				vfmt.fmt.pix_mp.plane_fmt[i].bytesperline =
+					bytesperline[i];
+		} else {
+			/*
+			 * G_FMT might return bytesperline values > width,
+			 * reset them to 0 to force the driver to update them
+			 * to the closest value for the new width.
+			 */
+			for (unsigned i = 0; i < vfmt.fmt.pix_mp.num_planes; i++)
+				vfmt.fmt.pix_mp.plane_fmt[i].bytesperline = 0;
+		}
+	} else {
+		if (set_fmts & FmtWidth)
+			vfmt.fmt.pix.width = width;
+		if (set_fmts & FmtHeight)
+			vfmt.fmt.pix.height = height;
+		if (set_fmts & FmtPixelFormat) {
+			vfmt.fmt.pix.pixelformat = pixfmt;
+			if (vfmt.fmt.pix.pixelformat < 256) {
+				vfmt.fmt.pix.pixelformat =
+					find_pixel_format(fd, vfmt.fmt.pix.pixelformat,
+							  false, false);
 			}
+		}
+		if (set_fmts & FmtField)
+			vfmt.fmt.pix.field = field;
+		if (set_fmts & FmtFlags)
+			vfmt.fmt.pix.flags = flags;
+		if (set_fmts & FmtBytesPerLine) {
+			vfmt.fmt.pix.bytesperline = bytesperline[0];
+		} else {
+			/*
+			 * G_FMT might return a bytesperline value > width,
+			 * reset this to 0 to force the driver to update it
+			 * to the closest value for the new width.
+			 */
+			vfmt.fmt.pix.bytesperline = 0;
+		}
+	}
+	return 0;
+}
+
+void vidcap_set(cv4l_fd &_fd)
+{
+	if (options[OptSetVideoFormat] || options[OptTryVideoFormat]) {
+		int fd = _fd.g_fd();
+		int ret;
+		struct v4l2_format vfmt;
 
+		if (vidcap_get_and_update_fmt(_fd, vfmt) == 0) {
 			if (options[OptSetVideoFormat])
 				ret = doioctl(fd, VIDIOC_S_FMT, &vfmt);
 			else
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index dcc39b51..739dc5a9 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -348,6 +348,7 @@ void stds_list(cv4l_fd &fd);
 // v4l2-ctl-vidcap.cpp
 void vidcap_usage(void);
 void vidcap_cmd(int ch, char *optarg);
+int vidcap_get_and_update_fmt(cv4l_fd &_fd, struct v4l2_format &vfmt);
 void vidcap_set(cv4l_fd &fd);
 void vidcap_get(cv4l_fd &fd);
 void vidcap_list(cv4l_fd &fd);
-- 
2.17.1

