Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53939 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab2KVUtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 15:49:51 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3087367eek.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 12:49:50 -0800 (PST)
Message-ID: <50AE8FEA.1060509@gmail.com>
Date: Thu, 22 Nov 2012 21:49:46 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [GIT PULL FOR 3.8] V4L2 driver for S3C24XX/S3C64XX SoC series
 camera interface
References: <50AD4845.5080209@gmail.com>
In-Reply-To: <50AD4845.5080209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 11/21/2012 10:31 PM, Sylwester Nawrocki wrote:
> The following changes since commit
> 2c4e11b7c15af70580625657a154ea7ea70b8c76:
>
> [media] siano: fix RC compilation (2012-11-07 11:09:08 +0100)
>
> are available in the git repository at:
> git://linuxtv.org/snawrocki/media.git mainline/s3c-camif

I've found a bug and have updated this branch:

The following changes since commit 2c4e11b7c15af70580625657a154ea7ea70b8c76:

   [media] siano: fix RC compilation (2012-11-07 11:09:08 +0100)

are available in the git repository at:
   git://linuxtv.org/snawrocki/media.git mainline/s3c-camif

Sylwester Nawrocki (2):
       V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface
       MAINTAINERS: Add entry for S3C24XX/S3C64XX SoC CAMIF driver

  MAINTAINERS                                      |    8 +
  drivers/media/platform/Kconfig                   |   12 +
  drivers/media/platform/Makefile                  |    1 +
  drivers/media/platform/s3c-camif/Makefile        |    5 +
  drivers/media/platform/s3c-camif/camif-capture.c | 1672 
++++++++++++++++++++++
  drivers/media/platform/s3c-camif/camif-core.c    |  662 +++++++++
  drivers/media/platform/s3c-camif/camif-core.h    |  393 +++++
  drivers/media/platform/s3c-camif/camif-regs.c    |  606 ++++++++
  drivers/media/platform/s3c-camif/camif-regs.h    |  269 ++++
  include/media/s3c_camif.h                        |   45 +
  10 files changed, 3673 insertions(+), 0 deletions(-)
  create mode 100644 drivers/media/platform/s3c-camif/Makefile
  create mode 100644 drivers/media/platform/s3c-camif/camif-capture.c
  create mode 100644 drivers/media/platform/s3c-camif/camif-core.c
  create mode 100644 drivers/media/platform/s3c-camif/camif-core.h
  create mode 100644 drivers/media/platform/s3c-camif/camif-regs.c
  create mode 100644 drivers/media/platform/s3c-camif/camif-regs.h
  create mode 100644 include/media/s3c_camif.h


And here is the diff:

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c 
b/drivers/media/platform/s3c-camif/camif-capture.c
index ef0b0ed..0812e2e 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -599,8 +599,7 @@ static int s3c_camif_close(struct file *file)
         pr_debug("[vp%d] state: %#x, owner: %p, pid: %d\n", vp->id,
                  vp->state, vp->owner, task_pid_nr(current));

-       if (mutex_lock_interruptible(&camif->lock))
-               return -ERESTARTSYS;
+       mutex_lock(&camif->lock);

         if (vp->owner == file->private_data) {
                 camif_stop_capture(vp);
@@ -624,9 +623,7 @@ static unsigned int s3c_camif_poll(struct file *file,
         struct camif_dev *camif = vp->camif;
         int ret;

-       if (mutex_lock_interruptible(&camif->lock))
-               return -ERESTARTSYS;
-
+       mutex_lock(&camif->lock);
         if (vp->owner && vp->owner != file->private_data)
                 ret = -EBUSY;
         else

---

Thanks,
Sylwester
