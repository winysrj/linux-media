Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54275 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1CIU6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 15:58:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [ANN] First draft of the agenda for the Warsaw meeting
Date: Wed, 9 Mar 2011 21:58:15 +0100
Cc: jaeryul.oh@samsung.com,
	"'linux-media'" <linux-media@vger.kernel.org>
References: <201103051620.31840.hverkuil@xs4all.nl> <010a01cbde28$d857c540$89074fc0$%oh@samsung.com> <201103090847.01661.hverkuil@xs4all.nl>
In-Reply-To: <201103090847.01661.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201103092158.19549.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Wednesday 09 March 2011 08:47:01 Hans Verkuil wrote:
> On Wednesday, March 09, 2011 08:08:43 Jaeryul Oh wrote:
> > Hi, Hans
> > 
> > We want to confirm if it is possible to discuss our concerning points
> > at each item of 1st draft that you made as below.
> > 
> > Our concerning items that we want to discuss are :
> > 
> > 1. Issues when using V4l2 control framework with codec
> > 
> >    : http://www.spinics.net/lists/linux-media/msg27975.html
> >    : Can we discuss 'V4l2 control framework to support codec' in your
> >    : first
> > 
> > agenda ?
> > 
> >      (Compressed format API for MPEG, H.264, etc. xxx)
> >      
> >    : We will post related contents in mailing list before joining Warsaw
> > 
> > meeting.
> 
> Certainly. If I am not mistaken the required control framework changes you
> refer to in the supplied link are actually done in Laurent's media
> controller/OMAP3 patch series, so these should appear any day now.

Im' afraid it's not there yet. The OMAP3 ISP code that requires this feature 
isn't ready yet, we're still working on it.

I've got two patches that implement control handlers at the file handler level 
for subdevs. I'll send them to the list (as RFC) to be used as a starting 
point for control handler support at the v4l2_fh level.

-- 
Regards,

Laurent Pinchart
