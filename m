Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KX7pD-0007T9-Nk
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 07:07:45 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 24 Aug 2008 07:06:13 +0200
References: <9e849af80808170229i4d79e160ibb8a928b2434f59b@mail.gmail.com>
	<200808172336.51407@orion.escape-edv.de>
In-Reply-To: <200808172336.51407@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808240706.14898@orion.escape-edv.de>
Subject: Re: [linux-dvb] activy dvb-t ALPS tdhd1-204A support?
Reply-To: linux-dvb@linuxtv.org
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

Oliver Endriss wrote:
> jaakko tuomainen wrote:
> > Hi,
> > 
> > Thanks for the patch, now I can tune to any free-to-air
> > channel with Kaffeine (i don't have pay-tv to test it).
> > Is there need for some kind of "fine tuning" of the driver
> > now when the cards are detected and work ok?
> 
> Great. I am a bit surprised that it works, since most of the parameters
> in 'struct tda1004x_config' are just an educated guess. ;-)
> 
> If there are no problems we can leave the parameters 'as is'.
> Fine tuning - if necessary - must be done by people who own the card
> and are able to compare behaviour with the windows driver.
> 
> Let's test the patch until next weekend, then I will commit it to HG.

Could you please post a log which contains the driver messages after a
coldstart (poweroff the machine).

I'd like to know whether the TDHD1 has an internal eeprom for the
tda10046 firmware. If yes, we do not need the request_firmware stuff.

Thanks,
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
