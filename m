Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40301 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdLDTDH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 14:03:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Eugeniu Rosca <erosca@de.adit-jv.com>
Cc: kieran.bingham@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: vsp1: Fix function declaration/definition mismatch
Date: Mon, 04 Dec 2017 21:03:20 +0200
Message-ID: <5605020.PYOHkQC8tp@avalon>
In-Reply-To: <20171204181034.GA28598@vmlxhi-102.adit-jv.com>
References: <20170820124006.4256-1-rosca.eugeniu@gmail.com> <3327408.dYccgZQZOG@avalon> <20171204181034.GA28598@vmlxhi-102.adit-jv.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eugeniu,

On Monday, 4 December 2017 20:10:34 EET Eugeniu Rosca wrote:
> On Mon, Dec 04, 2017 at 12:52:17PM +0200, Laurent Pinchart wrote:
> > On Friday, 24 November 2017 20:40:57 EET Kieran Bingham wrote:
> >> Hi Eugeniu,
> >> 
> >> Thankyou for the patch,
> >> 
> >> Laurent - Any comments on this? Otherwise I'll bundle this in with my
> >> suspend/resume patch for a pull request.
> >> 
> >> <CUT>
> >> 
> >> I was going to say: We know the object is an entity by it's type. Isn't
> >> hgo more descriptive for it's name ?
> >> 
> >> However to answer my own question - The implementation function goes on
> >> to define a struct vsp1_hgo *hgo, so no ... the Entity object shouldn't
> >> be hgo.
> > 
> > And that's exactly why there's a difference between the declaration and
> > implementation :-) Naming the parameter hgo in the declaration makes it
> > clear to the reader what entity is expected. The parameter is then named
> > entity in the function definition to allow for the vsp1_hgo *hgo local
> > variable.
> > 
> > Is the mismatch a real issue ? I don't think the kernel coding style
> > mandates parameter names to be identical between function declaration and
> > definition.
> 
> You are the DRM/VSP1 and kernel experts, so feel free to drop the patch.
> Still IMO what makes kernel coding style sweet is its simplicity [1].
> Here is some statistics computed with exuberant ctags and cpccheck.
> 
> $ git describe HEAD
> v4.15-rc2
> 
> $ ctags --version
> Exuberant Ctags 5.9~svn20110310, Copyright (C) 1996-2009 Darren Hiebert
>   Addresses: <dhiebert@users.sourceforge.net>,
>   http://ctags.sourceforge.net
>     Optional compiled features: +wildcards, +regex
> 
> # Number of function definitions in drivers/media:
> $ find drivers/media -type d | \
>   xargs -I {} sh -c "ctags -x --c-types=f {}/*" | wc -l
> 24913
> 
> # Number of func declaration/definition mismatches found by cppcheck:
> $ cppcheck --force --enable=all --inconclusive  drivers/media/ 2>&1 | \
>   grep declaration | wc -l
> 168
> 
> It looks like only (168/24913) * 100% = 0,67% of all drivers/media
> functions have a mismatch between function declaration and function
> definition. Why making this number worse?

Of course the goal is not to introduce a mismatch for the sake of it. It makes 
sense for the declaration and definition to match in most cases. My point is 
that in this particular case I believe the mismatch makes the code more 
readable.

-- 
Regards,

Laurent Pinchart
