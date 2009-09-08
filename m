Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2f.orange.fr ([80.12.242.151]:50855 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbZIHQSG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2009 12:18:06 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2f14.orange.fr (SMTP Server) with ESMTP id E874080000A2
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 18:18:06 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2f14.orange.fr (SMTP Server) with ESMTP id DB01A80000A7
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 18:18:06 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-19-82.w92-135.abo.wanadoo.fr [92.135.50.82])
	by mwinf2f14.orange.fr (SMTP Server) with ESMTP id 7730A80000A2
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 18:18:06 +0200 (CEST)
Message-ID: <4AA683BD.6070601@gmail.com>
Date: Tue, 08 Sep 2009 18:18:05 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com>
In-Reply-To: <4AA63434.1010709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Morvan Le Meut a écrit :
> Morvan Le Meut a écrit :
>> Samuel Rakitnican a écrit :
>>> On Tue, 08 Sep 2009 10:25:44 +0200, Morvan Le Meut 
>>> <mlemeut@gmail.com> wrote:
>>>
>>>> Morvan Le Meut a écrit :
>>>>> Hello all
>>>>> This is an old card i bough by error ( wanted the DVB-T version ) 
>>>>> but i tried it and i see a small problem :
>>>>> The remote isn't supported. ( If it is, i wonder why my computer 
>>>>> don't see it )
>>>>>
>>>>> I found an old patch to add remote support to it here :
>>>>>
>>>>> http://tfpsly.free.fr/Files/Instant_TV_PCI_remote/saa7134_patch_for_AdsInstantTVPCI.gz 
>>>>> ( The webpage talking about it is 
>>>>> http://tfpsly.free.fr/francais/index.html?url=http://tfpsly.free.fr/Files/Instant_TV_PCI_remote/index.html 
>>>>> in french )
>>>>>
>>>>> But since i found out long ago that i shouldn't even think of 
>>>>> altering a source file, could someone adapt that old patch to 
>>>>> correct this ? ( should be quick, i guess )
>>>>>
>>>>> Thanks.
>>>>>
>>>>>
>>>>> -- To unsubscribe from this list: send the line "unsubscribe 
>>>>> linux-media" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>> Well, i'm trying it myself ( by hand, since the patch looks old ) :
>>>> adding
>>>> case SAA7134_BOARD_ADS_INSTANT_TV: at line 6659 in saa7134-cards.c
>>>> (before "dev->has_remote = SAA7134_REMOTE_GPIO;" )
>>>> is that correct ?
>>>> but from the diff file i should add what seems to be the remote 
>>>> keycode in saa7134-input.c
>>>> "+static IR_KEYTAB_TYPE AdsInstantTvPci_codes[IR_KEYTAB_SIZE] = {
>>>> +    // Buttons are in the top to bottom physical order
>>>> +    // Some buttons return the same raw code, so they are 
>>>> currently disabled
>>>> +    [ 127] = KEY_FINANCE,   // "release all keys" code - prevent 
>>>> repeating enlessly a key
>>>> +   +    [ 27 ] = KEY_POWER,"
>>>> ( and so on )
>>>>  Since i didn't see other keycodes for the other cards, i guess 
>>>> this is wrong, so where should i add them ?
>>>> ( i barely understand what i am doing right now :p )
>>>>
>>>> Thanks
>>>
>>> Hi Morvan,
>>>
>>> I'm not a developer, however I've done someting similar in the past...
>>>
>>> This "keycodes" looks pretty strange to me, but then again I'm not a 
>>> developer.
>>>
>>> Just add it by hand and compile it, and install it.
>>>
>>> After successful load of all new modules, you should get some 
>>> response in terminal, or in dmesg output like "Unknown key..." if 
>>> keymap table is wrong by pressing buttons on remote. If this gpio's 
>>> are correct:
>>>
>>> +        mask_keycode = 0xffffff;
>>> +        mask_keyup   = 0xffffff;
>>> +        mask_keydown = 0xffffff;
>>> +        polling      = 50; // ms
>>>
>> Still working on it, i found out where thoses keycodes should go :
>> ir-keymaps.c
>> i'm not a developer either, but i tried to learn C a few years ago
>> so i'm not completly lost, i just can't understand what all that code 
>> is doing ...
>> But it is strange that such an old card had this lack of remote 
>> support go unnoticed.
>>
>> ( I really have no luck when it come to TV cards : first, my PC Basic 
>> EC168 card ( tnt usb basic v5 ) doesn't work where it should, then my 
>> HVR-1120 works but not with mythtv and now the remote i wanted to use 
>> isn't supported :D )
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> /home/momo/TNT/v4l-dvb/v4l/saa7134-input.c: In function
> 'saa7134_input_init1':
> /home/momo/TNT/v4l-dvb/v4l/saa7134-input.c:655: error:
> 'AdsInstantTvPci_codes' undeclared (first use in this function)
>
> guess i missed something, i'll have to wait for someone to correct it :)
>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Since it doesn't work with thoses keycodes, i'm trying it with 
"ir_codes_adstech_dvb_t_pci". I'm sure it won't work ( it would be toot 
easy otherwise :D ) but since the remote looks the same ...
If by chance it work, i'll try to better document what i did for someone 
to write a patch. ( Or at least, to serve as a reminder the next time 
i'll encounter the problem :) )


