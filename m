Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1.bt.bullet.mail.ird.yahoo.com ([212.82.108.232]:22480 "HELO
	nm1.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752566Ab1HTLIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 07:08:39 -0400
Message-ID: <4E4F95B2.9020703@yahoo.com>
Date: Sat, 20 Aug 2011 12:08:34 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/6 ] EM28xx - pass correct buffer size to snprintf
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com> <4E4DFA65.4090508@redhat.com>
In-Reply-To: <4E4DFA65.4090508@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------040702020503090609000809"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040702020503090609000809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

snprintf()'s size parameter includes space for the terminating '\0' character.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------040702020503090609000809
Content-Type: text/x-patch;
 name="EM28xx-snprintf.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-snprintf.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-17 08:52:19.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-18 22:03:05.000000000 +0100
@@ -3085,7 +3085,7 @@
 		goto err;
 	}
 
-	snprintf(dev->name, 29, "em28xx #%d", nr);
+	snprintf(dev->name, sizeof(dev->name), "em28xx #%d", nr);
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;

--------------040702020503090609000809--
