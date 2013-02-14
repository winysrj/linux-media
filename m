Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45842 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474Ab3BNTQ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 14:16:56 -0500
Message-ID: <511D37FF.9070206@iki.fi>
Date: Thu, 14 Feb 2013 21:16:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>,
	linux-media@vger.kernel.org
Subject: Re: DVB: EOPNOTSUPP vs. ENOTTY in ioctl(FE_READ_UNCORRECTED_BLOCKS)
References: <511CE2BF.8020905@tvdr.de> <511D085A.80009@iki.fi> <CAHFNz9JN_z5xa0eyaacdOKSdTJoOqAW87+jeLW+3AnARDVX41g@mail.gmail.com>
In-Reply-To: <CAHFNz9JN_z5xa0eyaacdOKSdTJoOqAW87+jeLW+3AnARDVX41g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2013 08:05 PM, Manu Abraham wrote:
> On Thu, Feb 14, 2013 at 9:22 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 02/14/2013 03:12 PM, Klaus Schmidinger wrote:
>>>
>>> In VDR I use an ioctl() call with FE_READ_UNCORRECTED_BLOCKS on a device
>>> (using stb0899).
>>> After this call I check 'errno' for EOPNOTSUPP to determine whether this
>>> device supports this call. This used to work just fine, until a few months
>>> ago I noticed that my devices using stb0899 didn't display their signal
>>> quality in VDR's OSD any more. After further investigation I found that
>>> ioctl(FE_READ_UNCORRECTED_BLOCKS) no longer returns EOPNOTSUPP, but rather
>>> ENOTTY. And since I stop getting the signal quality in case any unknown
>>> errno value appears, this broke my signal quality query function.
>>>
>>> Is there a reason why this has been changed?
>>
>>
>> I changed it in order to harmonize error codes. ENOTTY is correct error code
>> for the case IOCTL is not implemented. What I think it is Kernel wide
>> practice.
>>
>
> By doing so, You BROKE User Space ABI. Whatever it is, we are not allowed to
> break User ABI. https://lkml.org/lkml/2012/12/23/75

Yes, it will change API, that's clear. But the hell, how you will get 
anything fixed unless you change it? Introduce totally new API 
every-time when bug is found? You should also understand that changing 
that single error code on that place will not change all the drivers and 
there will be still some other error statuses returned by individual 
drivers.

It is about 100% clear that ENOTTY is proper error code for 
unimplemented IOCTL. I remember maybe more than one discussion about 
that unimplemented IOCTL error code. It seems to be defined by POSIX [1] 
standard.

If you do some searching you will easily find out a lot of discussions:
[1] http://www.makelinux.net/ldd3/chp-6-sect-1
[2] http://www.mail-archive.com/ltp-list@lists.sourceforge.net/msg14981.html
[3] http://linux.about.com/library/cmd/blcmdl2_ioctl.htm

>>> Should a caller check against both EOPNOTSUPP *and* ENOTTY?
>>
>>
>> Current situation is a big mess. All the drivers are returning what error
>> codes they wish. You simply cannot trust any error code.
>
>
> As you stated above, If a device doesn't have an IOCTL implemented, it
> was returning EOPNOTSUPP for *any* driver that doesn't implement that
> IOCTL. By changing it to ENOTTY, you broke existing applications.

There is a lot of drivers implementing stub callbacks and returning own 
values. Likely much more than those which does not implement it at all.

> How can a driver return an error code, for an IOCTL that is *not* implemented ?
> AFAICS, your statement is bogus. :-)

Just implementing IOCTL and returning some value! Have you looked those 
drivers?) There is very many different errors returned, especially in 
cases where hardware is not able to provide asked value at the time, 
example sleeping.

Maybe the most common status is just to return 0 as status and some 
random numbers as data - but there has been some discussion it is bad 
idea too.

It is just easy to fix back these few cases by implementing missing 
callbacks and return EOPNOTSUPP. But it will not "fix" all the drivers, 
only those which were totally without a callback.

And I ran RFC before started harmonizing error codes. There was not too 
many people commenting how to standardize these error codes....


regards
Antti
-- 
http://palosaari.fi/
