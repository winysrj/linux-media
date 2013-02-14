Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:51096 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759993Ab3BNSFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 13:05:53 -0500
Received: by mail-ve0-f171.google.com with SMTP id b10so2386355vea.2
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2013 10:05:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511D085A.80009@iki.fi>
References: <511CE2BF.8020905@tvdr.de>
	<511D085A.80009@iki.fi>
Date: Thu, 14 Feb 2013 23:35:48 +0530
Message-ID: <CAHFNz9JN_z5xa0eyaacdOKSdTJoOqAW87+jeLW+3AnARDVX41g@mail.gmail.com>
Subject: Re: DVB: EOPNOTSUPP vs. ENOTTY in ioctl(FE_READ_UNCORRECTED_BLOCKS)
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 14, 2013 at 9:22 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 02/14/2013 03:12 PM, Klaus Schmidinger wrote:
>>
>> In VDR I use an ioctl() call with FE_READ_UNCORRECTED_BLOCKS on a device
>> (using stb0899).
>> After this call I check 'errno' for EOPNOTSUPP to determine whether this
>> device supports this call. This used to work just fine, until a few months
>> ago I noticed that my devices using stb0899 didn't display their signal
>> quality in VDR's OSD any more. After further investigation I found that
>> ioctl(FE_READ_UNCORRECTED_BLOCKS) no longer returns EOPNOTSUPP, but rather
>> ENOTTY. And since I stop getting the signal quality in case any unknown
>> errno value appears, this broke my signal quality query function.
>>
>> Is there a reason why this has been changed?
>
>
> I changed it in order to harmonize error codes. ENOTTY is correct error code
> for the case IOCTL is not implemented. What I think it is Kernel wide
> practice.
>

By doing so, You BROKE User Space ABI. Whatever it is, we are not allowed to
break User ABI. https://lkml.org/lkml/2012/12/23/75

>
>> Should a caller check against both EOPNOTSUPP *and* ENOTTY?
>
>
> Current situation is a big mess. All the drivers are returning what error
> codes they wish. You simply cannot trust any error code.


As you stated above, If a device doesn't have an IOCTL implemented, it
was returning EOPNOTSUPP for *any* driver that doesn't implement that
IOCTL. By changing it to ENOTTY, you broke existing applications.

How can a driver return an error code, for an IOCTL that is *not* implemented ?
AFAICS, your statement is bogus. :-)


Regards,
Manu
