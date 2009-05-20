Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:33317 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZETPLN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 11:11:13 -0400
Date: Wed, 20 May 2009 17:11:03 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
cc: linux-media@vger.kernel.org
Subject: Re: RE : RE : Hauppauge Nova-TD-500 vs. T-500
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAALN4GP6siTEuuMjrEDdv4uQEAAAAA@tv-numeric.com>
Message-ID: <alpine.LRH.1.10.0905201658030.15868@pub4.ifh.de>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAALN4GP6siTEuuMjrEDdv4uQEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 May 2009, Thierry Lelegard wrote:
>> When you tune both frontends at the same time, please try to not tune the
>> same frequency.
>
> I don't. In my tests, I use only one frontend.
>
> In production, it could be possible that two frontends on the same TD-500
> tune the same frequency for some period of time. What is the problem with that ?

If two oscillators are oscillating at the same frequency, they are 
interfering each other. Results for devices like yours are a variation of 
the SNR of 10dB (rare, but I have seen it in our labs).

Solution is simple: frontends are always tuned with a small frequency 
offset (like 100kHz) . Usually (for DiBcom demods at least) it is no 
problem to recover such an offset.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
