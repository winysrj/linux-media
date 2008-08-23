Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KWvN6-0001Fq-Hi
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 17:49:49 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 23 Aug 2008 17:48:54 +0200
References: <48B00D6C.8080302@gmx.de> <200808231711.36277@orion.escape-edv.de>
	<alpine.LRH.1.10.0808231716530.26788@pub5.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0808231716530.26788@pub5.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808231748.54615@orion.escape-edv.de>
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
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

Patrick Boettcher wrote:
> Hi,
> 
> On Sat, 23 Aug 2008, Oliver Endriss wrote:
> > Btw, I don't understand Patrick's workaround.
> 
> The Flexcop i2c-interface is not very flexible. You cannot send just a 
> single write request with an independent read request following.

Ah, ok. Maybe we should add some comments.

> The same problematic applies for several USB-I2C requests as we have it in 
> dvb-usb at several places.
> 
> In addition (see my other mail in that thread), sending two independent 
> i2c_transfers which actually belong together is not really safe.

The current code in the else path will *never* work, because the tuner
does not support repeated start conditions. The problem is not the I2C
master (saa7146/flexcop) but the I2C slave (s5h1420).

> (However 
> I understand that for most single-receiver boards it is no real problem, 
> as long as no one is using this i2c-adapter from user-space at the same 
> time.)

True.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
