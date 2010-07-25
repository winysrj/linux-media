Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <arnuschky@xylon.de>) id 1OcvnD-00023w-61
	for linux-dvb@linuxtv.org; Sun, 25 Jul 2010 09:38:39 +0200
Received: from xylos.xylon.de ([80.237.242.185] helo=mail.xylon.de)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OcvnC-0002Gy-Bj; Sun, 25 Jul 2010 09:38:38 +0200
Received: from localhost (xylos.xylon.de [127.0.0.1])
	by mail.xylon.de (Postfix) with ESMTP id AC1816A0008
	for <linux-dvb@linuxtv.org>; Sun, 25 Jul 2010 09:38:34 +0200 (CEST)
Received: from mail.xylon.de ([127.0.0.1])
	by localhost (mail.xylon.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SpyYIVCV1TlP for <linux-dvb@linuxtv.org>;
	Sun, 25 Jul 2010 09:38:33 +0200 (CEST)
Message-ID: <20100725093833.61271ktl891c25ts@webmail.xylon.de>
Date: Sun, 25 Jul 2010 09:38:33 +0200
From: Arnuschky <arnuschky@xylon.de>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Very poor quality on buget card TwinHan VP DST
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I am using a TwinHan VP DST card under Ubuntu Lucid Lynx (2.6.32-23  
with s2-liplianin-dkms updated dvb drivers).

The card is detected fine, but does not seem to have analogue tuner. I  
can scan channels fine, and I can watch TV using digital-only capable  
applications (Me-TV, Kaffeine). Nevertheless, the general quality is  
VERY bad. Basically, there's not a single frame without decoding error  
and the picture freezes often. Sound suffers the same problem. It all  
behaves like a bad signal/bad antenna installation.

The problem is: a parallel windows installation gives a crystal-clear  
and stable picture, without touching the antenna in between.

I assume it's a channel fine-tune problem or decoder quality. Can  
anyone help me with solving these problems?

Thanks
Arne


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
