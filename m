Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZHPWvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Aug 2009 18:51:22 -0400
Date: Sun, 16 Aug 2009 19:51:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] sms1xxx: restore GPIO
 functionality for all Hauppauge devices
Message-ID: <20090816195115.584b89b4@caramujo.chehab.org>
In-Reply-To: <303a8ee30908141041l4a3ada2aqcc87dc59a56e9677@mail.gmail.com>
References: <E1Mauhe-0003WS-E6@mail.linuxtv.org>
	<37219a840908131403v5d336c4dof316f562e465c6f4@mail.gmail.com>
	<1250212303.8915.5.camel@pc07.localdom.local>
	<303a8ee30908141041l4a3ada2aqcc87dc59a56e9677@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Aug 2009 13:41:47 -0400
Michael Krufky <mkrufky@kernellabs.com> escreveu:

> On Thu, Aug 13, 2009 at 9:11 PM, hermann pitton<hermann-pitton@arcor.de> wrote:
> >
> > Am Donnerstag, den 13.08.2009, 17:03 -0400 schrieb Michael Krufky:
> >> Mauro,
> >>
> >> This changeset is not in your git tree for Linus, but it fixes a
> >> regression in the 2.6.31 kernel -- can you push this to Linus as well?
> >>
> >> Thanks & regards,
> >>
> >> Mike
> >
> > Fixes for Hauppauge/Pinnacle devices are never ignored.
> >
> > http://linuxtv.org/hg/v4l-dvb/rev/f2deba9c23d6
> > http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-08/msg04800.html
> >
> > It might be related to this.
> >
> > http://lkml.indiana.edu/hypermail/linux/kernel/0908.1/02080.html
> >
> > You eventually might get some noise, if there are no fixes for more than
> > one year, but never the other way round.
> >
> > :)
> >
> > Cheers,
> > Hermann
> 
> 
> Thanks for your input, Hermann, but you're not entirely accurate --
> Mauro's pull request contains the changeset to fix the broken
> Hauppauge devices, but it does not mention the fix to restore the GPIO
> functionality.
> 
> I am aware that he "forgot to push" -- I was actually referring to his
> pull request, which included, "sms1xxx: fix broken Hauppauge devices"
> but did not include, "sms1xxx: restore GPIO functionality for all
> Hauppauge devices"
> 
> Mauro,
> 
> Thank you in advance for handling this :-)

This will be on a next GIT pull request, since I handled this after the last
upstream push



Cheers,
Mauro
