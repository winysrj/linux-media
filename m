Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:35583 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZKRMlJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 07:41:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: v4l: Use the video_drvdata function in drivers
Date: Wed, 18 Nov 2009 13:41:34 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@infradead.org, sakari.ailus@maxwell.research.nokia.com
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com> <4c8e56e69e0b1619dd4e5c32d45b8374.squirrel@webmail.xs4all.nl> <829197380911180136g4d372f2em84cf60bc9be4549c@mail.gmail.com>
In-Reply-To: <829197380911180136g4d372f2em84cf60bc9be4549c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181341.34679.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Wednesday 18 November 2009 10:36:45 Devin Heitmueller wrote:
> On Wed, Nov 18, 2009 at 4:13 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > I agree that it would help to split this patch up. Some cases are
> > trivial, so they can be put together in one patch. When things get more
> > complex it makes sense to put it in a separate patch for easier reviewing
> > by the relevant maintainers.
> >
> > This is a very nice cleanup and improves the driver code significantly.
> > Especially since so many drivers keep copying the same useless code time
> > and again :-(
> >
> > Reducing driver code complexity is a very important goal since that is
> > the weakest point of many of the existing drivers. But it should be done
> > carefully of course and in such a manner that people can review it
> > easily.
> 
> Hello Hans,
> 
> Thanks for the comments.
> 
> Review is good.  Review *and* actually trying the code is better.  If
> it comes down to Laurent's time being the constraint, I would rather
> see him spending the time setting up a tree with all his proposed
> patches and doing a call for testers than cutting up patches so that
> maintainers can review and guess whether it's not going to cause
> problems in their particular driver (and I say "guess" here because in
> some cases it may fail in non-obvious ways that wouldn't be noticed
> without actually trying it).

Time is always a constraint, but in this case the problem is that I don't have 
the necessary hardware to test all the changes.

Your wish turned into reality (I can't promise that for all wishes though 
;-)):

http://linuxtv.org/hg/~pinchartl/v4l-dvb-cleanup

-- 
Regards,

Laurent Pinchart
