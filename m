Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36256 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbaIPK6W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 06:58:22 -0400
Date: Tue, 16 Sep 2014 07:58:12 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH] [media] BZ#84401: Revert "[media] v4l: vb2: Don't
 return POLLERR during transient buffer underruns"
Message-ID: <20140916075812.04a8290d@concha.lan>
In-Reply-To: <4972900.uUGnPegBxW@avalon>
References: <1410826255-2025-1-git-send-email-m.chehab@samsung.com>
	<1803893.9xIcqpbx23@avalon>
	<20140916070129.3779bf34.m.chehab@samsung.com>
	<4972900.uUGnPegBxW@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Sep 2014 13:15:27 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Tuesday 16 September 2014 07:01:29 Mauro Carvalho Chehab wrote:
> > Em Tue, 16 Sep 2014 12:09:01 +0300 Laurent Pinchart escreveu:
> > > On Monday 15 September 2014 21:10:55 Mauro Carvalho Chehab wrote:
> > > > This reverts commit 9241650d62f79a3da01f1d5e8ebd195083330b75.
> > > > 
> > > > The commit 9241650d62f7 was meant to solve an issue with Gstreamer
> > > > version 0.10 with libv4l 1.2, where a fixup patch for DQBUF exposed
> > > > a bad behavior ag Gstreamer.
> > > 
> > > That's not correct. The patch was created to solve an issue observed with
> > > the Gstreamer 0.10 v4l2src element accessing the video device directly,
> > > *without* libv4l.
> > 
> > Ok. From the discussions we took yesterday on the thread, I got the
> > wrong impression from Nicolas comments that this happens only with
> > gst < 1.4 and libv4l >= 1.2.
> 
> My understanding is that recent gst versions worked around the problem, and 
> the above combination of versions might be problematic, but gst 0.10 is 
> definitely affected.
> 
> > > The V4L2 specification documents poll() as follows.
> > > 
> > > "When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet the
> > > poll() function succeeds, but sets the POLLERR flag in the revents field."
> > > 
> > > The vb2 poll implementation didn't conform with that, as it returned
> > > POLLERR when the buffer list was empty due to a transient buffer
> > > underrun, even if both VIDIOC_STREAMON and VIDIOC_QBUF have been called.
> > > 
> > > The commit thus brought the vb2 poll implementation in line with the
> > > specification. If we really want to revert it to its broken behaviour,
> > > then it would be fair to explain this in the revert message,
> > 
> > Ok, I'll rewrite the text. We likely want to fix the documentation too,
> > in order to reflect the way it is.
> > 
> > > and I want to know how you propose fixing this properly, as the revert
> > > really causes issues for userspace.
> > 
> > This patch simply broke all VBI applications. So, it should be reverted.
> >
> > From what you're saying, using Gst 0.10 with a kernel before 3.16 and
> > VB2 was always broken, right?
> 
> Correct. And not only gst 0.10, any userspace application that doesn't 
> specifically handles transient buffer underruns will be affected.
> 
> vb2 doesn't conform to the V4L2 specification, and I believe the specification 
> is right in this case. Reverting this patch will push the problem to 
> userspace, where all applications will have to handle buffer underruns 
> manually.

What happens with VB1? How is it solved there?

I don't generally use gst 0.10, but I don't remember a single error
report about gst 0.10 and VB1-based drivers.

> > And with VB1, is it also broken? If so, then this is a Gst 0.10 bug,
> > and the fix should be a patch for it, or a recommendation to upgrade
> > to a newer version without such bug.
> 
> As explained above, this isn't a gst bug.
> 
> > If, otherwise, it works with VB1, then we need to patch VB2 to have
> > exactly the same behavior as VB1 with that regards, as VBI works
> > with VB1.
> 
> One option would be to have implement a different poll behaviour for VBI and 
> video.

That would be a nightmare.
> 


-- 

Cheers,
Mauro
