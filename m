Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1606 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3BKOXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 09:23:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?iso-8859-15?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [REVIEWv2 PATCH 04/19] bttv: remove g/s_audio since there is only one audio input.
Date: Mon, 11 Feb 2013 15:22:56 +0100
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl> <0681941b222b6cc9c0bb288f81019d4f90c9d683.1360500224.git.hans.verkuil@cisco.com> <51180191.4070100@googlemail.com>
In-Reply-To: <51180191.4070100@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302111522.56234.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun February 10 2013 21:22:41 Frank Schäfer wrote:
> 
> Hmm... G/S_AUDIO is also used to query/set the capabilities and the mode
> of an input, which IMHO makes sense even if the input is the only one
> the device has ?

You are right, but there are problems with the implementation in this driver.
First of all, there is no ENUMAUDIO ioctl implemented, so applications were
never able to enumerate the audio inputs.

Now, it is possible to add this (and I have done this in this tree:
http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/bttv2).
However, the card definitions are unreliable with respect to the number of
audio inputs. So you may end up with a driver reporting incorrect information.

I tried it in the bttv2 branch and frankly it became rather messy.

Given the fact that there was never an ENUMAUDIO ioctl in the first place
I decided that it was better not to have these ioctls at all. Also, the
V4L2_CAP_AUDIO was never set, and they are incorrect anyway for boards that
do not have an audio input at all (common for surveillance boards).

There are other drivers as well that do not implement this, so applications
cannot rely on this ioctl being present.

I will update the commit message before I do the pull request, though. It
should be extended with the information above.

Regards,

	Hans

> Don't you think that it's also somehow inconsistent, because for the
> video inputs (G/S_INPUT) the spec says:
> "This ioctl will fail only when there are no video inputs, returning
> EINVAL." ?
> 
> 
> Regards,
> Frank
> 
> 
> 
> Am 10.02.2013 13:49, schrieb Hans Verkuil:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/pci/bt8xx/bttv-driver.c |   19 -------------------
> >  1 file changed, 19 deletions(-)
> >
> > diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> > index 6e61dbd..a02c031 100644
> > --- a/drivers/media/pci/bt8xx/bttv-driver.c
> > +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> > @@ -3138,23 +3138,6 @@ static int bttv_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
> >  	return 0;
> >  }
> >  
> > -static int bttv_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
> > -{
> > -	if (unlikely(a->index))
> > -		return -EINVAL;
> > -
> > -	strcpy(a->name, "audio");
> > -	return 0;
> > -}
> > -
> > -static int bttv_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
> > -{
> > -	if (unlikely(a->index))
> > -		return -EINVAL;
> > -
> > -	return 0;
> > -}
> > -
> >  static ssize_t bttv_read(struct file *file, char __user *data,
> >  			 size_t count, loff_t *ppos)
> >  {
> > @@ -3390,8 +3373,6 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
> >  	.vidioc_g_fmt_vbi_cap           = bttv_g_fmt_vbi_cap,
> >  	.vidioc_try_fmt_vbi_cap         = bttv_try_fmt_vbi_cap,
> >  	.vidioc_s_fmt_vbi_cap           = bttv_s_fmt_vbi_cap,
> > -	.vidioc_g_audio                 = bttv_g_audio,
> > -	.vidioc_s_audio                 = bttv_s_audio,
> >  	.vidioc_cropcap                 = bttv_cropcap,
> >  	.vidioc_reqbufs                 = bttv_reqbufs,
> >  	.vidioc_querybuf                = bttv_querybuf,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
