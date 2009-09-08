Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp28.orange.fr ([80.12.242.100]:3258 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZIHIZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2009 04:25:46 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2813.orange.fr (SMTP Server) with ESMTP id 4675E80000A6
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 10:25:45 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2813.orange.fr (SMTP Server) with ESMTP id 3AE6180000AB
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 10:25:45 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-19-82.w92-135.abo.wanadoo.fr [92.135.50.82])
	by mwinf2813.orange.fr (SMTP Server) with ESMTP id 0F6BC80000A6
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 10:25:45 +0200 (CEST)
Message-ID: <4AA61508.9040506@gmail.com>
Date: Tue, 08 Sep 2009 10:25:44 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com>
In-Reply-To: <4AA53C05.10203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Morvan Le Meut a écrit :
> Hello all
> This is an old card i bough by error ( wanted the DVB-T version ) but 
> i tried it and i see a small problem :
> The remote isn't supported. ( If it is, i wonder why my computer don't 
> see it )
>
> I found an old patch to add remote support to it here :
>
> http://tfpsly.free.fr/Files/Instant_TV_PCI_remote/saa7134_patch_for_AdsInstantTVPCI.gz 
>
> ( The webpage talking about it is 
> http://tfpsly.free.fr/francais/index.html?url=http://tfpsly.free.fr/Files/Instant_TV_PCI_remote/index.html 
> in french )
>
> But since i found out long ago that i shouldn't even think of altering 
> a source file, could someone adapt that old patch to correct this ? ( 
> should be quick, i guess )
>
> Thanks.
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Well, i'm trying it myself ( by hand, since the patch looks old ) :
adding
case SAA7134_BOARD_ADS_INSTANT_TV: at line 6659 in saa7134-cards.c
(before "dev->has_remote = SAA7134_REMOTE_GPIO;" )
is that correct ?
but from the diff file i should add what seems to be the remote keycode 
in saa7134-input.c
"+static IR_KEYTAB_TYPE AdsInstantTvPci_codes[IR_KEYTAB_SIZE] = {
+    // Buttons are in the top to bottom physical order
+    // Some buttons return the same raw code, so they are currently 
disabled
+    [ 127] = KEY_FINANCE,   // "release all keys" code - prevent 
repeating enlessly a key
+   
+    [ 27 ] = KEY_POWER,"
( and so on )
 Since i didn't see other keycodes for the other cards, i guess this is 
wrong, so where should i add them ?
( i barely understand what i am doing right now :p )

Thanks


