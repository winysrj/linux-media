Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:42831 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab1CWIlh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 04:41:37 -0400
Message-ID: <4D89B23B.7000803@iki.fi>
Date: Wed, 23 Mar 2011 10:41:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Malcolm Priestley <tvboxspy@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] v180 - DM04/QQBOX added support for BS2F7HZ0194 versions
References: <1297560908.24985.5.camel@tvboxspy>	 <4D87EAA7.2040803@redhat.com> <1300753968.15997.4.camel@localhost>	 <4D87F0CB.2090705@iki.fi> <1300831959.2048.25.camel@localhost> <4D892A0D.9090505@redhat.com>
In-Reply-To: <4D892A0D.9090505@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/23/2011 01:00 AM, Mauro Carvalho Chehab wrote:
> Em 22-03-2011 19:12, Malcolm Priestley escreveu:
>> On Tue, 2011-03-22 at 02:43 +0200, Antti Palosaari wrote:

>>> Anyhow, my opinion is still that we *should* make all NEC remotes as 32
>>> bit and leave handling of NEC 16, NEC 24, NEC 32 to NEC decoder. For
>>> example AF9015 current NEC handling is too complex for that reason... I
>>> don't like how it is implemented currently.
>>
>> One of the reasons for using 32 bit was interference from other consumer
>> remotes.  It appears, these near identical bubble remotes originate from
>> a Chinese factory and supplied with the same product with completely
>> different key mapping.
>>
>> I am not sure how many of these remotes are common to other devices.
>
> Drivers should get the 32 bit codes form NEC when hardware provides it.
> What we currently do is to identify if the code has 16, 24 or 32 bits,
> but it is probably better to always handle them as if they have 32 bits.

That's how af9015 driver handles it currently.

if (buf[14] == (u8) ~buf[15]) {
     if (buf[12] == (u8) ~buf[13]) {
         /* 16 bit NEC standard */
         priv->rc_keycode = buf[12] << 8 | buf[14];
     } else {
         /* 24 bit NEC extended*/
         priv->rc_keycode = buf[12] << 16 | buf[13] << 8 | buf[14];
     }
} else {
     /* 32 bit NEC full scancode */
     priv->rc_keycode = buf[12] << 24 | buf[13] << 16 | buf[14] << 8 | 
buf[15];
}

I think there is no any better currently.

Antti
-- 
http://palosaari.fi/
