Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.188])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@retrodesignfan.eu>) id 1LtBlA-00055h-0k
	for linux-dvb@linuxtv.org; Mon, 13 Apr 2009 04:18:56 +0200
Message-ID: <49E2A0E1.4020407@retrodesignfan.eu>
Date: Mon, 13 Apr 2009 04:18:09 +0200
From: Marco Borm <linux-dvb@retrodesignfan.eu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20090411221740.GB12581@www.viadmin.org>
In-Reply-To: <20090411221740.GB12581@www.viadmin.org>
Subject: Re: [linux-dvb] DVB-T USB dib0700 device recommendations?
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

Hi Henrik,

one of the cards in my system is the dib0700 based "'Hauppauge Nova-T 500".
Compared with the "TerraTec Cinergy 1400" I would say that the receiver 
sensitivity is worse but the main problem I have is that the card 
consumes a loot of energy (8-13W), which is much more than the 
Terratec(5-6W).
I calculated this using measure values of the whole system captured with 
a Conrad/Voltcraft Energy Monitor 3000.
Personally I am little bit shocked about that and wondering if this can 
be true because the dib is a USB-device, but the Voltcraft is one of the 
better measurement device.
Maybe the VIA usb-hub controller on the board is the problem?!

Would be interesting of someone has the same or other experiences with 
this card or other PCI based cards. Hauppauge ignores all my questions, 
so I can't recomment products of this manufacturer anyway.


Greetings,
Marco

H. Langos wrote:
> I've been trying to minimize energy consumption [...] But before running 
> out in the street and buying the first dib0700 device I'd like to know if 
> there are any devices that are 
>
> - especially good [...]
>
> or 
>
> - especially bad [...]
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
