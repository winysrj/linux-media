Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbZFKWVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 18:21:03 -0400
Date: Thu, 11 Jun 2009 19:20:52 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>
Cc: v4l-dvb-maintainer@linuxtv.org,
	"Udo A. Steinberg" <udo@hypervisor.org>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Message-ID: <20090611192052.782d47af@pedra.chehab.org>
In-Reply-To: <200906112222.50283.hverkuil@xs4all.nl>
References: <20090611221402.66709817@laptop.hypervisor.org>
	<200906112218.11016.hverkuil@xs4all.nl>
	<200906112222.50283.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 11 Jun 2009 22:22:50 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Thursday 11 June 2009 22:18:10 Hans Verkuil wrote:
> > On Thursday 11 June 2009 22:14:02 Udo A. Steinberg wrote:
> > > Hi all,
> > > 
> > > With Linux 2.6.30 the BTTV driver for my WinTV card claims
> > > 
> > > 	bttv0: audio absent, no audio device found!
> > > 
> > > and audio does not work. This worked up to and including 2.6.29. Is this a
> > > known issue? Does anyone have a fix or a patch for me to try?
> > 
> > You've no doubt compiled the bttv driver into the kernel and not as a module.
> > 
> > I've just pushed a fix for this to my tree: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
> 
> I've also attached a diff against 2.6.30 since the patch in my tree is against
> the newer v4l-dvb repository and doesn't apply cleanly against 2.6.30.


> # All i2c modules must come first:

Argh! this is an ugly solution. This can be an workaround for 2.6.30, but the
proper solution is to make sure that i2c core got initialized before any i2c
client.

Jean,

is there any patch meant to fix the usage of i2c when I2C and drivers are compiled with 'Y' ?




Cheers,
Mauro
