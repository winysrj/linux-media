Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:37608 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbZHZCTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 22:19:12 -0400
Message-ID: <50410.76.104.173.166.1251253129.squirrel@www.cyberseth.com>
In-Reply-To: <4A947F89.3010705@kernellabs.com>
References: <283002305-1251239519-cardhu_decombobulator_blackberry.rim.net-845544064-@bxe1079.bisx.prod.on.blackberry>
    <4A946CB5.2010800@kernellabs.com> <4A947260.1040907@kernellabs.com>
    <4A947F89.3010705@kernellabs.com>
Date: Tue, 25 Aug 2009 19:18:49 -0700 (PDT)
Subject: Re: Hauppauge 2250 - second tuner is only half working
From: seth@cyberseth.com
To: "Steven Toth" <stoth@kernellabs.com>
Cc: seth@cyberseth.com, "Steve Harrington" <steve@emel-harrington.net>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well my card is out the door already.  So it'll be a week or so till i can
try again. I'll give it a pretty thorough run down when i get the new
card, maybe I can dig up a repro.

This is probably just a red herring, but FWIW I had never cold booted the
machine (except monday morning when i yanked the card).  I warm booted
plenty, but i frequently would run full us-Cable scan's on both tuners. 
Some time last week when repo's pushed out 2.6.28-15, i had at least one
warm boot in there where i had the modules/firmware missing.  I
reinstalled (dist-clean, make, make install), rebooted, and tried again
and found it was working (well, for a little while until that spontaneous
reboot).

-Seth

> On 8/25/09 7:23 PM, Steven Toth wrote:
>
> I was able to repro the issue once however during patching the issue went
> away,
> never to return - regardless of whether the patch was active or not. I
> even ran
> a series of cold boots to try and repro the behavior but I cannot.
>
> I have seen the issue and I believe it exists, I just cannot get a
> reliable repro.
>
> If you can test tuner 1 on selected frequencies then test tuner 2 always
> against
> channel 103 (669MHz) and find a reliable repro case then I'll take another
> look.
>
> Annoying.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
>
>

