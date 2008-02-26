Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1Q0oJ3P018345
	for <video4linux-list@redhat.com>; Mon, 25 Feb 2008 19:50:19 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.180])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1Q0nn7s016675
	for <video4linux-list@redhat.com>; Mon, 25 Feb 2008 19:49:49 -0500
Received: by wa-out-1112.google.com with SMTP id j37so2162319waf.7
	for <video4linux-list@redhat.com>; Mon, 25 Feb 2008 16:49:49 -0800 (PST)
Message-ID: <f17812d70802251649p73c7fa2p881b1710ebad5f81@mail.gmail.com>
Date: Tue, 26 Feb 2008 08:49:48 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@pengutronix.de>
In-Reply-To: <Pine.LNX.4.64.0802251304320.4430@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802251304320.4430@axis700.grange>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] soc-camera: deactivate cameras when not used
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

Do you have a git tree or patch series (maybe a mbox patch aggregate)
that I can apply? Also let me know the baseline to apply, I guess it
should apply happily on top of linux-v4l2's current head, but I'm not
sure


On Mon, Feb 25, 2008 at 8:12 PM, Guennadi Liakhovetski
<g.liakhovetski@pengutronix.de> wrote:
> Only attach cameras to the host interface for probing, then detach until
>  open. This allows platforms with several cameras on an interface,
>  physically supporting only one camera, to handle multiple cameras and
>  activate them selectively after initial probing. The first attach during
>  probe is needed to activate the host interface to be able to physically
>  communicate with cameras.
>
>  Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
>
>  ---
>
>  Erik, would be nice if you could test this with one of your multi-camera
>  platforms.
>
>  diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
>  index 904e9df..e3f5a17 100644
>  --- a/drivers/media/video/soc_camera.c
>  +++ b/drivers/media/video/soc_camera.c
>  @@ -179,11 +179,9 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
>
>   static int soc_camera_open(struct inode *inode, struct file *file)
>   {
>  -       struct video_device *vdev = video_devdata(file);
>  -       struct soc_camera_device *icd = container_of(vdev->dev,
>  -                                            struct soc_camera_device, dev);
>  -       struct soc_camera_host *ici =
>  -               to_soc_camera_host(icd->dev.parent);
>  +       struct video_device *vdev;
>  +       struct soc_camera_device *icd;
>  +       struct soc_camera_host *ici;
>         struct soc_camera_file *icf;
>         int ret;
>
>  @@ -191,7 +189,12 @@ static int soc_camera_open(struct inode *inode, struct file *file)
>         if (!icf)
>                 return -ENOMEM;
>
>  -       icf->icd = icd;
>  +       /* Protect against icd->remove() until we module_get() both drivers. */
>  +       mutex_lock(&video_lock);
>  +
>  +       vdev = video_devdata(file);
>  +       icd = container_of(vdev->dev, struct soc_camera_device, dev);
>  +       ici = to_soc_camera_host(icd->dev.parent);
>
>         if (!try_module_get(icd->ops->owner)) {
>                 dev_err(&icd->dev, "Couldn't lock sensor driver.\n");
>  @@ -205,6 +208,22 @@ static int soc_camera_open(struct inode *inode, struct file *file)
>                 goto emgi;
>         }
>
>  +       icd->use_count++;
>  +
>  +       icf->icd = icd;
>  +
>  +       /* Now we really have to activate the camera */
>  +       if (icd->use_count == 1) {
>  +               ret = ici->add(icd);
>  +               if (ret < 0) {
>  +                       dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
>  +                       icd->use_count--;
>  +                       goto eiciadd;
>  +               }
>  +       }
>  +
>  +       mutex_unlock(&video_lock);
>  +
>         file->private_data = icf;
>         dev_dbg(&icd->dev, "camera device open\n");
>
>  @@ -205,9 +208,13 @@ static int soc_camera_open(struct inode *inode, struct file *file)
>
>         return 0;
>
>  +       /* All errors are entered with the video_lock held */
>  +eiciadd:
>  +       module_put(ici->owner);
>   emgi:
>         module_put(icd->ops->owner);
>   emgd:
>  +       mutex_unlock(&video_lock);
>         vfree(icf);
>         return ret;
>   }
>  @@ -230,8 +253,14 @@ static int soc_camera_close(struct inode *inode, struct file *file)
>         struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>         struct video_device *vdev = icd->vdev;
>
>  +       mutex_lock(&video_lock);
>  +       icd->use_count--;
>  +       if (!icd->use_count)
>  +               ici->remove(icd);
>         module_put(icd->ops->owner);
>         module_put(ici->owner);
>  +       mutex_unlock(&video_lock);
>  +
>         vfree(file->private_data);
>
>         dev_dbg(vdev->dev, "camera device close\n");
>  @@ -673,14 +702,14 @@ static int soc_camera_probe(struct device *dev)
>         if (!icd->probe)
>                 return -ENODEV;
>
>  +       /* We only call ->add() here to activate and probe the camera.
>  +        * We shall ->remove() and deactivate it immediately afterwards. */
>         ret = ici->add(icd);
>         if (ret < 0)
>                 return ret;
>
>         ret = icd->probe(icd);
>  -       if (ret < 0)
>  -               ici->remove(icd);
>  -       else {
>  +       if (ret >= 0) {
>                 const struct v4l2_queryctrl *qctrl;
>
>                 qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
>  @@ -689,6 +718,7 @@ static int soc_camera_probe(struct device *dev)
>                 icd->exposure = qctrl ? qctrl->default_value :
>                         (unsigned short)~0;
>         }
>  +       ici->remove(icd);
>
>         return ret;
>   }
>  @@ -698,13 +728,9 @@ static int soc_camera_probe(struct device *dev)
>   static int soc_camera_remove(struct device *dev)
>   {
>         struct soc_camera_device *icd = to_soc_camera_dev(dev);
>  -       struct soc_camera_host *ici =
>  -               to_soc_camera_host(icd->dev.parent);
>
>         if (icd->remove)
>                 icd->remove(icd);
>  -
>  -       ici->remove(icd);
>
>         return 0;
>   }
>  diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>  index 69aba71..c886b1e 100644
>  --- a/include/media/soc_camera.h
>  +++ b/include/media/soc_camera.h
>  @@ -41,6 +41,8 @@ struct soc_camera_device {
>         int (*probe)(struct soc_camera_device *icd);
>         void (*remove)(struct soc_camera_device *icd);
>         struct module *owner;
>  +       /* soc_camera.c private count. Only accessed with video_lock held */
>  +       int use_count;
>   };
>
>   struct soc_camera_file {
>



-- 
Cheers
- eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
