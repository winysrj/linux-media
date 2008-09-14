Return-path: <freebeer.bouwsma@gmail.com>
Date: Sun, 14 Sep 2008 10:50:08 -0400
In-reply-to: <48CC4669.9060407@singlespoon.org.au>
To: Paul Chubb <paulc@singlespoon.org.au>
Message-id: <48CD24A0.5020704@linuxtv.org>
MIME-version: 1.0
References: <466191.65236.qm@web46110.mail.sp1.yahoo.com>
 <48CC219C.9010007@singlespoon.org.au> <48CC3479.5080706@linuxtv.org>
 <48CC4669.9060407@singlespoon.org.au>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] xc3028 config issue. Re: Why I need to choose better
 Subject: headers [was: Re: Why (etc.)]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
  <mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
 <mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+freebeer.bouwsma=gmail.com@linuxtv.org
ReSent-Message-ID: <alpine.DEB.1.10.0809141912560.793@ybpnyubfg.ybpnyqbznva>
From: Steven Toth <freebeer.bouwsma@gmail.com>
List-ID: <linux-dvb@linuxtv.org>


Mauro, see question below.

Paul Chubb wrote:
> Steven Toth wrote:
>> Paul Chubb wrote:
>>> Barry,
>>> I drew the line at porting the xc3028 tuner module from mcentral.de 
>>> into v4l-dvb, so no didn't solve the firmware issues. If you know 
>>> what you are doing it should be trivial work - just linking in yet 
>>> another tuner module and then calling it like all the others. For me 
>>> because I don't know the code well it would take a week or two.
>>
>> No porting required.
>>
>> xc3028 tuner is already in the kernel, it should just be a case of 
>> configuring the attach/config structs correctly.
>>
>> - Steve
>>
> Steve,
>           I think we are talking about two different things. Yes the 
> xc3028 tuner is supported via tuner-xc2028 and works for many xc3028 
> based cards. This support uses the xc3028-v27.fw file that contains say 
> 80 firmware modules. This firmware was extracted from a Haupage windows 
> driver.

Correct.

(I changed the subject by the way)

> 
> I believe that the 1800H has some incompatibility with this firmware. 
> The mcentral.de tree has a different firmware loading and tuner support 
> module for xc3028 that loads individual firmware modules - you literally 
> put twenty or thirty files into /lib/firmware. This firmware is the 
> standard firmware from xceive before the card manufacturers get to it. 
> Comparing the dmesg listing from a working mcentral.de setup and the 
> non-working v4l tree the only thing that leaps out is the different 
> firmware. If I was continuing the next step would be to port that tuner 
> module into the v4l code and set it up in the normal way.

the v27.fw file does contain the correct firmware, so the fact that the 
inkernel tuner driver isn't select the correct version (or that it needs 
a hint in the config struct) is probably a very small fix.

Mauro (cc'd) generally maintains that driver and he should be able to 
help. My suggestion is that you cut/paste the attach/config struct from 
your leadtek code into this email thread. From you email address I guess 
you're trying to get DVB-T 7MHz working in Australia. Mauro can review it.

Ideally, we'd point you at a different card struct for the same tuner 
that we know works in Australia, so you build the leadtek config struct 
based on something that we know works.

Mauro, what should the attach/config struct look like for a xc2028/3028 
tune in Australia? Can you point to a working example or suggest a change?

Regards,

- Steve




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
