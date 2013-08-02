Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:20013 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3HBMGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 08:06:00 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r72C5nZ9017931
	for <linux-media@vger.kernel.org>; Fri, 2 Aug 2013 12:05:57 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] qv4l2: fix a bug where the alsa thread never stops
Date: Fri,  2 Aug 2013 14:05:36 +0200
Message-Id: <dba8ec599edbf0cc9e521f1178fe1c9f54eda050.1375445112.git.bwinther@cisco.com>
In-Reply-To: <1375445137-19443-1-git-send-email-bwinther@cisco.com>
References: <1375445137-19443-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <1a734456df06299e284f793264ca843c98b0f18a.1375445112.git.bwinther@cisco.com>
References: <1a734456df06299e284f793264ca843c98b0f18a.1375445112.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the output audio device never read the buffer then the alsa thread
would continue to fill it up and never stop when the capture stops.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/alsa_stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/qv4l2/alsa_stream.c b/utils/qv4l2/alsa_stream.c
index 90d3afb..43ecda3 100644
--- a/utils/qv4l2/alsa_stream.c
+++ b/utils/qv4l2/alsa_stream.c
@@ -436,7 +436,7 @@ static snd_pcm_sframes_t writebuf(snd_pcm_t *handle, char *buf, long len)
 {
     snd_pcm_sframes_t r;
 
-    while (1) {
+    while (!stop_alsa) {
 	r = snd_pcm_writei(handle, buf, len);
 	if (r == len)
 	    return 0;
-- 
1.8.3.2

