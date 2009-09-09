Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54479 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZIIJEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 05:04:01 -0400
Received: by bwz19 with SMTP id 19so275537bwz.37
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 02:04:04 -0700 (PDT)
Date: Wed, 09 Sep 2009 11:04:00 +0200
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
From: semiRocket <semirocket@gmail.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-2
MIME-Version: 1.0
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com>
 <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com>
 <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com>
 <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com>
Content-Transfer-Encoding: 8bit
Message-ID: <op.uzzfgyvj3xmt7q@crni>
In-Reply-To: <4AA767F2.50702@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 09 Sep 2009 10:31:46 +0200, Morvan Le Meut <mlemeut@gmail.com>  
wrote:

> Morvan Le Meut a écrit :
>> i can use the remote now ( using devinput in lirc ) but a few quirks  
>> remains :
>> - dmesg gives a lot of "saa7134 IR (ADS Tech Instant TV: unknown key:  
>> key=0x7f raw=0x7f down=1"
>> - in irw most keys are misidentified ( Power as RECORD, Mute as Menu,  
>> Down as DVD and DVD is correctly identified )
>>
>> i guess using ir_codes_adstech_dvb_t_pci was not such a bright idea  
>> after all :p
>> ( i included a full dmesg output )
>>
>> For now, it is enough work on my part, i'll try to correct those  
>> keycodes later. It is amazing what you can do even when you don't  
>> understand most of it :D .
> Working on it, but i don't think everything is correct : some totaly  
> unrelated keys have the same keycode.
> For example Jump and  Volume+ or Search and Volume-.
>
> Beside, i keep getting "
> Sep  9 10:17:16 debian kernel: [ 2029.892014] saa7134 IR (ADS Tech  
> Instant TV: unknown key: key=0x7f raw=0x7f down=0
> Sep  9 10:17:16 debian kernel: [ 2029.944029] saa7134 IR (ADS Tech  
> Instant TV: unknown key: key=0x7f raw=0x7f down=1"
> for each recognized keypress
>
> I'll need a lot of help there : i don't know what to do.
>

I think that correct gpio mask in saa7134-input.c would give unique  
keycodes for every keypress. It's most likely that you need to invent new  
gpio mask, but I'm not sure about this:
	(http://linuxtv.org/wiki/index.php/Remote_controllers-V4L#How_to_add_remote_control_support_to_a_card_.28GPIO_remotes.29)

I'm sorry that I can't help you any further, it's getting far beyond my  
knowledge.

I'm leaving this to somebody else...

