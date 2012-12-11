Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2LKPSR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 10:18:17 -0500
Date: Tue, 11 Dec 2012 13:17:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: RFC: First draft of guidelines for submitting patches to
 linux-media
Message-ID: <20121211131759.2b9543d6@redhat.com>
In-Reply-To: <201212111415.31483.hverkuil@xs4all.nl>
References: <201212101407.09338.hverkuil@xs4all.nl>
	<201212111415.31483.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Dec 2012 14:15:31 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Mon 10 December 2012 14:07:09 Hans Verkuil wrote:
> > Hi all,
> > 
> > As discussed in Barcelona I would write a text describing requirements for new
> > drivers and what to expect when submitting patches to linux-media.
> > 
> > This is a first rough draft and nothing is fixed yet.
> > 
> > I have a few open questions:
> > 
> > 1) Where to put it? One thing I would propose that we improve is to move the
> > dvb and video4linux directories in Documentation/ to Documentation/media to
> > correctly reflect the drivers/media structure. If we do that, then we can put
> > this document in Documentation/media/SubmittingMediaPatches.
> > 
> > Alternatively, this is something we can document in our wiki.
> > 
> > 2) Are there DVB requirements as well for new drivers? We discussed a list of
> > V4L2 requirements in Barcelona, but I wonder if there is a similar list that
> > can be made for DVB drivers. Input on that will be welcome.
> > 
> > 3) This document describes the situation we will have when the submaintainers
> > take their place early next year. So please check if I got that part right.
> > 
> > 4) In Barcelona we discussed 'tags' for patches to help organize them. I've
> > made a proposal for those in this document. Feedback is very welcome.
> > 
> > 5) As discussed in Barcelona there will be git tree maintainers for specific
> > platforms, but we didn't really go into detail who would be responsible for
> > which platform. If you want to maintain a particular platform, then please
> > let me know.
> > 
> > 6) The patchwork section is very short at the moment. It should be extended
> > when patchwork gets support to recognize the various tags.
> > 
> > 7) Anything else that should be discussed here?
> 
> How to submit patches for a stable kernel.
> 
> I can never remember, and I'm sure I'm not the only one :-)

The standard way is to add this tag:

	Cc: stable@vger.kernel.org

eventually with a comment saying to what versions it should be applied, like:

	Cc: stable@vger.kernel.org	# for v3.5 and upper

If it is noticed later the need for it on stable, or a backport is needed,
the patch author should send the patch to stable@vger.kernel.org, c/c the ML,
preferably pointing to the upstream commit ID. The patch has to be merged
upstream before being merged at stable.

-- 

Cheers,
Mauro
