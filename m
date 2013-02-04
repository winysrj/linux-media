Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4497 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3BDIkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 03:40:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Huang Shijie <shijie8@gmail.com>
Subject: Re: [RFC PATCH 13/18] tlg2300: fix missing audioset.
Date: Mon, 4 Feb 2013 09:39:54 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <be96cdafc8e99572c58eeb92c14081705335aa0a.1359627298.git.hans.verkuil@cisco.com> <510F3DA4.2030209@gmail.com>
In-Reply-To: <510F3DA4.2030209@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb18030"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302040939.54680.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 4 2013 05:48:36 Huang Shijie wrote:
> 于 2013年01月31日 05:25, Hans Verkuil 写道:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/usb/tlg2300/pd-video.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
> > index da7cbd4..122f299 100644
> > --- a/drivers/media/usb/tlg2300/pd-video.c
> > +++ b/drivers/media/usb/tlg2300/pd-video.c
> > @@ -903,7 +903,7 @@ static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *in)
> >  	 * the audio input index mixed with this video input,
> >  	 * Poseidon only have one audio/video, set to "0"
> >  	 */
> > -	in->audioset	= 0;
> > +	in->audioset	= 1;
> i think it should be 0. it's need to be test.

The audioset field is a bitmask, not an index. So to tell that audio input 0
is available audioset should be set to 1 << 0 == 1.

Regards,

	Hans

> 
> thanks
> Huang Shijie
> >  	in->tuner	= 0;
> >  	in->std		= V4L2_STD_ALL;
> >  	in->status	= 0;
> 
