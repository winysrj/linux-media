Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47997 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbeKGVcS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 16:32:18 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] keytable: fix compilation warning
Date: Wed,  7 Nov 2018 12:02:14 +0000
Message-Id: <20181107120214.13906-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

keytable.c: In function ‘parse_opt’:
keytable.c:835:7: warning: ‘param’ may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 6fc22358..e15440de 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -832,7 +832,7 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 		do {
 			struct bpf_parameter *param;
 
-			if (!param) {
+			if (!p) {
 				argp_error(state, _("Missing parameter name: %s"), arg);
 				break;
 			}
-- 
2.17.2
