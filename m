Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:39277 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbZCDAln (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2009 19:41:43 -0500
Subject: Re: saa7134 and RDS
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>,
	"Hans J. Koch" <koch@hjk-az.de>,
	=?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <20090302133333.6f89aef0@glory.loctelecom.ru>
References: <20090302133333.6f89aef0@glory.loctelecom.ru>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 01:43:08 +0100
Message-Id: <1236127388.3324.20.camel@pc09.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 02.03.2009, 13:33 +0900 schrieb Dmitri Belimov:
> Hi All.
> 
> I want use RDS on our TV cards. But now saa7134 not work with saa6588.
> I found this old patch from Hans J. Koch. Why this patch is not in mercurial??
> Yes I know that patch for v4l ver.1 and for old kernel. But why not?? 
> v4l has other way for RDS on saa7134 boards?

I think the patch got lost, because it was not clear who should pull it
in. Likely Hartmut or Mauro would have picked it up in 2006 if pinged
directly.

Please try to work with Hans to get it in now. There was also a
suggestion to add a has_rds capability flag and about how to deal with
different RDS decoders later, IIRC.

Cheers,
Hermann

------- from Hans' original posting ------

> I finally succeeded adding support for the saa6588 RDS decoder to the saa7134 
> driver. I tested it with a Terratec Cinergy 600, and it seems to work. With 
> the attached patch applied to saa7134-video.c, I can do
> 
> modprobe saa6588 xtal=1
> 
> and can then read RDS data from /dev/radio.
> 
> I'd be pleased if you could apply that patch.
> 
> Cheers,
> Hans
> 
> Signed-off-by: Hans J. Koch <koch@xxxxxxxxx>
> 
> --- orig/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-video.c	2006-05-06 13:27:49.000000000 +0200
> +++ mine/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-video.c	2006-05-05 14:38:11.000000000 +0200
> @@ -31,6 +31,7 @@
>  #include "saa7134-reg.h"
>  #include "saa7134.h"
>  #include <media/v4l2-common.h>
> +#include <media/rds.h>
>  
>  #ifdef CONFIG_VIDEO_V4L1_COMPAT
>  /* Include V4L1 specific functions. Should be removed soon */
> @@ -1374,6 +1375,7 @@ static int video_release(struct inode *i
>  	struct saa7134_fh  *fh  = file->private_data;
>  	struct saa7134_dev *dev = fh->dev;
>  	unsigned long flags;
> +	struct rds_command cmd;
>  
>  	/* turn off overlay */
>  	if (res_check(fh, RESOURCE_OVERLAY)) {
> @@ -1409,6 +1411,7 @@ static int video_release(struct inode *i
>  	saa_andorb(SAA7134_OFMT_DATA_B, 0x1f, 0);
>  
>  	saa7134_i2c_call_clients(dev, TUNER_SET_STANDBY, NULL);
> +	saa7134_i2c_call_clients(dev, RDS_CMD_CLOSE, &cmd);
>  
>  	/* free stuff */
>  	videobuf_mmap_free(&fh->cap);
> @@ -2284,6 +2287,35 @@ static int radio_ioctl(struct inode *ino
>  	return video_usercopy(inode, file, cmd, arg, radio_do_ioctl);
>  }
>  
> +static ssize_t radio_read(struct file *file, char __user *data,
> +			 size_t count, loff_t *ppos)
> +{
> +	struct saa7134_fh *fh = file->private_data;
> +	struct saa7134_dev *dev = fh->dev;
> +	struct rds_command cmd;
> +	cmd.block_count = count/3;
> +	cmd.buffer = data;
> +	cmd.instance = file;
> +	cmd.result = -ENODEV;
> +
> +	saa7134_i2c_call_clients(dev, RDS_CMD_READ, &cmd);
> +
> +	return cmd.result;
> +}
> +
> +static unsigned int radio_poll(struct file *file, poll_table *wait)
> +{
> +	struct saa7134_fh *fh = file->private_data;
> +	struct saa7134_dev *dev = fh->dev;
> +	struct rds_command cmd;
> +	cmd.instance = file;
> +	cmd.event_list = wait;
> +	cmd.result = -ENODEV;
> +	saa7134_i2c_call_clients(dev, RDS_CMD_POLL, &cmd);
> +
> +	return cmd.result;
> +}
> +
>  static struct file_operations video_fops =
>  {
>  	.owner	  = THIS_MODULE,
> @@ -2305,6 +2337,8 @@ static struct file_operations radio_fops
>  	.open	  = video_open,
>  	.release  = video_release,
>  	.ioctl	  = radio_ioctl,
> +	.read	  = radio_read,
> +	.poll	  = radio_poll,
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,11)
>  	.compat_ioctl	= v4l_compat_ioctl32,
>  #endif
> 
> --
> 
> 
> With my best regards, Dmitry.
> 


