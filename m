Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:36084 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdGQWD6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:03:58 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] v4l2-compliance: fix warning in buffer::check
Date: Tue, 18 Jul 2017 00:03:47 +0200
Message-Id: <20170717220347.11312-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

The warning don't match the condition which triggers it, fix that.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---

Hi Hans,

Found this typo when investigating ALTERNATE support on R-Car VIN 
driver. Turns out that field format is a bit tricker then I first 
thought to support :-)

 utils/v4l2-compliance/v4l2-test-buffers.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
index 62baad76be455a86..2eeacdad31339e81 100644
--- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
+++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
@@ -303,7 +303,7 @@ int buffer::check(unsigned type, unsigned memory, unsigned index,
 				if (seq.field_nr) {
 					if ((int)g_sequence() != seq.last_seq)
 						warn("got sequence number %u, expected %u\n",
-							g_sequence(), seq.last_seq + 1);
+							g_sequence(), seq.last_seq);
 				} else {
 					fail_on_test((int)g_sequence() == seq.last_seq + 1);
 					if ((int)g_sequence() != seq.last_seq + 1)
-- 
2.13.0
