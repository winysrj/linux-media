Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JZYfg-0006KG-Pu
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 22:39:37 +0100
Message-ID: <47D84DBA.4080205@philpem.me.uk>
Date: Wed, 12 Mar 2008 21:40:10 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Bernhard Albers <bernhard.albers@gmx.org>
References: <47D7B9BC.3070304@gmx.org>
In-Reply-To: <47D7B9BC.3070304@gmx.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MT2266 I2C write failed, usb disconnet,
 WinTV Nova-TD stick, remote
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

Bernhard Albers wrote:
> [  628.492000] hub 4-0:1.0: port 9 disabled by hub (EMI?), re-enabling...
> [  628.492000] usb 4-9: USB disconnect, address 2
> [  628.500000] MT2266 I2C write failed
> [  628.500000] MT2266 I2C write failed
> [  650.208000] dvb-usb: error while stopping stream.

> Maybe it is a problem of the mainboard. It is an Asus m2a-vm hdmi
> (amd690g chipset and ati x1250 onboard graphics) with the latest Bios
> (1604).

Interesting theory...
I'm seeing the same thing on a Biostar TA690G mainboard, which uses the same 
chipset. It works fine on my desktop machine though (VIA K8T800PRO chipset; 
ASUS A8V Deluxe) and on my ASUS Eee (can't remember off-hand what chipset that 
uses, an Intel one of some description IIRC).

Had some strange signal issues with the Nova-TD-Stick too - Tuner 0 worked 
fine, but Tuner 1 failed to lock onto the mux that carries FilmFour. Putting a 
6dB attenuator inline fixed that nicely -- seems the low-noise amplifier in 
the Microtune chip sets its level based on an average of the whole band it's 
tuned to. Lots of strong signals = low amplification = not much signal 
strength going into the DiBcom decoder/demux chip. Weaken some of the strong 
signals, and it's fine. Most peculiar.

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
