Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:41512 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751114AbeEDNiN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 09:38:13 -0400
Subject: Re: [PATCH v2 0/9] cx231xx: House cleaning
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
 <472b7510-05bc-f52d-86e4-98f21362f5aa@xs4all.nl>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <3587c14b-105b-68ad-f999-53ece70bf16a@nextdimension.cc>
Date: Fri, 4 May 2018 08:38:12 -0500
MIME-Version: 1.0
In-Reply-To: <472b7510-05bc-f52d-86e4-98f21362f5aa@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 2018-05-04 01:27, Hans Verkuil wrote:
> Hi Brad,
>
> On 03/05/18 23:20, Brad Love wrote:
>> Included in this patch set is:
>> - Bugfix for a device not working
>> - Some clean up and value corrections
>> - Conversion to new dvb i2c helpers
>> - Update of device from old dvb attach to i2c device
>> - Dependency fixes
>> - Style fixes
>>
>> Changes since v1:
>> - Style fixes in i2c helper patch
>> - Some comment cleanup
>> - Hardware validation of analog tuning
>>
>> Brad Love (9):
>>   cx231xx: Fix several incorrect demod addresses
>>   cx231xx: Use board profile values for addresses
>>   cx231xx: Style fix for struct zero init
>>   cx231xx: [bug] Ignore an i2c mux adapter
>>   cx231xx: Switch to using new dvb i2c helpers
>>   cx231xx: Update 955Q from dvb attach to i2c device
>>   cx231xx: Remove unnecessary parameter clear
>>   cx231xx: Remove RC_CORE dependency
>>   cx231xx: Add I2C_MUX dependency
>>
>>  drivers/media/usb/cx231xx/Kconfig         |   1 -
>>  drivers/media/usb/cx231xx/cx231xx-cards.c |   6 +-
>>  drivers/media/usb/cx231xx/cx231xx-dvb.c   | 365 ++++++++----------------------
>>  3 files changed, 94 insertions(+), 278 deletions(-)
>>
> In case you are ever interested in converting this driver to vb2,
> I made an attempt back in 2015:
>
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=cx231xx
>
> I never got it to work (I think it was mainly the DVB part that
> didn't work, but I'm not certain anymore as it is such a long time
> ago). I ran out of time and haven't continued with it, but it would
> be really nice if someone could finish this vb2 conversion.
>
> Regards,
>
> 	Hans

I'll check this out and add it to my queue.

Cheers,

Brad
