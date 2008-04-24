Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1JovlX-0007d3-Ls
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 09:21:12 +0200
Received: from PCTL ([194.250.18.140]) (authenticated)
	by smtp06.msg.oleane.net (MTA) with ESMTP id m3O7L78P005284
	for <linux-dvb@linuxtv.org>; Thu, 24 Apr 2008 09:21:08 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Thu, 24 Apr 2008 09:21:06 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAvS+B+Nz04k29X/weWcnp3gEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <480F1BFF.7000907@scram.de>
Subject: [linux-dvb] RE :  RE :  Terratec Cinergy T USB XE Rev 2,
	any update ?
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

>I compiled this with gcc 4.2.3. This is what i did:
>...
>wget ftp://ftp.terratec.net/Receiver/Cinergy_T_USB_XE/Update/Cinergy_T_USB_XE_MKII_Drv_Linux.zip
>...
>hg clone http://linuxtv.org/hg/~anttip/af9015
>...

Thanks, it indeed works that way.

I missed:
- Replace dvb common code (where all compile errors were) by
  the "official" equivalent.
- Use Antti's hg repository instead of "official" one to get
  the af9015 driver.

There are still a lot of warnings from Terratec's driver indicating
poor coding techniques but it works.

Any idea when those two drivers will be integrated in the main tree?
Concerning the Terratec's driver, I have not seen any licence note,
neither GPL nor proprietary. Any chance to make it GPL?

-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
