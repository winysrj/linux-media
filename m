Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:59704 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbZIHJvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2009 05:51:23 -0400
Received: by fxm17 with SMTP id 17so2481260fxm.37
        for <linux-media@vger.kernel.org>; Tue, 08 Sep 2009 02:51:24 -0700 (PDT)
Date: Tue, 08 Sep 2009 11:51:16 +0200
To: "Morvan Le Meut" <mlemeut@gmail.com>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
From: "Samuel Rakitnican" <samuel.rakitnican@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-2
MIME-Version: 1.0
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com>
Content-Transfer-Encoding: 8bit
Message-ID: <op.uzxmzlj86dn9rq@crni>
In-Reply-To: <4AA61508.9040506@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 08 Sep 2009 10:25:44 +0200, Morvan Le Meut <mlemeut@gmail.com>  
wrote:

> Morvan Le Meut a écrit :
>> Hello all
>> This is an old card i bough by error ( wanted the DVB-T version ) but i  
>> tried it and i see a small problem :
>> The remote isn't supported. ( If it is, i wonder why my computer don't  
>> see it )
>>
>> I found an old patch to add remote support to it here :
>>
>> http://tfpsly.free.fr/Files/Instant_TV_PCI_remote/saa7134_patch_for_AdsInstantTVPCI.gz  
>> ( The webpage talking about it is  
>> http://tfpsly.free.fr/francais/index.html?url=http://tfpsly.free.fr/Files/Instant_TV_PCI_remote/index.html  
>> in french )
>>
>> But since i found out long ago that i shouldn't even think of altering  
>> a source file, could someone adapt that old patch to correct this ? (  
>> should be quick, i guess )
>>
>> Thanks.
>>
>>
>> -- To unsubscribe from this list: send the line "unsubscribe  
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> Well, i'm trying it myself ( by hand, since the patch looks old ) :
> adding
> case SAA7134_BOARD_ADS_INSTANT_TV: at line 6659 in saa7134-cards.c
> (before "dev->has_remote = SAA7134_REMOTE_GPIO;" )
> is that correct ?
> but from the diff file i should add what seems to be the remote keycode  
> in saa7134-input.c
> "+static IR_KEYTAB_TYPE AdsInstantTvPci_codes[IR_KEYTAB_SIZE] = {
> +    // Buttons are in the top to bottom physical order
> +    // Some buttons return the same raw code, so they are currently  
> disabled
> +    [ 127] = KEY_FINANCE,   // "release all keys" code - prevent  
> repeating enlessly a key
> +   +    [ 27 ] = KEY_POWER,"
> ( and so on )
>  Since i didn't see other keycodes for the other cards, i guess this is  
> wrong, so where should i add them ?
> ( i barely understand what i am doing right now :p )
>
> Thanks

Hi Morvan,

I'm not a developer, however I've done someting similar in the past...

This "keycodes" looks pretty strange to me, but then again I'm not a  
developer.

Just add it by hand and compile it, and install it.

After successful load of all new modules, you should get some response in  
terminal, or in dmesg output like "Unknown key..." if keymap table is  
wrong by pressing buttons on remote. If this gpio's are correct:

+		mask_keycode = 0xffffff;
+		mask_keyup   = 0xffffff;
+		mask_keydown = 0xffffff;
+		polling      = 50; // ms
