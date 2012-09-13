Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59417 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab2IMKQw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: workshop-2011@linuxtv.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Jun Nie <niej0001@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media summit/KS-2012 proposals
Date: Thu, 13 Sep 2012 03:01:34 +0200
Message-ID: <4239754.MNv9h5rKCc@avalon>
In-Reply-To: <201209051028.30258.hverkuil@xs4all.nl>
References: <20120713173708.GB17109@thunk.org> <CAGA24MKVVfT7BDGus+spj9CZWctS1YLdvOM5eWOGBdgeGqmnHw@mail.gmail.com> <201209051028.30258.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 05 September 2012 10:28:30 Hans Verkuil wrote:
> On Wed 5 September 2012 10:04:41 Jun Nie wrote:
> > Is there any summary for this summit or presentation material? I am
> > looking forward for some idea on CEC. It is really complex in
> > functionality.
> > Maybe other guys is expecting simiar fruite from summit too.
> 
> Yes, there will be a summit report. It's not quite finished yet, I think.
> 
> With respect to CEC we had some useful discussions. It will have to be a
> new class of device (/dev/cecX), so the userspace API will be separate from
> drm or v4l.

This is a repeat of a comment from the KS discussion: what about using the 
socket API instead of a device node ?

> And the kernel will have to take care of the core CEC protocol w.r.t.
> control and discovery due to the HDMI 1.4a requirements.
> 
> I plan on starting work on this within 1-2 weeks.
> 
> My CEC presentation can be found here:
> 
> http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-cec.odp

-- 
Regards,

Laurent Pinchart

