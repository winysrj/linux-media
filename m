Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:54662 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZA2CEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 21:04:15 -0500
Date: Thu, 29 Jan 2009 03:04:00 +0100 (CET)
From: Marton Balint <cus@fazekas.hu>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH] cx88: fix unexpected video resize when setting tv norm
In-Reply-To: <Pine.LNX.4.58.0901101325420.1626@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.64.0901290232500.25376@cinke.fazekas.hu>
References: <571b3176dc82a7206ade.1231614963@roadrunner.athome>
 <Pine.LNX.4.58.0901101325420.1626@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 10 Jan 2009, Trent Piepho wrote:
> On Sat, 10 Jan 2009, Marton Balint wrote:
> > Cx88_set_tvnorm sets the size of the video to fixed 320x240. This is ugly at
> > least, but also can cause problems, if it happens during an active video
> > transfer. With this patch, cx88_set_scale will save the last requested video
> > size, and cx88_set_tvnorm will scale the video to this size.
> 
> Instead of adding these extra fields to the core, maybe it would be better
> to just add w/h/field as arguments to set_tvnorm?  I have a patch to do
> this, but there are still problems.
> 
> The allowable sizes depends on the video norm.  If you select 720x576 in
> PAL and then change the norm to NTSC bad things will happen if the driver
> tries to maintain more than 480 lines.  So cx88_set_scale() will happily
> program bogus register values on size change.
> 
> cx88_set_tvnorm() would need to check if the current size can be maintained
> in the new norm and if it's not, change it to something valid (what?).  Or
> maybe the S_STD ioctl handler should adjust the size to something valid?
> 
> What does V4L2 say about what should happen if the current format will no
> longer be valid after a norm change?  Should the norm change fail?  Should
> the format be adjusted to one that is valid?  The norm is per device but
> the format is per file handle, so would changing the norm on one file
> handle modify the format of a different open file handle?  That doesn't
> seem right.  But, v4l2 seems require that you aren't allowed to set an
> invalid format, so getting an invalid format via a norm change seems wrong
> too.
> 
> Changing norms during capture has more problems.  I'm not sure if v4l2 even
> allows it.  Even if allowed, I don't think the cx88 driver should try to
> support it.
> 
> The norm change code will immediately program a bunch of register values
> when the norm is set.  These could easily screw up current video activity.
> Suppose the cx88 is in the middle of capturing a 576 line PAL frame and the
> norm is changed to NTSC.  How is that supposed to be handled?
> 
> In my patch, setting the tvnorm keeps the file handle's current size.  This
> won't work during capture as the cx88's scalers are programmed on a
> frame-by-frame basis and the current frame being captured might not be the
> same size as the file handle which tried to change the norm.
> 
> I think there is also a race in your patch, as the call to cx88_set_scale()
> when a frame is queued isn't protected against the tvnorm ioctl.  It might
> be possible to fix that by grabbing the queue spinlock before changing the
> norm.  Still, I don't think the code the programs the registers for a norm
> change is designed to be safe to call during capture.
> 
> So I think the best thing would be to have S_STD return -EBUSY if there is
> an ongoing capture.  Maybe even have v4l2-dev take care of that if
> possible.

The status of this patch has changed to "Changes Requested" in 
patchwork, but it's not obvious to me what changes are needed exactly.
Yes, in the comments quite a few questions came up, but we haven't 
decided the correct course of action for good, and the patch also makes 
sense in it's current form.

Regards,
  Marton
