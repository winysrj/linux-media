Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from correo.cdmon.com ([212.36.74.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jordi@cdmon.com>) id 1LATKd-0003tx-TH
	for linux-dvb@linuxtv.org; Wed, 10 Dec 2008 18:58:44 +0100
Message-ID: <4940032D.90106@cdmon.com>
Date: Wed, 10 Dec 2008 18:58:05 +0100
From: Jordi Moles Blanco <jordi@cdmon.com>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <493FFD3A.80209@cdmon.com>
	<alpine.DEB.2.00.0812101844230.989@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0812101844230.989@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] lifeview pci trio (saa7134) not working through
 diseqc anymore
Reply-To: jordi@cdmon.com
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

En/na BOUWSMA Barry ha escrit:
> On Wed, 10 Dec 2008, Jordi Moles Blanco wrote:
>
>   
>> here's what i got from scanning........
>>
>> switch 1 (astra 28.2E)
>>
>> ********
>> scan -s 1 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-28.2E
>>     
>>>>> tune to: 10729:v:1:22000
>>>>>           
>> 0x0000 0x206c: pmt_pid 0x0100 BSkyB -- E4+1 (running)
>>     
>
>   
>> switch 2 (astra 19E)
>> ********
>> scan -s 2 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-19.2E
>>     
>>>>> tune to: 10788:v:2:22000
>>>>>           
>> 0x0000 0x283d: pmt_pid 0x0100 BSkyB -- BBC 1 W Mids (running)
>>     
>
> You are correct, this is a transponder at 28E2 which
> shares freq,pol+sr with 19E2...
>
>
>   
>> And it doesn't matter if i run "scan -s 1" or "scan -s 2" or "scan -s
>> 3", it will always scan from "switch 1"
>>     
>
> Try with -s 0; I'm not sure if it is always the case,
> but my unhacked `scan' uses 0-3 for DiSEqC positions
> 1/4 to 4/4 -- I've hacked this to use the range of 1-4
> on all my `scan' and related tuning/streaming utilities.
>
>
> Personally, I prefer `0' to mean no DiSEqC at all, A/B
> as appropriate, and 1-4 to match all consumer equipment
> I've got my hands on (or A-D), but that's me...
>
>
> barry bouwsma
>   

hi, thanks for anwsering.

I've already tried that.

remember, on switch 1 i've got astra 28.2E and on switch 2 i've got 
astra 19E

no matter what i try...

scan -s 0 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-28.2E
scan -s 0 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-19.2E
scan -s 1 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-19.2E
scan -s 1 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-28.2E
scan -s 2 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-19.2E
scan -s 2 /home/servidor/.kde/share/apps/kaffeine/dvb-s/Astra-28.2E


i always get signal from Astra 28.2E

and if i switch cables and i put Astra 19E on switch 1 i'll always get 
signal from Astra 19.2.

I don't why but it looks like it doesn't know how to switch to "switch 2"

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
