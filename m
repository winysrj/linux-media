Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2NMim9c018808
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:48 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2NMiGMq019603
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:16 -0400
Received: by fg-out-1718.google.com with SMTP id e12so2174237fga.7
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 15:44:16 -0700 (PDT)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <da854c7e2b4372794c04.1206312205@liva.fdsoft.se>
In-Reply-To: <patchbomb.1206312199@liva.fdsoft.se>
Date: Sun, 23 Mar 2008 23:43:25 +0100
To: video4linux-list@redhat.com
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 6 of 6] cx88: Enable color killer by default
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

1 file changed, 1 insertion(+), 1 deletion(-)
linux/drivers/media/video/cx88/cx88-video.c |    2 +-


# HG changeset patch
# User "Frej Drejhammar <frej.drejhammar@gmail.com>"
# Date 1206312051 -3600
# Node ID da854c7e2b4372794c0437ab59776fe5fa5305ee
# Parent  77bef451d41348f8e5ca6b24fe402199ac243ead
cx88: Enable color killer by default

From: "Frej Drejhammar <frej.drejhammar@gmail.com>"

An enabled color killer will not degrade picture quality for color
input signals, only suppress bogus color information on
black-and-white input. Therefore enable it by default.

Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"

diff -r 77bef451d413 -r da854c7e2b43 linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 23 23:40:16 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 23 23:40:51 2008 +0100
@@ -261,7 +261,7 @@ static struct cx88_ctrl cx8800_ctls[] = 
 			.name          = "Color killer",
 			.minimum       = 0,
 			.maximum       = 1,
-			.default_value = 0x0,
+			.default_value = 0x1,
 			.type          = V4L2_CTRL_TYPE_BOOLEAN,
 		},
 		.reg                   = MO_INPUT_FORMAT,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
