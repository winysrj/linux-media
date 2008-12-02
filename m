Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.terions.de ([81.16.53.101] helo=pm1.terions.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alles@bredde.de>) id 1L7QdD-0006HA-EZ
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 09:29:20 +0100
Message-ID: <4934F1CA.1000805@bredde.de>
Date: Tue, 02 Dec 2008 09:28:58 +0100
From: Mark Breddemann <alles@bredde.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <492F1FF4.7030600@bredde.de>
In-Reply-To: <492F1FF4.7030600@bredde.de>
Subject: Re: [linux-dvb] Cinergy Hybrid XE with tm6010 chip
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

Nobody?

br wrote:
> Hi,
> I've got a Cinergy Hybrid XE DVB-T USB Stick, which has got a tm6010
> chip inside (I opened the case just to get sure). Quite fast I realized,
> that there are no stable Linux drivers out there, so i tried the
> unstable one.
> 
> So I checked out the repo at http://linuxtv.org/hg/~mchehab/tm6010/ and
> compiled (without DVB), installed, loaded the module and then inserted
> the stick and well.. nothing happened, because the driver did not knew
> about my device. To fix this, i added the line
> { USB_DEVICE(0x0ccd, 0x0086), .driver_info = TM6010_BOARD_GENERIC },
> to file tm6000-cards.c (my lsusb output is 'Bus 008 Device 004: ID
> 0ccd:0086 TerraTec Electronic GmbH'). I do not know, whether
> TM6010_BOARD_GENERIC is the correct one, but for me it seemed to be the
> best solution.
> Afterward, the driver recognized my stick and began to work:
> http://pastebin.com/f79722ed2 . In short: The firmware's missing. So I
> extracted the firmware with help of a python script I found on the
> internet and put it to the right place. Here's the (long) result:
> http://pastebin.com/f6c853b43
> 
> I'm not surprised that my journey has failed, because I do not really
> know what my added line does (good old try'n'error), so my question:
> Where to go from here?
> 
> Mark
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
