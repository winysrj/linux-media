Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.198.201]:58682 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZIKOLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 10:11:48 -0400
Content-Disposition: inline
From: iceberg <strakh@ispras.ru>
To: Jonathan Corbet <corbet@lwn.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Fwd: Re: [PATCH] fix lock imbalances in /drivers/media/video/cafe_ccic.c
Date: Fri, 11 Sep 2009 18:13:21 +0000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909111813.21232.strakh@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 09:30:03AM -0600, Jonathan Corbet wrote:
> On Thu, 10 Sep 2009 18:37:34 +0000
> iceberg <strakh@ispras.ru> wrote:
> 
> > In ./drivers/media/video/cafe_ccic.c, in function cafe_pci_probe: 
> > Mutex must be unlocked before exit
> >     1. On paths starting with mutex lock in line 1912, then continuing in 
lines: 
> > 1929, 1936 (goto unreg) and 1940 (goto iounmap) . 
> >     2. On path starting in line 1971 mutex lock, and then continuing in 
line 1978 
> > (goto out_smbus) mutex.
> 
> That's a definite bug, but I hate all those unlocks in the error
> branches.  As it happens, we don't really need the mutex until the
> device has been exposed to the rest of the kernel, so I propose the
> following as a better patch.
> 
> Thanks for pointing this out,
	If we can first pair of mutex_lock and mutex_unlock:

Fix lock imbalances in function device_authorization.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>

---
diff --git a/./drivers/media/video/cafe_ccic.c 
b/../b/drivers/media/video/cafe_ccic.c
index c4d181d..4c6bc86 100644
--- a/./drivers/media/video/cafe_ccic.c
+++ b/../b/drivers/media/video/cafe_ccic.c
@@ -1909,7 +1909,6 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 		goto out_free;
 
 	mutex_init(&cam->s_mutex);
-	mutex_lock(&cam->s_mutex);
 	spin_lock_init(&cam->dev_lock);
 	cam->state = S_NOTREADY;
 	cafe_set_config_needed(cam, 1);
@@ -1949,7 +1948,6 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	 * because the sensor could attach in this call chain, leading to
 	 * unsightly deadlocks.
 	 */
-	mutex_unlock(&cam->s_mutex);  /* attach can deadlock */
 	ret = cafe_smbus_setup(cam);
 	if (ret)
 		goto out_freeirq;
@@ -1975,7 +1973,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	cam->vdev.v4l2_dev = &cam->v4l2_dev;
 	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret)
-		goto out_smbus;
+		goto out_unlock;
 	video_set_drvdata(&cam->vdev, cam);
 
 	/*
@@ -1990,6 +1988,8 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	mutex_unlock(&cam->s_mutex);
 	return 0;
 
+out_unlock:
+	mutex_unlock(&cam->s_mutex);
 out_smbus:
 	cafe_smbus_shutdown(cam);
 out_freeirq:
