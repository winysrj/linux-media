Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8UL8lQq029548
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 17:10:05 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8UKTMuY001773
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 16:29:40 -0400
Received: by ug-out-1314.google.com with SMTP id o38so616432ugd.13
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 13:29:22 -0700 (PDT)
Message-ID: <30353c3d0809301329g505d88deu981ef9086bc81d6c@mail.gmail.com>
Date: Tue, 30 Sep 2008 16:29:21 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: v4l <video4linux-list@redhat.com>,
	"Jaime Velasco Juan" <jsagarribay@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
In-Reply-To: <30353c3d0809291729t15be3e4cjee3198a016dc7474@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0809291729t15be3e4cjee3198a016dc7474@mail.gmail.com>
Cc: 
Subject: Re: [PATCH 3/3] stkwebcam: simplify access to stk_camera struct
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

I just noticed a small discrepancy in this patch. Since
fp->private_data is set to the current stk_camera struct whenever a
successful open occurs, it is unnecessary to verify that this pointer
is not NULL during the associated read and poll functions. I will fix
this discrepancy in a few hours and re-submit the updated patch.

Regards,

David Ellingsworth

On Mon, Sep 29, 2008 at 8:29 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> From 4a7648e95119fb923f9c5656ea7512ae624dc4ba Mon Sep 17 00:00:00 2001
> From: David Ellingsworth <david@identd.dyndns.org>
> Date: Mon, 29 Sep 2008 20:00:26 -0400
> Subject: [PATCH] stkwebcam: simplify access to stk_camera struct
>
>
> Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
> ---
>  drivers/media/video/stk-webcam.c |   40 ++++---------------------------------
>  1 files changed, 5 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
> index 442dcd2..8ca9a89 100644
> --- a/drivers/media/video/stk-webcam.c
> +++ b/drivers/media/video/stk-webcam.c
> @@ -677,7 +677,7 @@ static int v4l_stk_open(struct inode *inode,
> struct file *fp)
>                unlock_kernel();
>                return -ENXIO;
>        }
> -       fp->private_data = vdev;
> +       fp->private_data = dev;
>        usb_autopm_get_interface(dev->interface);
>        unlock_kernel();
>
> @@ -686,19 +686,7 @@ static int v4l_stk_open(struct inode *inode,
> struct file *fp)
>
>  static int v4l_stk_release(struct inode *inode, struct file *fp)
>  {
> -       struct stk_camera *dev;
> -       struct video_device *vdev;
> -
> -       vdev = video_devdata(fp);
> -       if (vdev == NULL) {
> -               STK_ERROR("v4l_release called w/o video devdata\n");
> -               return -EFAULT;
> -       }
> -       dev = vdev_to_camera(vdev);
> -       if (dev == NULL) {
> -               STK_ERROR("v4l_release called on removed device\n");
> -               return -ENODEV;
> -       }
> +       struct stk_camera *dev = fp->private_data;
>
>        if (dev->owner == fp) {
>                stk_stop_stream(dev);
> @@ -718,14 +706,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
> __user *buf,
>        int i;
>        int ret;
>        unsigned long flags;
> -       struct stk_camera *dev;
> -       struct video_device *vdev;
>        struct stk_sio_buffer *sbuf;
> -
> -       vdev = video_devdata(fp);
> -       if (vdev == NULL)
> -               return -EFAULT;
> -       dev = vdev_to_camera(vdev);
> +       struct stk_camera *dev = fp->private_data;
>
>        if (dev == NULL)
>                return -EIO;
> @@ -784,15 +766,8 @@ static ssize_t v4l_stk_read(struct file *fp, char
> __user *buf,
>
>  static unsigned int v4l_stk_poll(struct file *fp, poll_table *wait)
>  {
> -       struct stk_camera *dev;
> -       struct video_device *vdev;
> -
> -       vdev = video_devdata(fp);
> -
> -       if (vdev == NULL)
> -               return -EFAULT;
> +       struct stk_camera *dev = fp->private_data;
>
> -       dev = vdev_to_camera(vdev);
>        if (dev == NULL)
>                return -ENODEV;
>
> @@ -830,16 +805,12 @@ static int v4l_stk_mmap(struct file *fp, struct
> vm_area_struct *vma)
>        unsigned int i;
>        int ret;
>        unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
> -       struct stk_camera *dev;
> -       struct video_device *vdev;
> +       struct stk_camera *dev = fp->private_data;
>        struct stk_sio_buffer *sbuf = NULL;
>
>        if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
>                return -EINVAL;
>
> -       vdev = video_devdata(fp);
> -       dev = vdev_to_camera(vdev);
> -
>        for (i = 0; i < dev->n_sbufs; i++) {
>                if (dev->sio_bufs[i].v4lbuf.m.offset == offset) {
>                        sbuf = dev->sio_bufs + i;
> @@ -1361,7 +1332,6 @@ static int stk_register_video_device(struct
> stk_camera *dev)
>        dev->vdev = stk_v4l_data;
>        dev->vdev.debug = debug;
>        dev->vdev.parent = &dev->interface->dev;
> -       video_set_drvdata(&dev->vdev, dev);
>        err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
>        if (err)
>                STK_ERROR("v4l registration failed\n");
> --
> 1.5.6
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
