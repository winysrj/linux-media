Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:55686 "EHLO iodev.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbdH1SnX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 14:43:23 -0400
Date: Mon, 28 Aug 2017 15:43:14 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        maintainers@bluecherrydvr.com, anton@corp.bluecherry.net,
        andrey.utkin@corp.bluecherry.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] pci: make video_device const
Message-ID: <20170828184313.GB9847@pirotess.bf.iodev.co.uk>
References: <1503752891-19879-1-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503752891-19879-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/Aug/2017 18:38, Bhumika Goyal wrote:
> Make these const as they are either used during a copy operation or
> passed to a const argument of the function cx88_vdev_init.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---
> * Combine the patch series sent for drivers/media/pci/ into a
> single patch.
> 
>  drivers/media/pci/cx88/cx88-blackbird.c     | 2 +-
>  drivers/media/pci/dt3155/dt3155.c           | 2 +-
>  drivers/media/pci/meye/meye.c               | 2 +-
>  drivers/media/pci/saa7134/saa7134-empress.c | 2 +-
>  drivers/media/pci/solo6x10/solo6x10-v4l2.c  | 2 +-
>  drivers/media/pci/sta2x11/sta2x11_vip.c     | 2 +-
>  drivers/media/pci/tw68/tw68-video.c         | 2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
> index aa49c95..e3101f0 100644
> --- a/drivers/media/pci/cx88/cx88-blackbird.c
> +++ b/drivers/media/pci/cx88/cx88-blackbird.c
> @@ -1075,7 +1075,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
>  	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
>  };
>  
> -static struct video_device cx8802_mpeg_template = {
> +static const struct video_device cx8802_mpeg_template = {
>  	.name                 = "cx8802",
>  	.fops                 = &mpeg_fops,
>  	.ioctl_ops	      = &mpeg_ioctl_ops,
> diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
> index 6a21969..1775c36 100644
> --- a/drivers/media/pci/dt3155/dt3155.c
> +++ b/drivers/media/pci/dt3155/dt3155.c
> @@ -499,7 +499,7 @@ static int dt3155_init_board(struct dt3155_priv *pd)
>  	return 0;
>  }
>  
> -static struct video_device dt3155_vdev = {
> +static const struct video_device dt3155_vdev = {
>  	.name = DT3155_NAME,
>  	.fops = &dt3155_fops,
>  	.ioctl_ops = &dt3155_ioctl_ops,
> diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
> index 0fe76be..49e047e 100644
> --- a/drivers/media/pci/meye/meye.c
> +++ b/drivers/media/pci/meye/meye.c
> @@ -1533,7 +1533,7 @@ static int meye_mmap(struct file *file, struct vm_area_struct *vma)
>  	.vidioc_default		= vidioc_default,
>  };
>  
> -static struct video_device meye_template = {
> +static const struct video_device meye_template = {
>  	.name		= "meye",
>  	.fops		= &meye_fops,
>  	.ioctl_ops 	= &meye_ioctl_ops,
> diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
> index b1d3648..66acfd3 100644
> --- a/drivers/media/pci/saa7134/saa7134-empress.c
> +++ b/drivers/media/pci/saa7134/saa7134-empress.c
> @@ -205,7 +205,7 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
>  
>  /* ----------------------------------------------------------- */
>  
> -static struct video_device saa7134_empress_template = {
> +static const struct video_device saa7134_empress_template = {
>  	.name          = "saa7134-empress",
>  	.fops          = &ts_fops,
>  	.ioctl_ops     = &ts_ioctl_ops,
> diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> index 3266fc2..99ffd1e 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> @@ -630,7 +630,7 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
>  	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>  };
>  
> -static struct video_device solo_v4l2_template = {
> +static const struct video_device solo_v4l2_template = {
>  	.name			= SOLO6X10_NAME,
>  	.fops			= &solo_v4l2_fops,
>  	.ioctl_ops		= &solo_v4l2_ioctl_ops,
> diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
> index 6343d24..eb5a9ea 100644
> --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
> +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
> @@ -754,7 +754,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };
>  
> -static struct video_device video_dev_template = {
> +static const struct video_device video_dev_template = {
>  	.name = KBUILD_MODNAME,
>  	.release = video_device_release_empty,
>  	.fops = &vip_fops,
> diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
> index 58c4dd7..8c1f4a0 100644
> --- a/drivers/media/pci/tw68/tw68-video.c
> +++ b/drivers/media/pci/tw68/tw68-video.c
> @@ -916,7 +916,7 @@ static int vidioc_s_register(struct file *file, void *priv,
>  #endif
>  };
>  
> -static struct video_device tw68_video_template = {
> +static const struct video_device tw68_video_template = {
>  	.name			= "tw68_video",
>  	.fops			= &video_fops,
>  	.ioctl_ops		= &video_ioctl_ops,
> -- 
> 1.9.1

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
