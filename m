Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <penio@setelcom.org>) id 1PnXSL-0005TS-QT
	for linux-dvb@linuxtv.org; Thu, 10 Feb 2011 15:25:14 +0100
Received: from ns.setelcom.org ([195.230.2.69])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1PnXSL-0006Jj-6u; Thu, 10 Feb 2011 15:25:13 +0100
Received: from localhost (localhost [127.0.0.1])
	by ns.setelcom.org (Postfix) with ESMTP id 4111429DD4
	for <linux-dvb@linuxtv.org>; Thu, 10 Feb 2011 16:24:43 +0200 (EET)
Received: from ns.setelcom.org ([127.0.0.1])
	by localhost (ns.setelcom.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z5OyGjIxeH-b for <linux-dvb@linuxtv.org>;
	Thu, 10 Feb 2011 16:24:43 +0200 (EET)
Received: from [192.168.16.226] (setelcom.gcn.bg [93.155.252.130])
	by ns.setelcom.org (Postfix) with ESMTP id C45FF29DA4
	for <linux-dvb@linuxtv.org>; Thu, 10 Feb 2011 16:24:42 +0200 (EET)
Message-ID: <4D53F56C.6040503@setelcom.org>
Date: Thu, 10 Feb 2011 16:25:48 +0200
From: "penio@setelcom.org" <penio@setelcom.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Support to TT-budget S-1500b ?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hi!
I bought PCI card  TT-budget S-1500 from dvbshop.net, but they send me 
new modification TT-budget S-1500b. The difference is in tuner - new 
code is BSBE1-D01A. The tuner itself is STB6000, but the QPSK 
demodulator is STx0288.
The card identify itself as:
Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
     Subsystem: Technotrend Systemtechnik GmbH Unknown device 101b
Is there any plan to support this device?

Thank you,
Penio Slavchev

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
