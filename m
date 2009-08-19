Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozgw.promptu.com ([203.144.27.9]:3383 "EHLO
	surfers.oz.promptu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753431AbZHSXU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 19:20:26 -0400
Date: Thu, 20 Aug 2009 09:20:21 +1000
From: Bob Hepple <bhepple@promptu.com>
To: treblid <treblid@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: help: Can't get DViCO FusionHDTV DVB-T Dual Digital 4 to work
 with new kernels
Message-Id: <20090820092021.66df84be.bhepple@promptu.com>
In-Reply-To: <941593fd0908191550vcc2ee17tfbffd06dfa91eb34@mail.gmail.com>
References: <941593fd0908182109p22e5e5f0i6959369c9ac7c12f@mail.gmail.com>
	<20090819170231.a411e47a.bhepple@promptu.com>
	<941593fd0908191550vcc2ee17tfbffd06dfa91eb34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 20 Aug 2009 06:50:25 +0800
treblid <treblid@gmail.com> wrote:

> On Wed, Aug 19, 2009 at 3:02 PM, Bob Hepple<bhepple@promptu.com> wrote:
> > 2.6.27 worked for me - exact same board (ignoring revisions - mine is
> > an older board, rev.1, I think)
> Mine is rev 1 too, I think.. :p
> 
> > 2.6.28 and up failed for me in exactly this manner. Same with a
> > head-of-tree v4l-dvb 'hg clone'
> >
> > AFAICT it's a v4l-dvb driver problem - at least no-one here refutes it
> > since I reported it here on 20090615.
> cool at least I'm not alone.. is this error related to the IR
> receiver?  coz I noticed the IR receiver is detected for 1 tuner and
> not the other.
> 

I don't _think_ it's anything to do with the IR. Mind you, I don't use
the IR at all (I prefer using a bluetooth mini-keyboard for mythTV -
the IR remote provided with the DViCO doesn't have enough
functions/buttons for me).

Anne Aileus also confirmed the regression on 20090727 and offered to do
some tests if someone could provide guidance. Haven't heard any more on
that thread so far.

Cheers


Bob


-- 
Bob Hepple <bhepple@promptu.com>
ph: 07-5584-5908 Fx: 07-5575-9550
