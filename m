Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35781 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab2CBSR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 13:17:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH/RFC][DRAFT] V4L: Add camera auto focus controls
Date: Fri, 02 Mar 2012 19:17:46 +0100
Message-ID: <10910238.HhAgf4n5o5@avalon>
In-Reply-To: <4F5005A3.9060503@gmail.com>
References: <1326749622-11446-1-git-send-email-sylvester.nawrocki@gmail.com> <1441235.tcAt0gpJAF@avalon> <4F5005A3.9060503@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 02 March 2012 00:26:27 Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> On 03/01/2012 11:30 PM, Laurent Pinchart wrote:
> > One option would be to disable the focus area control when the focus
> > distance is set to a value different than normal (or the other way
> > around). Control change events could be used to report that to userspace.
> > Would that work with your hardware ?
> 
> What would work, would be disabling the focus distance control when the
> focus area is set to a value different than "all".
> 
> I have also been considering adding an extra menu entry for the focus
> distance control, indicating some "neutral" state, but disabling the other
> control sounds like a better idea. I couldn't find anything reasonable, as
> there was already the focus distance "normal" menu entry.
> 
> Then, after the focus are is set to, for instance, "spot", transition to
> the focus distance "macro" would be only possible through focus area "all"
> (where the focus distance is enabled again). I guess it's acceptable.
> 
> It's only getting a bit harder for applications to present a single list
> of the focus modes to the user, since they would, for instance, grey out
> the entries corresponding to disabled control. It shouldn't be a big deal
> though.

It could indeed be a little bit confusing for users/applications, but having a 
separate private focus control wouldn't be much better :-) In both cases an 
application will need to know how to use the focus controls anyway.

-- 
Regards,

Laurent Pinchart

