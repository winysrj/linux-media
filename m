Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51214 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab0AXXwt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 18:52:49 -0500
Message-ID: <4B5CDD4A.5060800@iki.fi>
Date: Mon, 25 Jan 2010 01:52:42 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] media: dvb/af9015, implement eeprom hashing
References: <4B4F6BE5.2040102@iki.fi> <1264173055-14787-1-git-send-email-jslaby@suse.cz> <4B5C7258.1010605@iki.fi> <4B5C76B8.4090700@gmail.com>
In-Reply-To: <4B5C76B8.4090700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/24/2010 06:35 PM, Jiri Slaby wrote:
> On 01/24/2010 05:16 PM, Antti Palosaari wrote:
>>> +    af9015_config.eeprom_sum = 0;
>>> +    for (reg = 0; reg<   eeprom_size / sizeof(u32); reg++) {
>>> +        af9015_config.eeprom_sum *= GOLDEN_RATIO_PRIME_32;
>>> +        af9015_config.eeprom_sum += le32_to_cpu(((u32 *)eeprom)[reg]);
>>> +    }
>>> +
>>> +    deb_info("%s: eeprom sum=%.8x\n", __func__,
>>> af9015_config.eeprom_sum);
>>
>> Does this sum contain all 256 bytes from EEPROM? 256/4 is 64.
>
> Yes it does. It is computed as a hashed sum of 32-bit numbers (4 bytes)
> -- speed (does not matter) and larger space of hashes. Hence the
> division by 4. The cast does the trick: ((u32 *)eeprom)[reg] -- reg
> index is on a 4-byte basis.


OK, true. Anyhow, I don't know if this hashing formula is good enough - 
changing it later could be really pain. I compared it to the one used 
for em28xx driver and it was different. Could someone with better 
knowledge check that?

Generally it is good and ready for submission.

Acked-by: Antti Palosaari <crope@iki.fi>

regards
Antti
-- 
http://palosaari.fi/
