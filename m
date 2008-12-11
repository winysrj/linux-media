Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from correo.cdmon.com ([212.36.74.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jordi@cdmon.com>) id 1LAgYv-0005H6-0H
	for linux-dvb@linuxtv.org; Thu, 11 Dec 2008 09:06:24 +0100
Message-ID: <4940C9D6.2020704@cdmon.com>
Date: Thu, 11 Dec 2008 09:05:42 +0100
From: Jordi Moles Blanco <jordi@cdmon.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <493FFD3A.80209@cdmon.com>	<alpine.DEB.2.00.0812101844230.989@ybpnyubfg.ybpnyqbznva>	<4940032D.90106@cdmon.com>	<alpine.DEB.2.00.0812101956220.989@ybpnyubfg.ybpnyqbznva>	<49401C73.1010208@gmail.com>	<1228955664.3468.21.camel@pc10.localdom.local>	<494066C2.90105@gmail.com>
	<1228958740.3468.28.camel@pc10.localdom.local>
In-Reply-To: <1228958740.3468.28.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] lifeview pci trio (saa7134) not
 working	through	diseqc anymore
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

En/na hermann pitton ha escrit:
> Am Donnerstag, den 11.12.2008, 02:02 +0100 schrieb Jordi Molse:
>   
>> En/na hermann pitton ha escrit:
>>     
>>> Hi,
>>>
>>> Am Mittwoch, den 10.12.2008, 20:45 +0100 schrieb Jordi Molse:
>>>   
>>>       
>>>> En/na BOUWSMA Barry ha escrit:
>>>>     
>>>>         
>>>>> On Wed, 10 Dec 2008, Jordi Moles Blanco wrote:
>>>>>
>>>>>   
>>>>>       
>>>>>           
>>>>>>>> And it doesn't matter if i run "scan -s 1" or "scan -s 2" or "scan -s
>>>>>>>> 3", it will always scan from "switch 1"
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>> Try with -s 0; I'm not sure if it is always the case,
>>>>>>> but my unhacked `scan' uses 0-3 for DiSEqC positions
>>>>>>> 1/4 to 4/4 -- I've hacked this to use the range of 1-4
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>   
>>>>>       
>>>>>           
>>>>>> hi, thanks for anwsering.
>>>>>> I've already tried that.
>>>>>> remember, on switch 1 i've got astra 28.2E and on switch 2 i've got astra 19E
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> I realized soon after sending my reply, that I had probably
>>>>> confused myself about which inputs you had where, and my
>>>>> advice, while partly correct, wouldn't help...
>>>>>
>>>>> Anyway -- the important thing to remember, is that if your
>>>>> `scan' works as I expect and your kernel modules work properly
>>>>> and you have a 2/1 DiSEqC switch, that scan -s option...
>>>>>  0 -- will tune to position 1/2;
>>>>>  1 -- will tune to position 2/2;
>>>>>  2 -- will cycle back and tune position 1/2;
>>>>>  3 -- will again tune position 2/2
>>>>>  4 -- should spit a warning, I think (something does)
>>>>>
>>>>> In other words -- if your system worked properly, `-s 1'
>>>>> would give you 19E2 and `-s 2' would give you 28E; the
>>>>> opposite of your switch labels.
>>>>>
>>>>>
>>>>>
>>>>>   
>>>>>       
>>>>>           
>>>>>> I don't why but it looks like it doesn't know how to switch to "switch 2"
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> If I understand from your original post (re-reading it;
>>>>> as soon as people start posting distribution or system
>>>>> details my eyes sort of glaze over, while other people
>>>>> will get an `aha!' moment that shall remain elusive to
>>>>> me)...
>>>>>
>>>>> An older kernel version + modules worked;
>>>>> an update of those modules broke DiSEqC;
>>>>> your original kernel and modules didn't support your card.
>>>>>
>>>>> What I would suggest -- keeping in mind that the dvb kernel
>>>>> modules, which you should see with `lsmod', are where you
>>>>> should find correct support, are probably in some package
>>>>> unknown to me which you'd need to downgrade -- would be to
>>>>> either revert, if possible, whatever contains those modules,
>>>>> or jump ahead several kernel versions.
>>>>>
>>>>> If you feel comfortable compiling and installing a newer
>>>>> kernel (which is now around the 2.6.28 area), you could do
>>>>> that.
>>>>>
>>>>> Alternatively, and possibly better, would be to upgrade
>>>>> only the linux-dvb kernel modules, building them against
>>>>> your 2.6.24-era kernel source, which you may need to
>>>>> download and install.
>>>>>
>>>>> It's simple to download and build the latest linux-dvb
>>>>> modules even against a 2.6.24 kernel, and that should
>>>>> make things work -- if not, then something's been broken
>>>>> for a while, and some expert should be able to help you.
>>>>>
>>>>>
>>>>> barryb ouwsma
>>>>>
>>>>> _______________________________________________
>>>>> linux-dvb mailing list
>>>>> linux-dvb@linuxtv.org
>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>   
>>>>>       
>>>>>           
>>>> Hi again,
>>>>
>>>> and thanks for the info.
>>>>
>>>> Unfortunately, diseqc seems broken, because no matter what i try
>>>>
>>>> -s 0, 1 , 2 ,3.... i get 28.2E signal
>>>>
>>>> however, 4 shows an error, as you said.
>>>>
>>>> It used to work... so i'll try to get back or compile new linux-dvb 
>>>> module as you suggested.
>>>>
>>>> i'm really really newbie in this, i'm using kubuntu, so imagine.... 
>>>> hahahaha.
>>>>
>>>> i don't even know how to get started, i barely install thing by "apt-get"
>>>>
>>>> i'll try to find the way or post instead my problem in an ubuntu forum.
>>>>
>>>> thanks for the info.
>>>>
>>>>     
>>>>         
>>> we need a report at least from 2.6.25 or current v4l-dvb from
>>> linuxtv.org.
>>>
>>> Prior to this patch
>>> http://linuxtv.org/pipermail/linux-dvb/2007-June/018741.html
>>> the Trio failed for 13 Volts and tone generation.
>>> Don't have the hardware, but would expect BBC 1 London to work and BBC 1
>>> CI to fail.
>>>
>>> This patch disabled some lnpb21 boards, which have that one connected in
>>> such a way, that diseqc forwarding is disabled. They need it from the
>>> tda10086.
>>>
>>> This was fixed by Hartmut with suggestions from Patrick to make it a
>>> config option, if the tda10086 or the LNB chip in question is active.
>>>
>>> All saa7134 DVB-S drivers have this option as diseqc = 0 in the config
>>> currently and it should be right for the Trio too and the isl6421 should
>>> forward.
>>>
>>> For looking at Ubuntu stuff, they downport a lot of things, because
>>> always late with kernel releases, we need the exact sources to diff
>>> against.
>>>
>>> I still have only that single dish for initially helping Hartmut with
>>> the isl6405 devel, but no rotors and switches yet and might be not of
>>> much help.
>>>
>>> Cheers,
>>> Hermann
>>>
>>>
>>>
>>>
>>>
>>>
>>>   
>>>       
>> hi,
>>
>> thanks for the info. I agree that in ubuntu there seem always to be 
>> "unfinished" things and then rush many things into "stable" releases 
>> when "it's time".
>>
>> Anyway....
>>
>> i tried to upgrade the system from "hardy" to "intrepid", which meant a 
>> lot of ports upgraded, including kernel
>> 2.6.27.9.13
>>
>> that thing you say...
>>
>> "All saa7134 DVB-S drivers have this option as diseqc = 0 in the config
>>
>> currently and it should be right for the Trio too and the isl6421 should
>> forward."
>>
>>
>> is there any way i can try this? is there any config file i can edit to 
>> make that happen (to make diseqc work)?
>>
>> i'm not a experienced user ,but i've got the card and i'm really willing 
>> to help in any posible way.
>>
>> just let me know what i can do.
>>
>> thanks.
>>
>>     
>
> Hi,
>
> on that 2.6.27 "BBC 1 London" _and_ "BBC 1 CI" or equivalent at least
> should work on 28.2. It does for me on lnpb21 and isl6405.
>
> If something is still left for the switch then, either way connected, we
> can start to scratch our heads or pull hair later, seems to me.
>
> Cheers,
> Hermann
>  
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

hi,

well.. it doesn't work in my case.... double and triple checked, 
hehehe.... are you using the same card lifeview trio or another one with 
the same chip?

would you mind telling me what linux system are you working with? i'm 
desperate for this to work, i will change to any distro that makes 
diseqc work.

Thanks.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
