Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:38965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab0JNUhQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 16:37:16 -0400
Message-ID: <4CB769F6.1020904@redhat.com>
Date: Thu, 14 Oct 2010 17:37:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Greg KH <gregkh@suse.de>
Subject: [PATCH] V4L/DVB: Add a todo file for staging/tm6000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/TODO b/drivers/staging/tm6000/TODO
new file mode 100644
index 0000000..34780fc
--- /dev/null
+++ b/drivers/staging/tm6000/TODO
@@ -0,0 +1,6 @@
+There a few things to do before putting this driver in production:
+	- CodingStyle;
+	- Fix audio;
+	- Fix some panic/OOPS conditions.
+
+Please send patches to linux-media@vger.kernel.org
