Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966644Ab0GSUIE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 16:08:04 -0400
Date: Mon, 19 Jul 2010 15:59:12 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, kmcmartin@redhat.com
Subject: [PATCH] input: fix uninitialized old_keycode oops in
 input_set_keycode
Message-ID: <20100719195912.GC31837@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch as suggested by Kyle McMartin, in response to Red Hat bugzilla
615707, filed against a rawhide kernel carrying ir-core enabling patches
from the linuxtv staging/other tree. Fix is based on the similar logic in
input_set_keycode_big, and is confirmed by the bz reporter.

CC: Kyle McMartin <kmcmartin@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/input/input.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index ce5d90d..0c71977 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -900,6 +900,7 @@ int input_set_keycode(struct input_dev *dev,
 		if (retval)
 			goto out;
 
+		old_keycode = kt_entry.keycode;
 		kt_entry.keycode = keycode;
 
 		retval = dev->setkeycodebig(dev, &kt_entry);
-- 
1.7.1.1


-- 
Jarod Wilson
jarod@redhat.com

