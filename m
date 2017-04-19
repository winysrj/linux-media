Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:34990 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940326AbdDSXOa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:30 -0400
Received: by mail-qk0-f179.google.com with SMTP id f133so33322782qke.2
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:30 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 04/12] au8522: remove note about VBI not being implemented
Date: Wed, 19 Apr 2017 19:13:47 -0400
Message-Id: <1492643635-30823-5-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I got this working a couple of years ago.  Remove it from the
list of known issues.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 281b5ac..5e21640 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -17,7 +17,6 @@
 
 /* Developer notes:
  *
- * VBI support is not yet working
  * Enough is implemented here for CVBS and S-Video inputs, but the actual
  *  analog demodulator code isn't implemented (not needed for xc5000 since it
  *  has its own demodulator and outputs CVBS)
-- 
1.9.1
