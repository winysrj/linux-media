Return-path: <linux-media-owner@vger.kernel.org>
Received: from utm.netup.ru ([193.203.36.250]:60287 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1LAHFW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 02:05:22 -0500
Message-ID: <4ED72742.6020608@netup.ru>
Date: Thu, 01 Dec 2011 10:05:38 +0300
From: Abylay Ospan <aospan@netup.ru>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: LinuxTV ported to Windows
References: <4ED65C46.20502@netup.ru> <CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com>
In-Reply-To: <CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Thanks for this idea. Need to investigate.
Currently we've made porting and released the results without any 
license violations in mind ...

On 30.11.2011 20:23, Devin Heitmueller wrote:
> 2011/11/30 Abylay Ospan<aospan@netup.ru>:
>> Hello,
>>
>> We have ported linuxtv's cx23885+CAM en50221+Diseq to Windows OS (Vista, XP,
>> win7 tested). Results available under GPL and can be checkout from git
>> repository:
>> https://github.com/netup/netup-dvb-s2-ci-dual
>>
>> Binary builds (ready to install) available in build directory. Currently
>> NetUP Dual DVB-S2 CI card supported (
>> http://www.netup.tv/en-EN/dual_dvb-s2-ci_card.php ).
>>
>> Driver based on Microsoft BDA standard, but some features (DiSEqC, CI)
>> supported by custom API, for more details see netup_bda_api.h file.
>>
>> Any comments, suggestions are welcome.
>>
>> --
>> Abylai Ospan<aospan@netup.ru>
>> NetUP Inc.
> Am I the only one who thinks this is a legally ambigious grey area?
> Seems like this could be a violation of the GPL as the driver code in
> question links against a proprietary kernel.
>
> I don't want to start a flame war, but I don't see how this is legal.
> And you could definitely question whether it goes against the
> intentions of the original authors to see their GPL driver code being
> used in non-free operating systems.
>
> Devin
>

-- 
Abylai Ospan<aospan@netup.ru>
NetUP Inc.

