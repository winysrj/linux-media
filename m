Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41391 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753430AbdEAQKE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:10:04 -0400
Subject: [PATCH 1/7] rc-core: ati_remote - leave the internals of rc_dev
 alone
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:09:56 +0200
Message-ID: <149365499674.13489.14382562877148639117.stgit@zeus.hardeman.nu>
In-Reply-To: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The REP_DELAY setting on the input device is independent of hardware. This
change should not change how to driver works (as it does a keydown/keyup and
has no real repeat handling).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ati_remote.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 9cf3e69de16a..a4c6ad4f67c1 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -904,9 +904,6 @@ static int ati_remote_probe(struct usb_interface *interface,
 	if (err)
 		goto exit_kill_urbs;
 
-	/* use our delay for rc_dev */
-	ati_remote->rdev->input_dev->rep[REP_DELAY] = repeat_delay;
-
 	/* Set up and register mouse input device */
 	if (mouse) {
 		input_dev = input_allocate_device();
