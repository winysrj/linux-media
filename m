Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:64308 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757043Ab0DODo0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 23:44:26 -0400
Subject: Re: cx5000 default auto sleep mode
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: "Timothy D. Lenz" <tlenz@vorgon.com>, linux-media@vger.kernel.org
In-Reply-To: <k2h829197381004141040n4aa69e06x7a10c7ea70be3dcf@mail.gmail.com>
References: <4BC5FB77.2020303@vorgon.com>
	 <k2h829197381004141040n4aa69e06x7a10c7ea70be3dcf@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 14 Apr 2010 23:44:59 -0400
Message-Id: <1271303099.7643.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-04-14 at 13:40 -0400, Devin Heitmueller wrote:
> On Wed, Apr 14, 2010 at 1:29 PM, Timothy D. Lenz <tlenz@vorgon.com> wrote:
> > Thanks to Andy Walls, found out why I kept loosing 1 tuner on a FusionHD7
> > Dual express. Didn't know linux supported an auto sleep mode on the tuner
> > chips and that it defaulted to on. Seems like it would be better to default
> > to off. 
> 
> Regarding the general assertion that the power management should be
> disabled by default, I disagree.  The power savings is considerable,
> the time to bring the tuner out of sleep is negligible, and it's
> generally good policy.
> 
> Andy, do you have any actual details regarding the nature of the problem?

Not really.  DViCo Fusion dual digital tv card.  One side of the card
would yield "black video screen" when starting a digital capture
sometime after (?) the VDR ATSC EPG plugin tried to suck off data.  I'm
not sure there was a causal relationship.

I hypothesized that one side of the dual-tuner was going stupid or one
of the two channels used in the cx23885 was getting confused.  I was
looking at how to narrow the problem down to cx23885 chip or xc5000
tuner, or s5h14xx demod when I noted the power managment module option
for the xc5000.  I suggested Tim try it. 

It was dumb luck that my guess actually made his symptoms go away.

That's all I know.

Regards,
Andy


