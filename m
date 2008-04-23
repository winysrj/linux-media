Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp04.msg.oleane.net ([62.161.4.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1JoZjW-0001FP-A6
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 09:49:39 +0200
Received: from PCTL ([194.250.18.140]) (authenticated)
	by smtp04.msg.oleane.net (MTA) with ESMTP id m3N7nY34031656
	for <linux-dvb@linuxtv.org>; Wed, 23 Apr 2008 09:49:34 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 23 Apr 2008 09:49:32 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAXUecTuyghkSp+E+0SVbs1QEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <480DD592.7040209@scram.de>
Subject: [linux-dvb] RE :  Terratec Cinergy T USB XE Rev 2, any update ?
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

>> Main problem is that there is no tuner driver for Freescale MC44S803 
>> silicon tuner. Looks like there is code for MC44S803 on the net 
>> available (for example Terratec driver). Porting it to Linux should not 
>> be too big task.
>
>The Terratec driver *is* a linux driver, just for an older kernel version.
>I just did a very quick and dirty forward port of the driver (by replacing
>the included dvb-core and dvb-usb files with the ones of the current dvb
>hg tree) and the result compiled OK on 2.6.24. Even better, it even works :)

Which "Terratec driver" are you refering to ?

Is this a Terratec-provided driver ?

As I mentioned in my original post, the one at
ftp://ftp.terratec.net/Receiver/Cinergy_T_USB_XE/Update/Cinergy_T_USB_XE_MKII_Drv_Linux.zip
does not compile _at_all_ and this is not (or not only) a matter of kernel
version. There are many semantic errors that no C compiler would accept
(except maybe the K&R from the 70's). I started to fix the errors but when
I realized how bad it was, my trust in this code dropped and I gave up.

-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
