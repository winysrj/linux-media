Return-path: <linux-media-owner@vger.kernel.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]:43576 "EHLO
	shogun.pilppa.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754615AbZCXXiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 19:38:55 -0400
Date: Wed, 25 Mar 2009 01:28:38 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: Manu Abraham <abraham.manu@gmail.com>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
 and BER from HVR 4000 Lite
In-Reply-To: <49C96A37.4020905@gmail.com>
Message-ID: <Pine.LNX.4.64.0903250128110.11676@shogun.pilppa.org>
References: <49B9BC93.8060906@nav6.org>  <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
  <20090319101601.2eba0397@pedra.chehab.org>  <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
  <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>
 <1237689919.3298.179.camel@palomino.walls.org>
 <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com>
 <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>
 <49C96A37.4020905@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> That said, the solution takes the approach of "revolutionary" as
>>> opposed to "evolutionary", which always worries me.  While providing a
>>> much more powerful interface, it also means all of the applications
>>> will have to properly support all of the various possible
>>> representations of the data, increasing the responsibility in userland
>>> considerably.
>
> Not necessarily, the application can simply chose to support what
> the driver provides as is, thereby doing no translations at all.

>From the end user point of view it is not very usefull if he has 2 
different cards and application can not show any usefull signal goodness 
info in a way that would be easy to compare. So I think the attempt to 
standardize to db is good.

Maybe there could then in addition be some other optional method for also 
getting data in some hw specific format in a way that Manu suggested.
But there should anyway be mandatory to have this one "standard goodness 
value" in a way that does not require apps to make any complicate 
comparisons... (I bet half of those apps would be broken for years)

Mika
