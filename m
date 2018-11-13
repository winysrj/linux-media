Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36927 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731580AbeKMTkB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:40:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 3/9] v4l2-ioctl.c: log v4l2_buffer tag
Date: Tue, 13 Nov 2018 10:42:32 +0100
Message-Id: <20181113094238.48253-4-hverkuil@xs4all.nl>
In-Reply-To: <20181113094238.48253-1-hverkuil@xs4all.nl>
References: <20181113094238.48253-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When debugging is on, log the new tag field of struct v4l2_buffer
as well.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index c63746968fa3..81b9b3ccd7c3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -498,9 +498,12 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 			p->bytesused, p->m.userptr, p->length);
 	}
 
-	printk(KERN_DEBUG "timecode=%02d:%02d:%02d type=%d, flags=0x%08x, frames=%d, userbits=0x%08x\n",
-			tc->hours, tc->minutes, tc->seconds,
-			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
+	if (p->flags & V4L2_BUF_FLAG_TAG)
+		printk(KERN_DEBUG "tag=%llx\n", v4l2_buffer_get_tag(p));
+	else if (p->flags & V4L2_BUF_FLAG_TIMECODE)
+		printk(KERN_DEBUG "timecode=%02d:%02d:%02d type=%d, flags=0x%08x, frames=%d, userbits=0x%08x\n",
+		       tc->hours, tc->minutes, tc->seconds,
+		       tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
 }
 
 static void v4l_print_exportbuffer(const void *arg, bool write_only)
-- 
2.19.1
