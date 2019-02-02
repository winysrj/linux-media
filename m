Return-Path: <SRS0=sYKt=QJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043B4C282D7
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 14:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C53452086C
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 14:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbfBBODk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 09:03:40 -0500
Received: from mga18.intel.com ([134.134.136.126]:31394 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbfBBODk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Feb 2019 09:03:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Feb 2019 06:03:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,552,1539673200"; 
   d="scan'208";a="131023867"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga002.jf.intel.com with ESMTP; 02 Feb 2019 06:03:30 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 72FB520327;
        Sat,  2 Feb 2019 16:03:29 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gpvsa-0007P4-L0; Sat, 02 Feb 2019 16:02:44 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     hverkuil@xs4all.nl
Cc:     yong.zhi@intel.com, linux-media@vger.kernel.org,
        rajmohan.mani@intel.com
Subject: [v4l-utils PATCH v4 1/1] v4l2-ctl: Add support for META_OUTPUT buffer type
Date:   Sat,  2 Feb 2019 16:02:44 +0200
Message-Id: <20190202140244.28419-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for META_OUTPUT buffer type to v4l2-ctl.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Hans, others,

Here's v4 with the required changed committed.

 utils/v4l2-ctl/v4l2-ctl-meta.cpp | 92 ++++++++++++++++++++++++++--------------
 utils/v4l2-ctl/v4l2-ctl.cpp      |  7 +++
 utils/v4l2-ctl/v4l2-ctl.h        |  5 +++
 3 files changed, 72 insertions(+), 32 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-meta.cpp b/utils/v4l2-ctl/v4l2-ctl-meta.cpp
index 37c91940a8..75fbd6f4bf 100644
--- a/utils/v4l2-ctl/v4l2-ctl-meta.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-meta.cpp
@@ -21,14 +21,22 @@ static struct v4l2_format vfmt;	/* set_format/get_format */
 void meta_usage(void)
 {
 	printf("\nMetadata Formats options:\n"
-	       "  --list-formats-meta display supported metadata formats [VIDIOC_ENUM_FMT]\n"
-	       "  --get-fmt-meta      query the metadata format [VIDIOC_G_FMT]\n"
-	       "  --set-fmt-meta <f>  set the metadata format [VIDIOC_S_FMT]\n"
+	       "  --list-formats-meta display supported metadata capture formats [VIDIOC_ENUM_FMT]\n"
+	       "  --get-fmt-meta      query the metadata capture format [VIDIOC_G_FMT]\n"
+	       "  --set-fmt-meta <f>  set the metadata capture format [VIDIOC_S_FMT]\n"
 	       "                     parameter is either the format index as reported by\n"
 	       "                     --list-formats-meta, or the fourcc value as a string\n"
-	       "  --try-fmt-meta <f>  try the metadata format [VIDIOC_TRY_FMT]\n"
+	       "  --try-fmt-meta <f>  try the metadata capture format [VIDIOC_TRY_FMT]\n"
 	       "                     parameter is either the format index as reported by\n"
 	       "                     --list-formats-meta, or the fourcc value as a string\n"
+	       "  --list-formats-meta-out display supported metadata output formats [VIDIOC_ENUM_FMT]\n"
+	       "  --get-fmt-meta-out      query the metadata output format [VIDIOC_G_FMT]\n"
+	       "  --set-fmt-meta-out <f>  set the metadata output format [VIDIOC_S_FMT]\n"
+	       "                          parameter is either the format index as reported by\n"
+	       "                          --list-formats-meta-out, or the fourcc value as a string\n"
+	       "  --try-fmt-meta-out <f>  try the metadata output format [VIDIOC_TRY_FMT]\n"
+	       "                          parameter is either the format index as reported by\n"
+	       "                          --list-formats-meta-out, or the fourcc value as a string\n"
 	       );
 }
 
@@ -37,6 +45,8 @@ void meta_cmd(int ch, char *optarg)
 	switch (ch) {
 	case OptSetMetaFormat:
 	case OptTryMetaFormat:
+	case OptSetMetaOutFormat:
+	case OptTryMetaOutFormat:
 		if (strlen(optarg) == 0) {
 			meta_usage();
 			exit(1);
@@ -50,52 +60,70 @@ void meta_cmd(int ch, char *optarg)
 	}
 }
 
-void meta_set(cv4l_fd &_fd)
+static void __meta_set(cv4l_fd &_fd, bool set, bool _try, __u32 type)
 {
+	struct v4l2_format in_vfmt;
 	int fd = _fd.g_fd();
 	int ret;
 
-	if ((options[OptSetMetaFormat] || options[OptTryMetaFormat]) &&
-	    v4l_type_is_meta(_fd.g_type())) {
-		struct v4l2_format in_vfmt;
-
-		in_vfmt.type = _fd.g_type();
-		in_vfmt.fmt.meta.dataformat = vfmt.fmt.meta.dataformat;
+	if (!set && !_try)
+		return;
 
-		if (in_vfmt.fmt.meta.dataformat < 256) {
-			struct v4l2_fmtdesc fmt;
+	in_vfmt.type = type;
+	in_vfmt.fmt.meta.dataformat = vfmt.fmt.meta.dataformat;
 
-			fmt.index = in_vfmt.fmt.meta.dataformat;
-			fmt.type = in_vfmt.type;
+	if (in_vfmt.fmt.meta.dataformat < 256) {
+		struct v4l2_fmtdesc fmt;
 
-			if (doioctl(fd, VIDIOC_ENUM_FMT, &fmt))
-				fmt.pixelformat = 0;
+		fmt.index = in_vfmt.fmt.meta.dataformat;
+		fmt.type = in_vfmt.type;
 
-			in_vfmt.fmt.meta.dataformat = fmt.pixelformat;
-		}
+		if (doioctl(fd, VIDIOC_ENUM_FMT, &fmt))
+			fmt.pixelformat = 0;
 
-		if (options[OptSetMetaFormat])
-			ret = doioctl(fd, VIDIOC_S_FMT, &in_vfmt);
-		else
-			ret = doioctl(fd, VIDIOC_TRY_FMT, &in_vfmt);
-		if (ret == 0 && (verbose || options[OptTryMetaFormat]))
-			printfmt(fd, in_vfmt);
+		in_vfmt.fmt.meta.dataformat = fmt.pixelformat;
 	}
+
+	if (set)
+		ret = doioctl(fd, VIDIOC_S_FMT, &in_vfmt);
+	else
+		ret = doioctl(fd, VIDIOC_TRY_FMT, &in_vfmt);
+	if (ret == 0 && (verbose || _try))
+		printfmt(fd, in_vfmt);
+}
+
+void meta_set(cv4l_fd &_fd)
+{
+	__meta_set(_fd, options[OptSetMetaFormat], options[OptTryMetaFormat],
+		   V4L2_BUF_TYPE_META_CAPTURE);
+	__meta_set(_fd, options[OptSetMetaOutFormat],
+		   options[OptTryMetaOutFormat], V4L2_BUF_TYPE_META_OUTPUT);
+}
+
+void __meta_get(cv4l_fd &fd, __u32 type)
+{
+	vfmt.type = type;
+	if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
+		printfmt(fd.g_fd(), vfmt);
 }
 
 void meta_get(cv4l_fd &fd)
 {
-	if (options[OptGetMetaFormat] && v4l_type_is_meta(fd.g_type())) {
-		vfmt.type = fd.g_type();
-		if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
-			printfmt(fd.g_fd(), vfmt);
-	}
+	if (options[OptGetMetaFormat])
+		__meta_get(fd, V4L2_BUF_TYPE_META_CAPTURE);
+	if (options[OptGetMetaOutFormat])
+		__meta_get(fd, V4L2_BUF_TYPE_META_OUTPUT);
 }
 
 void meta_list(cv4l_fd &fd)
 {
-	if (options[OptListMetaFormats] && v4l_type_is_meta(fd.g_type())) {
+	if (options[OptListMetaFormats]) {
+		printf("ioctl: VIDIOC_ENUM_FMT\n");
+		print_video_formats(fd, V4L2_BUF_TYPE_META_CAPTURE);
+	}
+
+	if (options[OptListMetaOutFormats]) {
 		printf("ioctl: VIDIOC_ENUM_FMT\n");
-		print_video_formats(fd, fd.g_type());
+		print_video_formats(fd, V4L2_BUF_TYPE_META_OUTPUT);
 	}
 }
diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index fc19798c06..e61f9d0f38 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -123,6 +123,7 @@ static struct option long_options[] = {
 	{"list-formats-out", no_argument, 0, OptListOutFormats},
 	{"list-formats-out-ext", no_argument, 0, OptListOutFormatsExt},
 	{"list-formats-meta", no_argument, 0, OptListMetaFormats},
+	{"list-formats-meta-out", no_argument, 0, OptListMetaOutFormats},
 	{"list-subdev-mbus-codes", optional_argument, 0, OptListSubDevMBusCodes},
 	{"list-subdev-framesizes", required_argument, 0, OptListSubDevFrameSizes},
 	{"list-subdev-frameintervals", required_argument, 0, OptListSubDevFrameIntervals},
@@ -175,6 +176,9 @@ static struct option long_options[] = {
 	{"get-fmt-meta", no_argument, 0, OptGetMetaFormat},
 	{"set-fmt-meta", required_argument, 0, OptSetMetaFormat},
 	{"try-fmt-meta", required_argument, 0, OptTryMetaFormat},
+	{"get-fmt-meta-out", no_argument, 0, OptGetMetaOutFormat},
+	{"set-fmt-meta-out", required_argument, 0, OptSetMetaOutFormat},
+	{"try-fmt-meta-out", required_argument, 0, OptTryMetaOutFormat},
 	{"get-subdev-fmt", optional_argument, 0, OptGetSubDevFormat},
 	{"set-subdev-fmt", required_argument, 0, OptSetSubDevFormat},
 	{"try-subdev-fmt", required_argument, 0, OptTrySubDevFormat},
@@ -239,6 +243,7 @@ static struct option long_options[] = {
 	{"list-buffers-sdr", no_argument, 0, OptListBuffersSdr},
 	{"list-buffers-sdr-out", no_argument, 0, OptListBuffersSdrOut},
 	{"list-buffers-meta", no_argument, 0, OptListBuffersMeta},
+	{"list-buffers-meta-out", no_argument, 0, OptListBuffersMetaOut},
 	{"stream-count", required_argument, 0, OptStreamCount},
 	{"stream-skip", required_argument, 0, OptStreamSkip},
 	{"stream-loop", no_argument, 0, OptStreamLoop},
@@ -508,6 +513,7 @@ void printfmt(int fd, const struct v4l2_format &vfmt)
 		printf("\tBuffer Size     : %u\n", vfmt.fmt.sdr.buffersize);
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		printf("\tSample Format   : '%s'%s\n", fcc2s(vfmt.fmt.meta.dataformat).c_str(),
 		       printfmtname(fd, vfmt.type, vfmt.fmt.meta.dataformat).c_str());
 		printf("\tBuffer Size     : %u\n", vfmt.fmt.meta.buffersize);
@@ -1275,6 +1281,7 @@ int main(int argc, char **argv)
 		options[OptGetSdrFormat] = 1;
 		options[OptGetSdrOutFormat] = 1;
 		options[OptGetMetaFormat] = 1;
+		options[OptGetMetaOutFormat] = 1;
 		options[OptGetFBuf] = 1;
 		options[OptGetCropCap] = 1;
 		options[OptGetOutputCropCap] = 1;
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index 739dc5a9fe..a6bd020769 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -90,6 +90,7 @@ enum Option {
 	OptGetSdrFormat,
 	OptGetSdrOutFormat,
 	OptGetMetaFormat,
+	OptGetMetaOutFormat,
 	OptGetSubDevFormat,
 	OptSetSlicedVbiOutFormat,
 	OptSetOverlayFormat,
@@ -98,6 +99,7 @@ enum Option {
 	OptSetSdrFormat,
 	OptSetSdrOutFormat,
 	OptSetMetaFormat,
+	OptSetMetaOutFormat,
 	OptSetSubDevFormat,
 	OptTryVideoOutFormat,
 	OptTrySlicedVbiOutFormat,
@@ -109,6 +111,7 @@ enum Option {
 	OptTrySdrFormat,
 	OptTrySdrOutFormat,
 	OptTryMetaFormat,
+	OptTryMetaOutFormat,
 	OptTrySubDevFormat,
 	OptAll,
 	OptListStandards,
@@ -123,6 +126,7 @@ enum Option {
 	OptListOutFormats,
 	OptListOutFormatsExt,
 	OptListMetaFormats,
+	OptListMetaOutFormats,
 	OptListSubDevMBusCodes,
 	OptListSubDevFrameSizes,
 	OptListSubDevFrameIntervals,
@@ -206,6 +210,7 @@ enum Option {
 	OptListBuffersSdr,
 	OptListBuffersSdrOut,
 	OptListBuffersMeta,
+	OptListBuffersMetaOut,
 	OptStreamCount,
 	OptStreamSkip,
 	OptStreamLoop,
-- 
2.11.0

