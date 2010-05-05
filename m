Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48764 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0EEF4o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 01:56:44 -0400
Received: by fxm10 with SMTP id 10so3899104fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 22:56:42 -0700 (PDT)
Date: Wed, 5 May 2010 07:56:24 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [patch -next] input: unlock on error paths
Message-ID: <20100505055624.GB27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We can't return here directly, we need to unlock the event_lock first.
This was introduced in: edeada2cde "V4L/DVB: input: Add support for
EVIO[CS]GKEYCODEBIG"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/input/input.c b/drivers/input/input.c
index e623edf..7c3fc5e 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -759,8 +759,9 @@ int input_set_keycode_big(struct input_dev *dev,
 		if (!dev->setkeycode)
 			goto out;
 
-		if (input_fetch_scancode(kt_entry, &scancode))
-			return -EINVAL;
+		retval = input_fetch_scancode(kt_entry, &scancode);
+		if (retval)
+			goto out;
 
 		retval = dev->getkeycode(dev, scancode,
 					 &old_keycode);
