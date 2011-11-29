Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:62255 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab1K2Nap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 08:30:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: drm pixel formats update
Date: Tue, 29 Nov 2011 14:30:42 +0100
Cc: dri-devel@lists.freedesktop.org, ville.syrjala@linux.intel.com,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	Jesse Barker <jesse.barker@linaro.org>
References: <1321468945-28224-1-git-send-email-ville.syrjala@linux.intel.com> <201111291310.36589.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111291310.36589.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111291430.42608.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 29 November 2011 13:10:35 Laurent Pinchart wrote:
> Hi Ville,
> 
> Sorry for the late reply.
> 
> (Cross-posting to the linux-fbdev and linux-media mailing lists, as the
> topics I'm about to discuss are of interest to everybody)
> 
> On Wednesday 16 November 2011 19:42:23 ville.syrjala@linux.intel.com wrote:
> > I decided to go all out with the pixel format definitions. Added pretty
> > much all of the possible RGB/BGR variations. Just left out ones with
> > 16bit components and floats. Also added a whole bunch of YUV formats,
> > and 8 bit pseudocolor for good measure.
> > 
> > I'm sure some of the fourccs now clash with the ones used by v4l2,
> > but that's life.
> 
> Disclaimer: I realize this is a somehow controversial topic, and I'm not
> trying to start a flame war :-)
> 
> What about defining a common set of fourccs for both subsystem (and using
> them in FBDEV, which currently uses the V4L2 fourccs) ?
> 
> There's more and more overlap between DRM, FBDEV and V4L2, which results in
> confusion for the user and mess in the kernel. I believe cleaning this up
> will become more and more important with time, and also probably more and
> more difficult if we don't act now.
> 
> There's no way we will all quickly agree on a big picture unified
> architecture (I don't even know what it should look like), so I'm thinking
> about starting small and see where it will lead us. Sharing fourccs would
> be such a first step, and would make it easier for drivers to implement
> several of the DRM, FBDEV and V4L2 APIs.
> 
> Another step I'd like to take would be working on sharing the video mode
> definitions between subsystems. DRM has struct drm_mode_modeinfo and FBDEV
> has struct fb_videomode. The former can't be modified as it's used in
> userspace APIs, but I believe we should create a common in-kernel
> structure to represent modes. This would also make it easier to share the
> EDID parser between DRM and FBDEV.
> 
> One issue here is names. I understand that using names from another
> subsystem in a driver that has nothing to do with it (like using
> V4L2_PIX_FMT_* in DRM, or drm_mode_modeinfo in FBDEV) can be frustrating
> for many developers, so I'd like to propose an alternative. We have a
> media-related kernel API that is cross-subsystem, that's the media
> controller. It uses the prefix media_. We could use more specific versions
> of that preview (such as media_video_ and media_display_) as a neutral
> ground.

I agree.

> Another issue is control. It's quite natural to be suspicious about
> subsystems we're not familiar with, and giving up control on things we
> consider as highly important to other subsystems feels dangerous and
> wrong. Once again, media_* could be an answer to this problem. Instead of
> trying to push other subsystems to use our APIs (which are, obviously, the
> best possible ever, as they're the ones we work on :-)) with the promise
> that we will extend them to fullfill their needs if necessary, we could
> design new shared structures and core functions together with a media_
> prefix, and make sure they fullfill all the needs from the start. What I
> like about this approach is that each of the 3 video-related subsystems
> would then benefit from the experience of the other 2.
> 
> To make it perfectly clear, I want to emphasize that I'm not trying to
> replace DRM, FBDEV and V4L2 with a new shared subsystem. What I would like
> to see in the (near future) is collaboration and sharing of core features
> that make sense to share. I believe we should address this from a "pain
> point" point of view. The one that lead me to writing this e-mail is that
> developing a driver that implements both the DRM and FBDEV APIs for video
> output currently requires various similar structures, and code to
> translate between all of them. That code can't be shared between multiple
> drivers, is error-prone, and painful to maintin.
> 
> I can (and actually would like to) submit an RFC, but I would first like to
> hear your opinion on the topic.

I have added Jesse Barker to the CC list. I think that to achieve closer
cooperation between the various subsystems we need to organize a few days
of talks between the main developers to 1) understand each others subsystem,
2) to discover what functionality would be good to share, and 3) figure out
some sort of roadmap on how to do this.

Linaro might be a suitable organization that can assist with at least the
organizational part of setting up such a meeting. They did a good job in the
past (in Budapest and Cambourne) with the buffer sharing discussions.

One week of discussions/brainstorming between a small(ish) group of developers
can be very, very productive in my experience.

Regards,

	Hans

> 
> > If anyone has problems with the way the formats are defined, please
> > speak up now! Since only Jesse has bothered to comment on my rantings
> > I can only assume people are happy with my approach to things.
> > 
> > These patches should apply on top of Jesse's v3+v5 set... I think.
> > I sort of lost track of things when the patches started having
> > different version numbers. At least we're not yet into two digits
> > numbers ;)
