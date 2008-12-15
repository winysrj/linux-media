Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBF8W3Oa020974
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 03:32:03 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBF8Vm5J006308
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 03:31:49 -0500
Date: Mon, 15 Dec 2008 09:31:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <u3agtx39i.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812150910190.3722@axis700.grange>
References: <u3agtx39i.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH re-send v2] Add interlace support to
	sh_mobile_ceu_camera.c
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

On Fri, 12 Dec 2008, Kuninori Morimoto wrote:

> @@ -640,7 +658,15 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
>  	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
>  
>  	/* limit to sensor capabilities */
> -	return icd->ops->try_fmt(icd, f);
> +	ret = icd->ops->try_fmt(icd, f);
> +
> +	pcdev->is_interlace = 0;
> +	if (V4L2_FIELD_INTERLACED == f->fmt.pix.field) {
> +		pcdev->is_interlace = 1;
> +		f->fmt.pix.field = V4L2_FIELD_NONE;
> +	}
> +
> +	return ret;
>  }
>  
>  static int sh_mobile_ceu_reqbufs(struct soc_camera_file *icf,

...and once again I do not understand how this can work with the present 
soc_camera.c:

	/*
	 * TODO: this might also have to migrate to host-drivers, if anyone
	 * wishes to support other fields
	 */
	field = f->fmt.pix.field;

	if (field == V4L2_FIELD_ANY) {
		f->fmt.pix.field = V4L2_FIELD_NONE;
	} else if (field != V4L2_FIELD_NONE) {
		dev_err(&icd->dev, "Field type invalid.\n");
		return -EINVAL;
	}

	/* limit format to hardware capabilities */
	ret = ici->ops->try_fmt(icd, f);

I do not understand how you can get in your driver anything other than 
V4L2_FIELD_NONE, do you? Ahhh... I see now:

+static int tw9910_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
...
+	pix->field = V4L2_FIELD_INTERLACED;

Noooo... We don't want to do this. We first require that the user only 
requests NONE or ANY, and then rewrite it to INTERLACED... And then again 
you rewrite it to NONE... No, please, let's do this properly. That "TODO" 
above is for a reason there:-)

I would suggest, please, base your patches on soc_camera.c as if that 
field test was not there, and I'll take care to remove it. I.e., in tw9910 
you should just check for INTERLACED or ANY, if ANY rewrite it to 
INTERLACED, or return -EINVAL.

Thei in sh_ceu_mobile you re-implement the test above from soc_camera.c, 
extending it with INTERLACED after calling icd->ops->try_fmt(icd, f), 
something like

	switch (field) {
	case V4L2_FIELD_INTERLACED:
		pcdev->is_interlace = 1;
		break;
	case V4L2_FIELD_ANY:
		f->fmt.pix.field = V4L2_FIELD_NONE;
	case V4L2_FIELD_NONE:
		pcdev->is_interlace = 0;
		break;
	default:
		return -EINVAL;
	}

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
