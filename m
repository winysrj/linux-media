Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from h69-129-7-18.nwblwi.dedicated.static.tds.net ([69.129.7.18]
	helo=www.curtronics.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Curt.Blank@curtronics.com>) id 1KhIzl-00064i-CQ
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 09:04:39 +0200
Message-ID: <48D5F1FD.2060909@curtronics.com>
Date: Sun, 21 Sep 2008 02:04:29 -0500
From: Curt Blank <Curt.Blank@curtronics.com>
MIME-Version: 1.0
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
References: <48D32F0E.1000903@curtronics.com>
	<200809202159.50464.vanessaezekowitz@gmail.com>
	<48D5C4FC.4030106@curtronics.com>
	<200809210126.56055.vanessaezekowitz@gmail.com>
In-Reply-To: <200809210126.56055.vanessaezekowitz@gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Kworld PlusTV HD PCI 120 (ATSC 120)
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

Vanessa Ezekowitz wrote:
> On Saturday 20 September 2008 10:52:28 pm Curt Blank wrote:
>
>   
>> Um, sorry, there are a bunch of other modules loaded too. I was just
>> referring to the Conexant related modules.
>>     
>
> Ah ok.  Looking at the output of lsmod, it looks like everything loaded ok, and 
> the messages from dmesg look right too. 
>
> /me is even more confused.
>
>   
>> Below is the info requested, but it doesn't look like hte dmesg output
>> is of much help.
>>     
>
> After stripping out the usb-storage messages, what's left may be of use to the 
> others here on the list.
>
>   
>> Oh and I noticed here: http://linuxtv.org/wiki/index.php/ATSC_PCI_Cards
>> that the 120 card isn't listed, it would be easier to find I think if it
>> was. 
>>     
>
> It's below the main table, in the "Likely work as is.." section, 
> under "Experimental".  I'll create an entry in the main table once we get 
> everything working right.
>
>   
>> oh and you asked the v4l team but it looks like this message cam 
>> only to me?? (I cc'd my reply.)
>>     
>
> oooooops - my fault.  Next time, maybe I should check the "to" address before I 
> commit the message.  :-)
>
> Anyways, I forwarded our discussion to the v4l-dvb list so we can get more eyes 
> on this issue.  If you're not on that list, you might wish to join it:
>
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>

[Had to resend, I wasn't subscribed to linux-dvb.]

I just did another modprobe of the cx8800 module after a reboot and grep
-v'd all the usb stuff (which I'll have to look into as to why it's
doing that, new machine, new memory card reader). Anyway below is the
results of the modprobe.

Oh and do I need the cx88-alsa module?

Oh oh and, I really do appreciate your help. :)

Sep 21 01:27:26 touch kernel: Linux video capture interface: v2.00
Sep 21 01:27:27 touch kernel: cx88/0: cx2388x v4l2 driver version 0.0.6 
loaded
Sep 21 01:27:27 touch kernel: ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 
20 (level, low) -> IRQ 20
Sep 21 01:27:27 touch kernel: cx88[0]: subsystem: 17de:08c1, board: 
Kworld PlusTV HD PCI 120 (ATSC 120) [card=67,autodetected]
Sep 21 01:27:27 touch kernel: cx88[0]: TV tuner type 71, Radio tuner type -1
Sep 21 01:27:27 touch kernel: cx88[0]: Test OK
Sep 21 01:27:27 touch kernel: tuner' 1-0061: chip found @ 0xc2 (cx88[0])
Sep 21 01:27:27 touch kernel: xc2028 1-0061: creating new instance
Sep 21 01:27:27 touch kernel: xc2028 1-0061: type set to XCeive 
xc2028/xc3028 tuner
Sep 21 01:27:27 touch kernel: cx88[0]: Asking xc2028/3028 to load 
firmware xc3028-v27.fw
Sep 21 01:27:27 touch kernel: cx88[0]/0: found at 0000:04:06.0, rev: 5, 
irq: 20, latency: 64, mmio: 0xfb000000
Sep 21 01:27:27 touch kernel: cx88[0]/0: registered device video0 [v4l2]
Sep 21 01:27:27 touch kernel: cx88[0]/0: registered device vbi0
Sep 21 01:27:27 touch kernel: cx88[0]/0: registered device radio0
Sep 21 01:27:27 touch kernel: firmware: requesting xc3028-v27.fw
Sep 21 01:27:27 touch kernel: xc2028 1-0061: Loading 80 firmware images 
from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Sep 21 01:27:27 touch kernel: cx88[0]: Calling XC2028/3028 callback
Sep 21 01:27:27 touch kernel: xc2028 1-0061: Loading firmware for 
type=BASE (1), id 0000000000000000.
Sep 21 01:27:27 touch kernel: cx88[0]: Calling XC2028/3028 callback
Sep 21 01:27:29 touch kernel: xc2028 1-0061: Loading firmware for 
type=(0), id 000000000000b700.
Sep 21 01:27:29 touch kernel: SCODE (20000000), id 000000000000b700:
Sep 21 01:27:29 touch kernel: xc2028 1-0061: Loading SCODE for type=MONO 
SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Sep 21 01:27:29 touch kernel: cx88[0]: Calling XC2028/3028 callback
Sep 21 01:27:29 touch kernel: cx88[0]: Calling XC2028/3028 callback
Sep 21 01:27:29 touch kernel: xc2028 1-0061: Loading firmware for 
type=BASE FM (401), id 0000000000000000.
Sep 21 01:27:29 touch kernel: cx88[0]: Calling XC2028/3028 callback
Sep 21 01:27:31 touch kernel: xc2028 1-0061: Loading firmware for 
type=FM (400), id 0000000000000000.
Sep 21 01:27:31 touch kernel: cx88[0]: Calling XC2028/3028 callback




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
