Return-path: <mchehab@pedra>
Received: from mail-px0-f179.google.com ([209.85.212.179]:62305 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1FDHiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 03:38:12 -0400
Received: by pxi2 with SMTP id 2so1678350pxi.10
        for <linux-media@vger.kernel.org>; Sat, 04 Jun 2011 00:38:12 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 4 Jun 2011 04:38:12 -0300
Message-ID: <BANLkTikCgTWA92P2Qw4hqyvmQFRZm7+Aog@mail.gmail.com>
Subject: [PATCH] Increase max exposure value to 255 from 26.
From: =?ISO-8859-1?Q?Marco_Diego_Aur=E9lio_Mesquita?=
	<marcodiegomesquita@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The inline patch increases maximum exposure value from 26 to 255. It
has been tested and works well. Without the patch the captured image
is too dark and can't be improved too much.

Please CC answers as I'm not subscribed to the list.


Signed-off-by: Marco Diego Aurélio Mesquita <marcodiegomesquita@gmail.com>
---
 drivers/media/video/gspca/pac207.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/pac207.c
b/drivers/media/video/gspca/pac207.c
index 892b454..6a2fb26 100644
--- a/drivers/media/video/gspca/pac207.c
+++ b/drivers/media/video/gspca/pac207.c
@@ -39,7 +39,7 @@ MODULE_LICENSE("GPL");
 #define PAC207_BRIGHTNESS_DEFAULT	46

 #define PAC207_EXPOSURE_MIN		3
-#define PAC207_EXPOSURE_MAX		26
+#define PAC207_EXPOSURE_MAX		255
 #define PAC207_EXPOSURE_DEFAULT		5 /* power on default: 3 */
 #define PAC207_EXPOSURE_KNEE		8 /* 4 = 30 fps, 11 = 8, 15 = 6 */

-- 
1.6.3.3
