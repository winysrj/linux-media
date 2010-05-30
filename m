Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:1774 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0E3Pw0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 11:52:26 -0400
Message-ID: <4C02826A.6010207@linuxtv.org>
Date: Sun, 30 May 2010 11:21:14 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: VDR User <user.vdr@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: What ever happened to standardizing signal level?
References: <AANLkTinPCgrLPdtFgEDa76RnEG85GSLVJv0G6z56z3P1@mail.gmail.com>	<1275198741.3213.50.camel@pc07.localdom.local>	<AANLkTilIrG5cwlLv_iAI7E7XX5117qh4AHof80pRRYSs@mail.gmail.com> <AANLkTin97BxcUYCUvUt_UiXJUUKdbYNoAqFtqX1rf-EE@mail.gmail.com>
In-Reply-To: <AANLkTin97BxcUYCUvUt_UiXJUUKdbYNoAqFtqX1rf-EE@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Markus Rechberger wrote:
> Hi,
> 
> A little bit more "ontopic", did anyone get around to read the
> signallevel of the tda18721?
> I wonder the register does not return any signallevel as indicated in
> the specifications.
> 
> Markus

There is a "power level" value that can be read from the tda18271 -- I 
had a patch that enabled reading of this value, for testing purposes, 
but it wasn't as useful as I had hoped, so I never bothered to merge it.

If you'd like to play with it, I pushed up some code last year:

http://kernellabs.com/hg/~mkrufky/tda18271-pl/rev/4373874cff29

Let me know how this works for you, or if you choose to change it.  I If 
you find it valuable, we can merge it in somehow.

Regards,

Mike
