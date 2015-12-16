Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43178 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824AbbLPKhg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 05:37:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH v2 00/32] VSP: Add R-Car Gen3 support
Date: Wed, 16 Dec 2015 12:37:33 +0200
Message-ID: <1476580.3KzNLJVXIA@avalon>
In-Reply-To: <CAMuHMdXpJP9GFCsOVz2224BS5-XFTMrQwoDnzBbcuo+iv4R=Gw@mail.gmail.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <3938053.0568U3PJkY@avalon> <CAMuHMdXpJP9GFCsOVz2224BS5-XFTMrQwoDnzBbcuo+iv4R=Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Wednesday 16 December 2015 09:39:29 Geert Uytterhoeven wrote:
> On Sat, Dec 5, 2015 at 11:54 PM, Laurent Pinchart wrote:
> > On Saturday 05 December 2015 11:57:49 Geert Uytterhoeven wrote:
> >> As http://git.linuxtv.org/pinchartl/media.git/tag/?id=vsp1-kms-20151112
> >> is getting old, and has lots of conflicts with recent -next, do you plan
> >> to publish this in a branch, and a separate branch for integration, to
> >> ease integration in renesas-drivers?
> >> 
> >> Alternatively, I can just import the series you posted, but having the
> >> broken-out integration part would be nice.
> > 
> > The issue I'm facing is that there's more than just two series. Beside the
> > base VSP patches from this series, I have a series of DRM patches that
> > depend on this one, a series of V4L2 core patches, another series of VSP
> > patches that I still need to finish and a bunch of integration patches.
> > As some of these have dependencies on H3 CCF support that hasn't landed
> > in Simon's tree yet, I have merged your topic/cpg-mssr-v6 and
> > topic/r8a7795-drivers-sh-v1 branches into my tree for development.
> > 
> > I could keep all series in separate branches and merge the two topic
> > branches last, but that's not very handy during development when I have
> > to continuously rebase my patches. Is there a way I could handle this
> > that would make your life easier while not making mine more difficult ?
> 
> I feel your pain...
> 
> For development, committing to a single branch and rebasing interactively is
> also my workflow. But after a few 100 commits, rebasing takes a long time.
> And you can't publish that tree.
> 
> I started moving "finished" stuff to separate topic branches (this is the
> stuff published/imported into renesas-drivers topic branches, or kept in
> private branches for the parts I don't want to publish it yet), and merging
> them early on.

The issue here is that there is only a single batch of patches I consider as 
finished, and those are already present in a branch based directly on top of 
linuxtv/master that I then merge into my working branches. On a side note I've 
now sent a pull request for that.

The rest is not considered finished yet, I've modified the oldest branches no 
later than today. The code is stabilizing though, and I expect to send a pull 
request for a first batch of DU patches after the v4.5 merge window closes.

> Actual development is still done on top with frequent rebasing.
> 
> The problem starts when updating that. Instead of a simple rebase -i, it now
> involves:
>   - Duplicating the old topic branch, version number increased,
>   - Interactively rebasing the new topic branch, including/squashing commits
> from recent development,
>   - Merging in the new topic branch "early on", and rebasing all other
> private development on top of that.
> For "big" changes that's OK. For adding a bunch of Acked-by's it's a lot of
> work.
> 
> > In the meantime I've pushed vsp1-kms-20151206 to
> > git://linuxtv.org/pinchartl/media.git.
> 
> Hadn't thanked you yet for that: Thanks!

You're welcome, and there's now vsp1-kms-20151216 :-)

-- 
Regards,

Laurent Pinchart

