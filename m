Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2e.orange.fr ([80.12.242.112]:41647 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956AbZKRJzj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:55:39 -0500
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2e11.orange.fr (SMTP Server) with ESMTP id E22948000196
	for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 10:55:43 +0100 (CET)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2e11.orange.fr (SMTP Server) with ESMTP id D6DBF80001B7
	for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 10:55:43 +0100 (CET)
Received: from [192.168.1.11] (ANantes-551-1-61-38.w92-135.abo.wanadoo.fr [92.135.188.38])
	by mwinf2e11.orange.fr (SMTP Server) with ESMTP id 486368000196
	for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 10:55:43 +0100 (CET)
Message-ID: <4B03C4A5.70006@gmail.com>
Date: Wed, 18 Nov 2009 10:55:49 +0100
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support, giving
 up.
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com> <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com> <op.uzzfgyvj3xmt7q@crni> <4AA77240.2040504@gmail.com> <4AA77683.7010201@gmail.com> <4AA7C266.3000509@gmail.com> <op.uzzz96se6dn9rq@crni> <4AA7E166.7030906@gmail.com> <4AA81785.5000806@gmail.com> <4AA8BB20.4040701@gmail.com> <4AA919CA.20701@gmail.com> <4AAA0247.8020004@gmail.com>
In-Reply-To: <4AAA0247.8020004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
just a little update ( even if nobody seems to be interested :p ) :
I've been using this configuration for a while, and because i tend to 
forget to reinstall that patch for each kernel update, i found out some 
strange things.
First, very rarely ( it must have happened three times at most until now 
), the remotes keys tends to be misidentified as keyboards keys 
shortcuts : "volume up" seems to like to be identified as "search files" 
in Gnome.
Second, the stability of the whole OS seems to suffer from my hack.I'm 
not very certain about that since my computer have a tendency to hangs 
when playing a video with the proprietary Nvidia driver and flash 
loaded, but my computer tend to shut down all on its own ( like pressing 
the power button for more than 3 secs ) only when i enable the remote 
support. It take a while ( maybe a day or two ), and i've see it happen 
only once ( but it happened at least one other time while i was away 
from the computer, it could have been a power grid failure )

> Since i don't know where to look, i finally decided to use a basic 
> incorrect keymap :
> /* ADS Tech Instant TV PCI Remote */
> static struct ir_scancode ir_codes_adstech_pci[] = {
>    /* too many repeating codes : incorrect gpio ?. */
>       
>    { 0x1f, KEY_MUTE },
>    { 0x1d, KEY_SEARCH },
>    { 0x17, KEY_EPG },        /* Guide */
>    { 0x0f, KEY_UP },
>    { 0x6, KEY_DOWN },
>    { 0x16, KEY_LEFT },
>    { 0x1e, KEY_RIGHT },
>    { 0x0e, KEY_SELECT },        /* Enter */
>    { 0x1a, KEY_INFO },
>    { 0x12, KEY_EXIT },
>    { 0x19, KEY_PREVIOUS },
>    { 0x11, KEY_NEXT },
>    { 0x18, KEY_REWIND },
>    { 0x10, KEY_FORWARD },
>    { 0x4, KEY_PLAYPAUSE },
>    { 0x07, KEY_STOP },
>    { 0x1b, KEY_RECORD },
>    { 0x13, KEY_TUNER },        /* Live */
>    { 0x0a, KEY_A },
>    { 0x03, KEY_PROG1 },        /* 1 */
>    { 0x01, KEY_PROG2 },        /* 2 */
>    { 0x0, KEY_VIDEO },
>    { 0x0b, KEY_CHANNELUP },
>    { 0x08, KEY_CHANNELDOWN },
>    { 0x15, KEY_VOLUMEUP },
>    { 0x1c, KEY_VOLUMEDOWN },
> };
> 
> struct ir_scancode_table ir_codes_adstech_pci_table = {
>    .scan = ir_codes_adstech_pci,
>    .size = ARRAY_SIZE(ir_codes_adstech_pci),
> };
> EXPORT_SYMBOL_GPL(ir_codes_adstech_pci_table);
> 
> No numbers in favor of arrows and ch+/- Vol+/- . Well 246 will be arrows 
> and  5 select, 7 and 8 are undefined, 9 become vol-, 1 epg and 3 is tuner.
> If someone, one day, wants to find that missig bit, i'll be happy to 
> help. ( Strange anyway : it's as if there was a 0x7f mask even when i 
> specify a 0xff one )
> Feel free to write a patch.
> 
> Morvan Le Meut a écrit :
>> um .. help, please ?
>> how can i make the driver read 1011011 instead of 011011 when i press 
>> Power instead of record on the remote ?
>>
>> thanks
>>
>>
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>





