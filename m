Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957BDC43444
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D2C820815
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:40:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ao2.it header.i=@ao2.it header.b="JqsdZyrH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfACSkz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 13:40:55 -0500
Received: from mail.ao2.it ([92.243.12.208]:58430 "EHLO ao2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfACSkz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 13:40:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ao2.it; s=20180927;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=JFAfN0+7o1DcPPISxdQgm6nW9sVKi6SuEx+nthoJThM=;
        b=JqsdZyrHv3QzhuPK+TUVR8s69Qo5WPtoryv40qZxXO6NUj9mXJ9Z32XzNz/jEvnx3ybIIg9WIB7bQUc3Zosl9zxuieQuHl3pZ1V6FOLje9Sm3mFRPIULpgj0/WSKc68mXIJB7/8ugmxuWHClnArF1JurtvYa5CVnXbTGfbyt3VNyPxNuKrNSq89QUeHyqELz6bfGd93v5tpKvJ2vFTvdQ8Oy1uOV+6k1tmV1yZ/SDdvFpuIT/PLqOUJCR1zMR2Aup45Qvw7KouK4m+hApveXuidQiFS/WExzMCrGkFMYQ7/+xT/KGGRpPn8ae0FtVOMoL4u9UPv6eF/A7Tm74okWaw==;
Received: from localhost ([::1] helo=jcn)
        by ao2.it with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Hq-0002wS-Df; Thu, 03 Jan 2019 19:00:06 +0100
Received: from ao2 by jcn with local (Exim 4.92-RC3)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Io-0003D7-W6; Thu, 03 Jan 2019 19:01:06 +0100
From:   Antonio Ospite <ao2@ao2.it>
To:     linux-media@vger.kernel.org
Cc:     Antonio Ospite <ao2@ao2.it>
Subject: [RFC PATCH 5/5] v4l2-ctl: add an option to list controls in a machine-readable format
Date:   Thu,  3 Jan 2019 19:01:02 +0100
Message-Id: <20190103180102.12282-6-ao2@ao2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190103180102.12282-1-ao2@ao2.it>
References: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
 <20190103180102.12282-1-ao2@ao2.it>
MIME-Version: 1.0
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add a new option --list-ctrls-values to list the values of controls in
a format which can be passed again to --set-ctrl.

This can be useful to save and restore device settings:

  $ v4l2-ctl --list-ctrls-values >settings.txt 2>/dev/null
  $ v4l2-ctl --set-ctrl "$(cat settings.txt)"

The new option has been tested with the vivid driver and it works well
enough to be useful with a real driver as well.

String controls are not supported for now, as they may not be parsed
correctly by --set-ctrl if they contain a comma or a single quote.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 utils/v4l2-ctl/v4l2-ctl-common.cpp | 72 ++++++++++++++++++++++++++----
 utils/v4l2-ctl/v4l2-ctl.1.in       |  4 ++
 utils/v4l2-ctl/v4l2-ctl.cpp        |  1 +
 utils/v4l2-ctl/v4l2-ctl.h          |  1 +
 4 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
index 7777b45c..b4124608 100644
--- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
@@ -93,6 +93,9 @@ void common_usage(void)
 	       "  -l, --list-ctrls   display all controls and their values [VIDIOC_QUERYCTRL]\n"
 	       "  -L, --list-ctrls-menus\n"
 	       "		     display all controls and their menus [VIDIOC_QUERYMENU]\n"
+	       "  -m, --list-ctrls-values\n"
+	       "		     display all controls and their values in a format compatible with\n"
+	       "		     --set-ctrls (the 'm' stands for \"machine readable output\")\n"
 	       "  -r, --subset <ctrl>[,<offset>,<size>]+\n"
 	       "                     the subset of the N-dimensional array to get/set for control <ctrl>,\n"
 	       "                     for every dimension an (<offset>, <size>) tuple is given.\n"
@@ -409,6 +412,46 @@ static void print_qctrl(int fd, struct v4l2_query_ext_ctrl *queryctrl,
 	}
 }
 
