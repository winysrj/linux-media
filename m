Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63650 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2LKDNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 22:13:14 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, michael@mihu.de,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 0/1] media: saa7146: don't use mutex_lock_interruptible in
Date: Tue, 11 Dec 2012 04:05:27 +0100
Message-Id: <1355195128-10209-1-git-send-email-tipecaml@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the same kind of bug as the one fixed by
ddc43d6dc7df0849fe41b91460fa76145cf87b67 : mutex_lock() must be used in the
device_release file operation in order for all resources to be freed, since
returning -RESTARTSYS has no effect here.

I stole the commit log from Sylwester Nawrocki, who fixed a few of these issues,
since I could not formulate it better.

---

Cyril Roelandt (1):
  media: saa7146: don't use mutex_lock_interruptible() in
    device_release().

 drivers/media/common/saa7146/saa7146_fops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
1.7.10.4

