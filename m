Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72GV3ta024023
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 12:31:03 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m72GUcYx005847
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 12:30:38 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: video4linux-list@redhat.com
Date: Sat,  2 Aug 2008 18:30:33 +0200
Message-Id: <1217694634-32756-1-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <87d4krv0rd.fsf@free.fr>
References: <87d4krv0rd.fsf@free.fr>
Cc: 
Subject: [PATCH 1/2] Add Micron mt9m111 chip ID in V4L2 identifiers
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

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 include/media/v4l2-chip-ident.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 41b509b..e8d1e42 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -161,6 +161,7 @@ enum {
 	/* Micron CMOS sensor chips: 45000-45099 */
 	V4L2_IDENT_MT9M001C12ST		= 45000,
 	V4L2_IDENT_MT9M001C12STM	= 45005,
+	V4L2_IDENT_MT9M111		= 45007,
 	V4L2_IDENT_MT9V022IX7ATC	= 45010, /* No way to detect "normal" I77ATx */
 	V4L2_IDENT_MT9V022IX7ATM	= 45015, /* and "lead free" IA7ATx chips */
 };
-- 
1.5.5.3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