+static void print_qctrl_values(int fd, struct v4l2_query_ext_ctrl *queryctrl,
+		struct v4l2_ext_control *ctrl, int show_menus)
+{
+	std::string s = name2var(queryctrl->name);
+
+	if (queryctrl->nr_of_dims == 0) {
+		switch (queryctrl->type) {
+		case V4L2_CTRL_TYPE_INTEGER:
+		case V4L2_CTRL_TYPE_BOOLEAN:
+		case V4L2_CTRL_TYPE_MENU:
+		case V4L2_CTRL_TYPE_INTEGER_MENU:
+			printf("%s=%d,", s.c_str(), ctrl->value);
+			break;
+		case V4L2_CTRL_TYPE_BITMASK:
+			printf("%s=0x%08x,", s.c_str(), ctrl->value);
+			break;
+		case V4L2_CTRL_TYPE_INTEGER64:
+			printf("%s=%lld,", s.c_str(), ctrl->value64);
+			break;
+		case V4L2_CTRL_TYPE_STRING:
+			fprintf(stderr, "%s: string controls unsupported for now\n", queryctrl->name);
+			break;
+		default:
+			fprintf(stderr, "%s: unsupported payload type\n", queryctrl->name);
+			break;
+		}
+	}
+
+	if (queryctrl->nr_of_dims)
+		fprintf(stderr, "%s: unsupported payload type (multi-dimensional)\n", queryctrl->name);
+
+	if (queryctrl->flags)
+		fprintf(stderr, "%s: ignoring flags\n", queryctrl->name);
+
+	if ((queryctrl->type == V4L2_CTRL_TYPE_MENU ||
+	     queryctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU) && show_menus) {
+		fprintf(stderr, "%s: ignoring menus\n", queryctrl->name);
+	}
+}
+
 static void print_class_name(const char *name)
 {
 	printf("\n%s\n\n", name);
@@ -426,7 +469,8 @@ static int print_control(int fd, struct v4l2_query_ext_ctrl &qctrl, struct print
 	if (qctrl.flags & V4L2_CTRL_FLAG_DISABLED)
 		return 1;
 	if (qctrl.type == V4L2_CTRL_TYPE_CTRL_CLASS) {
-		format->print_class_name(qctrl.name);
+		if (format->print_class_name)
+			format->print_class_name(qctrl.name);
 		return 1;
 	}
 	ext_ctrl.id = qctrl.id;
@@ -1102,13 +1146,23 @@ void common_get(cv4l_fd &_fd)
 
 void common_list(cv4l_fd &fd)
 {
-	if (options[OptListCtrls] || options[OptListCtrlsMenus]) {
-		struct print_format classic_format = {
-			.print_class_name = print_class_name,
-			.print_qctrl = print_qctrl,
-			.show_menus = options[OptListCtrlsMenus],
-		};
-
-		list_controls(fd.g_fd(), &classic_format);
+	if (options[OptListCtrls] || options[OptListCtrlsMenus] || options[OptListCtrlsValues]) {
+		if (options[OptListCtrlsValues]) {
+			struct print_format machine_format = {
+				.print_class_name = NULL,
+				.print_qctrl = print_qctrl_values,
+				.show_menus = 0,
+			};
+
+			list_controls(fd.g_fd(), &machine_format);
+		} else {
+			struct print_format classic_format = {
+				.print_class_name = print_class_name,
+				.print_qctrl = print_qctrl,
+				.show_menus = options[OptListCtrlsMenus],
+			};
+
+			list_controls(fd.g_fd(), &classic_format);
+		}
 	}
 }
diff --git a/utils/v4l2-ctl/v4l2-ctl.1.in b/utils/v4l2-ctl/v4l2-ctl.1.in
index e60c2d49..98cc7b72 100644
--- a/utils/v4l2-ctl/v4l2-ctl.1.in
+++ b/utils/v4l2-ctl/v4l2-ctl.1.in
@@ -98,6 +98,10 @@ Display all controls and their values [VIDIOC_QUERYCTRL].
 \fB-L\fR, \fB--list-ctrls-menus\fR
 Display all controls and their menus [VIDIOC_QUERYMENU].
 .TP
+\fB-m\fR, \fB--list-ctrls-values\fR
+display all controls and their values in a format compatible with
+--set-ctrls (the 'm' stands for "machine readable output")
+.TP
 \fB-r\fR, \fB--subset\fR \fI<ctrl>\fR[,\fI<offset>\fR,\fI<size>\fR]+
 The subset of the N-dimensional array to get/set for control \fI<ctrl>\fR,
 for every dimension an (\fI<offset>\fR, \fI<size>\fR) tuple is given.
diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index a65262f6..647e1778 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -142,6 +142,7 @@ static struct option long_options[] = {
 	{"info", no_argument, 0, OptGetDriverInfo},
 	{"list-ctrls", no_argument, 0, OptListCtrls},
 	{"list-ctrls-menus", no_argument, 0, OptListCtrlsMenus},
+	{"list-ctrls-values", no_argument, 0, OptListCtrlsValues},
 	{"set-ctrl", required_argument, 0, OptSetCtrl},
 	{"get-ctrl", required_argument, 0, OptGetCtrl},
 	{"get-tuner", no_argument, 0, OptGetTuner},
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index 5a52a0a4..e60a1ea1 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -65,6 +65,7 @@ enum Option {
 	OptConcise = 'k',
 	OptListCtrls = 'l',
 	OptListCtrlsMenus = 'L',
+	OptListCtrlsValues = 'm',
 	OptListOutputs = 'N',
 	OptListInputs = 'n',
 	OptGetOutput = 'O',
-- 
2.20.1

