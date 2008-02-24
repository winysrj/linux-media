Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett2@onetel.com>) id 1JTMmR-0006WM-33
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 20:44:59 +0100
Message-Id: <B3DD497A-4D52-4717-B172-208C2FE26D8D@onetel.com>
From: Tim Hewett <tghewett2@onetel.com>
To: Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <47C19AED.90504@gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sun, 24 Feb 2008 19:44:25 +0000
References: <65A7136B-8AAD-44EE-921E-5376D7BAC14E@onetel.com>
	<47C09CB5.8060804@gmail.com>
	<FE251317-5C82-44A7-B2F3-7F0254A787E6@onetel.com>
	<47C0AF98.5000703@gmail.com>
	<342209CC-E522-49BC-A3D6-7A9A7CE23740@onetel.com>
	<47C0BC6D.2060606@gmail.com>
	<AC97F37D-D99C-402A-BFF4-AB6949597464@onetel.com>
	<47C19AED.90504@gmail.com>
Cc: Tim Hewett <tghewett2@onetel.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave
	AD	SP400 rebadge)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I have three diseqc switches, all different models, they all behave in  
this way. The PC also has three Skystar 2 (non HD) card and they all  
have trouble with these switches. I had hoped that because the Skystar  
HD2 has its own power supply separate from the PCI bus, that might  
help, but no.

My Technomate TM1000 receiver has no problems with any of the switches.

Different subject: I want to modify dvbstream to be able to tune the  
SkyStar HD2, is there any information on the changes to the API? I  
have tried to follow the changes made to szap.c, but so far without  
any success in terms of getting dvbstream to tune.

Tim.


On 24 Feb 2008, at 16:27, Manu Abraham wrote:

> Tim Hewett wrote:
>> Manu,
>> The Diseqc switch has been removed and now all polarities tune, and  
>> DVB-S2 works as well.
>
> Bad diseqc switch ?
>
> Regards,
> Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
