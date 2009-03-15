Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:40015 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbZCOQjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 12:39:14 -0400
Date: Sun, 15 Mar 2009 09:39:11 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <Pine.LNX.4.64.0903070144520.5665@axis700.grange>
Message-ID: <Pine.LNX.4.58.0903150922360.28292@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl> <20090304141715.0a1af14d@pedra.chehab.org>
 <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
 <Pine.LNX.4.58.0903051217070.24268@shell2.speakeasy.net>
 <Pine.LNX.4.64.0903052129510.4980@axis700.grange>
 <Pine.LNX.4.58.0903051243270.24268@shell2.speakeasy.net>
 <Pine.LNX.4.64.0903052315530.4980@axis700.grange>
 <Pine.LNX.4.58.0903061532210.24268@shell2.speakeasy.net>
 <Pine.LNX.4.64.0903070144520.5665@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 7 Mar 2009, Guennadi Liakhovetski wrote:
> On Fri, 6 Mar 2009, Trent Piepho wrote:
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

Because there are patches that touch both the media tree and outside it?  I
don't buy it.  Even for sub-systems that only use full git trees, you
almost never see a patch that touches multiple areas of maintainership.
It's just too hard to deal with getting acks from everyone involved,
dealing with the out-of-sync development git trees of the multiple areas
you want to touch, figuring out who will take your patch, etc.

It seems like the real complaint is that dealing v4l-dvb's development
system is more work for those people who choose not to use it.  Why don't
we just switch to CVS while were at it, to make it easier for those who
don't want to learn git?
