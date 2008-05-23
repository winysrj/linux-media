Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4N29A7Y010718
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 22:09:10 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4N28wtJ008723
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 22:08:58 -0400
From: Andy Walls <awalls@radix.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, video4linux-list@redhat.com
In-Reply-To: <20080522223700.2f103a14@core>
References: <20080522223700.2f103a14@core>
Content-Type: text/plain
Date: Thu, 22 May 2008 22:08:04 -0400
Message-Id: <1211508484.3273.86.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video4linux: Push down the BKL
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

On Thu, 2008-05-22 at 22:37 +0100, Alan Cox wrote:
> For most drivers the generic ioctl handler does the work and we update it
> and it becomes the unlocked_ioctl method. Older drivers use the usercopy
> method so we make it do the work. Finally there are a few special cases.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

I'd like to start planning out the changes to eliminate the BKL from
cx18.

Could someone give me a brief education as to what elements of
cx18/ivtv_v4l2_do_ioctl() would be forcing the use of the BKL for these
drivers' ioctls?   I'm assuming it's not the
mutex_un/lock(&....->serialize_lock) and that the answer's not in the
diff.

Thanks.
Andy

> diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
> index dbdcb86..faf3a31 100644
> --- a/drivers/media/video/cx18/cx18-ioctl.c
> +++ b/drivers/media/video/cx18/cx18-ioctl.c
> @@ -837,15 +837,16 @@ static int cx18_v4l2_do_ioctl(struct inode *inode, struct file *filp,
>  	return 0;
>  }
>  
> -int cx18_v4l2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
> -		    unsigned long arg)
> +long cx18_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct cx18_open_id *id = (struct cx18_open_id *)filp->private_data;
>  	struct cx18 *cx = id->cx;
>  	int res;
>  
> +	lock_kernel();
>  	mutex_lock(&cx->serialize_lock);
> -	res = video_usercopy(inode, filp, cmd, arg, cx18_v4l2_do_ioctl);
> +	res = video_usercopy(filp, cmd, arg, cx18_v4l2_do_ioctl);
>  	mutex_unlock(&cx->serialize_lock);
> +	unlock_kernel();
>  	return res;
>  }
> diff --git a/drivers/media/video/cx18/cx18-ioctl.h b/drivers/media/video/cx18/cx18-ioctl.h
> index 9f4c7eb..32bede3 100644
> --- a/drivers/media/video/cx18/cx18-ioctl.h
> +++ b/drivers/media/video/cx18/cx18-ioctl.h
> @@ -1,4 +1,4 @@
> -/*
> + /*
>   *  cx18 ioctl system call
>   *
>   *  Derived from ivtv-ioctl.h
> @@ -24,7 +24,6 @@
>  u16 cx18_service2vbi(int type);
>  void cx18_expand_service_set(struct v4l2_sliced_vbi_format *fmt, int is_pal);
>  u16 cx18_get_service_set(struct v4l2_sliced_vbi_format *fmt);
> -int cx18_v4l2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
> -		    unsigned long arg);
> +long cx18_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
>  int cx18_v4l2_ioctls(struct cx18 *cx, struct file *filp, unsigned cmd,
>  		     void *arg);
> diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
> index afb141b..7348b82 100644
> --- a/drivers/media/video/cx18/cx18-streams.c
> +++ b/drivers/media/video/cx18/cx18-streams.c
> @@ -39,7 +39,7 @@ static struct file_operations cx18_v4l2_enc_fops = {
>        .owner = THIS_MODULE,
>        .read = cx18_v4l2_read,
>        .open = cx18_v4l2_open,
> -      .ioctl = cx18_v4l2_ioctl,
> +      .unlocked_ioctl = cx18_v4l2_ioctl,
>        .release = cx18_v4l2_close,
>        .poll = cx18_v4l2_enc_poll,
>  };

> diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
> index d508b5d..a481b2d 100644
> --- a/drivers/media/video/ivtv/ivtv-ioctl.c
> +++ b/drivers/media/video/ivtv/ivtv-ioctl.c
> @@ -1726,7 +1726,7 @@ static int ivtv_v4l2_do_ioctl(struct inode *inode, struct file *filp,
>  	return 0;
>  }
>  
> -static int ivtv_serialized_ioctl(struct ivtv *itv, struct inode *inode, struct file *filp,
> +static int ivtv_serialized_ioctl(struct ivtv *itv, struct file *filp,
>  		unsigned int cmd, unsigned long arg)
>  {
>  	/* Filter dvb ioctls that cannot be handled by video_usercopy */
> @@ -1761,18 +1761,19 @@ static int ivtv_serialized_ioctl(struct ivtv *itv, struct inode *inode, struct f
>  	default:
>  		break;
>  	}
> -	return video_usercopy(inode, filp, cmd, arg, ivtv_v4l2_do_ioctl);
> +	return video_usercopy(filp, cmd, arg, ivtv_v4l2_do_ioctl);
>  }
>  
> -int ivtv_v4l2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
> -		    unsigned long arg)
> +long ivtv_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct ivtv_open_id *id = (struct ivtv_open_id *)filp->private_data;
>  	struct ivtv *itv = id->itv;
>  	int res;
>  
> +	lock_kernel();
>  	mutex_lock(&itv->serialize_lock);
> -	res = ivtv_serialized_ioctl(itv, inode, filp, cmd, arg);
> +	res = ivtv_serialized_ioctl(itv, filp, cmd, arg);
>  	mutex_unlock(&itv->serialize_lock);
> +	unlock_kernel();
>  	return res;
>  }
> diff --git a/drivers/media/video/ivtv/ivtv-ioctl.h b/drivers/media/video/ivtv/ivtv-ioctl.h
> index a03351b..6708ea0 100644
> --- a/drivers/media/video/ivtv/ivtv-ioctl.h
> +++ b/drivers/media/video/ivtv/ivtv-ioctl.h
> @@ -24,8 +24,7 @@
>  u16 service2vbi(int type);
>  void expand_service_set(struct v4l2_sliced_vbi_format *fmt, int is_pal);
>  u16 get_service_set(struct v4l2_sliced_vbi_format *fmt);
> -int ivtv_v4l2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
> -		    unsigned long arg);
> +long ivtv_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
>  int ivtv_v4l2_ioctls(struct ivtv *itv, struct file *filp, unsigned int cmd, void *arg);
>  void ivtv_set_osd_alpha(struct ivtv *itv);
>  int ivtv_set_speed(struct ivtv *itv, int speed);
> diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
> index 4ab8d36..3131f68 100644
> --- a/drivers/media/video/ivtv/ivtv-streams.c
> +++ b/drivers/media/video/ivtv/ivtv-streams.c
> @@ -48,7 +48,7 @@ static const struct file_operations ivtv_v4l2_enc_fops = {
>        .read = ivtv_v4l2_read,
>        .write = ivtv_v4l2_write,
>        .open = ivtv_v4l2_open,
> -      .ioctl = ivtv_v4l2_ioctl,
> +      .unlocked_ioctl = ivtv_v4l2_ioctl,
>        .release = ivtv_v4l2_close,
>        .poll = ivtv_v4l2_enc_poll,
>  };
> @@ -58,7 +58,7 @@ static const struct file_operations ivtv_v4l2_dec_fops = {
>        .read = ivtv_v4l2_read,
>        .write = ivtv_v4l2_write,
>        .open = ivtv_v4l2_open,
> -      .ioctl = ivtv_v4l2_ioctl,
> +      .unlocked_ioctl = ivtv_v4l2_ioctl,
>        .release = ivtv_v4l2_close,
>        .poll = ivtv_v4l2_dec_poll,
>  };



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
