Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59539 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab2IQJS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 05:18:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	=?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS capability.
Date: Mon, 17 Sep 2012 11:18:58 +0200
Message-ID: <4124728.lDo7VTRoK5@avalon>
In-Reply-To: <50564BCE.8010901@gmail.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <2870315.6PlfZS62FS@avalon> <50564BCE.8010901@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sunday 16 September 2012 23:59:42 Sylwester Nawrocki wrote:
> On 09/16/2012 05:33 PM, Laurent Pinchart wrote:
> > On Sunday 16 September 2012 15:57:14 Hans Verkuil wrote:
> >> On Sat September 15 2012 22:16:24 Sylwester Nawrocki wrote:
> >>> On 09/15/2012 02:35 PM, Hans Verkuil wrote:

> >>> Have anyone has ever come with a use case for switching timestamps clock
> >>> type, can anyone give an example of it ? How likely is we will ever need
> >>> that ?
> >> 
> >> Well, ALSA allows you to switch between gettimeofday and monotonic. So in
> >> theory at least if an app selects gettimeofday for alsa, that app might
> >> also want to select gettimeofday for v4l2.

Does it, in its kernel API ? The userspace ALSA library (or possibly 
PulseAudio, I'd need to check) allows converting between clock sources, but I 
don't think the kernel API supports several clock sources.

> OK, I'm not complaining any more. :)
> 
> >> I'd really like to keep this door open. My experience is that if
> >> something is possible, then someone somewhere will want to use it.
> 
> Indeed, caps flags approach might be too limited anyway. And a v4l2 control
> might be not good for reporting things like these.
> 
> > As far as system timestamps are concerned I think the monotonic clock
> > should be enough, at least for now. Raw monotonic could possibly be
> > useful later.
> > 
> > Another important use case I have in mind is to provide raw device
> > timestamps. For instance UVC devices send a device clock timestamp along
> > with video frames. That timestamp can be useful to userspace
> > applications.
> 
> Could be interesting to add support for something like this. Of what format
> are then such device timestamps ?

They're device-dependent :-) In the UVC case they're 32-bit integers.

-- 
Regards,

Laurent Pinchart

