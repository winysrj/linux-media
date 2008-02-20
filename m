Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <werner.braun@gmx.de>) id 1JRxdm-0002Q3-UT
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 23:42:14 +0100
From: Werner Braun <werner.braun@gmx.de>
To: linux-dvb@linuxtv.org
Date: Wed, 20 Feb 2008 23:41:31 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802202341.32370.werner.braun@gmx.de>
Subject: [linux-dvb] auto detection of Flytv duo/hybrid and pci/cardbus
	confusion
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

>Am Sonntag, den 17.02.2008, 21:53 +0100 schrieb Peter Missel:
>> Greetings all!
>> 
>> Let me clear things up a bit.
>> 
>> > > First clarification, duo versus hybrid.
>> > > Are "duo" cards equipped with two independent tuners that can both be
>> > > used at the same time?
>> > > Are "hybrid" cards necessarily equipped with digital and analogue 
tuners?
>> > > Can a two tuner card be both a duo and a hybrid, if one tuner is 
digital
>> > > the other is analogue and they can both be used at the same time?
>> >
>> 
>> LifeView are using two vendor IDs - 4E42h for all (!) their OEMs, and their 
>> own one for LifeView branded cards. Hence we need two PCI ID entries for 
>> everything, each pair pointing back to the same card data.
>> 
>> Then, card types.
>> 
>> The analog-only and "hybrid" have one single tuner, for DVB-T or analog. 
>> The "Duo" cards have two tuner frontends, one for DVB-T and the other for 
>> analog.
>> "Trio" cards add a DVB-S frontend, which cannot be used at the same time as 
>> the DVB-T frontend. Like the Duo, these can run one digital and one analog 
>> stream in parallel.
>> 
>> Finally, card shapes.
>> 
>> Each card type comes in CardBus, PCI, and MiniPCI shape. The flavors are 
>> compatible, so that again, the PCI ID data point back to the same card 
entry 
>> for e.g. the PCI and CardBus Duo.
>> 
>> The card type/shape combinations are distinctly identified by their 
subsystem 
>> ID. No need to guesstimate anything.
>> 
>> That's the plan at least.
>> 
>> regards,
>> Peter
>
>Hi Peter!
>
>Your plan is fine so far.
>
>We might add some more comments to group devices obviously together,
>since those looking first time at it are a bit lost.
>
>For such i2c IR limits, we have your and Eddi's comments.
>
>Since we can't help it easily, Peter D. should suggest the older version
>of the MSI A/D for auto detection. It won't make anything more worse on
>that not fully clear Vivanco stuff, except Hartmut might have ideas.

>Cheers,
>Hermann

Hermann and Peter,

I guess it was me with the Vivanco card in May/June last year. I took a time 
out from the mailing list due to time constraints, but am back and willing to 
help you sorting out the open issues, as far as my limited competences allow 
for it.

The current status with my Vivanco 21057 card (4e42:3306) is:

- DVB-T works with the patches you suggested last year
- Analog not (but did not bother anyway)
- FM: did not try
- Remote: dto. (I'm sitting in front of the computer anyway)

Funny thing: since Kernel 2.6.22, firmware upload does not work any longer. I 
have to boot XP before and do a warm reboot, then DVB-T under Linux works.

Best regards
Werner

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
