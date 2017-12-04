Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.de.adit-jv.com ([62.225.105.245]:35262 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbdLDSTP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 13:19:15 -0500
Date: Mon, 4 Dec 2017 19:10:34 +0100
From: Eugeniu Rosca <erosca@de.adit-jv.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <kieran.bingham@ideasonboard.com>
CC: <erosca@de.adit-jv.com>, <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] v4l: vsp1: Fix function declaration/definition mismatch
Message-ID: <20171204181034.GA28598@vmlxhi-102.adit-jv.com>
References: <20170820124006.4256-1-rosca.eugeniu@gmail.com>
 <85aabc6e-b332-1f9e-3fbf-87f0d7bcf9f3@ideasonboard.com>
 <3327408.dYccgZQZOG@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3327408.dYccgZQZOG@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent, Kieran,

On Mon, Dec 04, 2017 at 12:52:17PM +0200, Laurent Pinchart wrote:
> Hello,
> 
> On Friday, 24 November 2017 20:40:57 EET Kieran Bingham wrote:
> > Hi Eugeniu,
> > 
> > Thankyou for the patch,
> > 
> > Laurent - Any comments on this? Otherwise I'll bundle this in with my
> > suspend/resume patch for a pull request.
> > 
> > <CUT>
> > 
> > I was going to say: We know the object is an entity by it's type. Isn't hgo
> > more descriptive for it's name ?
> > 
> > However to answer my own question - The implementation function goes on to
> > define a struct vsp1_hgo *hgo, so no ... the Entity object shouldn't be hgo.
> 
> And that's exactly why there's a difference between the declaration and 
> implementation :-) Naming the parameter hgo in the declaration makes it clear 
> to the reader what entity is expected. The parameter is then named entity in 
> the function definition to allow for the vsp1_hgo *hgo local variable.
> 
> Is the mismatch a real issue ? I don't think the kernel coding style mandates 
> parameter names to be identical between function declaration and definition.

You are the DRM/VSP1 and kernel experts, so feel free to drop the patch.
Still IMO what makes kernel coding style sweet is its simplicity [1].
Here is some statistics computed with exuberant ctags and cpccheck.

$ git describe HEAD
v4.15-rc2

$ ctags --version
Exuberant Ctags 5.9~svn20110310, Copyright (C) 1996-2009 Darren Hiebert
  Addresses: <dhiebert@users.sourceforge.net>,
  http://ctags.sourceforge.net
    Optional compiled features: +wildcards, +regex

# Number of function definitions in drivers/media:
$ find drivers/media -type d | \
  xargs -I {} sh -c "ctags -x --c-types=f {}/*" | wc -l
24913

# Number of func declaration/definition mismatches found by cppcheck:
$ cppcheck --force --enable=all --inconclusive  drivers/media/ 2>&1 | \
  grep declaration | wc -l
168

It looks like only (168/24913) * 100% = 0,67% of all drivers/media
functions have a mismatch between function declaration and function
definition. Why making this number worse?

BR,
Eugeniu.

[1] ./Documentation/process/coding-style.rst: Kernel coding style is super simple.
