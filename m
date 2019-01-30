Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D23C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 14:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 253D6218A3
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 14:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bThUZ4z9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbfA3Omq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:42:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40069 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfA3Omq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 09:42:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id f188so21761783wmf.5
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 06:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aomUgd5kRKclYU/njJf6fhaEJKCyyPfTGQHWP/WcwJY=;
        b=bThUZ4z9jK6EiDLV3IJwIseAs/ZlccA/adxvjIfLhWgccW21eookECT7pUzACx9srp
         CjbuPtwwoCty3UjotoyakNk3UAVvHjbMcoI4kLujTqg5SqcCkiYB7WZXAul3zyGzbLIj
         y6KDrOeqaFj7OKDS+rpIjdxhOIjvC7Rc/5BVYBqllD6Z+wmK0uANf5s+yICTUljX8FQR
         z1EofWHhpBV/G7OK87o37GAc7ap+rn29Kj6PpMIgJudmB+zUZwfyrVD4wm5sUvJU+avS
         gGxCuzwFp8TGS3cB8pwP5uSnkY9lAAnkdNDJACcQAIrZQzqbfwCMq0a8ryb7yeeNb6s2
         u12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aomUgd5kRKclYU/njJf6fhaEJKCyyPfTGQHWP/WcwJY=;
        b=tdj8wajn300B6Dk9cWXli2RcxZ0vcpxTF6cVBWVQz+JTZ1mafjuhLYThF1SKuYMY+W
         nR25Lr+3w3dXHU3W2XrKBWFX2kA98rf3J1F2Emn6esrvM0Jpcsm7QRvE68d0xLdjE2tt
         2PxyY/TRNd3eMQ66bkiv4wCujaviyJtYJ9WSzAgn24+AVh43QVUfFbzisuUY7DGte48j
         LFjNA4z7nBTjieklSLHe1r9Vwvb7oa4IeY66eIuj4pFxCbnp7uYgZzDSsfWasiE82KIJ
         94AZb8ltFyAWOpUIWFGwP46ADr5ziFljcMFsuJJOH4Wbh6T7umQAJ/jb5eRx/49fFkBI
         za2g==
X-Gm-Message-State: AJcUukfSytUUFu8lQDOn+kD0RhWiulSkvkE9xBj2/apJkoHmMVNpNjw5
        5lOB1yJ9D1J4tKFcibZQ3m1WJo0V6oQ=
X-Google-Smtp-Source: ALg8bN4zx+RPwtHj07YwYpMGxja6pUhYyetgd8V502ByTWKXlwTC8YpOAEgyLU+k/KUOFs6hKJakrA==
X-Received: by 2002:a1c:bd86:: with SMTP id n128mr25489621wmf.22.1548859363506;
        Wed, 30 Jan 2019 06:42:43 -0800 (PST)
Received: from localhost.localdomain ([87.69.88.129])
        by smtp.gmail.com with ESMTPSA id a18sm1924596wrp.13.2019.01.30.06.42.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 06:42:42 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2] v4l2-ctl: add function vidcap_get_and_update_fmt
Date:   Wed, 30 Jan 2019 06:42:29 -0800
Message-Id: <20190130144229.41942-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add a function vidcap_get_and_update_fmt to set
the format from cmd params. Use it in capture_setup.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
Changes from v1:
change the order of vidcap_get_and_update_fmt and vidcap_set

utils/v4l2-ctl/v4l2-ctl-streaming.cpp |  13 +++
 utils/v4l2-ctl/v4l2-ctl-vidcap.cpp    | 134 ++++++++++++++------------
 utils/v4l2-ctl/v4l2-ctl.h             |   1 +
 3 files changed, 88 insertions(+), 60 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index d6c3f6a9..2f66e052 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1902,17 +1902,30 @@ static int capture_setup(cv4l_fd &fd, cv4l_queue &in, cv4l_fd *exp_fd)
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

