Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZIWOgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 10:36:31 -0400
Message-ID: <4ABA3274.4020407@tripleplay-services.com>
Date: Wed, 23 Sep 2009 15:36:36 +0100
From: Lou Otway <louis.otway@tripleplay-services.com>
MIME-Version: 1.0
To: Manu <eallaud@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: Symbol rate limit for TT 3200
References: <1236276271.7491.1@manu-laptop>
In-Reply-To: <1236276271.7491.1@manu-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu wrote:
> 	Hi all,
> I have been struggling for quite a while to lock on a DVB-S2 
> transponder. And recently I got some information that they changed the 
> symbol rate to 45MS/s which looks borderline to me. Can someone confirm 
> that the TT 3200 can do that?
> I also attach a log that I obtained when trying to lock on this 
> transponder with the following parameters:
> QPSK, FEC= 5/6, 45MS/s
> The driver I used was Igor's (very recent) one with szap-s2. The status 
> oscillates between 00 and 0b, it can take long to attain 0b which 
> suggests long and unreliable lock (never got VITERBI, just demod lock
> +sync).
> Thx for any help
> Bye
> Emmanuel
> --
>   
I've been having a similar problem and have tried using the patch from 
Igor Liplianin.

http://marc.info/?l=linux-dvb&m=122730082915638&w=2

Unfortunately this patch didn't work for my device until I reduced 
hi_clk to 110MHz.

I'm concious that Manu Abraham (to avoid confusion with the OP, also 
called Manu) doesn't recommend a frequency higher than 99MHz.

Is this a device limitation? What are the chances of damaging the device 
by setting a clock frequency higher than 99MHz?

Many thanks,

Lou

