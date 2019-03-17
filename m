Return-Path: <SRS0=+2CU=RU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E86C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 16:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA24420835
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 16:51:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJotivD7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfCQQvy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Mar 2019 12:51:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38608 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbfCQQvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Mar 2019 12:51:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id n125so9612438pfn.5
        for <linux-media@vger.kernel.org>; Sun, 17 Mar 2019 09:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SMo71V4KZ5B443X/TQj/15rp1X/Vw4d/W9sMCwiDTdk=;
        b=RJotivD7sUP/LpPE7Jao47+QaJkUvJfU87t+WHIgzGXbpEFzDoqG51jkCO/UKbr7XM
         CT8PtMOAAkY8MEJO7mvWuCspDiVk58d+9Oonlfei5m0oXKaxH6WAutkjNi8wwTFDsyNw
         CoPq1l4kAJ1Kk+0zOmo88hq5UNjI4ZTHGMq7FjTRFLg3+DHK/r9uUwqjJN0mGF/8d6/s
         93+SRyz4YH3hnsZardJSYnJz3J319+Y6J+ElzMf5exzAJltS3JxroxSsrzm8M95NsjRw
         ZwTuOSdTutopGEcHp3eVXA9t4etlvdeeJrP44eVEVVssb7Wt8H3RuXv6GxIrVhGlUaDE
         qYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SMo71V4KZ5B443X/TQj/15rp1X/Vw4d/W9sMCwiDTdk=;
        b=ApqgS4NZJgpx53dvQuaojYNdvsNqBC1B/S6ekbqNxzLyfXwGdBdQAmGCZaQ6e/OZnE
         8rOjo+I/5RkK+9eY2mr037+CP5DXi2nveRY3xfBZosY5J5mjrvT50qyvxztI5tfYl+WG
         SIs/B3wigKUo8bAnwaV8IopNCFfBjRnFh3T6v6TC7QHK3p9+bnLx9nxfpjimOW1+iDXR
         kVvkVows0W8dlZCbLsTYxY8Btf+qHa3/DJGVgOpyizsufmVm6fIaTfNku2Wp2mGp/7of
         l1/xCYMtBJfaYWQotXLeeycF9FaGL2A99Y20uSNsjVvo9MTXk7U5vrwttsdJivDibxVg
         zVlQ==
X-Gm-Message-State: APjAAAWppZ41/mGwXBRFTwM7ZeejzVFvtEa2SnEMNwfwtrAKpJXiraDX
        J62VSjgfudburhsm+N27gNmW/TqaROY=
X-Google-Smtp-Source: APXvYqxlkGNO8FApe9yyh0QCtdjlXDQGzalc5UlI00Oq+Z6zFhuyh/pNApRKwqKyeJtjKK8/rGbRRw==
X-Received: by 2002:a17:902:442:: with SMTP id 60mr7969376ple.107.1552841513112;
        Sun, 17 Mar 2019 09:51:53 -0700 (PDT)
Received: from perclnx98.iil.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id o2sm476025pfh.128.2019.03.17.09.51.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Mar 2019 09:51:52 -0700 (PDT)
From:   dorodnic@gmail.com
X-Google-Original-From: sergey.dorodnicov@intel.com
To:     linux-media@vger.kernel.org
Cc:     laurent.pinchart@ideasonboard.com, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Subject: [PATCH] media: Add missing "Auto" option to the power line frequency control
Date:   Sun, 17 Mar 2019 13:01:25 -0400
Message-Id: <1552842085-3439-2-git-send-email-sergey.dorodnicov@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552842085-3439-1-git-send-email-sergey.dorodnicov@intel.com>
References: <1552842085-3439-1-git-send-email-sergey.dorodnicov@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>

Section 4.2.2.3.6 of the USB Device Class Definition for Video Devices,
specifies "Auto" as a valid value for the power line frequency control.
This makes uvcvideo module consistent with control definition inside
/drivers/media/v4l2-core/v4l2-ctrls.c:
camera_power_line_frequency[] = {
	"Disabled",
	"50 Hz",
	"60 Hz",
	"Auto",

Signed-off-by: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 14cff91..a85910a 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -358,6 +358,7 @@ static const struct uvc_menu_info power_line_frequency_controls[] = {
 	{ 0, "Disabled" },
 	{ 1, "50 Hz" },
 	{ 2, "60 Hz" },
+	{ 3, "Auto" },
 };
 
 static const struct uvc_menu_info exposure_auto_controls[] = {
-- 
2.7.4

