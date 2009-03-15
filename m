Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2237 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbZCOQr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 12:47:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
Date: Sun, 15 Mar 2009 17:48:12 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
References: <200903022218.24259.hverkuil@xs4all.nl> <Pine.LNX.4.64.0903070144520.5665@axis700.grange> <Pine.LNX.4.58.0903150922360.28292@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0903150922360.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151748.12322.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 15 March 2009 17:39:11 Trent Piepho wrote:
> On Sat, 7 Mar 2009, Guennadi Liakhovetski wrote:
> > On Fri, 6 Mar 2009, Trent Piepho wrote:
> > > On Thu, 5 Mar 2009, Guennadi Liakhovetski wrote:
> > > > On Thu, 5 Mar 2009, Trent Piepho wrote:
> > > > > ALSA used a partial tree, but their system was much worse than
> > > > > v4l-dvb's. I think the reason more systems don't do it is that
> > > > > setting up the build system we have with v4l-dvb was a lot of
> > > > > work.  They don't have that.
> > > >
> > > > Right, it was a lot of work, it is still quite a bit of work (well,
> > > > I'm not doing that work directly, but it affetcs me too, when I
> > > > have to adjust patches, that I generated from a complete kernel
> > > > tree to fit compatibility-"emhanced" versions), and it is not going
> > > > to be less work.
> > >
> > > Why must you generate your patches from a different tree?  One could
> > > just as well say that the linux kernel indentation style is more
> > > work, since they use GNU style have to translate their patch from a
> > > re-indented tree.
> >
> > [snip]
> >
> > Hans has already answered your question very well in this thread. I
> > don't think I can add anything.
>
> Because there are patches that touch both the media tree and outside it? 
> I don't buy it.  Even for sub-systems that only use full git trees, you
> almost never see a patch that touches multiple areas of maintainership.
> It's just too hard to deal with getting acks from everyone involved,
> dealing with the out-of-sync development git trees of the multiple areas
> you want to touch, figuring out who will take your patch, etc.

Think embedded devices like omap, davinci and other SoC devices. These all 
require changes in both v4l-dvb and arch at the same time. Easy to do if 
you have a full git tree, much harder to do in the current situation.

These devices will become much more important in the coming months and 
years, so having a proper git tree will definitely help. 

This is a relatively new development and before that it was indeed rare to 
see patches touching on areas outside the media tree. Not anymore, though.

Regards,

	Hans

> It seems like the real complaint is that dealing v4l-dvb's development
> system is more work for those people who choose not to use it.  Why don't
> we just switch to CVS while were at it, to make it easier for those who
> don't want to learn git?


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
