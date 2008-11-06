Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1Ky8pA-0006k1-Ks
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 18:39:21 +0100
From: Darron Broad <darron@kewl.org>
To: wk <handygewinnspiel@gmx.de>
In-reply-to: <49131C19.1080404@gmx.de> 
References: <20081106124730.16840@gmx.net> <49131C19.1080404@gmx.de>
Date: Thu, 06 Nov 2008 17:39:13 +0000
Message-ID: <29835.1225993153@kewl.org>
Cc: Hans Werner <HWerner4@gmx.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] wscan: improved frontend autodetection
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <49131C19.1080404@gmx.de>, wk wrote:
>
>Hi,

LO

>Hans Werner wrote:
>> Currently wscan will not autodetect frontends which which have frontend != 0,
>> i.e. it only detects /dev/dvb/adapterN/frontend0 where N=0-3.
>>
>> Since multiple frontends per adapter are supported in 2.6.28, this means the correct
>> frontend may not be found. For example with the HVR4000, DVB-T is always at frontend1.
>>
>> The attached patch fixes this, searching for frontend 0-3 for each adapter 0-3.
>>
>> Signed-off-by: Hans Werner <hwerner4@gmx.de>
>Good idea. :)
>But while testing your patch it seems that it doesn't work as expected. 
>Here some example:
>
>w_scan version 20081106
>Info: using DVB adapter auto detection.
>   Found DVB-C frontend. Using adapter /dev/dvb/adapter0/frontend0
>   Found DVB-C frontend. Using adapter /dev/dvb/adapter1/frontend0
>   Found DVB-C frontend. Using adapter /dev/dvb/adapter2/frontend0
>Info: unable to open frontend /dev/dvb/adapter3/frontend1'
>Info: unable to open frontend /dev/dvb/adapter3/frontend2'
>Info: unable to open frontend /dev/dvb/adapter3/frontend3'
>-_-_-_-_ Getting frontend capabilities-_-_-_-_
>
>I'm using three dvb-c frontends.
>The detection doesnt stop anymore with your patch if a matching frontend 
>was found, because it doesnt leave the outer loop.
>Normally this search has to stop at /dev/dvb/adapter0/frontend0.
>That means we have to change your patch a little. I also increased the 
>number of adapters to 8, since i use more than 4.
>
>Can you please test the attached patch and give some feedback? If it 
>works fine for you, i would apply to w_scan.
>
>-Winfried
>
>PS: What is actually the maximum number of adapters and frontends per 
>adapter? Can anybody give some hint?

In relation to what Hans is addressing (Mutually exclusive frontends
on a single adapter AKA multi-frontend AKA MFE) then in theory the
core code is is not limited yet in practice there is a fixed provision
for two as that's the most that has been seen as yet.

Cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
