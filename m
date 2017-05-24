Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40310 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763985AbdEXIzm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 04:55:42 -0400
Subject: Re: [PATCH 1/3] [media] si2157: get chip id during probing
To: Andreas Kemnade <andreas@kemnade.info>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
 <1489616530-4025-2-git-send-email-andreas@kemnade.info>
 <43216679-3794-14ca-b489-00ac97a57777@iki.fi> <20170515222837.3d822338@aktux>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <e20f0625-98c9-7778-4723-ebff59195593@iki.fi>
Date: Wed, 24 May 2017 11:55:39 +0300
MIME-Version: 1.0
In-Reply-To: <20170515222837.3d822338@aktux>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/2017 11:28 PM, Andreas Kemnade wrote:
> Hi,
> 
> On Sun, 23 Apr 2017 15:19:21 +0300
> Antti Palosaari <crope@iki.fi> wrote:
> 
>> On 03/16/2017 12:22 AM, Andreas Kemnade wrote:
>>> If the si2157 is behind a e.g. si2168, the si2157 will
>>> at least in some situations not be readable after the si268
>>> got the command 0101. It still accepts commands but the answer
>>> is just ffffff. So read the chip id before that so the
>>> information is not lost.
>>>
>>> The following line in kernel output is a symptome
>>> of that problem:
>>> si2157 7-0063: unknown chip version Si21255-\xffffffff\xffffffff\xffffffff
>> That is hackish solution :( Somehow I2C reads should be get working
>> rather than making this kind of work-around. Returning 0xff to i2c reads
>> means that signal strength also shows some wrong static value?
>>
> Also this is needed for the Terratec CinergyTC2.
> I see the ff even on windows. So it cannot be solved by usb-sniffing of
> a working system, so, again how should we proceed?
> 
> a) not support dvb sticks which do not work with your preferred
>     order of initialization.
> 
> b) change order of initialisation (maybe optionally add a flag like
>     INIT_TUNER_BEFORE_DEMOD to avoid risk of breaking other things)
> 
> c) something like the current patch.
> 
> d) while(!i2c_readable(tuner)) {
>       write_random_data_to_demod();
>       write_random_data_it9306_bridge();
>     }
>     remember_random_data();
> 
> 
> There was not much feedback here.

If it is not possible to fix i2c communication then better to add some 
device specific logic to i2c adapter in order to meet demod/tuner 
requirements.


> 
> An excerpt from my windows sniff logs:
> ep: 02 l:   15 GEN_I2C_WR 00 0603c6120100000000
> ep: 02 l:    0
> ep: 81 l:    0
> ep: 81 l:    5 042300dcff
> ep: 02 l:    9 GEN_I2C_RD 00 0603c6
> ep: 02 l:    0
> ep: 81 l:    0
> ep: 81 l:   11 0a240080ffffffffff5b02
> ep: 02 l:   15 GEN_I2C_WR 00 0603c6140011070300
> ep: 02 l:    0
> ep: 81 l:    0
> ep: 81 l:    5 042500daff
> ep: 02 l:    9 GEN_I2C_RD 00 0403c6
> ep: 02 l:    0
> ep: 81 l:    0
> ep: 81 l:    9 08260080ffffff5901
> 
> here you see all the ffff from the device.
> 
> 
> 
> Regards,
> Andreas
> 

regards
Antti



-- 
http://palosaari.fi/
