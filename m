Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38106 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbcGOPOO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:14:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] cec/TODO: drop comment about sphinx documentation
Date: Fri, 15 Jul 2016 17:14:07 +0200
Message-Id: <1468595648-30008-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC documentation has been converted to sphinx, so this
TODO item can be dropped.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/TODO | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
index 8221d44..a10d4f8 100644
--- a/drivers/staging/media/cec/TODO
+++ b/drivers/staging/media/cec/TODO
@@ -14,7 +14,6 @@ Other TODOs:
 
 - Add a flag to inhibit passing CEC RC messages to the rc subsystem.
   Applications should be able to choose this when calling S_LOG_ADDRS.
-- Convert cec.txt to sphinx.
 - If the reply field of cec_msg is set then when the reply arrives it
   is only sent to the filehandle that transmitted the original message
   and not to any followers. Should this behavior change or perhaps
-- 
2.8.1

