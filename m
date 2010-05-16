Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45789 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750830Ab0EPE7w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 00:59:52 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: av7110 and budget_av are broken!
Date: Sun, 16 May 2010 06:21:48 +0200
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	e9hack <e9hack@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl> <AANLkTimRAmxOL_eilVew3E9cabznR0_H2QZsvAXWM-bk@mail.gmail.com> <1273974828.3200.12.camel@pc07.localdom.local>
In-Reply-To: <1273974828.3200.12.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005160622.00278@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 16 May 2010 03:53:48 hermann pitton wrote:
> 
> Am Samstag, den 15.05.2010, 22:33 -0300 schrieb Douglas Schilling
> Landgraf:
> > Hello Oliver,
> > 
> > On Sat, May 15, 2010 at 8:06 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
> > > On Wednesday 21 April 2010 11:44:16 Oliver Endriss wrote:
> > >> On Wednesday 21 April 2010 08:37:39 Hans Verkuil wrote:
> > >> > > Am 22.3.2010 20:34, schrieb e9hack:
> > >> > >> Am 20.3.2010 22:37, schrieb Hans Verkuil:
> > >> > >>> On Saturday 20 March 2010 17:03:01 e9hack wrote:
> > >> > >>> OK, I know that. But does the patch I mailed you last time fix this
> > >> > >>> problem
> > >> > >>> without causing new ones? If so, then I'll post that patch to the list.
> > >> > >>
> > >> > >> With your last patch, I've no problems. I'm using a a TT-C2300 and a
> > >> > >> Budget card. If my
> > >> > >> VDR does start, currently I've no chance to determine which module is
> > >> > >> load first, but it
> > >> > >> works. If I unload all modules and load it again, I've no problem. In
> > >> > >> this case, the
> > >> > >> modules for the budget card is load first and the modules for the FF
> > >> > >> loads as second one.
> > >> > >
> > >> > > Ping!!!!!!
> > >> >
> > >> > It's merged in Mauro's fixes tree, but I don't think those pending patches
> > >> > have been pushed upstream yet. Mauro, can you verify this? They should be
> > >> > pushed to 2.6.34!
> > >>
> > >> What about the HG driver?
> > >> The v4l-dvb HG repository is broken for 7 weeks...
> > >
> > > Hi guys,
> > >
> > > we have May 16th, and the HG driver is broken for 10 weeks now!
> > >
> > > History:
> > > - The changeset which caused the mess was applied on March 2nd:
> > >  http://linuxtv.org/hg/v4l-dvb/rev/2eda2bcc8d6f
> > >
> > > - A fix is waiting at fixes.git since March 24th:
> > >  http://git.linuxtv.org/fixes.git?a=commitdiff_plain;h=40358c8b5380604ac2507be2fac0c9bbd3e02b73
> > >
> > > Are there any plans to bring v4ldvb HG to an usable state?
> > 
> > Yes, Now I will collect patches from devel and fixes tree. At least
> > until we achieve a better approach on it.
> > Sorry the delay.
> > 
> > Sounds good? Any other suggestion?
> > 
> > Let me work on it.
> > 
> > Cheers
> > Douglas
> 
> 
> Hi, Douglas and Oliver,
> 
> just as a small comment.
> 
> I have not been on latest rc1 and such rcs close to a release for some
> time.
>
> But I was for a long time and v4l-dvb can't be a substitute for such.

Sorry, I do not want to cope with experimental kernels and their bugs on
my systems. I need a stable and reliable platform, so that I can
concentrate on 'my' bugs.

Usually I update the kernel every 3..4 releases (which causes enough
trouble due to changed features, interfaces etc).

> Despite of getting more users for testing, on _that_ front does not
> happen such much currently, keeping v4l-dvb is mostly a service for
> developers this time.
> 
> So, contributing on the backports and helping Douglas with such is
> really welcome.

I confess that I do not know much about the tree handling procedures of
the kernel. Imho it sounds crazy to have separate 'fixes' and
'development' trees.

A developer's tree (no matter whether HG or GIT) must also include the
fixes, otherwise it is unusable. You cannot wait until applied fixes
flow back from the kernel.

Btw, the v4ldvb HG repositories contain tons of disabled code (marked
'#if 0'), which was stripped for submission to the kernel.
Even if we would switch to GIT completely, we need a separate GIT
repository which would hold the original code.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
