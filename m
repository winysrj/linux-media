Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08297C282C0
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 02:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFD6C20861
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 02:52:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jehLDYUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfAVCw4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 21:52:56 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:40064 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfAVCw4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 21:52:56 -0500
Received: by mail-pl1-f175.google.com with SMTP id u18so10701597plq.7
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 18:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=fFjaQ4lfZ0KfvqbNkLeb9FsYI6FYE7+WpnvlD//m7bk=;
        b=jehLDYUkcMHfTK0kNBAcofPBYeK4vwMhK5yp3kNETZoclG1fbBietxQGU9/5Nyq26R
         1zqvULgYUOGsTZIVeX9oBjvcShYpzmJ6nBy2PxUXFTz+6GLVHXH3+20OdP1XMj/hZi/z
         vhx+i5G1bb4bJ+uQsFDht7DE/odIyNOdMClhwutxISqWqJ2y03vRIN+8SGqHIKh8AON5
         ScOr0OS4RXQ5jtZl+MdH0hxWNcv3eNnXhCYYLeSMqFJiOXMRhLdOMIP/sv6a4TwONO8U
         DnseO/TYchpU32ffjM0AR9lD0Z1FW5DRX2fdK5H+sObeqljKfnNtgluZir2U3BVn6+vz
         5aOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=fFjaQ4lfZ0KfvqbNkLeb9FsYI6FYE7+WpnvlD//m7bk=;
        b=gHGtpoBNomg4lVf9/Hx/og/r82FbNEMnulRn9qtbd7rPilathRx7ndCYbvb/0zV+3X
         fcDNx1sA3wuJ3kLrhRr1gUMtfJ9CmCc36sdfctjpxCjTFmLCcS7BQcQPSvWd9NxnFzxF
         b0G24gi14/H8YZV5DCEz4tbxn9Pvb5OkDgVCVsbUu7G/0qUAaBfvKZAQf4KZ3AqqyYE0
         ZCl4u6PIdL3kZa8zxfz0FDqSDYoqTTbucSgWtmsM5hlerLNh0OwFjFa7I9pc0hbRrr8N
         ucDzfUmObCeoPCcokB+gTJevOtPEFS4Ytw+yRwwJn4kp4ZkuUGdyxoNz6ywb6ot9asLm
         4PFg==
X-Gm-Message-State: AJcUukfak53nqTT64H1tOkWPWYk7b5VzcYb/RZ38ZTEy1wOui1hyHhC2
        AeAd0dgZx0YZTNKouOSPVBKxI+VAvOo=
X-Google-Smtp-Source: ALg8bN5CqxsNVZOPRA6cfZlsnaTeJrCONtulijUPXeyZc2eAjbvcTYAM4X67KdU2U5qZLt2IAqm/Fg==
X-Received: by 2002:a17:902:27e6:: with SMTP id i35mr31779816plg.222.1548125574974;
        Mon, 21 Jan 2019 18:52:54 -0800 (PST)
Received: from mangix-pc.lan (astound-69-42-16-32.ca.astound.net. [69.42.16.32])
        by smtp.gmail.com with ESMTPSA id c67sm25537440pfg.170.2019.01.21.18.52.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 18:52:53 -0800 (PST)
From:   Rosen Penev <rosenp@gmail.com>
To:     linux-media@vger.kernel.org
Subject: [v4l-utils] treewide: Fix compilation with uClibc++
Date:   Mon, 21 Jan 2019 18:52:52 -0800
Message-Id: <20190122025252.10125-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Several headers are missing.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 utils/cec-ctl/cec-ctl.cpp         | 1 +
 utils/cec-follower/cec-follower.h | 1 +
 utils/common/media-info.cpp       | 2 +-
 utils/rds-ctl/rds-ctl.cpp         | 2 ++
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/utils/cec-ctl/cec-ctl.cpp b/utils/cec-ctl/cec-ctl.cpp
index 76ce615e..bca1cc49 100644
--- a/utils/cec-ctl/cec-ctl.cpp
+++ b/utils/cec-ctl/cec-ctl.cpp
@@ -18,6 +18,7 @@
 #include <errno.h>
 #include <sys/ioctl.h>
 #include <stdarg.h>
+#include <ctime>
 #include <cerrno>
 #include <string>
 #include <vector>
diff --git a/utils/cec-follower/cec-follower.h b/utils/cec-follower/cec-follower.h
index b39293d1..36496fdc 100644
--- a/utils/cec-follower/cec-follower.h
+++ b/utils/cec-follower/cec-follower.h
@@ -9,6 +9,7 @@
 #define _CEC_FOLLOWER_H_
 
 #include <stdarg.h>
+#include <ctime>
 #include <cerrno>
 #include <string>
 #include <linux/cec-funcs.h>
diff --git a/utils/common/media-info.cpp b/utils/common/media-info.cpp
index 033821ed..3474100e 100644
--- a/utils/common/media-info.cpp
+++ b/utils/common/media-info.cpp
@@ -20,7 +20,7 @@
 
 #include <linux/media.h>
 
-#include <fstream>
+#include <iostream>
 #include <media-info.h>
 
 static std::string num2s(unsigned num, bool is_hex = true)
diff --git a/utils/rds-ctl/rds-ctl.cpp b/utils/rds-ctl/rds-ctl.cpp
index 3e68abeb..06b6344e 100644
--- a/utils/rds-ctl/rds-ctl.cpp
+++ b/utils/rds-ctl/rds-ctl.cpp
@@ -27,6 +27,8 @@
 #include <linux/videodev2.h>
 #include <libv4l2rds.h>
 
+#include <cctype>
+#include <ctime>
 #include <list>
 #include <vector>
 #include <map>
-- 
2.17.1

