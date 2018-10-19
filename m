Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:43186 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbeJSWSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 18:18:41 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id C38B81C5
        for <linux-media@vger.kernel.org>; Fri, 19 Oct 2018 14:12:22 +0000 (UTC)
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id r7fgVIICkOqm for <linux-media@vger.kernel.org>;
        Fri, 19 Oct 2018 09:12:22 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 9C2F0184
        for <linux-media@vger.kernel.org>; Fri, 19 Oct 2018 09:12:22 -0500 (CDT)
Received: by mail-io1-f69.google.com with SMTP id g133-v6so30347331ioa.12
        for <linux-media@vger.kernel.org>; Fri, 19 Oct 2018 07:12:22 -0700 (PDT)
From: Wenwen Wang <wang6495@umn.edu>
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] media: dvb: fix a missing-check bug
Date: Fri, 19 Oct 2018 09:12:13 -0500
Message-Id: <1539958334-11531-1-git-send-email-wang6495@umn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In dvb_audio_write(), the first byte of the user-space buffer 'buf' is
firstly copied and checked to see whether this is a TS packet, which always
starts with 0x47 for synchronization purposes. If yes, ts_play() will be
called. Otherwise, dvb_aplay() will be called. In ts_play(), the content of
'buf', including the first byte, is copied again from the user space.
However, after the copy, no check is re-enforced on the first byte of the
copied data.  Given that 'buf' is in the user space, a malicious user can
race to change the first byte after the check in dvb_audio_write() but
before the copy in ts_play(). Through this way, the user can supply
inconsistent code, which can cause undefined behavior of the kernel and
introduce potential security risk.

This patch adds a necessary check in ts_play() to make sure the first byte
acquired in the second copy contains the expected value. Otherwise, an
error code EINVAL will be returned.

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
