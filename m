Return-path: <mchehab@pedra>
Received: from cinke.fazekas.hu ([195.199.244.225]:38841 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1EVAfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 20:35:12 -0400
Date: Sun, 22 May 2011 02:24:49 +0200 (CEST)
From: Balint Marton <cus@fazekas.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 08/13] [media] rc-winfast: Fix the keycode tables
In-Reply-To: <alpine.LNX.2.00.1105220215030.28057@cinke.fazekas.hu>
Message-ID: <alpine.LNX.2.00.1105220222310.29855@cinke.fazekas.hu>
References: <cover.1295882104.git.mchehab@redhat.com> <20110124131843.7b5c82c7@pedra> <alpine.LNX.2.00.1105220215030.28057@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi,
>
>> One of the remotes has a picture available at:
>> 	http://lirc.sourceforge.net/remotes/leadtek/Y04G0004.jpg
>> 
>> As there's one variant with a set direction keys plus vol/chann
>> keys, and the same table is used for both models, change it to
>> represent all keys, avoiding the usage of weird function keys.
>> 
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> 
>> diff --git a/drivers/media/rc/keymaps/rc-winfast.c 
>> b/drivers/media/rc/keymaps/rc-winfast.c
>> index 2747db4..0062ca2 100644
>> --- a/drivers/media/rc/keymaps/rc-winfast.c
>> +++ b/drivers/media/rc/keymaps/rc-winfast.c
>> @@ -27,15 +27,15 @@ static struct rc_map_table winfast[] = {
>> 	{ 0x0e, KEY_8 },
>> 	{ 0x0f, KEY_9 },
>> 
>> -	{ 0x00, KEY_POWER },
>> +	{ 0x00, KEY_POWER2 },
>> 	{ 0x1b, KEY_AUDIO },		/* Audio Source */
>> 	{ 0x02, KEY_TUNER },		/* TV/FM, not on Y0400052 */
>> 	{ 0x1e, KEY_VIDEO },		/* Video Source */
>> 	{ 0x16, KEY_INFO },		/* Display information */
>> -	{ 0x04, KEY_VOLUMEUP },
>> -	{ 0x08, KEY_VOLUMEDOWN },
>> -	{ 0x0c, KEY_CHANNELUP },
>> -	{ 0x10, KEY_CHANNELDOWN },
>> +	{ 0x04, KEY_LEFT },
>> +	{ 0x08, KEY_RIGHT },
>> +	{ 0x0c, KEY_UP },
>> +	{ 0x10, KEY_DOWN },
>
> Left and right key is now swapped on my remote. (Which is exactly the same 
> model by the way that was shown in Y04G0004.jpg.) Could you please swap the 
> two keys?
>
> Regards,
>  Marton
>

Sorry, just saw the fix commited to linux-next :)

Regards,
   Marton
