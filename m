Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4511 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab1KYLSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 06:18:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/3] vivi: set device_caps.
Date: Fri, 25 Nov 2011 12:18:46 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1321956322-25084-1-git-send-email-hverkuil@xs4all.nl> <bd80eb41a795b4fac63dff9005b10835e4aa8b17.1321956058.git.hans.verkuil@cisco.com> <4ECF73C0.6090904@redhat.com>
In-Reply-To: <4ECF73C0.6090904@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251218.46431.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 25, 2011 11:53:52 Mauro Carvalho Chehab wrote:
> Em 22-11-2011 08:05, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/vivi.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> > index 7d754fb..84ea88d 100644
> > --- a/drivers/media/video/vivi.c
> > +++ b/drivers/media/video/vivi.c
> > @@ -819,8 +819,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
> >  	strcpy(cap->driver, "vivi");
> >  	strcpy(cap->card, "vivi");
> >  	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
> > -	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING | \
> > -			    V4L2_CAP_READWRITE;
> > +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> > +			    V4L2_CAP_READWRITE | V4L2_CAP_DEVICE_CAPS;
> > +	cap->device_caps = cap->capabilities;
> 
> Hmm... should V4L2_CAP_DEVICE_CAPS be present at both device_caps and capabilities?

Good question. It doesn't feel right to me to add it to device_caps: it
really doesn't mean anything there.

The whole point is to have device_caps only show the capabilities
of that device node. V4L2_CAP_DEVICE_CAPS is a capability of the whole
physical device, so I don't believe it should be set in device_caps.

> 
> IMHO, the better would be to do:
> 
> 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> 			    V4L2_CAP_READWRITE | V4L2_CAP_DEVICE_CAPS;
> 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
> Btw, this ambiguity should also be solved at the V4L2 spec.

I will update the docs, once we agree on this.

Regards,

	Hans
