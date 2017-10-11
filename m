Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:33014 "EHLO
        resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754231AbdJKBNb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 21:13:31 -0400
To: linux-media@vger.kernel.org
From: Ron Economos <w6rz@comcast.net>
Subject: [PATCH]media: dvb-frontends: Add delay to Si2168 restart
Message-ID: <7b146d05-ae00-bf35-c780-cd5ed54d1f86@comcast.net>
Date: Tue, 10 Oct 2017 18:13:30 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On faster CPUs a delay is required after the POWER_UP/RESUME command and 
the DD_RESTART command. Without the delay, the DD_RESTART command often 
returns -EREMOTEIO and the Si2168 does not restart.

diff --git a/drivers/media/dvb-frontends/si2168.c 
b/drivers/media/dvb-frontends/si2168.c
index 172fc36..f2a3c8f 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -15,6 +15,7 @@
   */

  #include "si2168_priv.h"
+#include <linux/delay.h>

  static const struct dvb_frontend_ops si2168_ops;

@@ -435,6 +436,7 @@ static int si2168_init(struct dvb_frontend *fe)
                 if (ret)
                         goto err;

+               udelay(100);
                 memcpy(cmd.args, "\x85", 1);
                 cmd.wlen = 1;
                 cmd.rlen = 1;
