Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mi0.bluebottle.com ([206.188.25.15])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vallhaus71@bluebottle.com>) id 1LYf3O-0004aQ-4W
	for linux-dvb@linuxtv.org; Sun, 15 Feb 2009 12:20:56 +0100
Received: from fe1.bluebottle.com (internal.bluebottle.com [206.188.24.43])
	by mi0.bluebottle.com (8.13.1/8.13.1) with ESMTP id n1FBKIFf008258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Sun, 15 Feb 2009 11:20:18 GMT
Received: from localhost (internal.bluebottle.com [206.188.24.43])
	(authenticated bits=0)
	by fe1.bluebottle.com (8.13.1/8.13.1) with ESMTP id n1FBKENO031415
	for <linux-dvb@linuxtv.org>; Sun, 15 Feb 2009 11:20:17 GMT
To: linux-dvb@linuxtv.org
Message-ID: <1234696814.4997fa6ea906c@mail.bluebottle.com>
Date: Sun, 15 Feb 2009 11:20:14 +0000
From: Kevin <vallhaus71@bluebottle.com>
MIME-Version: 1.0
Subject: [linux-dvb] Philips saa7131e chip on Asus
Reply-To: linux-media@vger.kernel.org
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

Hi, is there anyone who can please give me a hand, after months reading and trying things out, I still cannot make this work.
I have an Asus Wifi tv card which came with my P5WD2 board. This card is shown as 'Asus Tiger Analog Tv Card' in xp and works well in that os.  Looking at the physical card I can see these writings on the chips and tuners (looks like it has 2)
Philips saa7131E
D33005   CE4403
TN05211   SB0780 (don't know if these might help)
I am trying to make it work on Ubuntu 8.10 (32 bit) (also tried on 64 bit---nothing)
After  a brand new installation and updates to the kernel source and headers, my Kernel is 2.6.27.
I also installed the latest Mercurial and also copied firmware drivers (tda10046)  to the /lib/firmware folder. 

lspci shows this;
01:01.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d0)

sudo lspci -v shows this
01:01.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d0)
	Subsystem: ASUSTeK Computer Inc. Device 818c
	Flags: bus master, medium devsel, latency 64, IRQ 22
	Memory at e7edb800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [40] Power Management version 2
	Kernel driver in use: saa7134
	Kernel modules: saa7134

The device being shown as 818c is not like any other Asus dual card I have read about.
Looks like the card is being found but it is not being autodetected, dmesg is showing it as card=0.  I am manually forcing card numbers in /etc/modprobe.d/options file.  I have tried all the Asus card numbers there are in the cardlist but still did not manage to scan any channel.
I have only one connection to the card and it;s from cable tv.

Sorry if I took too long, tried to give as much info as possible, and please excuse me if this is the wrong place were to put this request, if it is can you kindly guide me where I may ask for help.  TIA


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
