Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp02.msg.oleane.net ([62.161.4.2])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1JnzQH-0005Ub-5t
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 19:03:22 +0200
Received: from PCTL ([194.250.18.140]) (authenticated)
	by smtp02.msg.oleane.net (MTA) with ESMTP id m3LH3HQk032509
	for <linux-dvb@linuxtv.org>; Mon, 21 Apr 2008 19:03:17 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Mon, 21 Apr 2008 19:03:16 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAAijN3xCp8g0Kp9uKDTg5IowEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Subject: [linux-dvb] Terratec Cinergy T USB XE Rev 2, any update ?
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

As part of my collection of DVB-T devices, I have got a
Terratec Cinergy T USB XE Rev 2.

This one is known as not yet supported on Linux. The Rev 1
which used the AF9005 is supported but not the Rev 2 which
uses the AF9015.

The article at http://www.linuxtv.org/wiki/index.php/Afatech_AF9015
is a bit worrying: "At present there are three different Linux drivers
available for the AF901x. That may strike one as being strange or
showing signs of a state of dis-coordination, but in actuality,
each driver has its own reason for coming into existence. In addition,
taken collectively, the development of three different drivers highlights
the relative complexity of the chip, as well as the flexibility in device
design that its employment permits."

In addition to that, the Terratec support site provides a Linux driver at
ftp://ftp.terratec.net/Receiver/Cinergy_T_USB_XE/Update/Cinergy_T_USB_XE_MKII_Drv_Linux.zip
The ReadMe.txt claims "Device VID/PID : 0CCD/0068 or 0CCD/0069 (no IR)"
and 0CCD:0069 is the Cinergy T USB XE Rev 2.

However, this driver does not compile. The driver is supposed to work
on Fedora Core 6 and I have Fedora 8 (kernel 2.6.24) but this does not
explain everything. Most compile errors are intrinsic to the code and
do not depend on the kernel. Given some horrible errors (like assigning
a pointer to a structure with the -integer- size of the structure),
I doubt that this driver has ever worked. How can a commercial company
put such a crap online ?

Is there any news with the AF9015 and more specifically the Cinergy
T USB XE Rev 2 ?

Does anyone get it working ?

Thanks in advance,
-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
