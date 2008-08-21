Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KWIEn-0007Ky-UC
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 00:02:39 +0200
Date: Fri, 22 Aug 2008 00:02:00 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Nicolas Will <nico@youplala.net>
In-Reply-To: <1219355890.6770.2.camel@youkaida>
Message-ID: <alpine.LRH.1.10.0808220000340.21606@pub5.ifh.de>
References: <1219330331.15825.2.camel@dark> <48ADCC81.5000407@nafik.cz>
	<37219a840808211321k34590d38v7ada0fb9655e5dfe@mail.gmail.com>
	<412bdbff0808211325h64d454d5m3353d8756b9eb737@mail.gmail.com>
	<37219a840808211329j697556fcj760057bb1c7b58a8@mail.gmail.com>
	<alpine.LRH.1.10.0808212337070.21606@pub5.ifh.de>
	<1219355890.6770.2.camel@youkaida>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 and analog broadcasting
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

Nicolas,

1) The firmware alone should fix the i2c problems, even with the currently 
used requests.
2) The new requests are necessary to have the xc5000 running correctly, if 
I understand everything correctly. So yes, it will be done first - I 
think.

Patrick.


On Thu, 21 Aug 2008, Nicolas Will wrote:

> On Thu, 2008-08-21 at 23:38 +0200, Patrick Boettcher wrote:
>> On Thu, 21 Aug 2008, Michael Krufky wrote:
>>> Lets sync up when you get to that point -- I have a good chunk of
>> code
>>> written that will add analog support to the dvb-usb framework as an
>>> optional additional adapter type.
>>
>> Wow wow wow. That sounds like music in my ears. Great direction!!!
>>
>
> hmmm, Devin, Patrick, let me be selfish a little bit, that's what I do
> best most of the time, so you can beat me up for it.
>
> Can the new i2c request code for the new firmware be done first?
>
> Nico
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
