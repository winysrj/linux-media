Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58386 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752583AbdBNT7i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 14:59:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Laura Abbott <labbott@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Clark, Rob" <robdclark@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [RFC simple allocator v2 1/2] Create Simple Allocator module
Date: Tue, 14 Feb 2017 21:59:55 +0200
Message-ID: <2684010.GP2h2R50oJ@avalon>
In-Reply-To: <CAKMK7uEoC6vrx-Yi0K0bFaPRctRNLmjgYrZN4thmX6a3Y0KU3A@mail.gmail.com>
References: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org> <1967325.JRFDDRuil3@avalon> <CAKMK7uEoC6vrx-Yi0K0bFaPRctRNLmjgYrZN4thmX6a3Y0KU3A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Tuesday 14 Feb 2017 20:44:44 Daniel Vetter wrote:
> On Tue, Feb 14, 2017 at 8:39 PM, Laurent Pinchart wrote:
> > On Tuesday 14 Feb 2017 20:33:58 Daniel Vetter wrote:
> >> On Mon, Feb 13, 2017 at 3:45 PM, Benjamin Gaignard wrote:
> >>> This is the core of simple allocator module.
> >>> It aim to offert one common ioctl to allocate specific memory.
> >>> 
> >>> version 2:
> >>> - rebased on 4.10-rc7
> >>> 
> >>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> >> 
> >> Why not ION? It's a bit a broken record question, but if there is a
> >> clear answer it should be in the patch&docs ...
> > 
> > There's a bit of love & hate relationship between Linux developers and
> > ION. The API has shortcomings, and attempts to fix the issues went
> > nowhere. As Laura explained, starting from a blank slate (obviously
> > keeping in mind the lessons learnt so far with ION and other similar APIs)
> > and then adding a wrapper to expose ION on Android systems (at least as an
> > interim measure) was thought to be a better option. I still believe it is,
> > but we seem to lack traction. The problem has been around for so long that
> > I feel everybody has lost hope.
> > 
> > I don't think this is unsolvable, but we need to regain motivation. In my
> > opinion the first step would be to define the precise extent of the
> > problem we want to solve.
> 
> I'm not sure anyone really tried hard enough (in the same way no one
> tried hard enough to destage android syncpts, until last year). And
> anything new should at least very clearly explain why ION (even with
> the various todo items we collected at a few conferences) won't work,
> and how exactly the new allocator is different from ION. I don't think
> we need a full design doc (like you say, buffer allocation is hard,
> we'll get it wrong anyway), but at least a proper comparison with the
> existing thing. Plus explanation why we can't reuse the uabi.

I've explained several of my concerns (including open questions that need 
answers) in another reply to this patch, let's discuss them there to avoid 
splitting the discussion.

> Because ime when you rewrite something, you generally get one thing
> right (the one thing that pissed you off about the old solution), plus
> lots and lots of things that the old solution got right, wrong
> (because it's all lost in the history).

History, repeating mistakes, all that. History never repeats itself though. We 
might make similar or identical mistakes, but there's no fatality, unless we 
decide not to try before even starting :-)

> ADF was probably the best example in this. KMS also took a while until all
> the fbdev wheels have been properly reinvented (some are still the same old
> squeaky onces as fbdev had, e.g. fbcon).
> 
> And I don't think destaging ION is going to be hard, just a bit of
> work (could be a nice gsoc or whatever).

Oh, technically speaking, it would be pretty simple. The main issue is to 
decide whether we want to commit to the existing ION API. I don't :-)

-- 
Regards,

Laurent Pinchart
