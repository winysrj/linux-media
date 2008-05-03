Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1JsJAi-0005WJ-HY
	for linux-dvb@linuxtv.org; Sat, 03 May 2008 16:57:12 +0200
From: Matthias Dahl <mldvb@mortal-soul.de>
To: Andy Walls <awalls@radix.net>
Date: Sat, 3 May 2008 16:56:59 +0200
References: <200805020849.15170.mldvb@mortal-soul.de>
	<1209734150.3475.48.camel@palomino.walls.org>
In-Reply-To: <1209734150.3475.48.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_80HHI02yF3Url1M"
Message-Id: <200805031657.00691.mldvb@mortal-soul.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] KNC1 DVB-C (MK3) w/ CI causes i2c_timeouts
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_80HHI02yF3Url1M
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Andy.

On Friday 02 May 2008 15:15:50 you wrote:

> Given that your software hasn't changed, and assuming the driver code is
> correct (for a large majority of users), then the remaining problem
> areas I see are the card itself, the mainboard's PCI bus, and the
> possibility of a marginal power supply.  (Can anyone else think of
> something else?)

Perhaps. But maybe it's a combination of a few factors: is the MK3 model w/ CI 
as widely used and tested as the older model w/ CI? Maybe a combination of my 
hardware is triggering some hw/sw flaw.

The card is brand-new and was slightly modified by KNC1 for better QAM256 
receiption with my cable provider. The mainboard is a Asus Crosshair which is 
pretty much top-notch. Irionically I am no gamer and still own a highend 
gamer board but it's hard to get a decent piece of quality hardware 
nowadays. :-( The power supply should be more than enough with its 500W. ;-)

> Can you check the output of
> # lspci -nnxxx
> for your Host and PCI bridges and the video card?

Thanks for the tipp. That brings me to another problem that I think might be 
related. Since I put in the new card, I am experiencing the following:

 - power on computer -> wait for kdm -> switching to console fails

   the monitor even turns off because it gets no signal. usually blindly
   switching back to Xorg works and the screen is back.

 - rebooting the system -> everything works fine from there on

I did some more investigating and figured that the problem only occurs when 
the system has just been powered on _and_ something is accessing the dvb-c 
card. So powering on the machine without starting the vdr works just fine. 
But as soon as vdr has been started, no more vt switching is possible. The 
problem doesn't show up after a reboot- at all. This is never ever happened 
with the old card. I checked the cabling and all but I wasn't able to figure 
out what's the cause of this. No error msgs. Nothing.

For the record, unfortunately I am using a nvidia card with the 173.08 driver 
release. But I already did that with the old card.

I have attached the lspci output for both cases by the way.

> Also could you look at the latency timer of all the PCI devices on the
> bus?  Values that are very high (e.g. nVidia likes to use 248) and
> values less than or equal to 32 (n.b. 0 is OK for some bridge devices)
> can cause problems.

Due the fact that I only have the knc one card in the machine and everything 
else is either on board or on PCI-E, the latency is 0 everywhere except for 
the knc one card, there it's 32.

> Tweaking PCI bus latency timers with "setpci" may resolve your problems.

I'll give that a shot too. I really would like to set the latency when the 
module is being loaded. Unfortunately there is no module parameter for that 
so I'll have a look through the sources and hard wire to 64 which should be 
plenty.

> I believe this is a log message from an error condition.  The EEPROM on
> the i2c bus on the card was not able to be read properly.
> (See: linux/drivers/media/dvb/ttpci/ttpci-eeprom.c)

That also happened with the old card so I guess that's okay.

BTW. I switched to kernel 2.6.25.1 and in-tree dvb but no change at least on 
the "boot up" problem. For the original problem, I'll have an eye on it.

Sometimes I really wonder why I chose to study computer science. Life could be 
so much easier. ;-)

If anyone has some more ideas or things I could try... :-)

Thanks a lot,
matthew.

--Boundary-00=_80HHI02yF3Url1M
Content-Type: application/x-zip;
  charset="iso-8859-15";
  name="lspci_powerup_with_problem.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="lspci_powerup_with_problem.zip"

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
AAAAAQABAFEAAACyDwAAAAA=

--Boundary-00=_80HHI02yF3Url1M
Content-Type: application/x-zip;
  charset="iso-8859-15";
  name="lspci_after_reboot-working.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="lspci_after_reboot-working.zip"

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

--Boundary-00=_80HHI02yF3Url1M
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_80HHI02yF3Url1M--
