Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guebby@gmail.com>) id 1KO2Ht-0002nS-MR
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 05:23:42 +0200
Received: by nf-out-0910.google.com with SMTP id g13so191511nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 29 Jul 2008 20:23:37 -0700 (PDT)
From: Jose Osvaldo <guebby@gmail.com>
To: linux-dvb@linuxtv.org
Date: Wed, 30 Jul 2008 05:16:12 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807300516.13142.guebby@gmail.com>
Subject: [linux-dvb] lower SNR
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

I have an AVerMedia AverTV Hybrid+FM PCI A16D (saa7135h+xc3028+mt352) and it 
works fine, but with the new driver (kernel 2.6.26) it has lower SNR than 
with the Markus Rechberger's driver. I have measured it with "dvbtune" and it 
is not only a number; in fact there are some channels that I could hardly 
tune but looked ok, which have now some MPEG artifacts. The SNR fall is from 
29000 dB to 26000 dB approximately in this channel.

Thanks.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
