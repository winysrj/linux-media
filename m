Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:32865 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936094AbcLQBFn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 20:05:43 -0500
Received: by mail-pg0-f41.google.com with SMTP id 3so37738848pgd.0
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2016 17:05:43 -0800 (PST)
Date: Fri, 16 Dec 2016 17:05:36 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] solo6x10: use designated initializers
Message-ID: <20161217010536.GA140725@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/pci/solo6x10/solo6x10-g723.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 6a35107aca25..36e93540bb49 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -350,7 +350,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
 
 int solo_g723_init(struct solo_dev *solo_dev)
 {
-	static struct snd_device_ops ops = { NULL };
+	static struct snd_device_ops ops = { };
 	struct snd_card *card;
 	struct snd_kcontrol_new kctl;
 	char name[32];
-- 
2.7.4


-- 
Kees Cook
Nexus Security
