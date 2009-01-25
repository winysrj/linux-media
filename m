Return-path: <linux-media-owner@vger.kernel.org>
Received: from bane.moelleritberatung.de ([77.37.2.25]:50722 "EHLO
	bane.moelleritberatung.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZAYOgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 09:36:45 -0500
Message-ID: <497C7669.5090408@makhutov.org>
Date: Sun, 25 Jan 2009 15:25:45 +0100
From: Artem Makhutov <artem@makhutov.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use scan-s2?
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de>
In-Reply-To: <497C359C.5090308@okg-computer.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Jens Krehbiel-Gräther schrieb:
> Artem Makhutov schrieb:
>   
>> Hello,
>>
>> I am wondering on how to use scan-s2.
>>
>> When running scan-s2 like this I am only getting 13 services:
>>
>> scan-s2 -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
>>
>> when running
>>
>> scan-s2 -a 2 -n -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
>>
>> then I am getting 152 services.
>>
>> When running the old dvbscan application I am getting 1461 services:
>>
>> dvbscan -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
>>
>>
>> Have I missed a parameter in scan-s2 or what else could be the problem?
>>
>> Thanks, Artem
>>     
>
>
> Hi Artem!
>
> I had the same "problem".When add no options I am only getting a few 
> services.
> When I add the "-n" option I get some more services but all services I 
> only get, when I am adding "-n -5".
>
> the "-5" means:
> multiply all filter timeouts by factor 5 for non-DVB-compliant section 
> repitition rates
>
> The scan takes a long time then, but I get 1476 services (Astra 19.2).
> My device is a Pinnacle PCTV 452e (USB).
> Perhaps this switch is working with your device, too?
>   
I just tried it out. It does not work :( I am getting 217 services now.
So I am still missing ~1200 services.

I have run the scan using a TeVii S650. Now I have run then same using
my SkyStar HD and I got 1467 services.

So there is something not working using the TeVii S650...

Any ideas?

Regards, Artem
