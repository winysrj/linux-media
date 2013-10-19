Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39236 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3JSJzG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Oct 2013 05:55:06 -0400
Message-ID: <526256F5.1060404@gmail.com>
Date: Sat, 19 Oct 2013 11:55:01 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] videobuf2: Add missing lock held on vb2_fop_relase
References: <Hans Verkuil <hverkuil@xs4all.nl> <1381736489-27852-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1381736489-27852-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On 10/14/2013 09:41 AM, Ricardo Ribalda Delgado wrote:
> vb2_fop_relase does not held the lock although it is modifying the
> queue->owner field.
[...]
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 9fc4bab..3a961ee 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2588,8 +2588,15 @@ int vb2_fop_release(struct file *file)
>   	struct video_device *vdev = video_devdata(file);
>
>   	if (file->private_data == vdev->queue->owner) {
> +		struct mutex *lock;
> +
> +		lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> +		if (lock)
> +			mutex_lock(lock);
>   		vb2_queue_release(vdev->queue);
>   		vdev->queue->owner = NULL;
> +		if (lock)
> +			mutex_unlock(lock);
>   	}
>   	return v4l2_fh_release(file);
>   }

It seems you didn't inspect all users of vb2_fop_release(). There are 3 
drivers
that don't assign vb2_fop_release() to struct v4l2_file_operations 
directly but
instead call it from within its own release() handler. Two of them do call
vb2_fop_release() with the video queue lock already held.

$ git grep -n vb2_fop_rel -- drivers/media/

drivers/media/platform/exynos4-is/fimc-capture.c:552:   ret = 
vb2_fop_release(file);
drivers/media/platform/exynos4-is/fimc-lite.c:549: 
vb2_fop_release(file);

A rather ugly solution would be to open code the vb2_fop_release() function
in those driver, like in below patch (untested). Unless there are better
proposals I would queue the patch as below together with the $subject patch
upstream.


 From 3617684d759bb021e3cf1d862a91cb6e18d12052 Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Sat, 19 Oct 2013 11:48:10 +0200
Subject: [PATCH] exynos4-is: Do not call vb2_fop_release() with queue 
lock held

Currently vb2_fop_release() function doesn't take the queue lock,
but it is going to change and then there would happen a deadlock
in fimc_capture_release() and fimc_lite_release(), since these
function take the video queue lock prior to calling vb2_fop_release().

To avoid a deadlock open code the vb2_fop_release() function in those
drivers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
  drivers/media/platform/exynos4-is/fimc-capture.c |   11 ++++++++---
  drivers/media/platform/exynos4-is/fimc-lite.c    |    8 +++++++-
  2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c 
b/drivers/media/platform/exynos4-is/fimc-capture.c
index fb27ff7..e9a5c90 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -537,6 +537,7 @@ static int fimc_capture_release(struct file *file)
  {
  	struct fimc_dev *fimc = video_drvdata(file);
  	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	struct video_device *vdev = &vc->ve.vdev;
  	bool close = v4l2_fh_is_singular_file(file);
  	int ret;

@@ -545,11 +546,15 @@ static int fimc_capture_release(struct file *file)
  	mutex_lock(&fimc->lock);

  	if (close && vc->streaming) {
-		media_entity_pipeline_stop(&vc->ve.vdev.entity);
+		media_entity_pipeline_stop(&vdev->entity);
  		vc->streaming = false;
  	}

-	ret = vb2_fop_release(file);
+	if (file->private_data == vdev->queue->owner) {
+		vb2_queue_release(vdev->queue);
+		vdev->queue->owner = NULL;
+	}
+	ret = v4l2_fh_release(file);

  	if (close) {
  		clear_bit(ST_CAPT_BUSY, &fimc->state);
@@ -557,7 +562,7 @@ static int fimc_capture_release(struct file *file)
  		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);

  		fimc_md_graph_lock(&vc->ve);
-		vc->ve.vdev.entity.use_count--;
+		vdev->entity.use_count--;
  		fimc_md_graph_unlock(&vc->ve);
  	}

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c 
b/drivers/media/platform/exynos4-is/fimc-lite.c
index e5798f7..182db3c 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -528,6 +528,7 @@ static int fimc_lite_release(struct file *file)
  {
  	struct fimc_lite *fimc = video_drvdata(file);
  	struct media_entity *entity = &fimc->ve.vdev.entity;
+	struct video_device *vdev = &fimc->ve.vdev;

  	mutex_lock(&fimc->lock);

@@ -546,7 +547,12 @@ static int fimc_lite_release(struct file *file)
  		mutex_unlock(&entity->parent->graph_mutex);
  	}

-	vb2_fop_release(file);
+	if (file->private_data == vdev->queue->owner) {
+		vb2_queue_release(vdev->queue);
+		vdev->queue->owner = NULL;
+	}
+	v4l2_fh_release(file);
+
  	pm_runtime_put(&fimc->pdev->dev);
  	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);

-- 
1.7.4.1
