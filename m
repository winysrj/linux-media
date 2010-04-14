Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42899 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab0DNRkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 13:40:14 -0400
Received: by gwaa18 with SMTP id a18so168550gwa.19
        for <linux-media@vger.kernel.org>; Wed, 14 Apr 2010 10:40:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BC5FB77.2020303@vorgon.com>
References: <4BC5FB77.2020303@vorgon.com>
Date: Wed, 14 Apr 2010 13:40:12 -0400
Message-ID: <k2h829197381004141040n4aa69e06x7a10c7ea70be3dcf@mail.gmail.com>
Subject: Re: cx5000 default auto sleep mode
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Timothy D. Lenz" <tlenz@vorgon.com>,
	Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 14, 2010 at 1:29 PM, Timothy D. Lenz <tlenz@vorgon.com> wrote:
> Thanks to Andy Walls, found out why I kept loosing 1 tuner on a FusionHD7
> Dual express. Didn't know linux supported an auto sleep mode on the tuner
> chips and that it defaulted to on. Seems like it would be better to default
> to off. If someone wants an auto power down/sleep mode and their software
> supports it, then let the program activate it. Seems people are more likely
> to want the tuners to stay on then keep shutting down.
>
> Spent over a year trying to figure out why vdr would loose control of 1 of
> the dual tuners when the atscepg pluging was used thinking it was a problem
> with the plugin.

The xc5000 power management changes I made were actually pretty
thoroughly tested with that card (between myself and Michael Krufky,
we tested it with just about every card that uses the tuner).  In
fact, we uncovered several power management bugs in other drivers as a
result of that effort.  It was a grueling effort that I spent almost
three months working on.

Generally I agree with the premise that functionality like this should
only be enabled for boards it was tested with.  However, in this case
it actually was pretty extensively tested with all the cards in
question (including this one), and thus it was deemed safe to enable
by default.  We've had cases in the past where developers exercised
poor judgement and blindly turned on power management to make it work
with one card, disregarding the possible breakage that could occur
with other cards that use the same driver -- this was *not* one of
those cases.

If there is a bug, it should be pretty straightforward to fix provided
it can be reproduced.

Regarding the general assertion that the power management should be
disabled by default, I disagree.  The power savings is considerable,
the time to bring the tuner out of sleep is negligible, and it's
generally good policy.

Andy, do you have any actual details regarding the nature of the problem?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
