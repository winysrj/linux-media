Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:32339 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933179Ab1CXICZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 04:02:25 -0400
Message-ID: <4D8AFB0C.803@maxwell.research.nokia.com>
Date: Thu, 24 Mar 2011 10:04:28 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: Re: [PATCH] omap3isp: implement ENUM_FMT
References: <4D889C61.905@matrix-vision.de> <4D89C2ED.5080803@maxwell.research.nokia.com> <4D89D460.7000808@matrix-vision.de>
In-Reply-To: <4D89D460.7000808@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Michael Jones wrote:
> Hi Sakari,

Hi Michael,

> On 03/23/2011 10:52 AM, Sakari Ailus wrote:
>> Hi Michael,
>>
>> Thanks for the patch.
>>
>> Michael Jones wrote:
>>> From dccbd4a0a717ee72a3271075b1e3456a9c67ca0e Mon Sep 17 00:00:00 2001
>>> From: Michael Jones <michael.jones@matrix-vision.de>
>>> Date: Tue, 22 Mar 2011 11:47:22 +0100
>>> Subject: [PATCH] omap3isp: implement ENUM_FMT
>>>
>>> Whatever format is currently being delivered will be declared as the only
>>> possible format
>>>
>>> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
>>> ---
>>>
>>> Some V4L2 apps require ENUM_FMT, which is a mandatory ioctl for V4L2.
>>> This patch doesn't enumerate all of the formats which could possibly be
>>> set (as is intended by ENUM_FMT), but at least it reports the one that
>>> is currently set.
>>
>> What would be the purpose of ENUM_FMT in this case? It provides no
>> additional information to user space, and the information it provides is
>> in fact incomplete. Using other formats is possible, but that requires
>> changes to the format configuration on links.
> 
> The only purpose of it was to provide minimum functionality for apps to
> be able to fetch frames from the ISP after setting up the ISP pipeline
> with media-ctl.  By "apps", I mean Gstreamer in my case, which Loïc had
> also recently asked Laurent about.

Are you familiar with the mcsrc?

<URL:http://meego.gitorious.org/maemo-multimedia/gst-nokia-videosrc>

I think it's

Also, I think v4lsrc could be fixed to cope with lack of VIDIOC_ENUM_FMT.

Besides what Laurent already mentioned, how the applications are
expected to select a video node from the 7 (or 8) that the ISP has is
not resolved yet. The requested pixelformat depends on the video node in
this case.

>> As the relevant format configuration is done on the subdevs and not on
>> the video nodes, the format configuration on the video nodes is very
>> limited and much affected by the state of the formats on the subdev pads
>> (which I think is right). This is not limited to ENUM_FMT but all format
>> related IOCTLs on the OMAP 3 ISP driver.
>>
>> My view is that should a generic application want to change (or
>> enumerate) the format(s) on a video node, the application would need to
>> be using libv4l for that.
>>
>> A compatibility layer implemented in libv4l (plugin, not the main
>> library) needs to configure the links in the first place, so
>> implementing ENUM_FMT in the plugin would not be a big deal. It could
>> even provide useful information. The possible results of the ENUM_FMT
>> would also depend on what kind of pipeline configuration does the plugin
>> support, though.
> 
> BTW, my GStreamer is using libv4l, although it looked like it's also
> possible to configure GStreamer to use ioctls directly.  I can agree
> that it would be nice to implement ENUM_FMT and the like in a
> compatibility layer in libv4l.  That would be in the true spirit of
> ENUM_FMT, where the app could actually see different formats it can set.
> 
> But is there any work being done on such a compatibility layer?

Yes. Yordan is working on that.

There's a plugin interface patch for libv4l and a MC-aware plugin that
uses the interface.

<URL:http://www.spinics.net/lists/linux-media/msg28925.html>

I think so far only the plugin interface patch is on the list.

> Is there a policy decision that in the future, apps will be required to
> use libv4l to get images from the ISP?  Are we not intending to support
> using e.g. media-ctl + some v4l2 app, as I'm currently doing during
> development?

If we speak about specific applications that are aware of the MC and the
OMAP 3 ISP itself, I'd guess those will continue to use the interfaces
provided by the driver directly.

But generic applications would likely be better off using libv4l. This
way they could use whatever there is in the libv4l plugin for the
platform (automatic exposure and white balance, for example).

I don't think generic applications _shouldn't_ be allowed to do without
libv4l. It's just that the functionality provided by the driver in this
case will be limited to a default pipeline and fixed format (as was your
patch for ENUM_FMT).

> In the meantime, I will continue using this patch locally to enable
> getting a live image with Gstreamer, and it can at least serve as a help
> to Loïc if he's trying to do the same.

Are there other applications that really need ENUM_FMT?

The spec says of ENUM_FMT that:

"To enumerate image formats applications initialize the type and index
field of struct v4l2_fmtdesc and call the VIDIOC_ENUM_FMT ioctl with a
pointer to this structure. Drivers fill the rest of the structure or
return an EINVAL error code. All formats are enumerable by beginning at
index zero and incrementing by one until EINVAL is returned."

As Laurent pointed out, I also agree that the patch itself is correct
but the information provided to the user space is correct but
incomplete. Coming up with a list of formats on a video node in the ISP
requires information from different parts of the MC graph.

I somehow feel it shouldn't be the responsibility of the driver to
provide this since using those formats requires different pad formats.

Various parts of the driver would need to be notified when links change
somewhere else. Also, if a video node isn't connected to anything
through an enabled link or the entity it's connected to, isn't, what
should ENUM_FMT provide then? An empty list?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
