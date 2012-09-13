Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:8959 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab2IMKiR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:38:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [Workshop-2011] Media summit/KS-2012 proposals
Date: Thu, 13 Sep 2012 12:38:11 +0200
Cc: workshop-2011@linuxtv.org, Jun Nie <niej0001@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20120713173708.GB17109@thunk.org> <201209051028.30258.hverkuil@xs4all.nl> <4239754.MNv9h5rKCc@avalon>
In-Reply-To: <4239754.MNv9h5rKCc@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131238.11888.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 13 September 2012 03:01:34 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday 05 September 2012 10:28:30 Hans Verkuil wrote:
> > On Wed 5 September 2012 10:04:41 Jun Nie wrote:
> > > Is there any summary for this summit or presentation material? I am
> > > looking forward for some idea on CEC. It is really complex in
> > > functionality.
> > > Maybe other guys is expecting simiar fruite from summit too.
> > 
> > Yes, there will be a summit report. It's not quite finished yet, I think.
> > 
> > With respect to CEC we had some useful discussions. It will have to be a
> > new class of device (/dev/cecX), so the userspace API will be separate from
> > drm or v4l.
> 
> This is a repeat of a comment from the KS discussion: what about using the 
> socket API instead of a device node ?

What benefit would that give me? I frankly don't think it maps that well to
a socket API. Some parts of the CEC protocol are more or less network like,
but others are point-to-point. Basically CEC is a mess, protocol-wise, and
I much prefer a char-device where you have more flexibility.

Regards,

	Hans

> > And the kernel will have to take care of the core CEC protocol w.r.t.
> > control and discovery due to the HDMI 1.4a requirements.
> > 
> > I plan on starting work on this within 1-2 weeks.
> > 
> > My CEC presentation can be found here:
> > 
> > http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-cec.odp
> 
> 
