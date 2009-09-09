Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2b.orange.fr ([80.12.242.146]:49966 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZIIIbp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2009 04:31:45 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b21.orange.fr (SMTP Server) with ESMTP id BC92A7000093
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 10:31:47 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b21.orange.fr (SMTP Server) with ESMTP id B00447000082
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 10:31:47 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-19-82.w92-135.abo.wanadoo.fr [92.135.50.82])
	by mwinf2b21.orange.fr (SMTP Server) with ESMTP id 375367000093
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2009 10:31:47 +0200 (CEST)
Message-ID: <4AA767F2.50702@gmail.com>
Date: Wed, 09 Sep 2009 10:31:46 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com> <4AA695EE.70800@gmail.com>
In-Reply-To: <4AA695EE.70800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Morvan Le Meut a écrit :
> i can use the remote now ( using devinput in lirc ) but a few quirks 
> remains :
> - dmesg gives a lot of "saa7134 IR (ADS Tech Instant TV: unknown key: 
> key=0x7f raw=0x7f down=1"
> - in irw most keys are misidentified ( Power as RECORD, Mute as Menu, 
> Down as DVD and DVD is correctly identified )
>
> i guess using ir_codes_adstech_dvb_t_pci was not such a bright idea 
> after all :p
> ( i included a full dmesg output )
>
> For now, it is enough work on my part, i'll try to correct those 
> keycodes later. It is amazing what you can do even when you don't 
> understand most of it :D .
Working on it, but i don't think everything is correct : some totaly 
unrelated keys have the same keycode.
For example Jump and  Volume+ or Search and Volume-.

Beside, i keep getting "
Sep  9 10:17:16 debian kernel: [ 2029.892014] saa7134 IR (ADS Tech 
Instant TV: unknown key: key=0x7f raw=0x7f down=0
Sep  9 10:17:16 debian kernel: [ 2029.944029] saa7134 IR (ADS Tech 
Instant TV: unknown key: key=0x7f raw=0x7f down=1"
for each recognized keypress

I'll need a lot of help there : i don't know what to do.

 


