Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fides.aptilo.com ([62.181.224.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonas@anden.nu>) id 1JM63n-0004U4-O2
	for linux-dvb@linuxtv.org; Mon, 04 Feb 2008 19:28:51 +0100
Received: from [192.168.1.8] (h-134-69.A157.cust.bahnhof.se [81.170.134.69])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by fides.aptilo.com (Postfix) with ESMTP id E06E51F9063
	for <linux-dvb@linuxtv.org>; Mon,  4 Feb 2008 19:28:19 +0100 (CET)
From: Jonas Anden <jonas@anden.nu>
To: linux-dvb@linuxtv.org
In-Reply-To: <1202031541.17762.23.camel@anden.nu>
References: <BC723861-F3E2-4B1C-BA54-D74B8960579A@firshman.co.uk>
	<47A38A25.2030804@firshman.co.uk> <1201902231.935.12.camel@youkaida>
	<200802021020.20298.shaun@saintsi.co.uk>
	<1202031541.17762.23.camel@anden.nu>
Content-Type: multipart/mixed; boundary="=-Rvk/wPbKDufuSIBvaJFH"
Date: Mon, 04 Feb 2008 19:28:09 +0100
Message-Id: <1202149689.6981.10.camel@anden.nu>
Mime-Version: 1.0
Subject: [linux-dvb] [PATCH] Nova-T 500 issues - losing one tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-Rvk/wPbKDufuSIBvaJFH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi all, 

> I have a hunch about this problem...
...
> This, ... leads me to believe that this is timer-induced. Something
> can't keep up. Adding debugging makes the operations slightly slower
> (the module needs to do additional IO to speak to syslogd), and this
> delay seems to be enough to keep it operational.

Attached is an extremely simple patch which seems to resolve the issue
for me. Before turning streaming on/off, I have inserted a tiny delay or
10 ms-

Just using 'debug=1' wasn't enough to keep tuner 2 from dying. I set it
up yesterday morning with debug=1, and when I got back home in the
evening the second tuner was dead again. I then made the attached patch
and the system has been stable since then (~24 hrs).

I also made a slight change by removing a "| 0x00" from the code. It
performs absolutely nothing (and is probably removed by the compiler in
optimization) but confuse when reading the code, imho... Patrick, if you
really want it there I can recreate the patch with the or statement
back ;)

Feel free to try it out.

  // J

--=-Rvk/wPbKDufuSIBvaJFH
Content-Disposition: attachment; filename=tunerdeath.patch
Content-Type: text/x-patch; name=tunerdeath.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r c08115f8f1f3 linux/drivers/media/dvb/dvb-usb/dib0700_core.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Sun Jan 27 17:24:26 2008 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Mon Feb 04 19:17:03 2008 +0100
@@ -243,7 +243,7 @@ int dib0700_streaming_ctrl(struct dvb_us
 	u8 b[4];
 
 	b[0] = REQUEST_ENABLE_VIDEO;
-	b[1] = (onoff << 4) | 0x00; /* this bit gives a kind of command, rather than enabling something or not */
+	b[1] = (onoff << 4); /* this bit gives a kind of command, rather than enabling something or not */
 	b[2] = (0x01 << 4); /* Master mode */
 	b[3] = 0x00;
 
@@ -256,6 +256,7 @@ int dib0700_streaming_ctrl(struct dvb_us
 
 	b[2] |= st->channel_state;
 
+	msleep(10);
 	deb_info("data for streaming: %x %x\n",b[1],b[2]);
 
 	return dib0700_ctrl_wr(adap->dev, b, 4);

--=-Rvk/wPbKDufuSIBvaJFH
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-Rvk/wPbKDufuSIBvaJFH--
