Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:34921 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2GZMKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 08:10:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [RFC] omap3-isp G_FMT & ENUM_FMT
Date: Thu, 26 Jul 2012 14:10:28 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207261410.28581.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 26 July 2012 13:59:54 Michael Jones wrote:
> Hello,
> 
> I would like to (re)submit a couple of patches to support V4L2 behavior at the
> V4L2 device nodes of the omap3-isp driver, but I'm guessing they require some
> discussion first.
> 
> I've previously submitted one of them here [1] to support ENUM_FMT for the
> omap3-isp. This sparked some discussion, the result of which was that my patch
> probably made sense. Later [2], Laurent mentioned that there was some
> discussion/decision about adding "profiles" to the V4L2 specification, and the
> OMAP3 ISP would probably implement the "streaming" profile.  That was 7 months
> ago and I haven't seen any discussion of such profiles.  Can somebody bring me
> up to speed on this?

Not much has happened. Actually, I've prepared a 'radio' profile which I hope
to post before the V4L2 workshop next month. But no other profiles were made yet.

In practice the v4l2-compliance tool does lots of checks that very closely
resemble a 'profile' checker.

But it will need some more work to correctly support low-level media
controller-based drivers.

Regards,

	Hans

> 
> The purpose of these two patches is for the V4L2 device nodes to support
> mandatory V4L2 ioctls G_FMT and ENUM_FMT, such that a pure V4L2 application,
> ignorant of the media controller, can still stream the images from the video
> nodes.  This presumes that the media controller would have been pre-configured.
> This approach is often seen on the mailing list using 'media-ctl' to configure
> the ISP, then 'yavta' to retrieve images.  Currently this works because yavta
> doesn't require ENUM_FMT (unlike Gstreamer), and only as long as one sets the
> same format with yavta as had already been set with media-ctl. I think yavta
> should be able to just do G_FMT to see what is configured.
> 
> To be clear (as discussed in [1]), ENUM_FMT does not behave according to its
> original intent, because it cannot enumerate possible formats the ISP can
> deliver.  It will enumerate only one format: the one configured with the media
> controller.  In a sense this complies with the specification, because S_FMT
> wouldn't be able to change the format to anything else.
> 
> I have tested these patches on v3.4, but I have rebased them to v3.5 here.
> I would remove the pr_debug() calls before submitting upstream, but they're
> useful for testing.
> 
> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg29640.html
> [2] http://www.mail-archive.com/linux-media@vger.kernel.org/msg40618.html
> 
> Michael Jones (2):
>   [media] omap3isp: implement ENUM_FMT
>   [media] omap3isp: support G_FMT
> 
>  drivers/media/video/omap3isp/ispvideo.c |   50 +++++++++++++++++++++++++++++++
>  1 files changed, 50 insertions(+), 0 deletions(-)
> 
> 
