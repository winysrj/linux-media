Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB382AHQ010941
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 03:02:10 -0500
Received: from cathcart.site5.com (89.6b.364a.static.theplanet.com
	[74.54.107.137])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB38239c031817
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 03:02:04 -0500
Message-ID: <49363CF6.4020707@compulab.co.il>
Date: Wed, 03 Dec 2008 10:01:58 +0200
From: Mike Rapoport <mike@compulab.co.il>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1227603594-16953-1-git-send-email-mike@compulab.co.il>
	<Pine.LNX.4.64.0811252225200.10677@axis700.grange>
	<492D1A2D.8070701@compulab.co.il> <493242F1.8000605@compulab.co.il>
	<Pine.LNX.4.64.0812010927530.3915@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0812010927530.3915@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH 1/2] mt9m111: add support for mt9m112 since sensors seem
	identical
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

Add MT9M112 chip id

Signed-off-by: Mike Rapoport <mike@compulab.co.il>

 include/media/v4l2-chip-ident.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index d73a8e9..50df634 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -166,6 +166,7 @@ enum {
 	V4L2_IDENT_MT9M001C12ST		= 45000,
 	V4L2_IDENT_MT9M001C12STM	= 45005,
 	V4L2_IDENT_MT9M111		= 45007,
+	V4L2_IDENT_MT9M112		= 45008,
 	V4L2_IDENT_MT9V022IX7ATC	= 45010, /* No way to detect "normal" I77ATx */
 	V4L2_IDENT_MT9V022IX7ATM	= 45015, /* and "lead free" IA7ATx chips */
 };

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
