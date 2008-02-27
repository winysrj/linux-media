Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1R1j9pJ008105
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 20:45:09 -0500
Received: from igraine.blacknight.ie (igraine.blacknight.ie [81.17.252.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1R1iVFV018673
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 20:44:31 -0500
Date: Wed, 27 Feb 2008 01:44:27 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080227014427.GB2685@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<20080218131125.2857f7c7@gaivota>
	<200802182320.40732.bonganilinux@mweb.co.za>
	<200802190121.36280.bonganilinux@mweb.co.za>
	<20080219111640.409870a9@gaivota>
	<20080226154102.GD30463@localhost>
	<20080227014238.GA2685@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227014238.GA2685@localhost>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Bongani Hlope <bonganilinux@mweb.co.za>
Subject: [PATCH] bttv: Re-enable radio tuner support for
	VIDIOCGFREQ/VIDIOCSFREQ ioctls.
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
 drivers/media/video/bt8xx/bttv-driver.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 5404fcc..817a961 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -1990,7 +1990,7 @@ static int bttv_g_frequency(struct file *file, void *priv,
 	if (0 != err)
 		return err;
 
-	f->type = V4L2_TUNER_ANALOG_TV;
+	f->type = btv->radio_user ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = btv->freq;
 
 	return 0;
@@ -2009,7 +2009,8 @@ static int bttv_s_frequency(struct file *file, void *priv,
 
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
-	if (unlikely(f->type != V4L2_TUNER_ANALOG_TV))
+	if (unlikely(f->type != (btv->radio_user
+		? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV)))
 		return -EINVAL;
 	mutex_lock(&btv->lock);
 	btv->freq = f->frequency;
-- 
1.5.4.34.g053d9

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
