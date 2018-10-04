Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:42052 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJDWCm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 18:02:42 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id D32069AF
        for <linux-media@vger.kernel.org>; Thu,  4 Oct 2018 14:59:49 +0000 (UTC)
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h3EBPvRe5EEJ for <linux-media@vger.kernel.org>;
        Thu,  4 Oct 2018 09:59:49 -0500 (CDT)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id A2BA41038
        for <linux-media@vger.kernel.org>; Thu,  4 Oct 2018 09:59:49 -0500 (CDT)
Received: by mail-it1-f197.google.com with SMTP id d10so8237023itk.3
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 07:59:49 -0700 (PDT)
From: Wenwen Wang <wang6495@umn.edu>
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: dvb: fix a missing-check bug
Date: Thu,  4 Oct 2018 09:59:36 -0500
Message-Id: <1538665177-17604-1-git-send-email-wang6495@umn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In dvb_video_write(), the first header byte of the buffer 'buf' supplied by
the user is checked to see whether 'buf' contains a TS packet, which
always starts with 0x47 for synchronization purposes. If yes, ts_play() is
called. Otherwise, dvb_play() will be called. Both of these two functions
will copy 'buf' again from the user space. However, no check is enforced
on the first byte of the copied content after the second copy. Since 'buf'
is in the user space, a malicious user can race to change the first byte
after the check in dvb_video_write() but before the second copy in
ts_play(). By doing so, the user can supply inconsistent data, which can
lead to undefined behavior in the driver.

This patch adds the required check in ts_play() to make sure the header
byte in the second copy is as expected. Otherwise an error code EINVAL will
be returned.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/media/pci/ttpci/av7110_av.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index ef1bc17..1ff6062 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -468,6 +468,8 @@ static ssize_t ts_play(struct av7110 *av7110, const char __user *buf,
 		}
 		if (copy_from_user(kb, buf, TS_SIZE))
 			return -EFAULT;
+		if (kb[0] != 0x47)
+			return -EINVAL;
 		write_ts_to_decoder(av7110, type, kb, TS_SIZE);
 		todo -= TS_SIZE;
 		buf += TS_SIZE;
-- 
2.7.4
