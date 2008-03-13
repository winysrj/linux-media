Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JZi4j-0002PI-1p
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 08:42:06 +0100
Received: by py-out-1112.google.com with SMTP id a29so3690895pyi.0
	for <linux-dvb@linuxtv.org>; Thu, 13 Mar 2008 00:41:58 -0700 (PDT)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: Philip Pemberton <lists@philpem.me.uk>
In-Reply-To: <47D84DBA.4080205@philpem.me.uk>
References: <47D7B9BC.3070304@gmx.org>  <47D84DBA.4080205@philpem.me.uk>
Date: Thu, 13 Mar 2008 08:41:52 +0100
Message-Id: <1205394112.6978.12.camel@tux>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MT2266 I2C write failed, usb disconnet,
	WinTV	Nova-TD stick, remote
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


Il giorno mer, 12/03/2008 alle 21.40 +0000, Philip Pemberton ha scritto:
> Bernhard Albers wrote:
> > [  628.492000] hub 4-0:1.0: port 9 disabled by hub (EMI?), re-enabling...
> > [  628.492000] usb 4-9: USB disconnect, address 2
> > [  628.500000] MT2266 I2C write failed
> > [  628.500000] MT2266 I2C write failed
> > [  650.208000] dvb-usb: error while stopping stream.
> 
> > Maybe it is a problem of the mainboard. It is an Asus m2a-vm hdmi
> > (amd690g chipset and ati x1250 onboard graphics) with the latest Bios
> > (1604).
> 
> Interesting theory...
> I'm seeing the same thing on a Biostar TA690G mainboard, which uses the same 

I've already told it to Bernard but not yet in the list:
Notice that this one seems to be a known issue (even to windows people)
related to an incompatibility between 690g mainboard (more precisely
sb600 southbridge) and nova td stick. It seems that it causes usb
disconnect when the stick works in dual mode (always in linux) using
both tuners at the same time. People reported the problem can be solved
with a pci usb expansion or using the stick with another mainboard.
There is also a note about it in the linuxtv wiki (NOVA-TD Stick page).
It's interesting to note that both you and Bernard experienced the
problem even with just one tuner.

Some link:
http://209.85.165.104/search?q=cache:3LygRMoeRqUJ:www.hauppauge.co.uk/board/showthread.php%3Ft%3D14152+nova+td+690g&hl=it&ct=clnk&cd=1

http://209.85.165.104/search?q=cache:KWnzteJ-zZkJ:www.hauppauge.co.uk/board/archive/index.php%3Ft-14247.html+nova+td+690g&hl=it&ct=clnk&cd=2

http://209.85.165.104/search?q=cache:-UJFsa42dsEJ:www.hauppauge.co.uk/board/archive/index.php%3Ft-14152.html+nova+td+sb600&hl=it&ct=clnk&cd=4

http://209.85.165.104/search?q=cache:tcwgQWV-jEUJ:www.hauppauge.co.uk/board/showthread.php%3Fp%3D63962+nova+td+sb600&hl=it&ct=clnk&cd=3



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
