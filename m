Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nerdig.org ([88.198.12.5] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan@codejunky.org>) id 1KFR5F-00083m-Bi
	for linux-dvb@linuxtv.org; Sun, 06 Jul 2008 12:03:06 +0200
Received: from nerdig.org (localhost [127.0.0.1])
	by mx-int.nerdig.org (Postfix) with ESMTP id 82FB3D17B55C
	for <linux-dvb@linuxtv.org>; Sun,  6 Jul 2008 12:04:17 +0200 (CEST)
Received: from b14tch (port-254.pppoe.wtnet.de [84.46.0.254])
	(Authenticated sender: jan@codejunky.org)
	by mx.nerdig.org (Postfix) with ESMTP id 0837ED17B55B
	for <linux-dvb@linuxtv.org>; Sun,  6 Jul 2008 12:04:16 +0200 (CEST)
From: Jan Meier <jan@codejunky.org>
To: linux-dvb@linuxtv.org
Date: Sun, 6 Jul 2008 12:01:30 +0200
References: <200807042146.26204.jan@codejunky.org>
	<200807060342.04968@orion.escape-edv.de>
In-Reply-To: <200807060342.04968@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807061201.30990.jan@codejunky.org>
Subject: Re: [linux-dvb] Cinergy 1200 DVB-C unsupported device
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

Hey Oliver,

Am Sonntag, 6. Juli 2008 03:42:04 schrieb Oliver Endriss:
> Jan Meier wrote:
> > Hello,
> >
> > I have a cinergy 1200 DVB-C card which is not supprted by the current
> > driver from the mercurial repository. lspci -vnn shows the following:
> >
> > Subsystem: TERRATEC Electronic GmbH Unknown device [153b:a156]
> >
> > The device with the device string 153b:1156 is supported, so I hacked
> > around in budget.c/budget-av.c and added a156 instead of 1156, and now
> > the device is found:
>
> The id 153b:a156 looks suspicious.
>
> Are you sure that the device is properly seated in the pci slot?
> If possible, you should also try a different slot.

I tried a different slot but it did not help.

> If this does not help, the subsystem id has very likely been overwritten.
> You might re-program the correct id 153b:1156 with the tool fix_eeprom:
> http://www.escape-edv.de/endriss/dvb/fix_eeprom.c

Yeah, fix_eeprom did the trick! Now the card is recognized, thanks a lot!

Kind regards,

jan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
