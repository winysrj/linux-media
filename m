Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KWIII-0007yK-HU
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 00:06:17 +0200
Received: by nf-out-0910.google.com with SMTP id g13so210837nfb.11
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 15:06:11 -0700 (PDT)
Message-ID: <412bdbff0808211506i6c6c96f6t7285848f2d79b5f0@mail.gmail.com>
Date: Thu, 21 Aug 2008 18:06:11 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0808220000340.21606@pub5.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <1219330331.15825.2.camel@dark> <48ADCC81.5000407@nafik.cz>
	<37219a840808211321k34590d38v7ada0fb9655e5dfe@mail.gmail.com>
	<412bdbff0808211325h64d454d5m3353d8756b9eb737@mail.gmail.com>
	<37219a840808211329j697556fcj760057bb1c7b58a8@mail.gmail.com>
	<alpine.LRH.1.10.0808212337070.21606@pub5.ifh.de>
	<1219355890.6770.2.camel@youkaida>
	<alpine.LRH.1.10.0808220000340.21606@pub5.ifh.de>
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

Yes, I am doing the i2c work before anything else (hopefully tonight).

Devin

On Thu, Aug 21, 2008 at 6:02 PM, Patrick Boettcher
<patrick.boettcher@desy.de> wrote:
> Nicolas,
>
> 1) The firmware alone should fix the i2c problems, even with the currently
> used requests.
> 2) The new requests are necessary to have the xc5000 running correctly, if
> I understand everything correctly. So yes, it will be done first - I
> think.
>
> Patrick.
>
>
> On Thu, 21 Aug 2008, Nicolas Will wrote:
>
>> On Thu, 2008-08-21 at 23:38 +0200, Patrick Boettcher wrote:
>>> On Thu, 21 Aug 2008, Michael Krufky wrote:
>>>> Lets sync up when you get to that point -- I have a good chunk of
>>> code
>>>> written that will add analog support to the dvb-usb framework as an
>>>> optional additional adapter type.
>>>
>>> Wow wow wow. That sounds like music in my ears. Great direction!!!
>>>
>>
>> hmmm, Devin, Patrick, let me be selfish a little bit, that's what I do
>> best most of the time, so you can beat me up for it.
>>
>> Can the new i2c request code for the new firmware be done first?
>>
>> Nico
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
