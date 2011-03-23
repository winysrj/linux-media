Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42029 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab1CWMQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 08:16:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH] omap3isp: implement ENUM_FMT
Date: Wed, 23 Mar 2011 13:16:45 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?iso-8859-1?q?Lo=EFc_Akue?= <akue.loic@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Yordan Kamenov <ykamenov@mm-sol.com>
References: <4D889C61.905@matrix-vision.de> <4D89C2ED.5080803@maxwell.research.nokia.com> <4D89D460.7000808@matrix-vision.de>
In-Reply-To: <4D89D460.7000808@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103231316.46934.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Wednesday 23 March 2011 12:07:12 Michael Jones wrote:
> On 03/23/2011 10:52 AM, Sakari Ailus wrote:
> > Michael Jones wrote:
> >> From dccbd4a0a717ee72a3271075b1e3456a9c67ca0e Mon Sep 17 00:00:00 2001
> >> From: Michael Jones <michael.jones@matrix-vision.de>
> >> Date: Tue, 22 Mar 2011 11:47:22 +0100
> >> Subject: [PATCH] omap3isp: implement ENUM_FMT
> >> 
> >> Whatever format is currently being delivered will be declared as the
> >> only possible format
> >> 
> >> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> >> ---
> >> 
> >> Some V4L2 apps require ENUM_FMT, which is a mandatory ioctl for V4L2.
> >> This patch doesn't enumerate all of the formats which could possibly be
> >> set (as is intended by ENUM_FMT), but at least it reports the one that
> >> is currently set.
> > 
> > What would be the purpose of ENUM_FMT in this case? It provides no
> > additional information to user space, and the information it provides is
> > in fact incomplete. Using other formats is possible, but that requires
> > changes to the format configuration on links.
> 
> The only purpose of it was to provide minimum functionality for apps to
> be able to fetch frames from the ISP after setting up the ISP pipeline
> with media-ctl.  By "apps", I mean Gstreamer in my case, which Loïc had
> also recently asked Laurent about.
> 
> > As the relevant format configuration is done on the subdevs and not on
> > the video nodes, the format configuration on the video nodes is very
> > limited and much affected by the state of the formats on the subdev pads
> > (which I think is right). This is not limited to ENUM_FMT but all format
> > related IOCTLs on the OMAP 3 ISP driver.
> > 
> > My view is that should a generic application want to change (or
> > enumerate) the format(s) on a video node, the application would need to
> > be using libv4l for that.
> > 
> > A compatibility layer implemented in libv4l (plugin, not the main
> > library) needs to configure the links in the first place, so
> > implementing ENUM_FMT in the plugin would not be a big deal. It could
> > even provide useful information. The possible results of the ENUM_FMT
> > would also depend on what kind of pipeline configuration does the plugin
> > support, though.
> 
> BTW, my GStreamer is using libv4l, although it looked like it's also
> possible to configure GStreamer to use ioctls directly.  I can agree
> that it would be nice to implement ENUM_FMT and the like in a
> compatibility layer in libv4l.  That would be in the true spirit of
> ENUM_FMT, where the app could actually see different formats it can set.
> 
> But is there any work being done on such a compatibility layer?
> 
> Is there a policy decision that in the future, apps will be required to
> use libv4l to get images from the ISP?  Are we not intending to support
> using e.g. media-ctl + some v4l2 app, as I'm currently doing during
> development?

Apps should be able to use the V4L2 API directly. However, we can't implement 
all that API, as most calls don't make sense for the OMA3 ISP driver. Which 
calls need to be implemented is a grey area at the moment, as there's no 
detailed semantics on how subdev-level configuration and video device 
configuration should interact.

Your implementation of ENUM_FMT looks correct to me, but the question is 
whether ENUM_FMT should be implemented. I don't think ENUM_FMT is a required 
ioctl, so maybe v4l2src shouldn't depend on it. I'm interesting in getting 
Hans' opinion on this.

> In the meantime, I will continue using this patch locally to enable
> getting a live image with Gstreamer, and it can at least serve as a help
> to Loïc if he's trying to do the same.

-- 
Regards,

Laurent Pinchart
