Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.viadmin.org ([195.145.128.101])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henrik-dvb@prak.org>) id 1Lu21v-0004xu-C2
	for linux-dvb@linuxtv.org; Wed, 15 Apr 2009 12:07:44 +0200
Date: Wed, 15 Apr 2009 12:06:42 +0200
From: Heinrich Langos <henrik-dvb@prak.org>
To: Lars Buerding <lindvb@metatux.net>
Message-ID: <20090415100642.GA2895@www.viadmin.org>
References: <20090411221740.GB12581@www.viadmin.org>
	<20090412175352.GC12581@www.viadmin.org>
	<49E4B07A.4030205@metatux.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49E4B07A.4030205@metatux.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T USB dib0700 device recomendations?
Reply-To: linux-media@vger.kernel.org
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

Hi Lars,

On Tue, Apr 14, 2009 at 05:49:14PM +0200, Lars Buerding wrote:
> Hello Hendrik,
> 
> >> out in the street and buying the first dib0700 device I'd like to know if 
> >> there are any devices that are 
> >>
> >> - especially good (sensitive reception, fast switch time, sensible tuner 
> >>   data (usable for comparing different antennas) and so on)
> >>
> >> or 
> >>
> >> - especially bad (invers of the above plus hardware bugs, annoyances and so
> >>   on..)
> >>     
> 
> I bought this model a while ago:
> { "Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity",
> 
> This is the "Nova-TD" equipped with one standard and one small RF Connector
> (Adapter Small -> Standard is included). There is another model with two
> small RF-Connectors,  I dont know anything about this one.
> 
> 
> positive:
> - standard Hauppauge remote-control (until now, I did not find a better
>   one for my VDR)

Did you take a look at the Terratec remotes? They look quite good to me,too 
with color buttons and so on.. It looks a little cheaper than the
HAuppauge's remote but hopefully that's just due to the choice of colors.. 

Even the XXS seems to come with the full 48 buttons remote.
http://www.terratec.net/en/products/pictures/produkt_bilder_en_9706.html

> - 2 seperate tuners
> 
> 
> negative:
> - I have massive problems receiving weak signals. If you dont live directly
>   beneath the radio tower, just dont buy it. For me, this is the main reason
>   why I just cant use it at home.

I do live close to the radio tower but some receivers have problem with some
channels when using a stick antenna. Thats why I switched to a cheapo do it
yourself double quad. Here's the link to the instructions in German:
http://www.cnet.de/praxis/wochenend/41001557/die+beste+eigenbau_dvb_t_antenne+doppelquad+fuer+5+euro+basteln.htm

And here's the google translation:

http://translate.google.com/translate?hl=en&sl=de&u=http://www.cnet.de/praxis/wochenend/41001557/die%2Bbeste%2Beigenbau_dvb_t_antenne%2Bdoppelquad%2Bfuer%2B5%2Beuro%2Bbasteln.htm&ei=mKLlScbqIMGPsAam-KWtCw&sa=X&oi=translate&resnum=1&ct=result&prev=/search%3Fq%3Dhttp://www.cnet.de/praxis/wochenend/41001557/die%252Bbeste%252Beigenbau_dvb_t_antenne%252Bdoppelquad%252Bfuer%252B5%252Beuro%252Bbasteln.htm%26hl%3Den%26client%3Diceweasel-a%26rls%3Dorg.debian:en-US:unofficial

> - it does not work with my AMD-Board (SB700-Chipset), I have no problems
>   using it on my Laptop (Intel-Chipset) and another AMD-Desktop
> (Nvidia-Chipset).
>   I have found several reports in Mailinglists mentioning the same problems.

Thats wierd. So the usb controler on the Nova-TD and the host controler on
the SB700 are incompatible? 

> I also have a "Hauppauge Nova-T USB-2" (dib3000, large metal case) and a
> "Hauppauge WinTV Ministick" (Siano sms1xx-Chipset), the RF-Part of both
> devices is a far better one compared to the Nova-TD.

Is there a way to truely compare different receiver's quality? The
information that femon and tzap report (SNR, BER, UNC) are only what the
receiver itself says. 

cheers
-henrik



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
