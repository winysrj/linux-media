Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56030 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934021AbbBDUKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 15:10:15 -0500
Received: by mail-wi0-f171.google.com with SMTP id l15so34369377wiw.4
        for <linux-media@vger.kernel.org>; Wed, 04 Feb 2015 12:10:14 -0800 (PST)
Message-ID: <54D27CA4.20009@gmail.com>
Date: Wed, 04 Feb 2015 21:10:12 +0100
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	dCrypt <dcrypt@telefonica.net>
CC: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [possible BUG, cx23885] Dual tuner TV card, works using one tuner
 only, doesn't work if both tuners are used
References: <54472CB702988260@smtp.movistar.es>	<02ee01d031ec$283a80f0$78af82d0$@net>	<006301d03b58$0181a9a0$0484fce0$@net>	<006e01d03fe7$4cf3dd70$e6db9850$@net> <CALzAhNVjZh7nm5_3hGpSh4ZMsstja+M_2GLh2-15F0yp8QDOVw@mail.gmail.com> <54D1D01B.30201@xs4all.nl> <54D23766.3050402@iki.fi>
In-Reply-To: <54D23766.3050402@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested with a couple of DVBSky T982 adapters against latest media 
master. No problems detected.
Moreover: even with earlier versions of the media tree (starting with 
the version in witch support for DVBSky t982 was added), I never 
encountered any problems.

Regards,
Tycho.

Op 04-02-15 om 16:14 schreef Antti Palosaari:
> On 02/04/2015 09:54 AM, Hans Verkuil wrote:
>> On 02/03/2015 08:32 PM, Steven Toth wrote:
>>> While I am the maintainer of the cx23885 driver, its currently
>>> undergoing a significant amount of churn related to Han's recent VB2
>>> and other changes. I consider the current driver broken until the
>>> feedback on the mailing list dies down. I'm reluctant to work on the
>>> driver while its considered unstable.
>>
>> Any issues in the driver are all related to streaming. Tuning has not
>> been touched at all and there is some anecdotal evidence that if there
>> are tuning issues they were there already before the vb2 conversion.
>>
>> To my knowledge the driver is now stable. There is still the occasional
>> kernel message that shouldn't be there which I am trying to track down,
>> but the driver crashes due to a vb2 race condition have been fixed.
>
> Tested with Hauppauge WinTV-HVR5525 against latest media master and 
> seems to work now. Earlier there was 2 problems:
> 1) lockdep splash
> 2) hangs when both adapters were streaming
>
> regards
> Antti
>

