Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSrq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:47:46 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id DF8085A66
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:47:45 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 02/17] alsa_stream: Use "default" alsa output device as default
Date: Sat, 13 Feb 2016 19:47:23 +0100
Message-Id: <1455389258-13470-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use "default" alsa output device as default, rather then hardcoding
"hw:0,0".

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/tvtimeconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tvtimeconf.c b/src/tvtimeconf.c
index cadae7a..001351b 100644
--- a/src/tvtimeconf.c
+++ b/src/tvtimeconf.c
@@ -817,7 +817,7 @@ config_t *config_new( void )
     ct->doc = 0;
 
     ct->alsa_inputdev = strdup( "hw:1,0" );
-    ct->alsa_outputdev = strdup( "hw:0,0" );
+    ct->alsa_outputdev = strdup( "default" );
 
     /* Default key bindings. */
     ct->keymap[ 0 ] = TVTIME_NOCOMMAND;
-- 
2.5.0

