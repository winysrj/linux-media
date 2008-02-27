Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1R1mCuH009173
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 20:48:12 -0500
Received: from igraine.blacknight.ie (igraine.blacknight.ie [81.17.252.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1R1lbhd020789
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 20:47:37 -0500
Date: Wed, 27 Feb 2008 01:47:29 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080227014729.GC2685@localhost>
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
Subject: [PATCH] bttv: Re-enabling radio support requires the use of struct
	bttv_fh.
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

A number of the radio tuner ioctl functions are shared with the TV
tuner, these functions require a struct bttv_fh data structure to be
allocated and initialized.

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
---
 drivers/media/video/bt8xx/bttv-driver.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)


Mauro, the radio_open function may want to do more initialisation then
the amount I copied from bttv_open.


diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 817a961..04a8263 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3417,6 +3417,7 @@ static int radio_open(struct inode *inode, struct file *file)
 {
 	int minor = iminor(inode);
 	struct bttv *btv = NULL;
+	struct bttv_fh *fh;
 	unsigned int i;
 
 	dprintk("bttv: open minor=%d\n",minor);
@@ -3431,12 +3432,19 @@ static int radio_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	dprintk("bttv%d: open called (radio)\n",btv->c.nr);
+
+	/* allocate per filehandle data */
+	fh = kmalloc(sizeof(*fh),GFP_KERNEL);
+	if (NULL == fh)
+		return -ENOMEM;
+	file->private_data = fh;
+	*fh = btv->init;
+	v4l2_prio_open(&btv->prio,&fh->prio);
+
 	mutex_lock(&btv->lock);
 
 	btv->radio_user++;
 
-	file->private_data = btv;
-
 	bttv_call_i2c_clients(btv,AUDC_SET_RADIO,NULL);
 	audio_input(btv,TVAUDIO_INPUT_RADIO);
 
@@ -3446,7 +3454,8 @@ static int radio_open(struct inode *inode, struct file *file)
 
 static int radio_release(struct inode *inode, struct file *file)
 {
-	struct bttv *btv = file->private_data;
+	struct bttv_fh *fh = file->private_data;
+	struct bttv *btv = fh->btv;
 	struct rds_command cmd;
 
 	btv->radio_user--;
@@ -3571,7 +3580,8 @@ static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
 static ssize_t radio_read(struct file *file, char __user *data,
 			 size_t count, loff_t *ppos)
 {
-	struct bttv    *btv = file->private_data;
+	struct bttv_fh *fh = file->private_data;
+	struct bttv *btv = fh->btv;
 	struct rds_command cmd;
 	cmd.block_count = count/3;
 	cmd.buffer = data;
@@ -3585,7 +3595,8 @@ static ssize_t radio_read(struct file *file, char __user *data,
 
 static unsigned int radio_poll(struct file *file, poll_table *wait)
 {
-	struct bttv    *btv = file->private_data;
+	struct bttv_fh *fh = file->private_data;
+	struct bttv *btv = fh->btv;
 	struct rds_command cmd;
 	cmd.instance = file;
 	cmd.event_list = wait;
-- 
1.5.4.34.g053d9

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
