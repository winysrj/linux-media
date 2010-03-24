Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:63460 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab0CXNcQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 09:32:16 -0400
Received: by fxm23 with SMTP id 23so29685fxm.1
        for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 06:32:14 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Mar 2010 10:32:12 -0300
Message-ID: <499b283a1003240632q4bb710b2lea0a545ae5cb22ff@mail.gmail.com>
Subject: [PATCH] Little fix on switch identation - cx88-dvb
From: Ricardo Maraschini <xrmarsx@gmail.com>
To: linux-media@vger.kernel.org
Cc: doug <dougsland@gmail.com>, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ricardo Maraschini <ricardo.maraschini@gmail.com>


--- a/linux/drivers/media/video/cx88/cx88-dvb.c Tue Mar 23 17:52:23 2010 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c Wed Mar 24 10:29:09 2010 -0300
@@ -1238,7 +1238,7 @@
                                fe->ops.tuner_ops.set_config(fe, &ctl);
                }
                break;
-        case CX88_BOARD_PINNACLE_HYBRID_PCTV:
+       case CX88_BOARD_PINNACLE_HYBRID_PCTV:
        case CX88_BOARD_WINFAST_DTV1800H:
                fe0->dvb.frontend = dvb_attach(zl10353_attach,
                                               &cx88_pinnacle_hybrid_pctv,
