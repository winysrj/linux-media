Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KDyc6-0007gD-8w
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 11:27:03 +0200
Date: Wed, 2 Jul 2008 11:26:14 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0806292244h2bffb642j46ea63c9cb643154@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0807021122190.20755@pub4.ifh.de>
References: <Pine.LNX.4.64.0806300012100.22453@voltron.homelinux.org>
	<412bdbff0806292244h2bffb642j46ea63c9cb643154@mail.gmail.com>
MIME-Version: 1.0
Cc: hwertz@avalon.net, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV 801e SE?
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

Hi,

It was a surprise for DiBcom-people that this device even exists. DiBcom 
has no information about the hardware-layout of this one. If my source is 
correct - the design was made by Yuan. They integrated the dib0700-driver 
(windows driver reference) and all the other drivers for the component on 
their own. Things like which GPIO from the dib0700 is used to reset the 
XC5000 or similar DiBcom can't tell.

The only thing I know is, that in ATSC-mode this device needs a different 
streaming mode than the DVB-devices (parallel instead of FIFO) - which is 
configurable with the current set_streaming-function in dib0700_core.c

Patrick.

On Mon, 30 Jun 2008, Devin Heitmueller wrote:

> I actually spent most of today rebuilding my Win32 dev environment so
> I can start getting some usb traces and work on it this week.
>
> Certainly it makes sense to coordinate.  I was going to start working
> on the xc5000 integration.  If you want to take a look at the S5H1411,
> that would be great.
>
> Devin
>
> On Mon, Jun 30, 2008 at 1:27 AM,  <hwertz@avalon.net> wrote:
>>      So, I got one of these Pinnacle PCTV 801e SE sticks.  This is USB,
>> receives NTSC+ATSC+QAM.
>>      First, two questions:
>>      1)I want to know, is anyone working on a driver for  this?  I don't
>> want to start if someone is like 99% finished.
>>      2)Anyone working on a DVB-driver-friendly XC5000 code?
>>
>>      Per a post from months ago (and I confirmed this by cracking mine
>> open) it uses a DiB0700 USB bridge chip, XC5000 tuner, S5H1411 8VSB/QAM
>> demodulator,  CX25843 NTSC decoder, and Cirrus Logic 5340CZZ chip for
>> something (original post speculated FM).
>>
>>      Also, I've seen Jernej Tonejc's posts from May 3 where he's found i2c
>> items at 0x19, 0x1a, 0x44 and 0x50.  I know not to mess with 0x50, that's
>> the EEPROM (based both on later post on that thread, and on looking
>> through source and seeing 0x50 is pretty common for the ROM.)
>>
>>      So, there's a DVB driver for DiB0700-based sticks.  I see there's
>> quite new code for S5H1411.  I don't see XC5000 support for DVB drivers,
>> but cx88 driver has XC5000 support and XC3028 support (and, the cx88 and
>> DVB drivers both look pretty clean!)  I was going to use DiB0700+XC3028 as
>> a template to basically see what functions go where from the cx88 way of
>> doing things, and then move XC5000 support straight over based on that.
>> The CX2584x code I see in-tree looks like a mess so that'll wait for later
>> (to be clear, I'm not disrespecting the CX2584x driver's code quality, the
>> chip just appears to be one of those ones that needs quite a bit of
>> hand-holding and general kicking to get things done... which I don't feel
>> like unravelling and moving to DVB framework at the moment 8-)
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>
>
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
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
