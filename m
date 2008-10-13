Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DLTe73027089
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 17:29:40 -0400
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DLSxGv007807
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 17:28:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Date: Mon, 13 Oct 2008 23:28:46 +0200
References: <48F3B56E.9050404@freemail.hu>
In-Reply-To: <48F3B56E.9050404@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200810132328.47170.hverkuil@xs4all.nl>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] video: simplify cx18_get_input() and
	ivtv_get_input()
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

On Monday 13 October 2008 22:54:06 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> The cx18_get_input() and ivtv_get_input() are called
> once from the VIDIOC_ENUMINPUT ioctl() and once from
> the *_log_status() functions. In the first case the
> struct v4l2_input is already filled with zeros,
> so doing this again is unnecessary.

And in the second case no one cares whether the struct is zeroed. And 
the same situation is also true for ivtv_get_output().

I would suggest just removing the memset() from ivtv_get_input, 
ivtv_get_output and cx18_get_input.

Good that you spotted that this memset is no longer needed BTW. I hadn't 
realized that.

For the record, I NACK this patch, but if you can make a new one that 
just removes the memsets then I'll sign off on that.

Regards,

	Hans

> The *_log_status() functions are called from
> VIDIOC_LOG_STATUS ioctl() which is only used for
> debug purposes, so it is worth to move the filling
> with zeros to a least frequently used function.
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -upr linux-2.6.27.orig/drivers/media/video/cx18/cx18-cards.c
> linux-2.6.27/drivers/media/video/cx18/cx18-cards.c ---
> linux-2.6.27.orig/drivers/media/video/cx18/cx18-cards.c	2008-10-10
> 00:13:53.000000000 +0200 +++
> linux-2.6.27/drivers/media/video/cx18/cx18-cards.c	2008-10-13
> 21:27:54.000000000 +0200 @@ -320,10 +320,9 @@ int
> cx18_get_input(struct cx18 *cx, u16 "Composite 3"
>  	};
>
> -	memset(input, 0, sizeof(*input));
>  	if (index >= cx->nof_inputs)
>  		return -EINVAL;
> -	input->index = index;
> +
>  	strlcpy(input->name, input_strs[card_input->video_type - 1],
>  			sizeof(input->name));
>  	input->type = (card_input->video_type == CX18_CARD_INPUT_VID_TUNER
> ? diff -upr linux-2.6.27.orig/drivers/media/video/cx18/cx18-ioctl.c
> linux-2.6.27/drivers/media/video/cx18/cx18-ioctl.c ---
> linux-2.6.27.orig/drivers/media/video/cx18/cx18-ioctl.c	2008-10-10
> 00:13:53.000000000 +0200 +++
> linux-2.6.27/drivers/media/video/cx18/cx18-ioctl.c	2008-10-13
> 21:28:11.000000000 +0200 @@ -712,7 +712,11 @@ static int
> cx18_log_status(struct file * cx18_read_eeprom(cx, &tv);
>  	}
>  	cx18_call_i2c_clients(cx, VIDIOC_LOG_STATUS, NULL);
> +
> +	memset(&vidin, 0, sizeof(vidin));
> +	vidin.index = cx->active_input;
>  	cx18_get_input(cx, cx->active_input, &vidin);
> +
>  	cx18_get_audio_input(cx, cx->audio_input, &audin);
>  	CX18_INFO("Video Input: %s\n", vidin.name);
>  	CX18_INFO("Audio Input: %s\n", audin.name);
> diff -upr linux-2.6.27.orig/drivers/media/video/ivtv/ivtv-cards.c
> linux-2.6.27/drivers/media/video/ivtv/ivtv-cards.c ---
> linux-2.6.27.orig/drivers/media/video/ivtv/ivtv-cards.c	2008-10-10
> 00:13:53.000000000 +0200 +++
> linux-2.6.27/drivers/media/video/ivtv/ivtv-cards.c	2008-10-13
> 21:22:59.000000000 +0200 @@ -1199,10 +1199,9 @@ int
> ivtv_get_input(struct ivtv *itv, u16 "Composite 3"
>  	};
>
> -	memset(input, 0, sizeof(*input));
>  	if (index >= itv->nof_inputs)
>  		return -EINVAL;
> -	input->index = index;
> +
>  	strlcpy(input->name, input_strs[card_input->video_type - 1],
>  			sizeof(input->name));
>  	input->type = (card_input->video_type == IVTV_CARD_INPUT_VID_TUNER
> ? diff -upr linux-2.6.27.orig/drivers/media/video/ivtv/ivtv-ioctl.c
> linux-2.6.27/drivers/media/video/ivtv/ivtv-ioctl.c ---
> linux-2.6.27.orig/drivers/media/video/ivtv/ivtv-ioctl.c	2008-10-10
> 00:13:53.000000000 +0200 +++
> linux-2.6.27/drivers/media/video/ivtv/ivtv-ioctl.c	2008-10-13
> 21:21:35.000000000 +0200 @@ -1446,7 +1446,11 @@ static int
> ivtv_log_status(struct file * ivtv_read_eeprom(itv, &tv);
>  	}
>  	ivtv_call_i2c_clients(itv, VIDIOC_LOG_STATUS, NULL);
> +
> +	memset(&vidin, 0, sizeof(vidin));
> +	vidin.index = itv->active_input;
>  	ivtv_get_input(itv, itv->active_input, &vidin);
> +
>  	ivtv_get_audio_input(itv, itv->audio_input, &audin);
>  	IVTV_INFO("Video Input:  %s\n", vidin.name);
>  	IVTV_INFO("Audio Input:  %s%s\n", audin.name,
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
