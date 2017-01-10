Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49437 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1762285AbdAJLpD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 06:45:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.10] cec: fix wrong last_la determination
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <5d795644-ba26-4b9b-67c6-13c78ea145ea@xs4all.nl>
Date: Tue, 10 Jan 2017 12:44:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to an incorrect condition the last_la used for the initial attempt at
claiming a logical address could be wrong.

The last_la wasn't converted to a mask when ANDing with type2mask, so that
test was broken.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index ebb5e391b800..87a6b65ed3af 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1206,7 +1206,7 @@ static int cec_config_thread_func(void *arg)
  		las->log_addr[i] = CEC_LOG_ADDR_INVALID;
  		if (last_la == CEC_LOG_ADDR_INVALID ||
  		    last_la == CEC_LOG_ADDR_UNREGISTERED ||
-		    !(last_la & type2mask[type]))
+		    !((1 << last_la) & type2mask[type]))
  			last_la = la_list[0];

  		err = cec_config_log_addr(adap, i, last_la);
