Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mailout03.sul.t-online.de ([194.25.134.81]
	helo=mailout03.sul.t-online.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JLnYl-0000A2-IA
	for linux-dvb@linuxtv.org; Sun, 03 Feb 2008 23:43:35 +0100
Message-ID: <47A6438B.3060606@t-online.de>
Date: Sun, 03 Feb 2008 23:43:23 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
References: <Pine.LNX.4.64.0801271922040.21518@pub2.ifh.de>	<479D1632.4010006@t-online.de>	<Pine.LNX.4.64.0801292211380.23532@pub2.ifh.de>	<479FB52A.6010401@t-online.de>
	<Pine.LNX.4.64.0801300047520.23532@pub2.ifh.de>
In-Reply-To: <Pine.LNX.4.64.0801300047520.23532@pub2.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TDA10086 with Pinnacle 400e tuning broken
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi, Patrick

Patrick Boettcher schrieb:
> Hi,
> 
> On Wed, 30 Jan 2008, Hartmut Hackmann wrote:
>>>> If i understand the LNBp21 and isl64xx datasheets correctly, these chips will
>>>> always use their internal 22kHz oscillator, it can just be turned on and off.
>>> I don't see how to turn on 22kHz on LNBP21. How can this be done?
>>>
>>> Patrick.
>>>
>> My understanding is that this needs to be done through the diseqc control:
>> via i2c control of the lnbp21, yo can either turn the tone permanently on
>> or let it be controlled by a pin - through the channel decoder.
> 
> The tda10086 is not generating the tone? Only the lnbp21 can do it? The 
> bit7 only enables that on the lnb21, because it is configured to only do 
> it, when a specific line is 1?
> 
> In that case the lnbp21-driver is not prepared for having the tone forced, 
> it seems. So data sheet reading.
> 
Are we talking about different chips / datashets?
Mine says that if the TEN bit is 0, the 22kHz generator is controlled by the
DSQIN pin. A high at this pin turns the OSCILLATOR on.
And to my understanding this is the only way to do it: the tda10086 has to generate
the ENVELOPE of the 22kHz signal. If it contains the carrier, this will disturb the
on chip oscillator. This might still work in the static case, but not if we
want to generate diseqc messages with bursts of just 11 periods.

> Actually I'm asking myself why it is wrong to not set the bit7 of the 
> tda10086? Could be a config option.
> 
See above. We might make it a config option, but we should only do it if we really
need to and i am not convinced yet.

>> Could it be that you somehow just forgot to choose the upper band in your tuning
>> data / dvb application?
> 
> I'm only using dvbscan and vdr - never bothering about that - it simply 
> worked ;)
> 
> Patrick.
> 
Are you sure that it is a lnbp21 on your board?
What kind of satellite equipment do you have?
- a single LNB, so the 22kHz tone is enough.
- a Multiswitch?
  if yes, which commands does it need / understand?
  - nothing but the tone?
  - a tone burst to switch between satellites and the tone?
  - full diseqc (2?) serial messages?

I got a board with tda10086 and lnbp21 let and started measuring.
voltage switching and static tone work fine with the current
configuration.

Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
