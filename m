Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jordi.moles@gmail.com>) id 1LAV0W-0001Zd-GR
	for linux-dvb@linuxtv.org; Wed, 10 Dec 2008 20:46:05 +0100
Received: by ey-out-2122.google.com with SMTP id 25so106009eya.17
	for <linux-dvb@linuxtv.org>; Wed, 10 Dec 2008 11:46:00 -0800 (PST)
Message-ID: <49401C73.1010208@gmail.com>
Date: Wed, 10 Dec 2008 20:45:55 +0100
From: Jordi Molse <jordi.moles@gmail.com>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <493FFD3A.80209@cdmon.com>	<alpine.DEB.2.00.0812101844230.989@ybpnyubfg.ybpnyqbznva>	<4940032D.90106@cdmon.com>
	<alpine.DEB.2.00.0812101956220.989@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0812101956220.989@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] lifeview pci trio (saa7134) not working through
 diseqc anymore
Reply-To: jordi.moles@gmail.com
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
>>>> And it doesn't matter if i run "scan -s 1" or "scan -s 2" or "scan -s
>>>> 3", it will always scan from "switch 1"
>>>>     
>>>>         
>>> Try with -s 0; I'm not sure if it is always the case,
>>> but my unhacked `scan' uses 0-3 for DiSEqC positions
>>> 1/4 to 4/4 -- I've hacked this to use the range of 1-4
>>>       
>
>
>   
>> hi, thanks for anwsering.
>> I've already tried that.
>> remember, on switch 1 i've got astra 28.2E and on switch 2 i've got astra 19E
>>     
>
> I realized soon after sending my reply, that I had probably
> confused myself about which inputs you had where, and my
> advice, while partly correct, wouldn't help...
>
> Anyway -- the important thing to remember, is that if your
> `scan' works as I expect and your kernel modules work properly
> and you have a 2/1 DiSEqC switch, that scan -s option...
>  0 -- will tune to position 1/2;
>  1 -- will tune to position 2/2;
>  2 -- will cycle back and tune position 1/2;
>  3 -- will again tune position 2/2
>  4 -- should spit a warning, I think (something does)
>
> In other words -- if your system worked properly, `-s 1'
> would give you 19E2 and `-s 2' would give you 28E; the
> opposite of your switch labels.
>
>
>
>   
>> I don't why but it looks like it doesn't know how to switch to "switch 2"
>>     
>
> If I understand from your original post (re-reading it;
> as soon as people start posting distribution or system
> details my eyes sort of glaze over, while other people
> will get an `aha!' moment that shall remain elusive to
> me)...
>
> An older kernel version + modules worked;
> an update of those modules broke DiSEqC;
> your original kernel and modules didn't support your card.
>
> What I would suggest -- keeping in mind that the dvb kernel
> modules, which you should see with `lsmod', are where you
> should find correct support, are probably in some package
> unknown to me which you'd need to downgrade -- would be to
> either revert, if possible, whatever contains those modules,
> or jump ahead several kernel versions.
>
> If you feel comfortable compiling and installing a newer
> kernel (which is now around the 2.6.28 area), you could do
> that.
>
> Alternatively, and possibly better, would be to upgrade
> only the linux-dvb kernel modules, building them against
> your 2.6.24-era kernel source, which you may need to
> download and install.
>
> It's simple to download and build the latest linux-dvb
> modules even against a 2.6.24 kernel, and that should
> make things work -- if not, then something's been broken
> for a while, and some expert should be able to help you.
>
>
> barryb ouwsma
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

Hi again,

and thanks for the info.

Unfortunately, diseqc seems broken, because no matter what i try

-s 0, 1 , 2 ,3.... i get 28.2E signal

however, 4 shows an error, as you said.

It used to work... so i'll try to get back or compile new linux-dvb 
module as you suggested.

i'm really really newbie in this, i'm using kubuntu, so imagine.... 
hahahaha.

i don't even know how to get started, i barely install thing by "apt-get"

i'll try to find the way or post instead my problem in an ubuntu forum.

thanks for the info.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
