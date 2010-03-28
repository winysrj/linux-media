Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:39320 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754918Ab0C1SMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 14:12:54 -0400
Message-ID: <4BAF9BDF.9020805@arcor.de>
Date: Sun, 28 Mar 2010 20:11:43 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: George Tellalov <gtellalov@bigfoot.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV HVR-900H
References: <20100328120729.GB6153@joro.homelinux.org> <20100328105145.GA2427@joro.homelinux.org> <27890244.1269777077513.JavaMail.ngmail@webmail18.arcor-online.net> <23371307.1269778330976.JavaMail.ngmail@webmail11.arcor-online.net> <20100328153759.GA2893@joro.homelinux.org>
In-Reply-To: <20100328153759.GA2893@joro.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.03.2010 17:37, schrieb George Tellalov:
> On Sun, Mar 28, 2010 at 02:12:10PM +0200, Stefan Ringel wrote:
>   
>>  
>>
>>
>> ----- Original Nachricht ----
>> Von:     George Tellalov <gtellalov@bigfoot.com>
>> An:      Stefan Ringel <stefan.ringel@arcor.de>
>> Datum:   28.03.2010 14:07
>> Betreff: Re: Hauppauge WinTV HVR-900H
>>
>>     
>>> On Sun, Mar 28, 2010 at 01:51:17PM +0200, Stefan Ringel wrote:
>>>       
>>>>  
>>>> In what for mode, analog or dvb-t?
>>>>
>>>>         
>>> The test? It was in analog mode using tvtime.
>>>
>>>       
>> And the dmsg log (with debug info), so we can see what wrong is. What for options have you set in the .config file?
>>
>>     
> Okay the same result with 2.6.33. I'm attaching my .config and dmesg's output.
> I also have debug=9 output but I'm not sure if it's appropriate to attach it
> here. Maybe I should gzip it?
>   

I have also this bug (v4l2 in tm6000)! It can go any time to find and
bugfix it. Please, test the dvb mode, what I think works and resend test
result.

Stefan Ringel

-- 
Stefan Ringel <stefan.ringel@arcor.de>

