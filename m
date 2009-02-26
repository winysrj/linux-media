Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay1.allsecurenet.com ([66.111.57.92])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tim@buttersideup.com>) id 1LcpZi-00083V-7M
	for linux-dvb@linuxtv.org; Fri, 27 Feb 2009 00:23:31 +0100
Message-ID: <49A7245F.6090306@buttersideup.com>
Date: Thu, 26 Feb 2009 23:23:11 +0000
From: Tim Small <tim@buttersideup.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <737399.42093.qm@web23305.mail.ird.yahoo.com>
In-Reply-To: <737399.42093.qm@web23305.mail.ird.yahoo.com>
Cc: kraxel@bytesex.org
Subject: Re: [linux-dvb] GDI Black Gold [14c7:0108] cx88 card
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

Hello,

I'm interested in getting this card working under Linux as well, it's 
labelled GDI2500PCTV on the back, and has a Conexant CX23881 visible on 
the front, with a Philips "TU1216/1 H P" RF box...  Looks like there may 
be some more ICs under the metal box, but I'd have to desolder it to 
check what they were (which I can do if necessary).

There seems to be TU1216 support in both v4l/saa7134-dvb.c and 
v4l/budget-av.c (code cut-n-paste by the look of it), but I can't see a 
way to select this tuner with the cx88xx module (e.g. CARDLIST.tuner).

So... I'm game for trying to get this working, and have a bit of kernel 
programming experience, but is there anything else I'm likely to need to 
know before I set out on this?

Cheers!

Tim.


Richard Runds wrote:
> Hi,
>
> Have a GDI Black Gold card with subsystem 14c7:0108 and I cannot make it work. Does anyone on the list have a working config for this card and/or know how to make this card work?
>
> I'm getting so far as video1 and vbi1 is created, but I don't have any entries in /dev/dvb/.
>
> cat /dev/video1 > test.mpg produces a video typical of a tv picture without signal (ant-war)... :)
>
>
> config
> ====
>
> /etc/modprobe.conf:
>
> alias char-major-81-1 cx88-dvb
> options cx88xx card=2 i2c_scan=1
>
> lspci -v:
>
> 02:09.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
>         Subsystem: Modular Technology Holdings Ltd GDI Black Gold
>         Flags: bus master, medium devsel, latency 64, IRQ 23
>         Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
>         Capabilities: [44] Vital Product Data
>         Capabilities: [4c] Power Management version 2
>
> 02:09.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
>         Subsystem: Modular Technology Holdings Ltd Unknown device 0108
>         Flags: bus master, medium devsel, latency 64, IRQ 5
>         Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
>         Capabilities: [4c] Power Management version 2
>
> dmesg:
>
> CORE cx88[0]: subsystem: 14c7:0108, board: GDI Black Gold [card=2,insmod option]
> TV tuner -1 at 0x1fe, Radio tuner -1 at 0x1fe
> cx88[0]: Test OK
> cx88[0]: i2c scan: found device @ 0x10  [???]
> cx88[0]: i2c scan: found device @ 0xa0  [eeprom]
> cx88[0]: GDI: tuner=unknown
> cx88[0]/2: cx2388x 8802 Driver Manager
> ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 21 (level, low) -> IRQ 23
> CORE cx88[0]: subsystem: 14c7:0108, board: GDI Black Gold [card=2,insmod option]
> TV tuner -1 at 0x1fe, Radio tuner -1 at 0x1fe
> cx88[0]: Test OK
> cx88[0]: i2c scan: found device @ 0x10  [???]
> cx88[0]: i2c scan: found device @ 0xa0  [eeprom]
> cx88[0]: GDI: tuner=unknown
> cx88[0]/0: found at 0000:02:09.0, rev: 5, irq: 23, latency: 64, mmio: 0xf5000000
> cx88[0]/0: registered device video1 [v4l2]
> cx88[0]/0: registered device vbi1
>
>
>
> Thanks,
>
> //riru
>
>
>
>
>       ___________________________________________________________
> Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
> now.
> http://uk.answers.yahoo.com/ 
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
