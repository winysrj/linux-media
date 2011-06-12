Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3775 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab1FLPrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 11:47:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv4 PATCH 6/8] v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner.
Date: Sun, 12 Jun 2011 17:46:58 +0200
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <e2a61ca8e17b7354a69bcb1b5ca35301efb5581e.1307875512.git.hans.verkuil@cisco.com> <4DF4CEDB.9070501@redhat.com>
In-Reply-To: <4DF4CEDB.9070501@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106121746.58795.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, June 12, 2011 16:36:11 Mauro Carvalho Chehab wrote:
> Em 12-06-2011 07:59, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > The subdevs are supposed to receive a valid tuner type for the g_frequency
> > and g/s_tuner subdev ops. Some drivers do this, others don't. So prefill
> > this in v4l2-ioctl.c based on whether the device node from which this is
> > called is a radio node or not.
> > 
> > The spec does not require applications to fill in the type, and if they
> > leave it at 0 then the 'supported_mode' call in tuner-core.c will return
> > false and the ioctl does nothing.
> 
> Interesting solution. Yes, this is the proper fix, but only after being sure
> that no drivers allow switch to radio using the video device, and vice-versa.

Why would that be a problem? What this patch does is that it fixes those
drivers that do *not* set vf/vt->type (i.e. leave it at 0). For those that already
set it nothing changes.

> Unfortunately, this is not the case, currently.
> 
> Most drivers allow this, following the previous V4L2 specs. Changing such
> behavior will probably require to write something at 
> Documentation/feature-removal-schedule.txt, as we're changing the behavior.

I think in the longer term we need to change the spec so that:

1) Opening a radio node no longer switches to radio mode. Instead, you need to
   call VIDIOC_S_FREQUENCY for that.
2) When VIDIOC_S_FREQUENCY the type field should match the video/radio node it
   is called on. So for /dev/radio type should be RADIO, for others it should be
   ANALOG_TV. Otherwise -EINVAL is called.

So this might be a good feature removal for 3.2 or 3.3.

Regards,

	Hans
