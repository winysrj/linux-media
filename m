Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]
	helo=spaceymail-a2.g.dreamhost.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lee.essen@nowonline.co.uk>) id 1JhMzP-0004zN-Qw
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 12:48:23 +0200
Received: from Cartman.owlsbarn.local (dsl-217-155-53-6.zen.co.uk
	[217.155.53.6])
	by spaceymail-a2.g.dreamhost.com (Postfix) with ESMTP id 10DD7EE3B8
	for <linux-dvb@linuxtv.org>; Thu,  3 Apr 2008 03:48:07 -0700 (PDT)
Message-Id: <08EC4328-5043-4C95-88DA-69C852074B94@nowonline.co.uk>
From: Lee Essen <lee.essen@nowonline.co.uk>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Thu, 3 Apr 2008 11:48:05 +0100
Subject: [linux-dvb] NSLU2 dma_free_coherent issue with DIB0700 driver (and
	probably others)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0961660845=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0961660845==
Content-Type: multipart/alternative; boundary=Apple-Mail-2--868264377


--Apple-Mail-2--868264377
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Hi,

Apologies if this is directed in the wrong place, as I suspect this is  
more of a kernel/USB issue than a DVB driver issue, but it does have  
an impact on people wanting to use this device with an NSLU2 (and I  
suspect it will also be a problem with many other devices.)

I have been experimenting using a variety of DVB-T USB devices with an  
NSLU2 with my ultimate aim being to build in a dual DVB-T device into  
the case and use it in very much the same way as the HDHomeRun device.

Using a DTT200U based device everything worked perfectly.

Then I started playing with a DIB0700 based device (actually an Elgato  
Eye-TV Diversity) and the system would just hang whenever I started  
using dvbstream, I got slightly different behaviour if I tried to tune  
it to an invalid frequency and eventually managed to get to a state  
when I could interrupt it before it completely locked up.

It seems that the driver was flagging an issue in the ARM architecture  
around not calling dma_free_coherent() with IRQ's disabled, apparently  
a warning was recently added to the ARM kernel so it logs a message  
and a stack trace each time ... this seemed to be happening so  
frequently it effectively locked the system up.

I did a little digging, but I'm not a kernel expert at all, and it  
seems that the ehci_hcd module is actually where the call is  
originating rather than the DVB driver itself, so I suspect that this  
will actually effect a significant number of the drivers when used on  
an ARM platform.

For the purposes of testing I removed the warning (from arch/arm/mm/ 
consistent line 363) and everything is fine, the driver operates  
perfectly and I can stream video nicely. BUT - clearly there is some  
kind of issue here that needs to be resolved.

More information is available at the link below, and also I have read  
comments suggesting that the issue has been discussed on the arm- 
kernel mailing list but that no resolution has yet been found.

http://forum.soft32.com/linux/ehci_hcd-map_single-unable-map-unsafe-buffer-standard-NSLU2-ftopict461241.html

For reference I'm using 2.6.24 and have tried the most recent drivers  
from linuxtv.org as well as a variety of others -- all seem to have  
the same problem (which is expected if the problem is actually in the  
USB system.)

Hope this is useful,

Lee.


--Apple-Mail-2--868264377
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; =
"><div>Hi,</div><div><br></div><div>Apologies if this is directed in the =
wrong place, as I suspect this is more of a kernel/USB issue than a DVB =
driver issue, but it does have an impact on people wanting to use this =
device with an NSLU2 (and I suspect it will also be a problem with many =
other devices.)</div><div><br></div><div>I have been experimenting using =
a variety of DVB-T USB devices with an NSLU2 with my ultimate aim being =
to build in a dual DVB-T device into the case and use it in very much =
the same way as the HDHomeRun device.</div><div><br></div><div>Using a =
DTT200U based device everything worked =
perfectly.</div><div><br></div><div>Then I started playing with a =
DIB0700 based device (actually an Elgato Eye-TV Diversity) and the =
system would just hang whenever I started using dvbstream, I got =
slightly different behaviour if I tried to tune it to an invalid =
frequency and eventually managed to get to a state when I could =
interrupt it before it completely locked up.</div><div><br></div><div>It =
seems that the driver was flagging an issue in the ARM architecture =
around not calling dma_free_coherent() with IRQ's disabled, apparently a =
warning was recently added to the ARM kernel so it logs a message and a =
stack trace each time ... this seemed to be happening so frequently it =
effectively locked the system up.</div><div><br></div><div>I did a =
little digging, but I'm not a kernel expert at all, and it seems that =
the ehci_hcd module is actually where the call is originating rather =
than the DVB driver itself, so I suspect that this will actually effect =
a significant number of the drivers when used on an ARM =
platform.</div><div><br></div><div>For the purposes of testing I removed =
the warning (from arch/arm/mm/consistent line 363) and everything is =
fine, the driver operates perfectly and I can stream video nicely. BUT - =
clearly there is some kind of issue here that needs to be =
resolved.</div><div><br></div><div>More information is available at the =
link below, and also I have read comments suggesting that the issue has =
been discussed on the arm-kernel mailing list but that no resolution has =
yet been found.</div><div><br></div><div><span class=3D"Apple-style-span" =
style=3D"font-family: Verdana; line-height: 18px; "><a =
href=3D"http://forum.soft32.com/linux/ehci_hcd-map_single-unable-map-unsaf=
e-buffer-standard-NSLU2-ftopict461241.html">http://forum.soft32.com/linux/=
ehci_hcd-map_single-unable-map-unsafe-buffer-standard-NSLU2-ftopict461241.=
html</a></span></div><div><font class=3D"Apple-style-span" =
face=3D"Verdana"><span class=3D"Apple-style-span" style=3D"line-height: =
18px;"><br></span></font></div><div><font class=3D"Apple-style-span" =
face=3D"Verdana"><span class=3D"Apple-style-span" style=3D"line-height: =
18px;">For reference I'm using 2.6.24 and have tried the most recent =
drivers from linuxtv.org as well as a variety of others -- all seem to =
have the same problem (which is expected if the problem is actually in =
the USB system.)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"Verdana"><span class=3D"Apple-style-span" style=3D"line-height: =
18px;"><br></span></font></div><div>Hope this is =
useful,</div><div><br></div><div>Lee.</div><div><br></div></body></html>=

--Apple-Mail-2--868264377--


--===============0961660845==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0961660845==--
