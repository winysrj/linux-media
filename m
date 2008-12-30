Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LHkNT-0000da-MJ
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 20:35:47 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1059725ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 11:35:40 -0800 (PST)
Date: Tue, 30 Dec 2008 20:34:49 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAaoT72bWgvUOpMz3wlvxejAEAAAAA@tv-numeric.com>
Message-ID: <alpine.DEB.2.00.0812302027170.29535@ybpnyubfg.ybpnyqbznva>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAaoT72bWgvUOpMz3wlvxejAEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE :  Compile error,
 bug in compat.h with kernel 2.6.27.9 ?
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

On Tue, 30 Dec 2008, Thierry Lelegard wrote:

> OK, looking into the source RPM for the latest Fedora 10 update
> kernel (kernel-2.6.27.9-159.fc10.src.rpm), it appears that
> the definition of pci_ioremap_bar in pci.h was introduced by
> linux-2.6.27.7-alsa-driver-fixups.patch
> 
> I assume that this is a Fedora-specific patch (or more generally Red Hat),
> back-porting 2.6.28 stuff.

There may be hope for a dirty hack...

As part of this, I also see
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -644,6 +644,7 @@ struct input_absinfo {
 #define SW_RADIO               SW_RFKILL_ALL   /* deprecated */
 #define SW_MICROPHONE_INSERT   0x04  /* set = inserted */
 #define SW_DOCK                        0x05  /* set = plugged into dock */
+#define SW_LINEOUT_INSERT      0x06  /* set = plugged into dock 
*/

which is not yet in my latest 2.6.28 git kernel...

These both seem to be present since -r1.1 through HEAD,
so I would guess you can special-case this check into
a 2.6.27 version test.


Of course, I have no idea what I'm talking about...

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
