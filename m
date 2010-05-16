Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:53645 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab0EPByz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 21:54:55 -0400
Subject: Re: av7110 and budget_av are broken!
From: hermann pitton <hermann-pitton@arcor.de>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	e9hack <e9hack@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <AANLkTimRAmxOL_eilVew3E9cabznR0_H2QZsvAXWM-bk@mail.gmail.com>
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl>
	 <201004211144.19591@orion.escape-edv.de>
	 <201005160106.56028@orion.escape-edv.de>
	 <AANLkTimRAmxOL_eilVew3E9cabznR0_H2QZsvAXWM-bk@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 16 May 2010 03:53:48 +0200
Message-Id: <1273974828.3200.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Samstag, den 15.05.2010, 22:33 -0300 schrieb Douglas Schilling
Landgraf:
> Hello Oliver,
> 
> On Sat, May 15, 2010 at 8:06 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
> > On Wednesday 21 April 2010 11:44:16 Oliver Endriss wrote:
> >> On Wednesday 21 April 2010 08:37:39 Hans Verkuil wrote:
> >> > > Am 22.3.2010 20:34, schrieb e9hack:
> >> > >> Am 20.3.2010 22:37, schrieb Hans Verkuil:
> >> > >>> On Saturday 20 March 2010 17:03:01 e9hack wrote:
> >> > >>> OK, I know that. But does the patch I mailed you last time fix this
> >> > >>> problem
> >> > >>> without causing new ones? If so, then I'll post that patch to the list.
> >> > >>
> >> > >> With your last patch, I've no problems. I'm using a a TT-C2300 and a
> >> > >> Budget card. If my
> >> > >> VDR does start, currently I've no chance to determine which module is
> >> > >> load first, but it
> >> > >> works. If I unload all modules and load it again, I've no problem. In
> >> > >> this case, the
> >> > >> modules for the budget card is load first and the modules for the FF
> >> > >> loads as second one.
> >> > >
> >> > > Ping!!!!!!
> >> >
> >> > It's merged in Mauro's fixes tree, but I don't think those pending patches
> >> > have been pushed upstream yet. Mauro, can you verify this? They should be
> >> > pushed to 2.6.34!
> >>
> >> What about the HG driver?
> >> The v4l-dvb HG repository is broken for 7 weeks...
> >
> > Hi guys,
> >
> > we have May 16th, and the HG driver is broken for 10 weeks now!
> >
> > History:
> > - The changeset which caused the mess was applied on March 2nd:
> >  http://linuxtv.org/hg/v4l-dvb/rev/2eda2bcc8d6f
> >
> > - A fix is waiting at fixes.git since March 24th:
> >  http://git.linuxtv.org/fixes.git?a=commitdiff_plain;h=40358c8b5380604ac2507be2fac0c9bbd3e02b73
> >
> > Are there any plans to bring v4ldvb HG to an usable state?
> 
> Yes, Now I will collect patches from devel and fixes tree. At least
> until we achieve a better approach on it.
> Sorry the delay.
> 
> Sounds good? Any other suggestion?
> 
> Let me work on it.
> 
> Cheers
> Douglas


Hi, Douglas and Oliver,

just as a small comment.

I have not been on latest rc1 and such rcs close to a release for some
time.

But I was for a long time and v4l-dvb can't be a substitute for such.

Despite of getting more users for testing, on _that_ front does not
happen such much currently, keeping v4l-dvb is mostly a service for
developers this time.

So, contributing on the backports and helping Douglas with such is
really welcome.

Cheers,
Hermann




