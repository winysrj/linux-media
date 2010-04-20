Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:56146 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab0DTRRc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 13:17:32 -0400
Message-ID: <4BCDE1A1.2000701@vorgon.com>
Date: Tue, 20 Apr 2010 10:17:21 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx5000 default auto sleep mode
References: <4BC5FB77.2020303@vorgon.com> <k2h829197381004141040n4aa69e06x7a10c7ea70be3dcf@mail.gmail.com>
In-Reply-To: <k2h829197381004141040n4aa69e06x7a10c7ea70be3dcf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 4/14/2010 10:40 AM, Devin Heitmueller wrote:
> On Wed, Apr 14, 2010 at 1:29 PM, Timothy D. Lenz<tlenz@vorgon.com>  wrote:
>> Thanks to Andy Walls, found out why I kept loosing 1 tuner on a FusionHD7
>> Dual express. Didn't know linux supported an auto sleep mode on the tuner
>> chips and that it defaulted to on. Seems like it would be better to default
>> to off. If someone wants an auto power down/sleep mode and their software
>> supports it, then let the program activate it. Seems people are more likely
>> to want the tuners to stay on then keep shutting down.
>>
>> Spent over a year trying to figure out why vdr would loose control of 1 of
>> the dual tuners when the atscepg pluging was used thinking it was a problem
>> with the plugin.
>
> The xc5000 power management changes I made were actually pretty
> thoroughly tested with that card (between myself and Michael Krufky,
> we tested it with just about every card that uses the tuner).  In
> fact, we uncovered several power management bugs in other drivers as a
> result of that effort.  It was a grueling effort that I spent almost
> three months working on.
>
> Generally I agree with the premise that functionality like this should
> only be enabled for boards it was tested with.  However, in this case
> it actually was pretty extensively tested with all the cards in
> question (including this one), and thus it was deemed safe to enable
> by default.  We've had cases in the past where developers exercised
> poor judgement and blindly turned on power management to make it work
> with one card, disregarding the possible breakage that could occur
> with other cards that use the same driver -- this was *not* one of
> those cases.
>
> If there is a bug, it should be pretty straightforward to fix provided
> it can be reproduced.
>
> Regarding the general assertion that the power management should be
> disabled by default, I disagree.  The power savings is considerable,
> the time to bring the tuner out of sleep is negligible, and it's
> generally good policy.
>
> Andy, do you have any actual details regarding the nature of the problem?
>
> Devin
>

This morning a tuner was down. So the long runs it made, maybe where a 
fluke. I still have options xc5000 no_poweroff=1 debug=1. I posted new 
logs, to http://24.255.17.209:2400/vdr/logs/. The files with ".new" ext 
are the new ones with lognig when the tuner went down.
