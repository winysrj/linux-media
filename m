Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f198.google.com ([209.85.216.198]:44925 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab0CLAJh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 19:09:37 -0500
Received: by pxi36 with SMTP id 36so196350pxi.21
        for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 16:09:37 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 11 Mar 2010 19:09:37 -0500
Message-ID: <412bdbff1003111609m72fc7e65he84a9791502cac7d@mail.gmail.com>
Subject: [PATCH] v4l2-ctl: fix regression in ability to set/get private
	controls
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 3dbab2e437c4a1673c1966937faec6e0fc56be01 Mon Sep 17 00:00:00 2001
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Wed, 10 Mar 2010 23:01:53 -0500
Subject: [PATCH] v4l2-ctl: fix regression in ability to set/get private controls

From: Devin Heitmueller <dheitmueller@kernellabs.com>

In hg revision 12546, a regression was introduced which resulted in the
ability to get/set private controls.  The change resulted in all attempts
to set private controls going through the extended controls interface, and
the extended controls interface explicitly denies ability to use private
control CIDs (it's enforced in the check_ext_ctl function in v4l2-ioctl.c.

Fix the code such that it goes back to using the older g_ctrl/s_ctrl if the
control ID is a private control.

Priority: high

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 utils/v4l2-ctl/v4l2-ctl.cpp |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 26d3996..c88bf6e 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -2589,7 +2589,8 @@ set_vid_fmt_error:
                }
                for (class2ctrls_map::iterator iter = class2ctrls.begin();
                                iter != class2ctrls.end(); ++iter) {
-                       if (iter->first == V4L2_CTRL_CLASS_USER) {
+                       if (iter->first == V4L2_CTRL_CLASS_USER ||
+                           iter->first == V4L2_CID_PRIVATE_BASE) {
                                for (unsigned i = 0; i <
iter->second.size(); i++) {
                                        struct v4l2_control ctrl;

@@ -2881,7 +2882,8 @@ set_vid_fmt_error:
                }
                for (class2ctrls_map::iterator iter = class2ctrls.begin();
                                iter != class2ctrls.end(); ++iter) {
-                       if (iter->first == V4L2_CTRL_CLASS_USER) {
+                       if (iter->first == V4L2_CTRL_CLASS_USER ||
+                           iter->first == V4L2_CID_PRIVATE_BASE) {
                                for (unsigned i = 0; i <
iter->second.size(); i++) {
                                        struct v4l2_control ctrl;

-- 
1.6.3.3


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
