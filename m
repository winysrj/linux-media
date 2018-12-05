Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1193FC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC164206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC164206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbeLEKUv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:20:51 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:51611 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727540AbeLEKUt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:20:49 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id UUIKgznz1aOW5UUIRgJeiA; Wed, 05 Dec 2018 11:20:48 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 03/10] v4l2-ioctl.c: log v4l2_buffer tag
Date:   Wed,  5 Dec 2018 11:20:33 +0100
Message-Id: <20181205102040.11741-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKI+hqaJArCk5zM7Bxic5lRQOtyIAXP+4YvHkyTK/PmIsza2iHo4UwfCZUp8Xk6KoF6T73y0rIKZzR17eKB5MgMkPYCoyIZA5qIM6U/m6ctruywdwH8x
 hIxblW1A4tYWTWEtDbkOHelC6om+Y8XF+jaxqJS9H6n5Nyy8gZXRqZBrMZTMOwO6f7E0Y4VLM+kmC/5/9c/3rU2ecMWo2wKfrYfPw9fOA6QE+u3pZLTzp7ZS
 GHNfvVy3E+U2U0deDjNJZ9lBIEefsU/KXrnVhpJjPFeNUA16Mb75j1HFU84ja3V9hiUeOXq77jEYwiY6rd4haqPDFvt/fCs+MjjN6C747AyHENW06ennG0+H
 WSRnC3lb7dOrVI300N0hlqK/vZ+PlsJNa9flJOQIYSRIW9thwP/sNlAblfD0jTfKrCSScYFvMNeFRT8SsSCowK/SipxCRA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

When debugging is on, log the new tag field of struct v4l2_buffer
as well.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index b9616b1f227b..07c6c939a23c 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -498,9 +498,12 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 			p->bytesused, p->m.userptr, p->length);
 	}
 
-	printk(KERN_DEBUG "timecode=%02d:%02d:%02d type=%d, flags=0x%08x, frames=%d, userbits=0x%08x\n",
-			tc->hours, tc->minutes, tc->seconds,
-			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
+	if (p->flags & V4L2_BUF_FLAG_TAG)
+		printk(KERN_DEBUG "tag=%x\n", p->tag);
+	if (p->flags & V4L2_BUF_FLAG_TIMECODE)
+		printk(KERN_DEBUG "timecode=%02d:%02d:%02d type=%d, flags=0x%08x, frames=%d, userbits=0x%08x\n",
+		       tc->hours, tc->minutes, tc->seconds,
+		       tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
 }
 
 static void v4l_print_exportbuffer(const void *arg, bool write_only)
-- 
2.19.1

