Return-path: <linux-media-owner@vger.kernel.org>
Received: from utm.netup.ru ([193.203.36.250]:60286 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1LAHFO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 02:05:14 -0500
Message-ID: <4ED72739.7090508@netup.ru>
Date: Thu, 01 Dec 2011 10:05:29 +0300
From: Abylay Ospan <aospan@netup.ru>
MIME-Version: 1.0
To: Walter Van Eetvelt <walter@van.eetvelt.be>
CC: linux-media@vger.kernel.org
Subject: Re: LinuxTV ported to Windows
References: <4ED65C46.20502@netup.ru> <912e38aa28e2ea4d2723d65c93135397@mail.eetvelt.be>
In-Reply-To: <912e38aa28e2ea4d2723d65c93135397@mail.eetvelt.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Walter,

On 30.11.2011 21:46, Walter Van Eetvelt wrote:
> Nice!
>
> How is the CI implementation?
it's ok. Working fine under windows including MMI.
Professional CAM's (with multi-PID descramble) are tested.

> Can both CI's be used by both tuners?  Or
> is one CI bound to one tuner?
First CI slot assigned to first tuner/demod and second CI slot assigned 
for second tuner/demod by hardware.
You can't share CI slots between tuners.

>
> Walter
>
> On Wed, 30 Nov 2011 19:39:34 +0300, Abylay Ospan<aospan@netup.ru>  wrote:
>> Hello,
>>
>> We have ported linuxtv's cx23885+CAM en50221+Diseq to Windows OS (Vista,
>> XP, win7 tested). Results available under GPL and can be checkout from
>> git repository:
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

-- 
Abylai Ospan<aospan@netup.ru>
NetUP Inc.

