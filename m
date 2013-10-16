Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43496 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761202Ab3JPRXC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:02 -0400
Message-ID: <525ECB70.3000206@iki.fi>
Date: Wed, 16 Oct 2013 20:22:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>,
	Jean Delvare <khali@linux-fr.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH REVIEW] e4000: convert DVB tuner to I2C driver model
References: <1381876264-20342-1-git-send-email-crope@iki.fi>	<20131015203305.7dd5e55a.m.chehab@samsung.com>	<CAOcJUby9LnEUVFm1HFxOE6mJaSPi-2DAyH16zNDvRHACqbOkPw@mail.gmail.com>	<525EC23B.2020506@iki.fi>	<CAOcJUbxEycDwYV56cb3gSPHcbFvXYUnvFe53DhOndEigwdD73Q@mail.gmail.com>	<CAOcJUbxutEoBj56SCESPPyoHPkj3Z=VF-BtWsQdGYpsLGDX1zg@mail.gmail.com>	<20131016190953.7b2070b4@endymion.delvare> <CAOcJUbxz2FT9vohNLoij97awmKgM8wFKx3Pfjom-e4t3ynNkUg@mail.gmail.com>
In-Reply-To: <CAOcJUbxz2FT9vohNLoij97awmKgM8wFKx3Pfjom-e4t3ynNkUg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16.10.2013 20:19, Michael Krufky wrote:
> On Wed, Oct 16, 2013 at 1:09 PM, Jean Delvare <khali@linux-fr.org> wrote:
>> Hi Michael,
>>
>> On Wed, 16 Oct 2013 13:04:42 -0400, Michael Krufky wrote:
>>> YIKES!!  i2c_new_probed_device() does indeed probe the hardware --
>>> this is unacceptable, as such an action can damage the ic.
>>>
>>> Is there some additional information that I'm missing that lets this
>>> perform an attach without probe?
>>
>> Oh, i2c_new_probed_device() probes the device, what a surprise! :D
>>
>> Try, I don't know, i2c_new_device() maybe if you don't want the
>> probe? ;)
>>
>> --
>> Jean Delvare
>
> OK, so to confirm that I follow correctly, one can use
> i2c_new_device() to attach the sub-driver without probing, and the
> line that ensures that the correct sub-driver gets attached is
> "strlcpy(info.type, "e4000", I2C_NAME_SIZE);"  ??
>
> We're matching based on a string?  I think that's kinda yucky, but if
> that's what we're doing in i2c nowadays then I'm OK with it.
>
> If not, what prevents the wrong sub-driver from attaching to a device?
>   ...or conversely, how does the right sub-driver know which device to
> attach to?

Yes, it is that string. Driver has that string as a ID table entry. Then 
you issue i2c_new_device() call with string and it attachs driver when 
strings match.

> Again, if I'm asking "stupid questions" just point me to the documentation.
>
> -Mike
>

regards
Antti

-- 
http://palosaari.fi/
