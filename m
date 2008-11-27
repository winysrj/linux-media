Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from harpoon.unitedhosting.co.uk ([83.223.124.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert@watkin5.net>) id 1L5o0W-0006kM-Ey
	for linux-dvb@linuxtv.org; Thu, 27 Nov 2008 22:02:42 +0100
From: Robert Watkins <robert@watkin5.net>
To: Holger Rusch <holger@rusch.name>
In-Reply-To: <492E5EC9.30308@rusch.name>
References: <RCbI1iFQ0HKJFw8A@onasticksoftware.net>
	<492A8A43.4060001@rusch.name> <u0lnYVBoGwKJFwJg@onasticksoftware.net>
	<1227556939.16187.0.camel@youkaida>
	<100c0ba70811241329s594e3112h467e1deff9d3c1ac@mail.gmail.com>
	<1227644366.6949.18.camel@watkins-desktop>
	<412bdbff0811251229m7e36ed33jade32457a4c37185@mail.gmail.com>
	<492E5EC9.30308@rusch.name>
Date: Thu, 27 Nov 2008 21:02:27 +0000
Message-Id: <1227819747.7014.58.camel@watkins-desktop>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova/dib0700/i2C write failed
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0823094691=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0823094691==
Content-Type: multipart/alternative; boundary="=-+xXaUh0GOSLmVSXFM5v4"


--=-+xXaUh0GOSLmVSXFM5v4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2008-11-27 at 09:48 +0100, Holger Rusch wrote:

> Hi,
> 
> Devin Heitmueller schrieb:
> >> I also occasionally get
> >>  dib0700: firmware download failed at 17248 with -110
> >> My PC's got ATI's IXP SB400 USB2 Host Controllers.
> >> Rob Watkins
> 
> > Hello Robert,
> > Are you running dib0700 firmware version 1.10 or 1.20?
> > Devin
> 
> As written before.
> 
> I got an MB with SB700 USB Chipset and it seems to have the same 
> problems as the SB600 with the USB ports (disconnects here and then). 
> The SB400 seems to have them also?
> 
> I use a
> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity
> which is nearly the same as the Nova.
> 
> Now my system got a NEC-Chip USB PCIcard and everything works fine with
> the Cinergy connected there.


My Hauppauge Nova-T 500 Dual DVB-T is a PCI card with built in VIA USB
controller.

watkins@watkins-desktop:~$ lspci -vv | grep -i usb
00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host
Controller (rev 80) (prog-if 10 [OHCI])
00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host
Controller (rev 80) (prog-if 10 [OHCI])
00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host
Controller (rev 80) (prog-if 20 [EHCI])
02:01.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 62) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
02:01.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 62) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
02:01.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65) (prog-if
20 [EHCI])
	Subsystem: VIA Technologies, Inc. USB 2.0

The WinTV Nova-DT is connected to the USB 2.0 VIA Hub.
The USB 1.1 VIA hubs don't appear to have devices connected to them.

Regards,
Rob


--=-+xXaUh0GOSLmVSXFM5v4
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.18.3">
</HEAD>
<BODY>
On Thu, 2008-11-27 at 09:48 +0100, Holger Rusch wrote:
<BLOCKQUOTE TYPE=CITE>
<PRE>
Hi,

Devin Heitmueller schrieb:
&gt;&gt; I also occasionally get
&gt;&gt;  dib0700: firmware download failed at 17248 with -110
&gt;&gt; My PC's got ATI's IXP SB400 USB2 Host Controllers.
&gt;&gt; Rob Watkins

&gt; Hello Robert,
&gt; Are you running dib0700 firmware version 1.10 or 1.20?
&gt; Devin

As written before.

I got an MB with SB700 USB Chipset and it seems to have the same 
problems as the SB600 with the USB ports (disconnects here and then). 
The SB400 seems to have them also?

I use a
<A HREF="http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity">http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity</A>
which is nearly the same as the Nova.

Now my system got a NEC-Chip USB PCIcard and everything works fine with
the Cinergy connected there.
</PRE>
</BLOCKQUOTE>
<BR>
My Hauppauge Nova-T 500 Dual DVB-T is a PCI card with built in VIA USB controller.<BR>
<BR>
watkins@watkins-desktop:~$ lspci -vv | grep -i usb<BR>
00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller (rev 80) (prog-if 10 [OHCI])<BR>
00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller (rev 80) (prog-if 10 [OHCI])<BR>
00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host Controller (rev 80) (prog-if 20 [EHCI])<BR>
02:01.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62) (prog-if 00 [UHCI])<BR>
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller<BR>
02:01.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62) (prog-if 00 [UHCI])<BR>
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller<BR>
02:01.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65) (prog-if 20 [EHCI])<BR>
	Subsystem: VIA Technologies, Inc. USB 2.0<BR>
<BR>
The WinTV Nova-DT is connected to the USB 2.0 VIA Hub.<BR>
The USB 1.1 VIA hubs don't appear to have devices connected to them.<BR>
<BR>
Regards,<BR>
Rob<BR>
<BR>
</BODY>
</HTML>

--=-+xXaUh0GOSLmVSXFM5v4--



--===============0823094691==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0823094691==--
