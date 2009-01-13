Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42925 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754394AbZAMXYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 18:24:11 -0500
Message-ID: <496D22A2.2050605@gmx.de>
Date: Wed, 14 Jan 2009 00:24:18 +0100
From: Bastian Beekes <bastian.beekes@gmx.de>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: MSI DigiVox A/D II
References: <S1755369AbZAMWYU/20090113222421Z+45@vger.kernel.org>	 <496D1C18.3010403@gmx.de> <412bdbff0901131502g12d62917ka4fbebf7b74c6579@mail.gmail.com> <496D1F1B.8080801@gmx.de>
In-Reply-To: <496D1F1B.8080801@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, I'm installing Intrepid kernel right now, reboot and re-check...
It's getting late, I'll report back when I've got further...

thanks so far,
Bastian

Bastian Beekes wrote:
> Hm, ok...
> 
> thanks for your reply in *no time* :)
> So is the only option to upgrade to 8.10? I'd prefer to stick with the 
> LTS release...
> 
> Bastian
> 
> Devin Heitmueller wrote:
>> On Tue, Jan 13, 2009 at 5:56 PM, Bastian Beekes 
>> <bastian.beekes@gmx.de> wrote:
>>> Hi everybody,
>>>
>>> I got a MSI DigiVox A/D II and am running Ubuntu 8.04.
>>> I got picture working with the drivers from 
>>> http://linuxtv.org/hg/v4l-dvb
>>>  , but I don't have sound.
>>>
>>> This device already worked with the em28xx-drivers from mcentral.de, 
>>> but I
>>> had to manually load snd-usb-audio and em28xx-audio. The problem is, 
>>> I don't
>>> have the em28xx-audio module.
>>> I see a souce-file in /v4l-dvb/linux/drivers/media/video/em28xx for
>>> em28xx-audio, so how do I build it?
>>>
>>> btw, my usb-id is eb1a:e323, so it is recognized as Kworld VS-DVB-T 
>>> 323UR ,
>>> but it in fact is a MSI DigiVox A/D II...
>>>
>>> thanks for your help,
>>> Bastian
>>
>> Ubuntu screwed up their build process in 8.04 so that none of the
>> v4l-dvb "-audio" modules would get built.  The issue was fixed in
>> 8.10.
>>
>> Devin
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
