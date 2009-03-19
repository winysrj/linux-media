Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:58090 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbZCSJKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 05:10:23 -0400
Date: Thu, 19 Mar 2009 02:10:20 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <200903151748.12322.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903190154250.28292@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0903070144520.5665@axis700.grange>
 <Pine.LNX.4.58.0903150922360.28292@shell2.speakeasy.net>
 <200903151748.12322.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009, Hans Verkuil wrote:
> On Sunday 15 March 2009 17:39:11 Trent Piepho wrote:
> > Because there are patches that touch both the media tree and outside it?
> > I don't buy it.  Even for sub-systems that only use full git trees, you
> > almost never see a patch that touches multiple areas of maintainership.
> > It's just too hard to deal with getting acks from everyone involved,
> > dealing with the out-of-sync development git trees of the multiple areas
> > you want to touch, figuring out who will take your patch, etc.
>
> Think embedded devices like omap, davinci and other SoC devices. These all
> require changes in both v4l-dvb and arch at the same time. Easy to do if
> you have a full git tree, much harder to do in the current situation.
>
> These devices will become much more important in the coming months and
> years, so having a proper git tree will definitely help.
>
> This is a relatively new development and before that it was indeed rare to
> see patches touching on areas outside the media tree. Not anymore, though.

ALSA has a full git tree now, so there should be all these patches that
touch sound/ and something out side of sound too?  I'm not seeing them.
The only patches that touch inside and outside of ALSA are the ones that
fix some misspelled word in 100 random files or rename a linux header file.
