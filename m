Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2M06sIZ012228
	for <video4linux-list@redhat.com>; Fri, 21 Mar 2008 20:06:54 -0400
Received: from igraine.blacknight.ie (igraine.blacknight.ie [81.17.252.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2M06MWD002853
	for <video4linux-list@redhat.com>; Fri, 21 Mar 2008 20:06:22 -0400
Date: Sat, 22 Mar 2008 00:05:57 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Message-ID: <20080322000557.GA21314@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<200803172351.56717.bonganilinux@mweb.co.za>
	<20080320142212.2361f6d8@gaivota>
	<200803211655.31085.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803211655.31085.bonganilinux@mweb.co.za>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] bttv: Add a radio compat_ioctl file operation.
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

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
---
 drivers/media/video/bt8xx/bttv-driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


Hi Bongani

I only noticed that you might be using a 32 bit userspace, so the radio
compat_ioctl needs to be implmented.

Robert



diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 5404fcc..1bdb726 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3601,6 +3601,7 @@ static const struct file_operations radio_fops =
 	.read     = radio_read,
 	.release  = radio_release,
 	.ioctl	  = video_ioctl2,
+	.compat_ioctl	= v4l_compat_ioctl32,
 	.llseek	  = no_llseek,
 	.poll     = radio_poll,
 };
-- 
1.5.4.3.484.g60e3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
