Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:56662 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbZCGBo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 20:44:59 -0500
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
From: hermann pitton <hermann-pitton@arcor.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
In-Reply-To: <Pine.LNX.4.64.0903070144520.5665@axis700.grange>
References: <200903022218.24259.hverkuil@xs4all.nl>
	 <20090304141715.0a1af14d@pedra.chehab.org>
	 <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
	 <Pine.LNX.4.58.0903051217070.24268@shell2.speakeasy.net>
	 <Pine.LNX.4.64.0903052129510.4980@axis700.grange>
	 <Pine.LNX.4.58.0903051243270.24268@shell2.speakeasy.net>
	 <Pine.LNX.4.64.0903052315530.4980@axis700.grange>
	 <Pine.LNX.4.58.0903061532210.24268@shell2.speakeasy.net>
	 <Pine.LNX.4.64.0903070144520.5665@axis700.grange>
Content-Type: text/plain
Date: Sat, 07 Mar 2009 02:46:22 +0100
Message-Id: <1236390382.2259.17.camel@pc09.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 07.03.2009, 01:46 +0100 schrieb Guennadi Liakhovetski:
> On Fri, 6 Mar 2009, Trent Piepho wrote:
> 
> > On Thu, 5 Mar 2009, Guennadi Liakhovetski wrote:
> > > On Thu, 5 Mar 2009, Trent Piepho wrote:
> > > > ALSA used a partial tree, but their system was much worse than v4l-dvb's.
> > > > I think the reason more systems don't do it is that setting up the build
> > > > system we have with v4l-dvb was a lot of work.  They don't have that.
> > >
> > > Right, it was a lot of work, it is still quite a bit of work (well, I'm
> > > not doing that work directly, but it affetcs me too, when I have to adjust
> > > patches, that I generated from a complete kernel tree to fit
> > > compatibility-"emhanced" versions), and it is not going to be less work.
> > 
> > Why must you generate your patches from a different tree?  One could just
> > as well say that the linux kernel indentation style is more work, since
> > they use GNU style have to translate their patch from a re-indented tree.
> 
> [snip]
> 
> Hans has already answered your question very well in this thread. I don't 
> think I can add anything.
> 
> Thanks
> Guennadi

for me Trent clearly has the better arguments, but I do have of course a
different point of view.

Let's have this embedded Linux conference and listen to the arguments we
hopefully get some links to.

There is a lot going on, but you must convince me at least to buy some
of this stuff I call gadgets. I don't see any need so far ;)

You likely can get still anybody seriously interested to build the
always next rc1 and then one close to the final next kernel release too,
but I seriously doubt that you can convince anybody at all to give up
totally what we have for embedded mixed trees fun on latest git and
break all others by will for your latest pleasure.

Cheers,
Hermann




