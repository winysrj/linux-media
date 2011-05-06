Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51828 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1EFGEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 02:04:20 -0400
Received: by bwz15 with SMTP id 15so2396624bwz.19
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 23:04:19 -0700 (PDT)
Message-ID: <4DC38F61.9030506@gmail.com>
Date: Fri, 06 May 2011 08:04:17 +0200
From: =?ISO-8859-15?Q?Stefan_L=F6ffler?= <st.loeffler@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: =?ISO-8859-15?Q?Stefan_L=F6ffler?= <st.loeffler@gmail.com>
Subject: [libv4l] [PATCH] Webcam image upside down on Asus Eee PC T101MT (13d3:5122)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The caption pretty much says it all. Owing to different IDs, the flags
for similar Asus products don't cut in.
Originally reported for Ubuntu at
https://bugs.launchpad.net/ubuntu/+source/libv4l/+bug/774123.

Regards,
Stefan

Signed-off-by: Stefan Löffler <st.loeffler@gmail.com>


diff --git a/lib/libv4lconvert/control/libv4lcontrol.c
b/lib/libv4lconvert/control/libv4lcontrol.c
index 116bef5..6b3be9b 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -424,6 +424,8 @@ static const struct v4lcontrol_flags_info
v4lcontrol_flags[] = {
                V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
        { 0x13d3, 0x5122, 0, "ASUSTeK Computer Inc.        ", "U53Jc",
                V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
+       { 0x13d3, 0x5126, 0, "ASUSTeK Computer INC.", "T101MT",
+               V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
        { 0x13d3, 0x5130, 0, "ASUSTeK Computer INC.", "K40AE",
                V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
        { 0x13d3, 0x5130, 0, "ASUSTeK Computer INC.", "K40AF",


