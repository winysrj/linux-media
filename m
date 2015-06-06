Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34413 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbbFFHlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2015 03:41:35 -0400
Received: by igbhj9 with SMTP id hj9so30333806igb.1
        for <linux-media@vger.kernel.org>; Sat, 06 Jun 2015 00:41:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5571AFBE.8050509@iki.fi>
References: <CALzAhNW=Oei7_Nziozh3Mm+X_NNHvM5EdmPVPh9ajn5Aen9O2g@mail.gmail.com>
	<557048EF.3040703@iki.fi>
	<CAAZRmGw7NcDo8YJtYN5gC6DM23jtgqmGhhJUAa6VaEovX+qNdA@mail.gmail.com>
	<CAAZRmGy_AwJfGzfDorx_=43xNQ3cB915GFnck-YJ0gu0W64xKw@mail.gmail.com>
	<CALzAhNXWsv6O23yzRAx9L6TrKRvm9o7SdApsHjMgE3dpqUYpWA@mail.gmail.com>
	<CAAZRmGxtzq1qX=JKusF_A+_0od8sY8LO_kN-6ZWge2E7GMoweA@mail.gmail.com>
	<5571AFBE.8050509@iki.fi>
Date: Sat, 6 Jun 2015 09:41:34 +0200
Message-ID: <CAAZRmGyWXYUdEubcybwCM2Me4pBai6=M-2_iZv9bxPtAvu+AhQ@mail.gmail.com>
Subject: Re: [PATCH][media] SI2168: Resolve unknown chip version errors with
 different HVR22x5 models
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Indeed, the HVR-2205 I have works fine with that patch reverted and
after setting REGLEN_0bit for the Si2168 chips in the saa7164-cards.

The chip detection and firmware load is correct now.

[ 2046.684246] si2168 2-0064: found a 'Silicon Labs Si2168-B40'
[ 2046.684278] si2168 2-0064: downloading firmware from file
'dvb-demod-si2168-b40-01.fw'
[ 2049.242810] si2168 2-0064: firmware version: 4.0.11
[ 2049.261896] si2157 0-0060: found a 'Silicon Labs Si2157-A30'
[ 2049.294328] si2157 0-0060: firmware version: 3.0.5

I'll send the patches on to linux-media so Steven can evaluate the
impact on other boards, if any.

Cheers,
-olli


On 5 June 2015 at 16:18, Antti Palosaari <crope@iki.fi> wrote:
> On 06/05/2015 04:40 PM, Olli Salonen wrote:
>>
>> Hi Steven,
>>
>> It seems to me that that part of the code is identical to your driver, no?
>>
>> The media_tree driver:
>>
>> retval = saa7164_api_i2c_read(bus,
>>                       msgs[i].addr,
>>                       0 /* reglen */,
>>                       NULL /* reg */, msgs[i].len, msgs[i].buf);
>>
>> It's exactly the same with a little bit different formatting.
>
>
> And that looks correct.
>
> But the patch which does not look correct, or is at least unclear, is that
> [media] saa7164: Improvements for I2C handling
> http://permalink.gmane.org/gmane.comp.video.linuxtv.scm/22211
>
> First change does not have any effect as len should be zero in any case and
> memcpy() should do nothing.
>
> Second change looks something that is likely wrong. There is some hack which
> increases data len. All that register len stuff is logically wrong - I2C
> adapter handles just bytes and should not know nothing about client register
> layout. OK, there is some exceptions (like af9035) where I2C firmware
> actually knows register layout for some strange reason.
>
> So could you remove that patch and test?
>
> Antti
>
> --
> http://palosaari.fi/
