Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:35191 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0GII4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 04:56:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH 2/6] v4l: subdev: Add device node support
Date: Fri, 9 Jul 2010 10:57:38 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com> <201007081408.50289.laurent.pinchart@ideasonboard.com> <4C35D7E5.60407@redhat.com>
In-Reply-To: <4C35D7E5.60407@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007091057.39060.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 08 July 2010 15:51:33 Mauro Carvalho Chehab wrote:
> Em 08-07-2010 09:08, Laurent Pinchart escreveu:
> > On Wednesday 07 July 2010 22:53:40 Mauro Carvalho Chehab wrote:
> >> Em 07-07-2010 16:44, Laurent Pinchart escreveu:
> >>> On Wednesday 07 July 2010 16:58:01 Mauro Carvalho Chehab wrote:
> >>>> Em 07-07-2010 08:53, Laurent Pinchart escreveu:

[snip]

> >>>>> +static long subdev_ioctl(struct file *file, unsigned int cmd,
> >>>>> +	unsigned long arg)
> >>>>> +{
> >>>>> +	return video_usercopy(file, cmd, arg, subdev_do_ioctl);
> >>>> 
> >>>> This is a legacy call. Please, don't use it.
> >>> 
> >>> What should I use instead then ? I need the functionality of
> >>> video_usercopy. I could copy it to v4l2-subdev.c verbatim. As
> >>> video_ioctl2 shares lots of code with video_usercopy I think
> >>> video_usercopy should stay, and video_ioctl2 should use it.
> >> 
> >> The bad thing of video_usercopy() is that it has a "compat" code, to fix
> >> broken definitions of some iotls (see video_fix_command()), and that a
> >> few drivers still use it, instead of video_ioctl2.
> > 
> > video_ioctl2 has the same compat code.
> 
> Yes, in order to avoid breaking binary compatibility with files compiled
> against the old videodev2.h header that used to declare some ioctls as:

[snip]

> This doesn't make sense for subdev, as old binary-only applications will
> never use the legacy ioctl definitions.
> 
> Probably, we can mark this legacy support for removal at
> Documentation/feature-removal-schedule.txt, and remove
> it on a latter version of the kernel. It seems that the old ioctl
> definitions are before 2005 (before 2.6.12):

Good idea.

[snip]

> > What about renaming video_usercopy to __video_usercopy, adding an
> > argument to enable/disable the compat code, create a new video_usercopy
> > that calls __video_usercopy with compat code enabled, have video_ioctl2
> > call __video_usercopy with compat code enabled, and having subdev_ioctl
> > call __video_usercopy with compat code disabled ?
> 
> Seems good, but maybe the better is to put the call to video_fix_command()
> outside the common function.

Agreed. It belongs to video_usercopy and video_ioctl2.

> We may add also a printk for the video_usercopy wrapper printing that the
> driver is using a legacy API call, and that this will be removed on a next
> kernel version. Maybe this way, people will finally submit patches porting
> the last remaining drivers to video_ioctl2.
> 
> I suspect, however, that we'll end by needing a subdev-specific version of
> __video_usercopy, as we add new ioctls to subdev.

If we need one then I'll create one in v4l2-subdev.c, but as long as we don't 
there's little point in duplicating the code.

I've had a look at video_usercopy and video_ioctl2, and the functions are 
mostly identical. The differences are

- video_ioctl2 passes the original arg argument to __video_do_ioctl for _IO 
ioctls. video_usercopy passes NULL. This seems to be used by the ivtv driver 
to handle DVB _IO ioctls (VIDEO_SELECT_SOURCE, AUDIO_SET_MUTE, 
AUDIO_CHANNEL_SELECT and AUDIO_BILINGUAL_CHANNEL_SELECT) that pass an integer 
through the ioctl argument. Any objection against passing the original 
argument to the ioctl handler in video_usercopy as well ? I've quickly checked 
the video_usercopy users and none of them seem to check that arg is NULL for 
_IO ioctls. This should thus be harmless.

- For argument of known ioctls that have a few input fields at the beginning 
of the structure followed by output fields, video_ioctl2 only copies the input 
fields from userspace and zeroes out the rest. video_usercopy doesn't. Do we 
have video_usercopy drivers that abuse the output fields to pass information 
to the driver, or could the video_ioctl2 behaviour be generalized to 
video_usercopy ?

If the answer to the two questions is yes, video_usercopy and video_ioctl2 
could use the same code. Otherwise they can't, and in that case I should 
probably use video_usercopy in v4l2-subdev.c, replacing it with a private copy 
when it will disappear.

-- 
Regards,

Laurent Pinchart
