Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJD7Wmn008838
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 08:07:32 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBJD7HG2021151
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 08:07:17 -0500
Date: Fri, 19 Dec 2008 14:07:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <aec7e5c30812190426ja9252a6k95b626c2ce87a909@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812191403540.4536@axis700.grange>
References: <Pine.LNX.4.64.0812171938460.8733@axis700.grange>
	<aec7e5c30812190426ja9252a6k95b626c2ce87a909@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 3/4] soc-camera: add new bus width and signal polarity
 flags
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

On Fri, 19 Dec 2008, Magnus Damm wrote:

> On Thu, Dec 18, 2008 at 3:45 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > In preparation for i.MX31 camera host driver add flags for 4 and 15 bit bus
> > widths and for data lines polarity inversion.
> >
> > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> > ---
> 
> This is a good plan...
> 
> > Careful, soc_camera_bus_param_compatible() is more selective with this
> > patch, some configurations might break.
> 
> ...but you break the SuperH Migo-R board with this patch. You need to
> add flags to the Migo-R board code as well to avoid breakage, see the
> half-assed attached patch. Thanks to Morimoto-san for pointing out the
> breakage.
> 
> I wonder if it's a better strategy to break this patch into two parts
> - one with the flags only for early merge and another one that handles
> the part doing soc_camera_bus_param_compatible(). But maybe you depend
> on the latter to probe or attach properly?

Indeed, mea culpa. I'll replace the hg tree with a fixed one, where the 
bad patch will be replaced with the one below. Please check, that this 
works for you now, althoug, I must be fast asleep to break it again:-)

Thanks Guennadi
---

>From 1d89b241f4553a5ceb5b6fd9870f02324cc281fe Mon Sep 17 00:00:00 2001
From: Guennadi Liakhovetski <lg@denx.de>
Date: Mon, 15 Dec 2008 00:49:41 +0100
Subject: [PATCH] soc-camera: add new bus width and signal polarity flags

In preparation for i.MX31 camera host driver add flags for 4 and 15 bit bus
widths and for data lines polarity inversion.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 include/media/soc_camera.h |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2ca447a..95ecf70 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -221,15 +221,20 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 #define SOCAM_HSYNC_ACTIVE_LOW		(1 << 3)
 #define SOCAM_VSYNC_ACTIVE_HIGH		(1 << 4)
 #define SOCAM_VSYNC_ACTIVE_LOW		(1 << 5)
-#define SOCAM_DATAWIDTH_8		(1 << 6)
-#define SOCAM_DATAWIDTH_9		(1 << 7)
-#define SOCAM_DATAWIDTH_10		(1 << 8)
-#define SOCAM_DATAWIDTH_16		(1 << 9)
-#define SOCAM_PCLK_SAMPLE_RISING	(1 << 10)
-#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 11)
-
-#define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_9 | \
-			      SOCAM_DATAWIDTH_10 | SOCAM_DATAWIDTH_16)
+#define SOCAM_DATAWIDTH_4		(1 << 6)
+#define SOCAM_DATAWIDTH_8		(1 << 7)
+#define SOCAM_DATAWIDTH_9		(1 << 8)
+#define SOCAM_DATAWIDTH_10		(1 << 9)
+#define SOCAM_DATAWIDTH_15		(1 << 10)
+#define SOCAM_DATAWIDTH_16		(1 << 11)
+#define SOCAM_PCLK_SAMPLE_RISING	(1 << 12)
+#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 13)
+#define SOCAM_DATA_ACTIVE_HIGH		(1 << 14)
+#define SOCAM_DATA_ACTIVE_LOW		(1 << 15)
+
+#define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | \
+			      SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \
+			      SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_16)
 
 static inline unsigned long soc_camera_bus_param_compatible(
 			unsigned long camera_flags, unsigned long bus_flags)
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
