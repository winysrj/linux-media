Return-path: <mchehab@gaivota>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60856 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0JaWTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Oct 2010 18:19:00 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: drivers/media/IR/ir-keytable.c::ir_getkeycode - 'retval' may be used uninitialized
Date: Sun, 31 Oct 2010 15:18:42 -0700
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	mchehab@redhat.com
References: <tkrat.980deadea593e9ed@s5r6.in-berlin.de>
In-Reply-To: <tkrat.980deadea593e9ed@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010311518.42998.dmitry.torokhov@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sunday, October 31, 2010 10:51:21 am Stefan Richter wrote:
> Commit 9f470095068e "Input: media/IR - switch to using new keycode
> interface" added the following build warning:
> 
> drivers/media/IR/ir-keytable.c: In function 'ir_getkeycode':
> drivers/media/IR/ir-keytable.c:363: warning: 'retval' may be used uninitialized in this function
> 
> It is due to an actual bug but I don't know the fix.
> 

The patch below should fix it. I wonder if Linus released -rc1 yet...

-- 
Dmitry

Input: ir-keytable - fix uninitialized variable warning

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

We were forgetting to set up proper return value in success path causing
ir_getkeycode() to fail intermittently:

drivers/media/IR/ir-keytable.c: In function 'ir_getkeycode':
drivers/media/IR/ir-keytable.c:363: warning: 'retval' may be used
uninitialized in this function

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/media/IR/ir-keytable.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 9186b45..f7fafff 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -389,6 +389,8 @@ static int ir_getkeycode(struct input_dev *dev,
 	ke->len = sizeof(entry->scancode);
 	memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
 
+	retval = 0;
+
 out:
 	spin_unlock_irqrestore(&rc_tab->lock, flags);
 	return retval;
