Return-path: <mchehab@pedra>
Received: from chybek.jannau.net ([83.169.20.219]:44873 "EHLO
	chybek.jannau.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1DFHM7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 03:12:59 -0400
Received: from aniel.jannau.net (p5DDC4991.dip0.t-ipconnect.de [93.220.73.145])
	by chybek.jannau.net (Postfix) with ESMTPSA id 922325A180BE
	for <linux-media@vger.kernel.org>; Wed,  6 Apr 2011 09:12:58 +0200 (CEST)
Date: Wed, 6 Apr 2011 09:15:12 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB-APPS: azap gets -p argument
Message-ID: <20110406071512.GB8115@aniel>
References: <AANLkTimexhCMBSd7UNr1gizgbnarwS9kucZC0nWSBJxX@mail.gmail.com>
 <201103151450.08708@orion.escape-edv.de>
 <20110404110519.GE24212@aniel>
 <201104060839.08855@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104060839.08855@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Apr 06, 2011 at 08:39:05AM +0200, Oliver Endriss wrote:
> On Monday 04 April 2011 13:05:19 Janne Grunau wrote:
> > On Tue, Mar 15, 2011 at 02:50:05PM +0100, Oliver Endriss wrote:
> > > The PAT/PMT from the stream does not describe the dvr stream correctly.
> > > 
> > > The dvr device provides *some* PIDs of the transponder, while the
> > > PAT/PMT reference *all* programs of the transponder.
> > 
> > True, the PAT references some PMT pids which won't be included. All pids
> > from the desired program should be included. A transport stream without
> > PAT/PMT is as invalid as the stream with incorrect PAT/PMT/missing pids
> > but the second is easier to handle for player software than the first.
> 
> A sane player can handle a TS stream without PAT/PMT.
> Iirc mplayer never had any problems.

mplayer with default options has only no problems as long as the video
codec is mpeg2 and possible mpeg 1 layer 2 audio. Try any H.264 stream
and see it fail. That was the reason why I want to change the behaviour
with -r in the first place. http://blog.fefe.de/?ts=b58fb6b1 (german
content) triggered it.

I don't care too much. Can someone please push Christian's original
patch adding -p to azap.

Janne
