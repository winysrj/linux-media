Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9M1PAF021054
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 17:01:25 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9M1Afq030433
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 17:01:11 -0500
Message-ID: <493EEA59.2040406@hhs.nl>
Date: Tue, 09 Dec 2008 22:59:53 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jim Paris <jim@jtan.com>
References: <20081209215837.GA24743@psychosis.jim.sh>
In-Reply-To: <20081209215837.GA24743@psychosis.jim.sh>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: gspca: fix vidioc_s_jpegcomp locking
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

Jim Paris wrote:
> This locking looked wrong.
> 

Hi,

I appreciate the effort, but please do not send patches just because something 
looks wrong. The original code is perfectly fine. It check if the sub driver 
supports set_jcomp at all, this check does not need locking.

Regards,

Hans


> -jim
> 
> --
> 
> gspca: fix vidioc_s_jpegcomp locking
> 
> Signed-off-by: Jim Paris <jim@jtan.com>
> 
> diff -r b50857fea6df linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Tue Dec 09 16:20:31 2008 -0500
> +++ b/linux/drivers/media/video/gspca/gspca.c	Tue Dec 09 16:55:39 2008 -0500
> @@ -1320,10 +1320,10 @@
>  	struct gspca_dev *gspca_dev = priv;
>  	int ret;
>  
> +	if (!gspca_dev->sd_desc->set_jcomp)
> +		return -EINVAL;
>  	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
>  		return -ERESTARTSYS;
> -	if (!gspca_dev->sd_desc->set_jcomp)
> -		return -EINVAL;
>  	ret = gspca_dev->sd_desc->set_jcomp(gspca_dev, jpegcomp);
>  	mutex_unlock(&gspca_dev->usb_lock);
>  	return ret;
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
