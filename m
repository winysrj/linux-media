Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41316 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab2BHNyU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Feb 2012 08:54:20 -0500
Message-ID: <4F327E8A.6010800@iki.fi>
Date: Wed, 08 Feb 2012 15:54:18 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] IT913X Version 1 and Version 2 keymaps
References: <1328135384.2552.20.camel@tvbox> <4F2FCAAD.3070706@iki.fi> <1328548004.2331.15.camel@tvbox>
In-Reply-To: <1328548004.2331.15.camel@tvbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.02.2012 19:06, Malcolm Priestley wrote:
> On Mon, 2012-02-06 at 14:42 +0200, Antti Palosaari wrote:
>> On 02/02/2012 12:29 AM, Malcolm Priestley wrote:
>>> IT913X V1 V2 keymaps
>>> +static struct rc_map_table it913x_v1_rc[] = {
>>> +	/* Type 1 */

>>
>> That remote is already there. Use existing remote instead of adding new
>> one with different name. It is RC_MAP_MSI_DIGIVOX_III
>>
> The driver originally used this map.
>
> RC_MAP_MSI_DIGIVOX_III and RC_MAP_KWORLD_315U also are the same map.

Yes it is. As you likely saw from the comments I have added:
/* This remote seems to be same as rc-kworld-315u.c. Anyhow, add new 
remote since rc-kworld-315u.c lacks NEC extended address byte. */

The reason I was forced to add new keymap instead of fixing 
RC_MAP_KWORLD_315U was simple I didn't have em28xx device to test and 
fix it at that time. So I added new correct keymap. Fix should be done 
for em28xx driver to handle 24bit NEC extended.


>>> +	/* Type 2 - 20 buttons */
>>> +	{ 0x807f0d, KEY_0 },
>>> +	{ 0x807f0e, KEY_STOP },
>>
>> That is NEC basic - 16 bit, not 24 bit. That remote seems to be here
>> also. It is RC_MAP_TERRATEC_SLIM_2. Use existing instead of define new.
>>
>
> All ITE NEC remotes are 32bit with 0xff00 mask. However, they are
> modified to 24 bit or 16 bit.

That is wrong assumption. NEC sends always physically 32bit. Original 
NEC is is still 16bit long as payload. Other 16bit are reduntant and are 
used for checksum. If you XOR byte0 and byte1 you got 0xff. Same applies 
for byte2 and byte3.
Using 0xff00 you give as example => 0xff XOR 0x00 = 0xFF.
And for remote in question, 0x80 XOR 7f = 0xFF.

> The both maps need to merged because they share the same product ID.

Yes, thats tricky part. I still don't see idea to put all possible 
remotes to one file. If you look AF9015 driver you can see same problem. 
And maybe many others too. That was one reason for RC-core too. The idea 
was to upload keytable from the userspace in that case.

>>> +static struct rc_map_table it913x_v2_rc[] = {
>>> +	/* Type 1 */
>>> +	/* 9005 remote */
>>> +	{ 0x807f12, KEY_POWER2 },	/* Power (RED POWER BUTTON)*/
>>
>> That is also 16 bit NEC basic.
>>
> This is a different map.
>
> All the maps will soon need to be 32bit, HID type interfaces need the
> 32bit map uploaded.

It does not matter what HID wants. As those are simply checksums you can 
calculate those easily in the driver. See af9015 for example. And some 
other drivers too, IIRC DiBcom at least.

IMHO all NEC should be defined as full 32 bit code. I asked that many 
times when RC-core was introduced and I was converting af9015 to 
RC-core. But it is now differently, only payload bytes are defined to 
the keytable and checksum bytes left out. That was spoken many times on 
the mailing list. Try to search some discussion, af9015 + rc-core is 
good starting point.

regards
Antti
-- 
http://palosaari.fi/
