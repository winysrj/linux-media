Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1MKR6LX027404
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 15:27:06 -0500
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1MKQY3w000362
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 15:26:34 -0500
Message-ID: <47BF2FCD.7090604@free.fr>
Date: Fri, 22 Feb 2008 21:25:49 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
References: <1202916257-10421-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1202916257-10421-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [RFC 1/1] v4l2_extension: helper daemon commands passing
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

Jiri Slaby a écrit :
> Here I would like to know if the the commands passing interface to the
> helper daemon introduced in this patch is OK, or alternatively propose
> some other idea ;).
>   
It is a good starting point.
All ioctls will be processed in the helper daemon via the process_ioctl
command.
read/write processings make less context switchings than ioctls.
Further, mmap will be required to pass the compressed/uncompressed frames.

The point to think about is how to identify the base driver when we
reach the process_ioctl function.
The helper daemon must behave in a specific way for each base driver to
extend.
I see 2 solutions:
- identify the base driver at each request between the extended driver
and the helper daemon,
- instanciate a helper daemon for each base driver (that means
concurrent accesses to /dev/v4l2_extension)
Identify the base driver means the helper daemon must know its
capabilities, not only its name.

> ---
>  .../video/v4l2_extension/v4l2_extension-hlp.c      |  136 +++++++++++++++++++-
>  .../video/v4l2_extension/v4l2_extension-video.c    |   29 ++++-
>  .../media/video/v4l2_extension/v4l2_extension.h    |   34 ++++-
>  linux/include/linux/v4l2ext.h                      |   21 +++
>  v4l2-apps/v4l2ext_helper/v4l2ext_helper.c          |   40 ++++++-
>  5 files changed, 245 insertions(+), 15 deletions(-)
>  create mode 100644 linux/include/linux/v4l2ext.h
>
> diff --git a/linux/drivers/media/video/v4l2_extension/v4l2_extension-hlp.c b/linux/drivers/media/video/v4l2_extension/v4l2_extension-hlp.c
> index acea54b..ef4e9cc 100644
> --- a/linux/drivers/media/video/v4l2_extension/v4l2_extension-hlp.c
> +++ b/linux/drivers/media/video/v4l2_extension/v4l2_extension-hlp.c
> @@ -19,12 +19,21 @@
>   *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#include <linux/completion.h>
> +#include <linux/list.h>
>  #include <linux/miscdevice.h>
>  
>  #include "v4l2_extension.h"
>  
>  #define HELPER_IF_NAME              "v4l2_extension"
>  
> +struct helperd {
> +	struct list_head commands;	/* pending commands */
> +	struct list_head pcommands;	/* in process commands */
> +	__u32 tag;			/* next command's tag */
> +	wait_queue_head_t waitqueue;
> +} helperd_dev;
> +
>  /* helper_daemon states if the helper daemon has opened the driver */
>  static unsigned int helper_daemon;
>  static DEFINE_MUTEX(helper_daemon_lock);
> @@ -93,16 +102,119 @@ static int v4l2ext_hlp_release(struct inode *inode, struct file *file)
>  	mutex_lock(&helper_daemon_lock);
>  	/* Helper daemon has gone */
>  	helper_daemon = 0;
> -	kfree(file->private_data);
>  
>  	mutex_unlock(&helper_daemon_lock);
>  
>  	return 0;
>  }
>  
> +
> +static ssize_t v4l2ext_hlp_read(struct file *filp, char __user *buf,
> +		size_t count, loff_t *off)
> +{
> +	struct helperd *dev = filp->private_data;
> +	struct v4l2ext_hlp_icmd *icmd;
> +	struct v4l2ext_hlp_cmd __user *ubuf;
> +	unsigned int data_size = 0;
> +
> +	printk(KERN_DEBUG "READ A\n");
> +	if (count < sizeof(struct v4l2ext_hlp_cmd))
> +		return -EINVAL;
> +
> +	if (list_empty(&dev->commands))
> +		return -EAGAIN;
> +
> +	if (mutex_lock_interruptible(&helper_daemon_lock))
> +		return -ERESTARTSYS;
> +	icmd = list_first_entry(&dev->commands, struct v4l2ext_hlp_icmd, list);
> +	list_move_tail(&icmd->list, &dev->pcommands);
> +	mutex_unlock(&helper_daemon_lock);
> +
> +	ubuf = (struct v4l2ext_hlp_cmd __user *)buf;
> +	if (copy_to_user(ubuf, &icmd->cmd, sizeof(struct v4l2ext_hlp_cmd)))
> +		return -EFAULT;
> +	count -= sizeof(struct v4l2ext_hlp_cmd);
> +
> +	if (icmd->dir & V4L2EXT_HLP_WRITE)
> +		data_size = icmd->data_size;
> +	if (count < data_size)
> +		return -EINVAL;
> +
> +	if (data_size && copy_to_user(&ubuf->data, icmd->data, data_size))
> +		return -EFAULT;
> +
> +	printk(KERN_DEBUG "READ: %ld\n", sizeof(struct v4l2ext_hlp_cmd) + data_size);
> +
> +	return sizeof(struct v4l2ext_hlp_cmd) + data_size;
> +}
> +
> +static ssize_t v4l2ext_hlp_write(struct file *filp, const char __user *buf,
> +		size_t count, loff_t *off)
> +{
> +	struct helperd *dev = filp->private_data;
> +	struct v4l2ext_hlp_icmd *icmd;
> +	const struct v4l2ext_hlp_cmd __user *ubuf;
> +	struct v4l2ext_hlp_cmd cmd;
> +	unsigned int found = 0, data_size = 0;
> +	ssize_t ret;
> +
> +	printk(KERN_DEBUG "WRITE A\n");
> +	if (count < sizeof(struct v4l2ext_hlp_cmd))
> +		return -EINVAL;
> +
> +	ubuf = (const struct v4l2ext_hlp_cmd __user *)buf;
> +	if (copy_from_user(&cmd, ubuf, sizeof(struct v4l2ext_hlp_cmd)))
> +		return -EFAULT;
> +	count -= sizeof(struct v4l2ext_hlp_cmd);
> +
> +	if (mutex_lock_interruptible(&helper_daemon_lock))
> +		return -ERESTARTSYS;
> +	list_for_each_entry(icmd, &dev->pcommands, list)
> +		if (icmd->tag == cmd.tag) {
> +			found++;
> +			break;
> +		}
> +	if (!found) {
> +		printk(KERN_WARNING "v4l2ext_hlp: cmd with unqueued tag: %x\n",
> +				cmd.tag);
> +		mutex_unlock(&helper_daemon_lock);
> +		return -EINVAL;
> +	}
> +	list_del(&icmd->list);
> +	mutex_unlock(&helper_daemon_lock);
> +
> +	if (cmd.type == V4L2EXT_HLP_TYPE_INVALID) {
> +		ret = sizeof(struct v4l2ext_hlp_cmd);
> +		icmd->status = -EINVAL;
> +		goto err;
> +	}
> +
> +	if (icmd->dir & V4L2EXT_HLP_READ)
> +		data_size = icmd->data_size;
> +	if (count < data_size) { /* XXX requeue instead ? */
> +		icmd->status = ret = -EINVAL;
> +		goto err;
> +	}
> +	if (data_size && copy_from_user(icmd->data, &ubuf->data, data_size)) {
> +		icmd->status = -EINVAL;
> +		ret = -EFAULT;
> +		goto err;
> +	}
> +
> +	ret = sizeof(struct v4l2ext_hlp_cmd) + data_size;
> +err:
> +	complete(&icmd->done);
> +
> +	printk(KERN_DEBUG "WRITE: %ld\n", ret);
> +
> +	return ret;
> +}
> +
>  static const struct file_operations v4l2ext_hlp_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= v4l2ext_hlp_open,
> +	.read		= v4l2ext_hlp_read,
> +	.write		= v4l2ext_hlp_write,
>  	.poll		= v4l2ext_hlp_poll,
>  	.release	= v4l2ext_hlp_release,
>  	.mmap		= v4l2ext_hlp_mmap,
> @@ -115,6 +227,28 @@ static struct miscdevice misc_device = {
>  	.fops = &v4l2ext_hlp_fops,
>  };
>  
> +int v4l2ext_hlp_send_cmd(struct v4l2ext_hlp_icmd *icmd)
> +{
> +	init_completion(&icmd->done);
> +	mutex_lock(&helper_daemon_lock);
> +	if (!helper_daemon) {
> +		mutex_unlock(&helper_daemon_lock);
> +		return -EINVAL;
> +	}
> +	icmd->tag = icmd->cmd.tag = helperd_dev.tag++;
> +	list_add_tail(&icmd->list, &helperd_dev.commands);
> +	mutex_unlock(&helper_daemon_lock);
> +
> +	wake_up_interruptible(&helperd_dev.waitqueue);
> +	if (!wait_for_completion_timeout(&icmd->done, HZ * 10)) {
> +		printk(KERN_WARNING "v4l2ext: cmd %.8x type %u timed out\n",
> +				icmd->cmd.cmd, icmd->cmd.type);
> +		return -EINVAL;
> +	}
> +
> +	return icmd->status;
> +}
> +
>  int v4l2ext_hlp_init(void)
>  {
>  	return misc_register(&misc_device);
> diff --git a/linux/drivers/media/video/v4l2_extension/v4l2_extension-video.c b/linux/drivers/media/video/v4l2_extension/v4l2_extension-video.c
> index 789f7a4..e6c742c 100644
> --- a/linux/drivers/media/video/v4l2_extension/v4l2_extension-video.c
> +++ b/linux/drivers/media/video/v4l2_extension/v4l2_extension-video.c
> @@ -430,13 +430,32 @@ static int vidioc_enum_fmt_cap(struct file *file, void  *priv,
>  {
>  	struct v4l2ext *dev = priv;
>  	struct video_device *base_dev = dev->base_vdev;
> +	int ret = -EINVAL;
>  
>  	if (base_dev->vidioc_enum_fmt_cap)
> -		return base_dev->vidioc_enum_fmt_cap(&dev->fake_file,
> -						     dev->fake_file.private_data,
> -						     vfd);
> -	else
> -		return -EINVAL;
> +		ret = base_dev->vidioc_enum_fmt_cap(&dev->fake_file,
> +				dev->fake_file.private_data, vfd);
> +
> +	printk(KERN_DEBUG "ENUM_FMT: %d\n", ret);
> +	if (ret == -EINVAL) {
> +		struct v4l2ext_hlp_icmd icmd = {
> +			.cmd = {
> +				.type = V4L2EXT_HLP_TYPE_IOCTL,
> +				.cmd = VIDIOC_ENUM_FMT,
> +			},
> +			.dir = V4L2EXT_HLP_RW,
> +			.data = vfd,
> +			.data_size = sizeof(*vfd),
> +		};
> +		vfd->index -= dev->base_fmt;
> +		printk(KERN_DEBUG "SEND_CMD A %u\n", dev->base_fmt);
> +		ret = v4l2ext_hlp_send_cmd(&icmd);
> +		printk(KERN_DEBUG "SEND_CMD: %d\n", ret);
> +		vfd->index += dev->base_fmt;
> +	} else if (!ret)
> +		dev->base_fmt = vfd->index + 1;
> +
> +	return ret;
>  }
>  
>  static int vidioc_g_fmt_cap(struct file *file, void *priv,
> diff --git a/linux/drivers/media/video/v4l2_extension/v4l2_extension.h b/linux/drivers/media/video/v4l2_extension/v4l2_extension.h
> index 1ceaef3..2a86ce9 100644
> --- a/linux/drivers/media/video/v4l2_extension/v4l2_extension.h
> +++ b/linux/drivers/media/video/v4l2_extension/v4l2_extension.h
> @@ -20,14 +20,18 @@
>   *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#include <linux/v4l2ext.h>
>  #include <linux/videodev2.h>
>  
>  #include <media/v4l2-common.h>
>  
>  #include "compat.h"
>  
> -#include <linux/version.h>
> +#include <linux/completion.h>
> +#include <linux/list.h>
>  #include <linux/mutex.h>
> +#include <linux/types.h>
> +#include <linux/version.h>
>  
>  #define V4L2EXT_VERSION_CODE KERNEL_VERSION(0, 0, 1)
>  
> @@ -48,15 +52,29 @@ void v4l2ext_unregister(struct video_device *base_vdev);
>  /***************************************************************************/
>  /* v4l2 helper daemon interface                                            */
>  /***************************************************************************/
> +
> +#define V4L2EXT_HLP_NONE	0
> +#define V4L2EXT_HLP_READ	1
> +#define V4L2EXT_HLP_WRITE	2
> +#define V4L2EXT_HLP_RW		(V4L2EXT_HLP_READ | V4L2EXT_HLP_WRITE)
> +struct v4l2ext_hlp_icmd {
> +	/* internals */
> +	struct list_head list;
> +	struct completion done;
> +	int status;
> +	__u32 tag;
> +
> +	/* externals */
> +	struct v4l2ext_hlp_cmd cmd;
> +	unsigned int dir;
> +	unsigned int data_size;
> +	void *data;
> +};
> +
>  int v4l2ext_hlp_init(void);
>  void v4l2ext_hlp_fini(void);
>  
> -/***************************************************************************/
> -/* v4l2 helper daemon private interface                                    */
> -/***************************************************************************/
> -struct helperd {
> -	wait_queue_head_t waitqueue;
> -};
> +int v4l2ext_hlp_send_cmd(struct v4l2ext_hlp_icmd *icmd);
>  
>  /***************************************************************************/
>  /* v4l2 extension driver private interface                                 */
> @@ -74,6 +92,8 @@ struct v4l2ext {
>  
>  	int dev_nr; /* extended device sequential number */
>  	struct video_device *vdev; /* the extended video device entry point */
> +
> +	__u32 base_fmt;
>  };
>  
>  /*
> diff --git a/linux/include/linux/v4l2ext.h b/linux/include/linux/v4l2ext.h
> new file mode 100644
> index 0000000..16053ec
> --- /dev/null
> +++ b/linux/include/linux/v4l2ext.h
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (c) 2008 Jiri Slaby <jirislaby@gmail.com>
> + *
> + * Licensed under GPLv2
> + */
> +
> +#ifndef V4L2EXT_H_FILE
> +#define V4L2EXT_H_FILE
> +
> +#include <linux/types.h>
> +
> +#define V4L2EXT_HLP_TYPE_INVALID	0
> +#define V4L2EXT_HLP_TYPE_IOCTL		1
> +struct v4l2ext_hlp_cmd {
> +	__u32 type;
> +	__u32 cmd;
> +	__u32 tag;	/* don't touch */
> +	__u8 data[0];
> +} __attribute__ ((packed));
> +
> +#endif
> diff --git a/v4l2-apps/v4l2ext_helper/v4l2ext_helper.c b/v4l2-apps/v4l2ext_helper/v4l2ext_helper.c
> index 34c684f..eb582ba 100644
> --- a/v4l2-apps/v4l2ext_helper/v4l2ext_helper.c
> +++ b/v4l2-apps/v4l2ext_helper/v4l2ext_helper.c
> @@ -32,6 +32,10 @@
>  #include <syslog.h>
>  #include <unistd.h>
>  
> +#include <linux/ioctl.h> /* _IOC macros, videodev doesn't include it! */
> +#include <linux/v4l2ext.h>
> +#include <linux/videodev2.h>
> +
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  
> @@ -172,9 +176,24 @@ static int daemonize(const char *lockfile)
>  	return 0;
>  }
>  
> +static int process_ioctl(struct v4l2ext_hlp_cmd *cmd)
> +{
> +	int ret = -1;
> +
> +	switch (cmd->cmd) {
> +	case VIDIOC_ENUM_FMT: {
> +		struct v4l2_fmtdesc *fmt = (void *)&cmd->data;
> +		printf("ENUM_FMT: i %u, type %u\n", fmt->index, fmt->type);
> +		break;
> +	}
> +	}
> +
> +	return ret;
> +}
> +
>  int main(int argc, char *argv[])
>  {
> -	void *ring;
> +	struct v4l2ext_hlp_cmd *cmd;
>  	char buffer[512];
>  	fd_set fds;
>  	int ch, fd, r;
> @@ -228,10 +247,27 @@ int main(int argc, char *argv[])
>  
>  		/* react to the devices's request */
>  		r = read(fd, buffer, sizeof(buffer));
> -		if (r <= 0) {
> +		if (r <= (int)sizeof(struct v4l2ext_hlp_cmd)) {
>  			LOG(LOG_ERR, "error on read (%s)", strerror(errno));
>  			return EXIT_FAILURE;
>  		}
> +		cmd = (struct v4l2ext_hlp_cmd *)buffer;
> +		printf("type %u, cmd: %x, tag: %x\n", cmd->type, cmd->cmd, cmd->tag);
> +
> +		r = -1;
> +		switch (cmd->type) {
> +		case V4L2EXT_HLP_TYPE_IOCTL:
> +			r = process_ioctl(cmd);
> +			break;
> +		}
> +
> +		if (r < 0)
> +			cmd->type = V4L2EXT_HLP_TYPE_INVALID;
> +
> +		if (write(fd, buffer, sizeof(buffer)) <= 0) {
> +			LOG(LOG_ERR, "error on write (%s)", strerror(errno));
> +			return EXIT_FAILURE;
> +		}
>  	}
>  
>  	/* Finish up */
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
