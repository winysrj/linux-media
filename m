Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:42227 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753394Ab1DFHAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 03:00:04 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH] DVB-APPS: azap gets -p argument
Date: Wed, 6 Apr 2011 08:39:05 +0200
Cc: linux-media@vger.kernel.org
References: <AANLkTimexhCMBSd7UNr1gizgbnarwS9kucZC0nWSBJxX@mail.gmail.com> <201103151450.08708@orion.escape-edv.de> <20110404110519.GE24212@aniel>
In-Reply-To: <20110404110519.GE24212@aniel>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104060839.08855@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 04 April 2011 13:05:19 Janne Grunau wrote:
> On Tue, Mar 15, 2011 at 02:50:05PM +0100, Oliver Endriss wrote:
> > On Tuesday 15 March 2011 13:32:58 Janne Grunau wrote:
> > > On Tue, Mar 15, 2011 at 01:23:40PM +0100, Christian Ulrich wrote:
> > > > Hi, thank you for your feedback.
> > > > 
> > > > Indeed, I never used -r alone, but only with -p.
> > > > So with your patch, [acst]zap -r will be the same as -rp. That looks good to me.
> > > 
> > > well, azap not yet. iirc I implemented -p for azap but it was never
> > > applied since nobody tested it. see attached patch for [cst]zap
> > 
> > NAK.
> 
> I think we had the same discussion when I submitted -p for czap and
> tzap.

I don't care about an additional option, but the behaviour with option
'-r' should not change. There is no need to do so.

> > The PAT/PMT from the stream does not describe the dvr stream correctly.
> > 
> > The dvr device provides *some* PIDs of the transponder, while the
> > PAT/PMT reference *all* programs of the transponder.
> 
> True, the PAT references some PMT pids which won't be included. All pids
> from the desired program should be included. A transport stream without
> PAT/PMT is as invalid as the stream with incorrect PAT/PMT/missing pids
> but the second is easier to handle for player software than the first.

A sane player can handle a TS stream without PAT/PMT.
Iirc mplayer never had any problems.

> > For correct results the PAT/PMT has to be re-created.
> 
> That's not possible from ?zap and I hope you don't suggest we add
> PMT/PAT rewriting routines to kernel software demuxer.

No. ;-)

> > The separate -p option seems acceptable - as a debug feature.
> 
> -r is as much a debug feature as -p. the output is invalid too

With separate options, you have a choice. So implement a separate option
'-p', and everything is fine.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
