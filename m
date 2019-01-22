Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C532C282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 12:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0BF120879
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 12:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfAVMMI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:12:08 -0500
Received: from mga18.intel.com ([134.134.136.126]:19369 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbfAVMMH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 07:12:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 04:06:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,506,1539673200"; 
   d="scan'208";a="127898297"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga002.jf.intel.com with ESMTP; 22 Jan 2019 04:06:03 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 20FFD2042C;
        Tue, 22 Jan 2019 14:06:02 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gluo2-0008Md-OO; Tue, 22 Jan 2019 14:05:26 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, yong.zhi@intel.com, hverkuil@xs4all.nl
Subject: [yavta PATCH v2 1/1] v4l2-ctl: Add support for META_OUTPUT buffer type
Date:   Tue, 22 Jan 2019 14:05:26 +0200
Message-Id: <20190122120526.32112-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for META_OUTPUT buffer type to v4l2-ctl.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Hans,

Here's an update for the meta output buffer type in v4l2-ctl.

Since v1:

- Merge help text for meta and meta out buffer types

- Unify implementation for meta format handling

 utils/v4l2-ctl/v4l2-ctl-meta.cpp | 71 ++++++++++++++++++++++++++++++++++++----
 utils/v4l2-ctl/v4l2-ctl.cpp      |  7 ++++
 utils/v4l2-ctl/v4l2-ctl.h        |  5 +++
 3 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-meta.cpp b/utils/v4l2-ctl/v4l2-ctl-meta.cpp
index 37c91940a8..f4aa434937 100644
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
@@ -55,8 +65,38 @@ void meta_set(cv4l_fd &_fd)
 	int fd = _fd.g_fd();
 	int ret;
 
+	if (!v4l_type_is_meta(_fd.g_type()))
+		return;
+
 	if ((options[OptSetMetaFormat] || options[OptTryMetaFormat]) &&
-	    v4l_type_is_meta(_fd.g_type())) {
+	    v4l_type_is_capture(_fd.g_type())) {
+		struct v4l2_format in_vfmt;
+
+		in_vfmt.type = _fd.g_type();
+		in_vfmt.fmt.meta.dataformat = vfmt.fmt.meta.dataformat;
+
+		if (in_vfmt.fmt.meta.dataformat < 256) {
+			struct v4l2_fmtdesc fmt;
+
+			fmt.index = in_vfmt.fmt.meta.dataformat;
+			fmt.type = in_vfmt.type;
+
+			if (doioctl(fd, VIDIOC_ENUM_FMT, &fmt))
+				fmt.pixelformat = 0;
+
+			in_vfmt.fmt.meta.dataformat = fmt.pixelformat;
+		}
+
+		if (options[OptSetMetaFormat])
+			ret = doioctl(fd, VIDIOC_S_FMT, &in_vfmt);
+		else
+			ret = doioctl(fd, VIDIOC_TRY_FMT, &in_vfmt);
+		if (ret == 0 && (verbose || options[OptTryMetaFormat]))
+			printfmt(fd, in_vfmt);
+	}
+
+	if ((options[OptSetMetaOutFormat] || options[OptTryMetaOutFormat]) &&
+	    v4l_type_is_output(_fd.g_type())) {
 		struct v4l2_format in_vfmt;
 
 		in_vfmt.type = _fd.g_type();
@@ -85,7 +125,16 @@ void meta_set(cv4l_fd &_fd)
 
 void meta_get(cv4l_fd &fd)
 {
-	if (options[OptGetMetaFormat] && v4l_type_is_meta(fd.g_type())) {
+	if (!v4l_type_is_meta(fd.g_type()))
+		return;
+
+	if (options[OptGetMetaFormat] && v4l_type_is_capture(fd.g_type())) {
+		vfmt.type = fd.g_type();
+		if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
+			printfmt(fd.g_fd(), vfmt);
+	}
+
+	if (options[OptGetMetaOutFormat] && v4l_type_is_output(fd.g_type())) {
 		vfmt.type = fd.g_type();
 		if (doioctl(fd.g_fd(), VIDIOC_G_FMT, &vfmt) == 0)
 			printfmt(fd.g_fd(), vfmt);
@@ -94,7 +143,15 @@ void meta_get(cv4l_fd &fd)
 
 void meta_list(cv4l_fd &fd)
 {
-	if (options[OptListMetaFormats] && v4l_type_is_meta(fd.g_type())) {
+	if (!v4l_type_is_meta(fd.g_type()))
+		return;
+
+	if (options[OptListMetaFormats] && v4l_type_is_capture(fd.g_type())) {
+		printf("ioctl: VIDIOC_ENUM_FMT\n");
+		print_video_formats(fd, fd.g_type());
+	}
+
+	if (options[OptListMetaOutFormats] && v4l_type_is_output(fd.g_type())) {
 		printf("ioctl: VIDIOC_ENUM_FMT\n");
 		print_video_formats(fd, fd.g_type());
 	}
diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 1783979d76..ffac8716d0 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -122,6 +122,7 @@ static struct option long_options[] = {
 	{"list-formats-out", no_argument, 0, OptListOutFormats},
 	{"list-formats-out-ext", no_argument, 0, OptListOutFormatsExt},
 	{"list-formats-meta", no_argument, 0, OptListMetaFormats},
+	{"list-formats-meta-out", no_argument, 0, OptListMetaOutFormats},
 	{"list-subdev-mbus-codes", optional_argument, 0, OptListSubDevMBusCodes},
 	{"list-subdev-framesizes", required_argument, 0, OptListSubDevFrameSizes},
 	{"list-subdev-frameintervals", required_argument, 0, OptListSubDevFrameIntervals},
@@ -174,6 +175,9 @@ static struct option long_options[] = {
 	{"get-fmt-meta", no_argument, 0, OptGetMetaFormat},
 	{"set-fmt-meta", required_argument, 0, OptSetMetaFormat},
 	{"try-fmt-meta", required_argument, 0, OptTryMetaFormat},
+	{"get-fmt-meta-out", no_argument, 0, OptGetMetaOutFormat},
+	{"set-fmt-meta-out", required_argument, 0, OptSetMetaOutFormat},
+	{"try-fmt-meta-out", required_argument, 0, OptTryMetaOutFormat},
 	{"get-subdev-fmt", optional_argument, 0, OptGetSubDevFormat},
 	{"set-subdev-fmt", required_argument, 0, OptSetSubDevFormat},
 	{"try-subdev-fmt", required_argument, 0, OptTrySubDevFormat},
@@ -238,6 +242,7 @@ static struct option long_options[] = {
 	{"list-buffers-sdr", no_argument, 0, OptListBuffersSdr},
 	{"list-buffers-sdr-out", no_argument, 0, OptListBuffersSdrOut},
 	{"list-buffers-meta", no_argument, 0, OptListBuffersMeta},
+	{"list-buffers-meta-out", no_argument, 0, OptListBuffersMetaOut},
 	{"stream-count", required_argument, 0, OptStreamCount},
 	{"stream-skip", required_argument, 0, OptStreamSkip},
 	{"stream-loop", no_argument, 0, OptStreamLoop},
@@ -507,6 +512,7 @@ void printfmt(int fd, const struct v4l2_format &vfmt)
 		printf("\tBuffer Size     : %u\n", vfmt.fmt.sdr.buffersize);
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		printf("\tSample Format   : '%s'%s\n", fcc2s(vfmt.fmt.meta.dataformat).c_str(),
 		       printfmtname(fd, vfmt.type, vfmt.fmt.meta.dataformat).c_str());
 		printf("\tBuffer Size     : %u\n", vfmt.fmt.meta.buffersize);
@@ -1247,6 +1253,7 @@ int main(int argc, char **argv)
 		options[OptGetSdrFormat] = 1;
 		options[OptGetSdrOutFormat] = 1;
 		options[OptGetMetaFormat] = 1;
+		options[OptGetMetaOutFormat] = 1;
 		options[OptGetFBuf] = 1;
 		options[OptGetCropCap] = 1;
 		options[OptGetOutputCropCap] = 1;
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index 5a52a0a48f..fc51cd1b97 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -89,6 +89,7 @@ enum Option {
 	OptGetSdrFormat,
 	OptGetSdrOutFormat,
 	OptGetMetaFormat,
+	OptGetMetaOutFormat,
 	OptGetSubDevFormat,
 	OptSetSlicedVbiOutFormat,
 	OptSetOverlayFormat,
@@ -97,6 +98,7 @@ enum Option {
 	OptSetSdrFormat,
 	OptSetSdrOutFormat,
 	OptSetMetaFormat,
+	OptSetMetaOutFormat,
 	OptSetSubDevFormat,
 	OptTryVideoOutFormat,
 	OptTrySlicedVbiOutFormat,
@@ -108,6 +110,7 @@ enum Option {
 	OptTrySdrFormat,
 	OptTrySdrOutFormat,
 	OptTryMetaFormat,
+	OptTryMetaOutFormat,
 	OptTrySubDevFormat,
 	OptAll,
 	OptListStandards,
@@ -122,6 +125,7 @@ enum Option {
 	OptListOutFormats,
 	OptListOutFormatsExt,
 	OptListMetaFormats,
+	OptListMetaOutFormats,
 	OptListSubDevMBusCodes,
 	OptListSubDevFrameSizes,
 	OptListSubDevFrameIntervals,
@@ -205,6 +209,7 @@ enum Option {
 	OptListBuffersSdr,
 	OptListBuffersSdrOut,
 	OptListBuffersMeta,
+	OptListBuffersMetaOut,
 	OptStreamCount,
 	OptStreamSkip,
 	OptStreamLoop,
-- 
2.11.0

