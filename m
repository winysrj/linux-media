Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <sunil@khiatani.ath.cx>) id 1OdwFl-00085r-5H
	for linux-dvb@linuxtv.org; Wed, 28 Jul 2010 04:20:17 +0200
Received: from imsm058.netvigator.com ([218.102.48.211])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OdwFk-0004H9-0E; Wed, 28 Jul 2010 04:20:16 +0200
Received: from khiatani.ath.cx ([219.78.29.165]) by imsm058dat.netvigator.com
	(InterMail vM.7.05.01.01 201-2174-106-103-20060222) with ESMTP
	id <20100728021957.BTEJ27715.imsm058dat.netvigator.com@khiatani.ath.cx>
	for <linux-dvb@linuxtv.org>; Wed, 28 Jul 2010 10:19:57 +0800
Received: from localhost (localhost [127.0.0.1])
	by khiatani.ath.cx (Postfix) with ESMTP id 2C61A6240A1
	for <linux-dvb@linuxtv.org>; Wed, 28 Jul 2010 10:19:53 +0800 (HKT)
Received: from khiatani.ath.cx ([127.0.0.1])
	by localhost (khiatani.ath.cx [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5paa1Vi34YVP for <linux-dvb@linuxtv.org>;
	Wed, 28 Jul 2010 10:19:51 +0800 (HKT)
Received: from localhost (localhost [127.0.0.1])
	by khiatani.ath.cx (Postfix) with ESMTP id 1F0FA624762
	for <linux-dvb@linuxtv.org>; Wed, 28 Jul 2010 10:19:51 +0800 (HKT)
Received: from localhost (localhost [127.0.0.1])
	(Authenticated sender: sunil@khiatani.ath.cx)
	by khiatani.ath.cx (Postfix) with ESMTP id BD9AF6241B5
	for <linux-dvb@linuxtv.org>; Wed, 28 Jul 2010 10:19:50 +0800 (HKT)
Message-ID: <20100728101950.11647lqrc27uj6xw@khiatani.ath.cx>
Date: Wed, 28 Jul 2010 10:19:50 +0800
From: Sunil Khiatani <sunil@khiatani.ath.cx>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Adding Analog support to Mygica X8558.
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

I would like to try to add support to the mygica X8558. Digital TV is  
already supported for this hardware in the linux kernel but analog  
support isn't.  I haven't done kernel development before but the  
chipset it contains, cx23885, seems to be widely supported.

I'm having trouble deciding whether it is possible to enable analog  
support on this card.  It seems that there are two tuners for digital  
tv, but only one cx23885.  Will it be possible to support two analog  
tuners as well? What information should I try to obtain to help answer  
this question so I can start coding for it asap


Regards,

Sunil


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
