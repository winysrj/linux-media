Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:58177 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbZJKW3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 18:29:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Very busy for the next several weeks...
Date: Mon, 12 Oct 2009 00:30:56 +0200
Cc: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	ivtv-users@ivtvdriver.org
References: <200910111802.42492.hverkuil@xs4all.nl>
In-Reply-To: <200910111802.42492.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910120030.57034.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 11 October 2009 18:02:42 Hans Verkuil wrote:
> Hi all,
> 
> You may have noticed very little activity from me lately: this is due to
> a lot of traveling and a very busy work schedule.
> 
> This will continue until early November at least.
> 
> So if you do not get an answer to a question, then that's why.
> 
> I will try my utmost to do any reviews related to the new APIs discussed
> during the v4l-dvb mini-summit in Portland. I've started that, after all.
> One exception will probably be the memory pool discussions: that is not my
> area of expertise so I doubt I can contribute much there.

I've been pretty busy as well since the LPC. The memory pool RFC got delayed a 
bit (but I've been working on subdev and media-controller related tasks, so my 
work will hopefully be useful too :-)). Following your discussion I studied 
the GEM architecture and I'll contact the Intel developers to see if sharing 
buffers between the GPU and the V4L2 devices could be possible. I'm a bit 
scared this will be difficult, as GPU memory is accessed through the GART (a 
kind of IOMMU for GPUs) and we would have to deal with textures tiling and 
swizzling.
 
> Note that even though I have more time in November, I really want to use
> that time to continue work on the control framework, so whether I will have
> much time to do anything else is doubtful as well. And December will almost
> certainly be very busy again...
> 
> My apologies for the ivtv users: I'm pretty certain that's on hold for the
> rest of the year (not that there was much going on and I hope Andy can help
> out there). The new SoC support being discussed and worked on will be
> pretty much the only thing I'll be paying attention to for now.
> 
> Just so you all know what to expect...

We all have business and personal schedules to deal with. Nobody should expect 
you or any open-source developer to put life aside and commit 100% to open-
source projects (unless funded by a company, but that's another story).

-- 
Regards,

Laurent Pinchart
