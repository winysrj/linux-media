Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6431FC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 01:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F174218A6
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 01:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ccW+soL9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbeLSBcv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 20:32:51 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:37197 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbeLSBcv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 20:32:51 -0500
Received: by mail-pf1-f202.google.com with SMTP id i3so16917473pfj.4
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 17:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yj76ol9i47/AU4bCLurPYgGV6L9o3/EOqtXfA4wPq+A=;
        b=ccW+soL99zIuLrbpZQ5MZTZvTWDXGRbiAp1zmUnSXMXefFXAxeb0rIeIuXwuvzG5+I
         ssDfIski0BrVXYFuzgR1x0RsdA2g32Q1j94U1OAfwge2YnUrVqrDHD2mwj5ytCuLbkWC
         DikTHv6PuVi6nTE2KS7vMHA7PBIt4++slRMiW+NRRJjs7WuO3qlfapkXvEx3AOymJb3U
         obFhtU98aFv4gYGQv8/mVU1fxyGA9DdLEsyVAEjHudWuRynhJOrzKu8HFX526hBSpoLw
         7g1p/HSM0tBDCrhPAY3IaksThf8hq0X2SZwoU1K1E3XMSjW4gg0ZbGDm6GvJpqBf2Eyt
         VpsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yj76ol9i47/AU4bCLurPYgGV6L9o3/EOqtXfA4wPq+A=;
        b=cV3+/sxkfSa1ddJqKQa2HmFmKYLJAv2j/C4xGNmzNIpoHJUF1uphgRU1muEEGGPmhu
         iucRPd1DYLZpN9E8IwgnFTQYQ5QzseapKjS4U8/QnL+S6gY9Y5e+w/p7zts1ctESKsVM
         iHMeOXj7KtV9OvY680F0GPGiMV8FrsJSQCWX5USiAvpxyIlAWRYdzyUFoDqK50cpAJcz
         5uZF39HeSIGu+zcR6DfwxWlRT45tgp8NgQcr8E+9T8AtwE1W15KSNAAikG9cctHc/oui
         vJ7tfoXIpQK1/ddI0es6twFNWlO4tIJfPaSreg7i15sos0rw0GO9Y6UuDi4n3LslhBe6
         4luw==
X-Gm-Message-State: AA+aEWb0DlhjwGmN/lSJTNKd47/0h3loBtXSltq5htcGvRrzncUiDRZQ
        k8ReNWdJnaV7LeuQcsPqePw8DmoSLljrMGM=
X-Google-Smtp-Source: AFSGD/VuWaPE/rHfoHG1J9J3ZkhIAZghcuoKB/66C2831LzzUMz7NbEC8RGNwQVOV2d8TkL55W178LPSExnUvns=
X-Received: by 2002:a63:480a:: with SMTP id v10mr10661000pga.105.1545183170432;
 Tue, 18 Dec 2018 17:32:50 -0800 (PST)
Date:   Tue, 18 Dec 2018 17:32:48 -0800
Message-Id: <20181219013248.94850-1-astrachan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.20.1.415.g653613c723-goog
Subject: [PATCH v2] media: uvcvideo: Fix 'type' check leading to overflow
From:   Alistair Strachan <astrachan@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     syzbot <syzkaller@googlegroups.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

When initially testing the Camera Terminal Descriptor wTerminalType
field (buffer[4]), no mask is used. Later in the function, the MSB is
overloaded to store the descriptor subtype, and so a mask of 0x7fff
is used to check the type.

If a descriptor is specially crafted to set this overloaded bit in the
original wTerminalType field, the initial type check will fail (falling
through, without adjusting the buffer size), but the later type checks
will pass, assuming the buffer has been made suitably large, causing an
overflow.

Avoid this problem by checking for the MSB in the wTerminalType field.
If the bit is set, assume the descriptor is bad, and abort parsing it.

Originally reported here:
https://groups.google.com/forum/#!topic/syzkaller/Ot1fOE6v1d8
A similar (non-compiling) patch was provided at that time.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Alistair Strachan <astrachan@google.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: kernel-team@android.com
---
v2: Use an alternative fix suggested by Laurent
 drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index bc369a0934a3..7fde3ce642c4 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1065,11 +1065,19 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		/* Make sure the terminal type MSB is not null, otherwise it
-		 * could be confused with a unit.
+		/*
+		 * Reject invalid terminal types that would cause issues:
+		 *
+		 * - The high byte must be non-zero, otherwise it would be
+		 *   confused with a unit.
+		 *
+		 * - Bit 15 must be 0, as we use it internally as a terminal
+		 *   direction flag.
+		 *
+		 * Other unknown types are accepted.
 		 */
 		type = get_unaligned_le16(&buffer[4]);
-		if ((type & 0xff00) == 0) {
+		if ((type & 0x7f00) == 0 || (type & 0x8000) != 0) {
 			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
 				"interface %d INPUT_TERMINAL %d has invalid "
 				"type 0x%04x, skipping\n", udev->devnum,
-- 
2.20.1.415.g653613c723-goog

