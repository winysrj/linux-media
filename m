Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3A9f4lK018811
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 05:41:04 -0400
Received: from igraine.blacknight.ie (igraine.blacknight.ie [81.17.252.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3A9eq3C031673
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 05:40:52 -0400
Date: Thu, 10 Apr 2008 10:40:31 +0100
From: Robert Fitzsimons <robfitz@273k.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080410094031.GA2532@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] bttv: Fix memory leak in radio_release
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

Fix the leak of the bttv_fh structure allocated in radio_open which
was introduced by commit 5cd3955cb8adfc1edf481e9e1cb2289db50ccacb.

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
---
 drivers/media/video/bt8xx/bttv-driver.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


Seeing as commit 'V4L/DVB (7277): bttv: Re-enabling radio support
requires the use of struct bttv_fh' made it into mainline I better fix
the memory leak I introduced.

Robert


diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index fcf8f2d..59a8847 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3457,6 +3457,9 @@ static int radio_release(struct inode *inode, struct file *file)
 	struct bttv *btv = fh->btv;
 	struct rds_command cmd;
 
+	file->private_data = NULL;
+	kfree(fh);
+
 	btv->radio_user--;
 
 	bttv_call_i2c_clients(btv, RDS_CMD_CLOSE, &cmd);
-- 
1.5.4.3.484.g60e3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
