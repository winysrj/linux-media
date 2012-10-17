Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42626 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab2JQKdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 06:33:04 -0400
Date: Wed, 17 Oct 2012 11:38:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Robert Morell <rmorell@nvidia.com>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20121017113802.73a313d6@pyramind.ukuu.org.uk>
In-Reply-To: <CAPM=9txQvNgVK824FrT6GD5eZeeaOEPkBzC9sdd9E4tu=ZdPNw@mail.gmail.com>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
	<201210110857.15660.hverkuil@xs4all.nl>
	<20121016212208.GB10462@morell.nvidia.com>
	<20121017105321.062c898d@pyramind.ukuu.org.uk>
	<CAPM=9txT+Wa_JXvsv7O3mqA6WK19z8chvSVxGQdf7R3Xo-mtQg@mail.gmail.com>
	<20121017112504.47269452@pyramind.ukuu.org.uk>
	<CAPM=9txQvNgVK824FrT6GD5eZeeaOEPkBzC9sdd9E4tu=ZdPNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 17 Oct 2012 20:22:04 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Wed, Oct 17, 2012 at 8:25 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> > Please go and discuss estoppel, wilful infringement and re-licensing with
> >> > your corporate attorneys. If you want to relicense components of the code
> >> > then please take the matter up with the corporate attorneys of the rights
> >> > holders concerned.
> >>
> >> Alan please stick with the facts. This isn't a relicense of anything.
> >
> > In your opinion. Are you a qualified IP attorney - NO. Are you my lawyer
> > - NO. Does my laywer disagree with you - YES.
> 
> Okay then we should remove this code from the kernel forthwith, as I
> showed it was illegally relicensed previously in your lawyers opinion.

That would not be the same question I asked my lawyer.

Anyway I refer you to the Developer's Certificate of Origin 1.1.

Anything Signed off was submitted under the GPL and so is usable as part
of a GPL derived work, but not as part of a non GPL derived work. Thus
Nouveau can happily use it for example. Simples.

And as I said before if Nvidia believe the _GPL makes no difference and
their work is not derivative then it's clearly within their power to just
ignore it, at which point *they* take the risk on their own.

>From the fact this patch keeps getting resubmitted despite repeated
objection I deduce they are in fact of the view it does matter and that
therefore it is a licensing change and they are scared of the
consequences of ignoring it.

Alan
