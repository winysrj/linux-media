Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:36911 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbZIMDni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:43:38 -0400
Subject: Re: cx88: 2 channels on each of 2 cards
From: hermann pitton <hermann-pitton@arcor.de>
To: Adam Swift <vikevid@omnitude.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090913114622.cwfj5t1kgowgkgo4@omnitude.net>
References: <20090913114622.cwfj5t1kgowgkgo4@omnitude.net>
Content-Type: text/plain
Date: Sun, 13 Sep 2009 05:40:48 +0200
Message-Id: <1252813248.3259.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 13.09.2009, 11:46 +1000 schrieb Adam Swift:
> Hi all,
> 
> I have 2 LeadTek WinFast TV2000 XP Expert analog capture cards. I'm  
> attempting to get 4 channels of video in, using both the S-video and  
> component inputs (not the tuners) of each cards. I understand that  
> this was possible with the bt878 which this chip is an evolution of.
> 
> However, it doesn't work.
> 
> 1 channel on each card gives no signal on the "second" card- i.e. the  
> one initialised second. This is from tests with  and ZoneAlarm (the  
> application I'm trying to use the cards with).
> 
> 2 channels on one card kinda works, but not correctly. Sometimes one  
> channel will display vertical split-screen of both feeds, with a  
> little noise at the top, bottom, and in between. Sometimes each  
> channel will display correctly, but will appear to "vibrate" up and  
> down, and the channels seem to alternate between which one updates. I  
> can provide screenshots of both these behaviours if it will help.
> 
> I've tried this with the following kernels:
> 2.6.29-larch
> 2.6.17-10mdv
> 
> If someone can point me in the right direction I may be able to do any  
> patches required myself, but I need a starting point.
> 
> Thanks in advance,
> Adam Swift
> 

Adam,

starting point here is, that neither of the now older chips like bt878,
saa713x or cx88xx can do two external inputs at the same time on one
chip at once. 

At least saa713x and cx88xx boards can do DVB and analog at once for
external inputs, if not depending on a single hybrid tuner for both,
also DVB and analog TV from tuners.

Else, they totally depend on software switching between those external
inputs.

In short, to have those inputs at once, you need at least two those
chips per board and PCI hardware able to deal with them.

Cheers,
Hermann





