Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49870 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2C2Ldh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 07:33:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: Gary Thomas <gary@mlbassoc.com>,
	Joshua Hintze <joshua.hintze@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Using MT9P031 digital sensor
Date: Thu, 29 Mar 2012 13:33:37 +0200
Message-ID: <2125149.qqo69uga5z@avalon>
In-Reply-To: <CAGGh5h3VJ-otjbKXkxrHwQjA-z3LnyxU7A-DwM70zm-BHhFECQ@mail.gmail.com>
References: <CAGD8Z75ELkV6wJOfuCFU3Z2dS=z5WbV-7izazaG7SVtfPMcn=A@mail.gmail.com> <4F709A15.7050501@mlbassoc.com> <CAGGh5h3VJ-otjbKXkxrHwQjA-z3LnyxU7A-DwM70zm-BHhFECQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 27 March 2012 16:44:50 jean-philippe francois wrote:
> Le 26 mars 2012 18:32, Gary Thomas <gary@mlbassoc.com> a écrit :
> > On 2012-03-26 09:37, Joshua Hintze wrote:
> >> Gary,
> >> 
> >> I'm using linux branch from 2.6.39
> >> 
> >> Fetch URL: git://www.sakoman.com/git/linux-omap-2.6
> >> branch: omap-2.6.39
> >> 
> >> I'm using an overo board so I figured I should follow Steve Sakoman's
> >> repository.
> >> 
> >> Which brings up another question, would you recommend going off of one
> >> of Laurent's repo's and if so which one?
> > 
> > The last time I tried Laurent's repo, it did not have the UYVY support in
> > the OMAP3ISP/CCDC merged in.  I don't know if that has changed recently.
> 
> I think you are talking about UYVY/YUYV sensor input to the CDCD which
> was not working.
> However, the previewer part is working, ie Bayer input and YUV output.
> 
> UYVY input is present in one of Laurent's tree. I did not test it.

I've updated my tree with the latest code. I unfortunately still don't have 
the necessary hardware to test it.

-- 
Regards,

Laurent Pinchart

