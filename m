Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:37471
	"EHLO QMTA03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060AbZAYQwO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 11:52:14 -0500
Date: Sun, 25 Jan 2009 11:52:07 -0500
From: Jeff DeFouw <jeffd@i2k.com>
To: linux-media@vger.kernel.org, killero_24@yahoo.com
Subject: Re: [linux-dvb] HVR-1800 Support
Message-ID: <20090125165207.GA30450@blorp.plorb.com>
References: <463244.61379.qm@web45416.mail.sp1.yahoo.com> <20090124203726.GA9808@blorp.plorb.com> <37219a840901250726q7f385702uf33c07ac5b09647d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840901250726q7f385702uf33c07ac5b09647d@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 25, 2009 at 10:26:51AM -0500, Michael Krufky wrote:
> On Sat, Jan 24, 2009 at 3:37 PM, Jeff DeFouw <jeffd@i2k.com> wrote:
> > On Tue, Jan 20, 2009 at 10:08:51PM -0800, Killero SS wrote:
> >> i'm using ubuntu 8.10 2.6.27-9-generic
> >> and tried compiling latest modules with hg-clone but my analog capture got broken, firmware error...
> >> so i got back to original kernel modules
> >> however, some people claim they get audio with analog on /dev/video1
> >> this has never be my case, im using svideo signal so wondering if that may be it.
> >> i get analog video on video0 and video1, but some colors look pretty weird, red for example.
> >
> > The driver in the kernel and hg does not set up the registers properly
> > for the video or audio in S-Video mode.  I made some changes to get mine
> > working.  I can probably make a patch for you if you can get your source
> > build working.
> 
> Why not sign it off and send it in to the list, to be merged into the
> official sources?
> 
> Surely if there is a bug or missing feature that you've fixed, it
> should be merged into the repository so that everybody else can
> benefit from it.

Right now it's kind of a dirty hack just for my card.  I'm stepping on 
code shared with other cx23885/cx25840 cards and potentially breaking 
them without any way to check.  It needs a few more changes anyway, but 
the breaking would still be a problem.  I can either hope for the best, 
or add extra variables and conditions just for this card and make a 
little mess.

-- 
Jeff DeFouw <jeffd@i2k.com>
