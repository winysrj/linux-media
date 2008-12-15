Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBF8XH6J021410
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 03:33:17 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBF8X3M3006876
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 03:33:03 -0500
Date: Mon, 15 Dec 2008 09:33:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <aec7e5c30812150028t11589040g3ae33eb2c82bbf08@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812150932320.3722@axis700.grange>
References: <utz9bmtgn.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812132131410.10954@axis700.grange>
	<umyeyuivo.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812150844560.3722@axis700.grange>
	<aec7e5c30812150028t11589040g3ae33eb2c82bbf08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add tw9910 driver
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

On Mon, 15 Dec 2008, Magnus Damm wrote:

> On Mon, Dec 15, 2008 at 5:06 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > What happens is that v4l2-ioctl.c::check_fmt() calls soc_camera_s_std(),
> > verifies that it returns 0, and then sets current_norm, which you then use
> > in your driver in tw9910_select_norm(). This way again we have no way to
> > reject an unsupported tv-norm. Like, try selecting a SECAM norm:-) So, we
> > need two patches here: first to add a set_std method to struct
> > soc_camera_ops and call it from soc_camera_s_std():
> >
> > static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
> > {
> >        struct soc_camera_file *icf = file->private_data;
> >        struct soc_camera_device *icd = icf->icd;
> >        return icd->ops->set_std(icd, a);
> > }
> >
> > and second - your driver implementing this method. Or do we have to pass
> > set_std first to the host driver? Looks like neither i.MX31 nor PXA270
> > have anything to do with it, SuperH neither?
> 
> The CEU has nothing to do with it. For our hardware this is handled by
> the TW9910 video decoder. The CEU driver has to be switched to
> interlace mode, but that's about it. =)

Good, then passing it directly to the camera driver should be enough for 
now.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
