Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:47641 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964820AbbI2Rr6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2015 13:47:58 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH] v4l-utils: mc_nextgen_test fix -d option parsing
Date: Tue, 29 Sep 2015 11:47:54 -0600
Message-Id: <1443548874-4360-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mc_nextgen_test -d option doesn't work due to a missing break.
Fix the bug so -d, --device=DEVICE option can accept a device
name. Without this fix, mc_nextgen_test assumes default device
name.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 contrib/test/mc_nextgen_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/contrib/test/mc_nextgen_test.c b/contrib/test/mc_nextgen_test.c
index 490f048..e287096 100644
--- a/contrib/test/mc_nextgen_test.c
+++ b/contrib/test/mc_nextgen_test.c
@@ -89,6 +89,7 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 	case 'd':
 		strncpy(media_device, arg, sizeof(media_device) - 1);
 		media_device[sizeof(media_device)-1] = '\0';
+		break;
 
 	case '?':
 		argp_state_help(state, state->out_stream,
-- 
2.1.4

