Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:44429 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559AbZFIK7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 06:59:22 -0400
Received: by fxm9 with SMTP id 9so2867722fxm.37
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2009 03:59:23 -0700 (PDT)
Subject: [patch review] gspca - stv06xx: remove needless if check and goto
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>,
	Erik =?ISO-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Jun 2009 14:59:40 +0400
Message-Id: <1244545180.28249.8.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Jean-Francois and Erik André

What do you think about such small change?
Looks like the code doesn't need if-check and goto here in stv06xx_stopN
function. The code after label "out" does this.

--
Patch removes needless if check and goto. 


Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
--
diff -r ed3781a79c73 linux/drivers/media/video/gspca/stv06xx/stv06xx.c
--- a/linux/drivers/media/video/gspca/stv06xx/stv06xx.c	Sat Jun 06 16:31:34 2009 +0400
+++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx.c	Tue Jun 09 14:49:04 2009 +0400
@@ -293,8 +293,6 @@
 		goto out;
 
 	err = sd->sensor->stop(sd);
-	if (err < 0)
-		goto out;
 
 out:
 	if (err < 0)


-- 
Best regards, Klimov Alexey

