Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6333AC43387
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 334DA20815
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ao2.it header.i=@ao2.it header.b="VTlpoFTv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfACSlB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 13:41:01 -0500
Received: from mail.ao2.it ([92.243.12.208]:58433 "EHLO ao2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfACSlB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 13:41:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ao2.it; s=20180927;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=hpryT/OzjHsFMb4eVdqf6EOcTMkFYwvsBlU8gQJByXA=;
        b=VTlpoFTvsxZpNzjq/8yJfu0FkvOe4D/TnzGQamp3SW7a5numSLDbouz/m0PVZbxIRCKGLp/c8PzvyuiSnTWEu5mQqKzGRjXX1pzNhpg0TaNNiPH9f9/zMMbrGDOOYsdwxJgLooy+fPZbE1riFCO9s9F7Yl83wYXHQltd5zUwtYX5CfVMnCD6WVh7oJLYJNjHlY3PMxCA70o/7uMzZt6j4EVGHTF0I7z6hxZ+ysIlSjvLtnmhkm66Cfs0SvtC65TonpZ/LIfkMP1Z6Ev2BEYtBRzFMo74/8zNGVg/qU+QUUpQnmLTJCF63CVqnN5oygc0VmBj6unR2oShhJL6nghTJw==;
Received: from localhost ([::1] helo=jcn)
        by ao2.it with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Hq-0002wO-7z; Thu, 03 Jan 2019 19:00:06 +0100
Received: from ao2 by jcn with local (Exim 4.92-RC3)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Io-0003D4-Tm; Thu, 03 Jan 2019 19:01:06 +0100
From:   Antonio Ospite <ao2@ao2.it>
To:     linux-media@vger.kernel.org
Cc:     Antonio Ospite <ao2@ao2.it>
Subject: [RFC PATCH 4/5] v4l2-ctl: abstract the mechanism used to print the list of controls
Date:   Thu,  3 Jan 2019 19:01:01 +0100
Message-Id: <20190103180102.12282-5-ao2@ao2.it>
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

Sometimes it may be useful to list the controls using a different output
format than the current one used by --list-ctrls, for instance a new
printing format could output a string which can be later fed to
--set-ctrl.

Add an abstraction mechanism to make it possible to add new output
formats for controls.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 utils/v4l2-ctl/v4l2-ctl-common.cpp | 32 ++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
index 5d41d720..7777b45c 100644
--- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
@@ -30,6 +30,12 @@ struct ctrl_subset {
 	unsigned size[V4L2_CTRL_MAX_DIMS];
 };
 
+struct print_format {
+	void (*print_class_name)(const char *);
+	void (*print_qctrl)(int, struct v4l2_query_ext_ctrl *, struct v4l2_ext_control *, int);
+	int show_menus;
+};
+
 typedef std::map<unsigned, std::vector<struct v4l2_ext_control> > class2ctrls_map;
 
 typedef std::map<std::string, struct v4l2_query_ext_ctrl> ctrl_qmap;
@@ -408,7 +414,7 @@ static void print_class_name(const char *name)
 	printf("\n%s\n\n", name);
 }
 
-static int print_control(int fd, struct v4l2_query_ext_ctrl &qctrl, int show_menus)
+static int print_control(int fd, struct v4l2_query_ext_ctrl &qctrl, struct print_format *format)
 {
 	struct v4l2_control ctrl;
 	struct v4l2_ext_control ext_ctrl;
@@ -420,17 +426,17 @@ static int print_control(int fd, struct v4l2_query_ext_ctrl &qctrl, int show_men
 	if (qctrl.flags & V4L2_CTRL_FLAG_DISABLED)
 		return 1;
 	if (qctrl.type == V4L2_CTRL_TYPE_CTRL_CLASS) {
-		print_class_name(qctrl.name);
+		format->print_class_name(qctrl.name);
 		return 1;
 	}
 	ext_ctrl.id = qctrl.id;
 	if ((qctrl.flags & V4L2_CTRL_FLAG_WRITE_ONLY) ||
 	    qctrl.type == V4L2_CTRL_TYPE_BUTTON) {
-		print_qctrl(fd, &qctrl, &ext_ctrl, show_menus);
+		format->print_qctrl(fd, &qctrl, &ext_ctrl, format->show_menus);
 		return 1;
 	}
 	if (qctrl.type >= V4L2_CTRL_COMPOUND_TYPES) {
-		print_qctrl(fd, &qctrl, NULL, show_menus);
+		format->print_qctrl(fd, &qctrl, NULL, format->show_menus);
 		return 1;
 	}
 	ctrls.which = V4L2_CTRL_ID2WHICH(qctrl.id);
@@ -460,7 +466,7 @@ static int print_control(int fd, struct v4l2_query_ext_ctrl &qctrl, int show_men
 		}
 		ext_ctrl.value = ctrl.value;
 	}
-	print_qctrl(fd, &qctrl, &ext_ctrl, show_menus);
+	format->print_qctrl(fd, &qctrl, &ext_ctrl, format->show_menus);
 	if (qctrl.type == V4L2_CTRL_TYPE_STRING)
 		free(ext_ctrl.string);
 	return 1;
@@ -512,7 +518,7 @@ static int query_ext_ctrl_ioctl(int fd, struct v4l2_query_ext_ctrl &qctrl)
 	return rc;
 }
 
-static void list_controls(int fd, int show_menus)
+static void list_controls(int fd, struct print_format *format)
 {
 	const unsigned next_fl = V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
 	struct v4l2_query_ext_ctrl qctrl;
@@ -521,7 +527,7 @@ static void list_controls(int fd, int show_menus)
 	memset(&qctrl, 0, sizeof(qctrl));
 	qctrl.id = next_fl;
 	while (query_ext_ctrl_ioctl(fd, qctrl) == 0) {
-		print_control(fd, qctrl, show_menus);
+		print_control(fd, qctrl, format);
 		qctrl.id |= next_fl;
 	}
 	if (qctrl.id != next_fl)
@@ -529,11 +535,11 @@ static void list_controls(int fd, int show_menus)
 	for (id = V4L2_CID_USER_BASE; id < V4L2_CID_LASTP1; id++) {
 		qctrl.id = id;
 		if (query_ext_ctrl_ioctl(fd, qctrl) == 0)
-			print_control(fd, qctrl, show_menus);
+			print_control(fd, qctrl, format);
 	}
 	for (qctrl.id = V4L2_CID_PRIVATE_BASE;
 			query_ext_ctrl_ioctl(fd, qctrl) == 0; qctrl.id++) {
-		print_control(fd, qctrl, show_menus);
+		print_control(fd, qctrl, format);
 	}
 }
 
@@ -1097,6 +1103,12 @@ void common_get(cv4l_fd &_fd)
 void common_list(cv4l_fd &fd)
 {
 	if (options[OptListCtrls] || options[OptListCtrlsMenus]) {
-		list_controls(fd.g_fd(), options[OptListCtrlsMenus]);
+		struct print_format classic_format = {
+			.print_class_name = print_class_name,
+			.print_qctrl = print_qctrl,
+			.show_menus = options[OptListCtrlsMenus],
+		};
+
+		list_controls(fd.g_fd(), &classic_format);
 	}
 }
-- 
2.20.1

