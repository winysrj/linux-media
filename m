Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:61621 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3BFUso (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 15:48:44 -0500
Received: by mail-vb0-f41.google.com with SMTP id l22so1145275vbn.14
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 12:48:43 -0800 (PST)
MIME-Version: 1.0
From: Eddi De Pieri <eddi@depieri.net>
Date: Wed, 6 Feb 2013 21:48:23 +0100
Message-ID: <CAKdnbx4niA+UPaWf=sJCOj61iBTdtT7D0aqc7hvWFi-5biD3kg@mail.gmail.com>
Subject: [PATCH] media_build update IS_ENABLED macro
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix media_build by updating IS_ENABLED macro

Signed-off-by: Eddi De Pieri <eddi@depieri.net>

diff --git a/v4l/compat.h b/v4l/compat.h
index 8ef90aa..fd0d139 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -1102,7 +1102,7 @@ static inline void i2c_unlock_adapter(struct
i2c_adapter *adapter)
 #define __config_enabled(arg1_or_junk) ___config_enabled(arg1_or_junk 1, 0)
 #define ___config_enabled(__ignored, val, ...) val
 #define IS_ENABLED(option) \
-               (config_enabled(option) || config_enabled(option##_MODULE))
+               (defined(__enabled_ ## option) || defined(__enabled_
## option ## _MODULE))
 #endif

 #ifdef NEED_USB_TRANSLATE_ERRORS
