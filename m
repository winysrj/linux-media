Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab2DKCSF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 22:18:05 -0400
Message-ID: <4F84E9D2.7000405@redhat.com>
Date: Tue, 10 Apr 2012 23:17:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
CC: linux-media@vger.kernel.org,
	"Steinar H. Gunderson" <sesse@samfundet.no>
Subject: Re: [PATCH 03/11] Hack to fix a mutex issue in the DVB layer.
References: <20120401155330.GA31901@uio.no> <1333295631-31866-3-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <1333295631-31866-3-git-send-email-sgunderson@bigfoot.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-04-2012 12:53, Steinar H. Gunderson escreveu:
> From: "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> dvb_usercopy(), which is called on all ioctls, not only copies data to and from
> userspace, but also takes a lock on the file descriptor, which means that only
> one ioctl can run at a time. This means that if one thread of mumudvb is busy
> trying to get, say, the SNR from the frontend (which can hang due to the issue
> above), the CAM thread's ioctl(fd, CA_GET_SLOT_INFO, ...) will hang, even
> though it doesn't need to communicate with the hardware at all.  This obviously
> requires a better fix, but I don't know the generic DVB layer well enough to
> say what it is. Maybe it's some sort of remnant of from when all ioctl()s took
> the BKL. Note that on UMP kernels without preemption, mutex_lock is to the best
> of my knowledge a no-op, so these delay issues would not show up on non-SMP.
> 
> Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
> ---
>  drivers/media/dvb/dvb-core/dvbdev.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
> index 00a6732..e1217f6 100644
> --- a/drivers/media/dvb/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb/dvb-core/dvbdev.c
> @@ -417,10 +417,8 @@ int dvb_usercopy(struct file *file,
>  	}
>  
>  	/* call driver */
> -	mutex_lock(&dvbdev_mutex);
>  	if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
>  		err = -EINVAL;
> -	mutex_unlock(&dvbdev_mutex);

As-is, this would be too risky, as it may break random drivers. 

A change like that would require to push down the mutex lock into each caller for
dvb_user_copy:

drivers/media/dvb/dvb-core/dmxdev.c:      return dvb_usercopy(file, cmd, arg, dvb_demux_do_ioctl);
drivers/media/dvb/dvb-core/dmxdev.c:      return dvb_usercopy(file, cmd, arg, dvb_dvr_do_ioctl);
drivers/media/dvb/dvb-core/dvb_ca_en50221.c:      return dvb_usercopy(file, cmd, arg, dvb_ca_en50221_io_do_ioctl);
drivers/media/dvb/dvb-core/dvb_net.c:     return dvb_usercopy(file, cmd, arg, dvb_net_do_ioctl);
drivers/media/dvb/dvb-core/dvbdev.c:      return dvb_usercopy(file, cmd, arg, dvbdev->kernel_ioctl);
drivers/media/dvb/dvb-core/dvbdev.c:int dvb_usercopy(struct file *file,
drivers/media/dvb/dvb-core/dvbdev.h:we simply define out own dvb_usercopy(), which will hopefully become
drivers/media/dvb/dvb-core/dvbdev.h:extern int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,

$ git grep kernel_ioctl drivers/media/dvb/
drivers/media/dvb/dvb-core/dvb_frontend.c:                .kernel_ioctl = dvb_frontend_ioctl
drivers/media/dvb/dvb-core/dvbdev.c:      if (!dvbdev->kernel_ioctl)
drivers/media/dvb/dvb-core/dvbdev.c:      return dvb_usercopy(file, cmd, arg, dvbdev->kernel_ioctl);
drivers/media/dvb/dvb-core/dvbdev.h:      int (*kernel_ioctl)(struct file *file, unsigned int cmd, void *arg);
drivers/media/dvb/firewire/firedtv-ci.c:  .kernel_ioctl   = fdtv_ca_ioctl,
drivers/media/dvb/ttpci/av7110.c: .kernel_ioctl   = dvb_osd_ioctl,
drivers/media/dvb/ttpci/av7110_av.c:      .kernel_ioctl   = dvb_video_ioctl,
drivers/media/dvb/ttpci/av7110_av.c:      .kernel_ioctl   = dvb_audio_ioctl,
drivers/media/dvb/ttpci/av7110_ca.c:      .kernel_ioctl   = dvb_ca_ioctl,

And optimize the code there to avoid uneeded locks.

>  
>  	if (err < 0)
>  		goto out;

