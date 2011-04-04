Return-path: <mchehab@pedra>
Received: from chybek.jannau.net ([83.169.20.219]:41362 "EHLO
	chybek.jannau.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1DDLDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:03:09 -0400
Date: Mon, 4 Apr 2011 13:05:19 +0200
From: Janne Grunau <j@jannau.net>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB-APPS: azap gets -p argument
Message-ID: <20110404110519.GE24212@aniel>
References: <AANLkTimexhCMBSd7UNr1gizgbnarwS9kucZC0nWSBJxX@mail.gmail.com>
 <AANLkTingP4tLViGTMvKeBM4XNj-cRZtqECh4WjLgZM40@mail.gmail.com>
 <20110315123258.GA6570@aniel>
 <201103151450.08708@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103151450.08708@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 15, 2011 at 02:50:05PM +0100, Oliver Endriss wrote:
> On Tuesday 15 March 2011 13:32:58 Janne Grunau wrote:
> > On Tue, Mar 15, 2011 at 01:23:40PM +0100, Christian Ulrich wrote:
> > > Hi, thank you for your feedback.
> > > 
> > > Indeed, I never used -r alone, but only with -p.
> > > So with your patch, [acst]zap -r will be the same as -rp. That looks good to me.
> > 
> > well, azap not yet. iirc I implemented -p for azap but it was never
> > applied since nobody tested it. see attached patch for [cst]zap
> 
> NAK.

I think we had the same discussion when I submitted -p for czap and
tzap.

> The PAT/PMT from the stream does not describe the dvr stream correctly.
> 
> The dvr device provides *some* PIDs of the transponder, while the
> PAT/PMT reference *all* programs of the transponder.

True, the PAT references some PMT pids which won't be included. All pids
from the desired program should be included. A transport stream without
PAT/PMT is as invalid as the stream with incorrect PAT/PMT/missing pids
but the second is easier to handle for player software than the first.

> For correct results the PAT/PMT has to be re-created.

That's not possible from ?zap and I hope you don't suggest we add
PMT/PAT rewriting routines to kernel software demuxer.

> The separate -p option seems acceptable - as a debug feature.

-r is as much a debug feature as -p. the output is invalid too

Janne
