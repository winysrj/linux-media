Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KUqSJ-0005dN-CZ
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 00:10:36 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 17 Aug 2008 23:36:51 +0200
References: <9e849af80808170229i4d79e160ibb8a928b2434f59b@mail.gmail.com>
In-Reply-To: <9e849af80808170229i4d79e160ibb8a928b2434f59b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808172336.51407@orion.escape-edv.de>
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

jaakko tuomainen wrote:
> Hi,
> 
> Thanks for the patch, now I can tune to any free-to-air
> channel with Kaffeine (i don't have pay-tv to test it).
> Is there need for some kind of "fine tuning" of the driver
> now when the cards are detected and work ok?

Great. I am a bit surprised that it works, since most of the parameters
in 'struct tda1004x_config' are just an educated guess. ;-)

If there are no problems we can leave the parameters 'as is'.
Fine tuning - if necessary - must be done by people who own the card
and are able to compare behaviour with the windows driver.

Let's test the patch until next weekend, then I will commit it to HG.

CU
Oliver

P.S.:
CI support is not implemented for Activy cards.

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
