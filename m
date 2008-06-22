Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <SiestaGomez@web.de>) id 1KAOGE-0000XY-8r
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 14:01:35 +0200
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id 19BA3E2BD33E
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 14:01:01 +0200 (CEST)
Received: from [88.152.136.212] (helo=midian.waldorf.intern)
	by smtp06.web.de with asmtp (WEB.DE 4.109 #226) id 1KAOFg-0006Jz-00
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 14:01:00 +0200
Date: Sun, 22 Jun 2008 14:01:00 +0200
From: SG <SiestaGomez@web.de>
To: linux-dvb@linuxtv.org
Message-Id: <20080622140100.f841c5a2.SiestaGomez@web.de>
In-Reply-To: <200806221035.50028.l.lacher@abian.de>
References: <200806220300.51879.l.lacher@abian.de> <485DB191.9090907@to-st.de>
	<200806221035.50028.l.lacher@abian.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="Multipart=_Sun__22_Jun_2008_14_01_00_+0200_RTOje3i5afPg3c9p"
Subject: Re: [linux-dvb] dvb_usb_dib0700 and Remote Control DSR-0112
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--Multipart=_Sun__22_Jun_2008_14_01_00_+0200_RTOje3i5afPg3c9p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

its better to always use directly the
/dev/input/by-path/pci-2-1--event-ir 
device because the event interface could change the next time you plug it in
or when using another new input device.

The get the remote work you need to apply the attached patch.
Also attached you find a lirc config which works fine here.

Best regards,
Martin


On Sun, 22 Jun 2008 10:35:49 +0200
Lutz Lacher <l.lacher@abian.de> wrote:

> Hi Tobias,
> 
> > So, sticks IR receiver is reported as /class/input/input21 and you are
> > trying to use irrecord on /dev/input/event9? Does not fit together, you
> > should try irrecord on /dev/input/input21 instead! (just my personal
> > opinion ;)
> >
> i don't have an /dev/input/input21, and if i understood the web page 
> correctly, it's always the same device. It says:
> 
> But Linux systems runing recent udev will automatically create non-varying 
> names, a nicer and automatic way of providing a stable input event name:
> 
> ls -l /dev/input/by-path on my system
> lrwxrwxrwx 1 root root 9 2008-06-22 09:56 pci-2-1--event-ir -> ../event9
> 
> which disappears if i plug out the stick and reappears if i plug it in again.
> eg. now it's reported as:
> kernel: input: IR-receiver inside an USB DVB receiver as /class/input/input11
> 
> Best regards, Lutz
> 
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



--Multipart=_Sun__22_Jun_2008_14_01_00_+0200_RTOje3i5afPg3c9p
Content-Type: text/x-diff;
 name="dib0700_devices_ir_DSR-0112.diff"
Content-Disposition: attachment;
 filename="dib0700_devices_ir_DSR-0112.diff"
Content-Transfer-Encoding: 7bit

--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-06-15 17:12:38.000000000 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-06-08 18:33:22.000000000 +0200
@@ -601,7 +601,42 @@
 	{ 0xeb, 0x54, KEY_PREVIOUS },
 	{ 0xeb, 0x58, KEY_RECORD },
 	{ 0xeb, 0x5c, KEY_NEXT },
-
+	/* Key codes for the Haupauge NOVA USB-Stick */
+	{ 0x1d, 0x1f, KEY_BACK },
+	{ 0x1d, 0x14, KEY_UP },
+	{ 0x1d, 0x1c, KEY_RADIO },
+	{ 0x1d, 0x3b, KEY_HOME },
+	{ 0x1d, 0x3D, KEY_POWER },
+	{ 0x1d, 0x16, KEY_LEFT },
+	{ 0x1d, 0x25, KEY_OK },
+	{ 0x1d, 0x17, KEY_RIGHT },
+	{ 0x1d, 0x24, KEY_PREVIOUS },
+	{ 0x1d, 0x1E, KEY_NEXT },
+	{ 0x1d, 0x37, KEY_RECORD },
+	{ 0x1d, 0x15, KEY_DOWN },
+	{ 0x1d, 0x36, KEY_STOP },
+	{ 0x1d, 0x30, KEY_PAUSE },
+	{ 0x1d, 0x35, KEY_PLAY },
+	{ 0x1d, 0x00, KEY_0 },
+	{ 0x1d, 0x01, KEY_1 },
+	{ 0x1d, 0x02, KEY_2 },
+	{ 0x1d, 0x03, KEY_3 },
+	{ 0x1d, 0x04, KEY_4 },
+	{ 0x1d, 0x05, KEY_5 },
+	{ 0x1d, 0x06, KEY_6 },
+	{ 0x1d, 0x07, KEY_7 },
+	{ 0x1d, 0x08, KEY_8 },
+	{ 0x1d, 0x09, KEY_9 },
+	{ 0x1d, 0x32, KEY_REWIND },
+	{ 0x1d, 0x34, KEY_FASTFORWARD },
+	{ 0x1d, 0x20, KEY_CHANNELUP },
+	{ 0x1d, 0x21, KEY_CHANNELDOWN },
+	{ 0x1d, 0x10, KEY_VOLUMEUP },
+	{ 0x1d, 0x11, KEY_VOLUMEDOWN },
+	{ 0x1d, 0x0A, KEY_TEXT },
+	{ 0x1d, 0x0D, KEY_MENU },
+	{ 0x1d, 0x12, KEY_CHANNEL },
+	{ 0x1d, 0x0F, KEY_MUTE },
 	/* Key codes for the Haupauge WinTV Nova-TD, copied from nova-t-usb2.c (Nova-T USB2) */
 	{ 0x1e, 0x00, KEY_0 },
 	{ 0x1e, 0x01, KEY_1 },

--Multipart=_Sun__22_Jun_2008_14_01_00_+0200_RTOje3i5afPg3c9p
Content-Type: application/octet-stream;
 name="dsr-0112.conf"
Content-Disposition: attachment;
 filename="dsr-0112.conf"
Content-Transfer-Encoding: base64

CiMgUGxlYXNlIG1ha2UgdGhpcyBmaWxlIGF2YWlsYWJsZSB0byBvdGhlcnMKIyBieSBzZW5kaW5n
IGl0IHRvIDxsaXJjQGJhcnRlbG11cy5kZT4KIwojIHRoaXMgY29uZmlnIGZpbGUgd2FzIGF1dG9t
YXRpY2FsbHkgZ2VuZXJhdGVkCiMgdXNpbmcgbGlyYy0wLjguMihkZXYvaW5wdXQpIG9uIFN1biBK
dW4gIDggMTg6Mzg6MDEgMjAwOAojCiMgY29udHJpYnV0ZWQgYnkgCiMKIyBicmFuZDogICAgICAg
ICAgICBoYXVwcGF1Z2Ugbm92YSB1c2Igc3RpY2sgcmVtb3ZlCiMgbW9kZWwgbm8uIG9mIHJlbW90
ZSBjb250cm9sOiBEU1ItMDExMgojIGRldmljZXMgYmVpbmcgY29udHJvbGxlZCBieSB0aGlzIHJl
bW90ZToKIwoKYmVnaW4gcmVtb3RlCgogIG5hbWUgIGhhdXBwYXVnZQogYml0cyAgICAgICAgICAg
MzIKICBlcHMgICAgICAgICAgICAzMAogIGFlcHMgICAgICAgICAgMTAwCgogIG9uZSAgICAgICAg
ICAgICAwICAgICAwCiAgemVybyAgICAgICAgICAgIDAgICAgIDAKICBnYXAgICAgICAgICAgMjQ5
ODA4CiAgdG9nZ2xlX2JpdCAgICAgIDEKCiAgICAgIGJlZ2luIGNvZGVzCiAgICAgICAgICBiYWNr
ICAgICAgICAgICAgICAgICAgICAgMHgwMDAxMDA5RQogICAgICAgICAgdXAgICAgICAgICAgICAg
ICAgICAgICAgIDB4MDAwMTAwNjcKICAgICAgICAgIHR2ICAgICAgICAgICAgICAgICAgICAgICAw
eDAwMDEwMTgxCiAgICAgICAgICBob21lICAgICAgICAgICAgICAgICAgICAgMHgwMDAxMDA2Ngog
ICAgICAgICAgcG93ZXIgICAgICAgICAgICAgICAgICAgIDB4MDAwMTAwNzQKICAgICAgICAgIGxl
ZnQgICAgICAgICAgICAgICAgICAgICAweDAwMDEwMDY5CiAgICAgICAgICBvayAgICAgICAgICAg
ICAgICAgICAgICAgMHgwMDAxMDE2MAogICAgICAgICAgcmlnaHQgICAgICAgICAgICAgICAgICAg
IDB4MDAwMTAwNkEKICAgICAgICAgIHByZXYgICAgICAgICAgICAgICAgICAgICAweDAwMDEwMTlD
CiAgICAgICAgICBuZXh0ICAgICAgICAgICAgICAgICAgICAgMHgwMDAxMDE5NwogICAgICAgICAg
cmVjICAgICAgICAgICAgICAgICAgICAgIDB4MDAwMTAwQTcKICAgICAgICAgIGRvd24gICAgICAg
ICAgICAgICAgICAgICAweDAwMDEwMDZDCiAgICAgICAgICBzdG9wICAgICAgICAgICAgICAgICAg
ICAgMHgwMDAxMDA4MAogICAgICAgICAgcGF1c2UgICAgICAgICAgICAgICAgICAgIDB4MDAwMTAw
NzcKICAgICAgICAgIHBsYXkgICAgICAgICAgICAgICAgICAgICAweDAwMDEwMENGCiAgICAgICAg
ICAxICAgICAgICAgICAgICAgICAgICAgICAgMHgwMDAxMDAwMgogICAgICAgICAgMiAgICAgICAg
ICAgICAgICAgICAgICAgIDB4MDAwMTAwMDMKICAgICAgICAgIDMgICAgICAgICAgICAgICAgICAg
ICAgICAweDAwMDEwMDA0CiAgICAgICAgICA0ICAgICAgICAgICAgICAgICAgICAgICAgMHgwMDAx
MDAwNQogICAgICAgICAgNSAgICAgICAgICAgICAgICAgICAgICAgIDB4MDAwMTAwMDYKICAgICAg
ICAgIDYgICAgICAgICAgICAgICAgICAgICAgICAweDAwMDEwMDA3CiAgICAgICAgICA3ICAgICAg
ICAgICAgICAgICAgICAgICAgMHgwMDAxMDAwOAogICAgICAgICAgOCAgICAgICAgICAgICAgICAg
ICAgICAgIDB4MDAwMTAwMDkKICAgICAgICAgIDkgICAgICAgICAgICAgICAgICAgICAgICAweDAw
MDEwMDBBCiAgICAgICAgICAwICAgICAgICAgICAgICAgICAgICAgICAgMHgwMDAxMDAwQgogICAg
ICAgICAgdHh0ICAgICAgICAgICAgICAgICAgICAgIDB4MDAwMTAxODQKICAgICAgICAgIG1lbnUg
ICAgICAgICAgICAgICAgICAgICAweDAwMDEwMDhCCiAgICAgICAgICByZXcgICAgICAgICAgICAg
ICAgICAgICAgMHgwMDAxMDBBOAogICAgICAgICAgZndkICAgICAgICAgICAgICAgICAgICAgIDB4
MDAwMTAwRDAKICAgICAgICAgIGNoKyAgICAgICAgICAgICAgICAgICAgICAweDAwMDEwMTkyCiAg
ICAgICAgICBjaC0gICAgICAgICAgICAgICAgICAgICAgMHgwMDAxMDE5MwogICAgICAgICAgdm9s
KyAgICAgICAgICAgICAgICAgICAgIDB4MDAwMTAwNzMKICAgICAgICAgIHZvbC0gICAgICAgICAg
ICAgICAgICAgICAweDAwMDEwMDcyCiAgICAgICAgICBjaC1iYWNrICAgICAgICAgICAgICAgICAg
MHgwMDAxMDE2QgogICAgICAgICAgbXV0ZSAgICAgICAgICAgICAgICAgICAgIDB4MDAwMTAwNzEK
ICAgICAgZW5kIGNvZGVzCgplbmQgcmVtb3RlCgoK

--Multipart=_Sun__22_Jun_2008_14_01_00_+0200_RTOje3i5afPg3c9p
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Multipart=_Sun__22_Jun_2008_14_01_00_+0200_RTOje3i5afPg3c9p--
