Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:60781 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab0CWUmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 16:42:25 -0400
Received: by fxm23 with SMTP id 23so2605718fxm.1
        for <linux-media@vger.kernel.org>; Tue, 23 Mar 2010 13:42:23 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Mar 2010 17:42:23 -0300
Message-ID: <499b283a1003231342h6fcbe74di2aa67eb91b18cf0c@mail.gmail.com>
Subject: [PATCH] Fix Warning ISO C90 forbids mixed declarations and code -
	cx88-dvb
From: Ricardo Maraschini <xrmarsx@gmail.com>
To: linux-media@vger.kernel.org
Cc: doug <dougsland@gmail.com>, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- a/linux/drivers/media/video/cx88/cx88-dvb.c Tue Mar 23 16:17:11 2010 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c Tue Mar 23 17:29:29 2010 -0300
@@ -1401,7 +1401,8 @@
       case CX88_BOARD_SAMSUNG_SMT_7020:
               dev->ts_gen_cntrl = 0x08;

-               struct cx88_core *core = dev->core;
+               struct cx88_core *core;
+               core = dev->core;

               cx_set(MO_GP0_IO, 0x0101);



Signed-off-by: Ricardo Maraschini <ricardo.maraschini@gmail.com>


For any comments, please CC me in the message. I am waiting moderator
approval to subscribe to this mailing list
