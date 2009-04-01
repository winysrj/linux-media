Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:41353 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZDACrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 22:47:06 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2750123ywb.1
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 19:47:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <15ed362e0903311934h6e6bbbc5q70971ee4c0dfaaa8@mail.gmail.com>
References: <15ed362e0903301947rf0de73eo8edbd8cbcd5b5abd@mail.gmail.com>
	 <412bdbff0903301957i77c36f10hcb9e9cb919124057@mail.gmail.com>
	 <15ed362e0903302039g6d9575cnca5d9b62b566db72@mail.gmail.com>
	 <49D228EA.3090302@linuxtv.org>
	 <412bdbff0903310734r3002e083j9c7f83bfc9855c7d@mail.gmail.com>
	 <15ed362e0903311838w19c03f37ob9e893d35ea5cd92@mail.gmail.com>
	 <412bdbff0903311844ye3323fbh1cc633cea4216149@mail.gmail.com>
	 <15ed362e0903311934h6e6bbbc5q70971ee4c0dfaaa8@mail.gmail.com>
Date: Tue, 31 Mar 2009 22:47:03 -0400
Message-ID: <412bdbff0903311947vae9541bj765bb62c6f68cf0e@mail.gmail.com>
Subject: Re: XC5000 DVB-T/DMB-TH support
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: David Wong <davidtlwong@gmail.com>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 31, 2009 at 10:34 PM, David Wong <davidtlwong@gmail.com> wrote:
> On Wed, Apr 1, 2009 at 9:44 AM, Devin Heitmueller
> <devin.heitmueller@gmail.com> wrote:
>> On Tue, Mar 31, 2009 at 9:38 PM, David Wong <davidtlwong@gmail.com> wrote:
>>> Thanks Devin. The demod locks after using -2750000.
>>>
>>> David.
>>
>> That's great news.  If you send me a patch (including your SOB), I
>> will put it into the xc5000 patch series I am putting together this
>> week.
>>
>> Regards,
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>>
>
> No problem. But how about frequency compensation value for DTV7?
> We know DTV6 and DTV8 settings now, just DTV7 is missing for FE_OFDM.

DTV7 is probably also 2750000.  Also, looking at the tuner-xc2028.c
suggests there are some edge cases where it might need to be 2250000.

However, if you are unable to test it, do not include it in the patch.
 I would rather have it not supported explicitly in the driver than
include untested code.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
