Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBF9fGoJ021793
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 04:41:16 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBF9exkG009645
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 04:41:00 -0500
Date: Mon, 15 Dec 2008 10:41:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
In-Reply-To: <Pine.LNX.4.64.0812150844560.3722@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812151031420.4416@axis700.grange>
References: <utz9bmtgn.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812132131410.10954@axis700.grange>
	<umyeyuivo.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812150844560.3722@axis700.grange>
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

On Mon, 15 Dec 2008, morimoto.kuninori@renesas.com wrote:

> Thank you for checking my patch and some advice.
> 
> > Thei in sh_ceu_mobile you re-implement the test above from soc_camera.c, 
> > extending it with INTERLACED after calling icd->ops->try_fmt(icd, f), 
> > something like
> > 
> > 	switch (field) {
> > 	case V4L2_FIELD_INTERLACED:
> > 		pcdev->is_interlace = 1;
> > 		break;
> > 	case V4L2_FIELD_ANY:
> > 		f->fmt.pix.field = V4L2_FIELD_NONE;
> > 	case V4L2_FIELD_NONE:
> > 		pcdev->is_interlace = 0;
> > 		break;
> > 	default:
> > 		return -EINVAL;
> > 	}
> 
> Now I understand that we need some patch like this.
> Is it correct ? or not ?
> 
> o add set_std to soc_camera         -> for check norm

Not add, it is already there, just modify as I described in another reply 
to you (slightly extended):

> static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
> {
> 	struct soc_camera_file *icf = file->private_data;
> 	struct soc_camera_device *icd = icf->icd;
> 	if (!icd->ops->set_std)
> 		return 0;
> 	return icd->ops->set_std(icd, a);
> }

of course, also adding the respective field to struct soc_camera_ops

> o fix soc_camera_enum_input         -> for use V4L2_INPUT_TYPE_TUNER or CAMERA

Yes, I am not quite sure how best to do this though. I think, we also want 
to continue supporting the default behaviour, so, we should add a 
enum_input method to struct soc_camera_ops, if defined - call it, if not, 
fallback to default current behaviour.

> o fix field test on soc_camera      -> remove field test (or add allow INTERLACED)

Remove. But this patch I can do myself, because I will also have to patch 
pxa_camera.c, you just assume this test is not there, for your tests just 
remove it.

> o interlace mode patch to sh_mobile_ceu
> o tw9910 driver

Yep.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
