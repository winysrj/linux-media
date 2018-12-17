Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D82C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 21:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D59F214D8
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 21:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lA4+iaSn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388715AbeLQVC0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 16:02:26 -0500
Received: from mail-it1-f202.google.com ([209.85.166.202]:34976 "EHLO
        mail-it1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbeLQVC0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 16:02:26 -0500
Received: by mail-it1-f202.google.com with SMTP id c128so748288itc.0
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2018 13:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=B+CAsm1YTSnfyOzthHq98oApnuFShmgtKcCoWarGH7U=;
        b=lA4+iaSnhKAxHl3sM/PcWBc44+4vkkmcF+iya/Ea00QPw6PpEPE2guDnP7oSyAGDWT
         vRvZMv+2S9LDl9MAIKbOtDcwJYYjpAa9MbJxGye5YBj0FNDxyyeHZ3s2UhyHy8P8y+JM
         LPb7VzTX4W8mONYqDafaytBq1D+wfiSIqkmQqN5WXtA/9lzK0kXqAwmuN/PZV3SjpXoG
         /cgrlCUp6YmCPLq8uy9QXvIRhHRyybVjyIybDasLt/Ur60d50B+iflqg1CzPgnfs7fFx
         ubNX+VN90YKN215c3TkNcseQG6Qk0WR5bMKc9X0rFeDrZmadOZm0sPTe950tFleK4j68
         ef5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=B+CAsm1YTSnfyOzthHq98oApnuFShmgtKcCoWarGH7U=;
        b=dOy+Pd2ZmKoYETTc1Q9SK+/URcKB/Pz06mbiW+CuYAsp6v2hUz/Y1AME2hYsGTZ+w1
         Heac5OsFVhmL7Ai7jNnEhmT88nASc1LqHtLM/RSU/hBx1fKXfEhuje/VsT9rdYSZsSpe
         19+aWtnR8ZLNTXPO9oQhEESZ+ZmMfjuVlMgnNeySwR3Fzmjk9YVJLY5ZJjfNa1uVJ0Ms
         zSpQevuRfYoQqTNfWSi70Zs6+pQDC1A+sppQO13YCg+kWGjaz3nqGRs4hdVxgx9FKOKp
         AebMQiMRsd+jlkOUWhqv30q1eI1LZ0L2xu+hY3NwXA60bTP/Y05xbrYL4KDTklq1W5JU
         FDeQ==
X-Gm-Message-State: AA+aEWZ7X+BHHgk3jTaFeyW1/2nYmzkLWOxOUaiWmswqZVioa2hDwoI6
        etcIFP5QUt+FYXzK3ToM3w2ovR3C+toxvkA=
X-Google-Smtp-Source: AFSGD/U2r31mE+jQY/9G2qHUqSuvEj0gUErUDVwlAhxLIFDpwS+ZjfYciMXrmD1QpcbwPxohifGg2gVeICHlBmE=
X-Received: by 2002:a24:a94:: with SMTP id 142mr528711itw.15.1545080544896;
 Mon, 17 Dec 2018 13:02:24 -0800 (PST)
Date:   Mon, 17 Dec 2018 13:02:22 -0800
Message-Id: <20181217210222.115419-1-astrachan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.20.0.405.gbc1bbc6f85-goog
Subject: [PATCH] media: uvcvideo: Fix 'type' check leading to overflow
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

When initially testing the Camera Terminal Descriptor wTerminalType
field (buffer[4]), no mask is used. Later in the function, the MSB is
overloaded to store the descriptor subtype, and so a mask of 0x7fff
is used to check the type.

If a descriptor is specially crafted to set this overloaded bit in the
original wTerminalType field, the initial type check will fail (falling
through, without adjusting the buffer size), but the later type checks
will pass, assuming the buffer has been made suitably large, causing an
overflow.

This problem could be resolved in a few different ways, but this fix
applies the same initial type check as used by UVC_ENTITY_TYPE (once we
have a 'term' structure.) Such crafted wTerminalType fields will then be
treated as *generic* Input Terminals, not as CAMERA or
MEDIA_TRANSPORT_INPUT, avoiding an overflow.

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
 drivers/media/usb/uvc/uvc_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index bc369a0934a3..279a967b8264 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1082,11 +1082,11 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		p = 0;
 		len = 8;
 
-		if (type == UVC_ITT_CAMERA) {
+		if ((type & 0x7fff) == UVC_ITT_CAMERA) {
 			n = buflen >= 15 ? buffer[14] : 0;
 			len = 15;
 
-		} else if (type == UVC_ITT_MEDIA_TRANSPORT_INPUT) {
+		} else if ((type & 0x7fff) == UVC_ITT_MEDIA_TRANSPORT_INPUT) {
 			n = buflen >= 9 ? buffer[8] : 0;
 			p = buflen >= 10 + n ? buffer[9+n] : 0;
 			len = 10;
-- 
2.20.0.405.gbc1bbc6f85-goog

