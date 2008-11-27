Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <holger@rusch.name>) id 1L5cYI-0005Nk-6p
	for linux-dvb@linuxtv.org; Thu, 27 Nov 2008 09:48:48 +0100
Message-ID: <492E5EC9.30308@rusch.name>
Date: Thu, 27 Nov 2008 09:48:09 +0100
From: Holger Rusch <holger@rusch.name>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <RCbI1iFQ0HKJFw8A@onasticksoftware.net>	<492A8A43.4060001@rusch.name>
	<u0lnYVBoGwKJFwJg@onasticksoftware.net>	<1227556939.16187.0.camel@youkaida>	<100c0ba70811241329s594e3112h467e1deff9d3c1ac@mail.gmail.com>	<1227644366.6949.18.camel@watkins-desktop>
	<412bdbff0811251229m7e36ed33jade32457a4c37185@mail.gmail.com>
In-Reply-To: <412bdbff0811251229m7e36ed33jade32457a4c37185@mail.gmail.com>
Subject: Re: [linux-dvb] Nova/dib0700/i2C write failed
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

Hi,

Devin Heitmueller schrieb:
>> I also occasionally get
>>  dib0700: firmware download failed at 17248 with -110
>> My PC's got ATI's IXP SB400 USB2 Host Controllers.
>> Rob Watkins

> Hello Robert,
> Are you running dib0700 firmware version 1.10 or 1.20?
> Devin

As written before.

I got an MB with SB700 USB Chipset and it seems to have the same 
problems as the SB600 with the USB ports (disconnects here and then). 
The SB400 seems to have them also?

I use a
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity
which is nearly the same as the Nova.

Now my system got a NEC-Chip USB PCIcard and everything works fine with
the Cinergy connected there.

Iam using Debian 2.6.26-1 on lenny with v4l out of the hg.

The Board is an Asrock Fulldisplayport.

Last v4l hg checkout and compile time: 23.11. 18:31

storage:~# cat /etc/debian_version
lenny/sid

storage:~# uname -a
Linux storage 2.6.26-1-amd64 #1 SMP Sat Nov 8 20:31:23 UTC 2008 x86_64 
GNU/Linux

storage:~# lspci -vv | grep -i usb
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller (prog-if 10 [OHCI])
00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller 
(prog-if 10 [OHCI])
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
Controller (prog-if 20 [EHCI])
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller (prog-if 10 [OHCI])
00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller 
(prog-if 10 [OHCI])
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
Controller (prog-if 20 [EHCI])
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 
Controller (prog-if 10 [OHCI])
05:06.0 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
         Subsystem: NEC Corporation Hama USB 2.0 CardBus
05:06.1 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
         Subsystem: NEC Corporation Hama USB 2.0 CardBus
05:06.2 USB Controller: NEC Corporation USB 2.0 (rev 02) (prog-if 20 [EHCI])

-- 
+ Contact? => http://site.rusch.name/ +

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
