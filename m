Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52977 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2CAX0c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 18:26:32 -0500
Received: by eaaq12 with SMTP id q12so417774eaa.19
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2012 15:26:30 -0800 (PST)
Message-ID: <4F5005A3.9060503@gmail.com>
Date: Fri, 02 Mar 2012 00:26:27 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH/RFC][DRAFT] V4L: Add camera auto focus controls
References: <1326749622-11446-1-git-send-email-sylvester.nawrocki@gmail.com> <4F4A6493.1080004@gmail.com> <1441235.tcAt0gpJAF@avalon>
In-Reply-To: <1441235.tcAt0gpJAF@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 03/01/2012 11:30 PM, Laurent Pinchart wrote:
> One option would be to disable the focus area control when the focus distance
> is set to a value different than normal (or the other way around). Control
> change events could be used to report that to userspace. Would that work with
> your hardware ?

What would work, would be disabling the focus distance control when the focus 
area is set to a value different than "all".

I have also been considering adding an extra menu entry for the focus distance 
control, indicating some "neutral" state, but disabling the other control
sounds like a better idea. I couldn't find anything reasonable, as there was 
already the focus distance "normal" menu entry.

Then, after the focus are is set to, for instance, "spot", transition to 
the focus distance "macro" would be only possible through focus area "all"
(where the focus distance is enabled again). I guess it's acceptable.

It's only getting a bit harder for applications to present a single list 
of the focus modes to the user, since they would, for instance, grey out 
the entries corresponding to disabled control. It shouldn't be a big deal 
though.


--
Regards,
Sylwester
