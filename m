Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yolgecen@arcor.de>) id 1KlKfP-0005Tr-K4
	for linux-dvb@linuxtv.org; Thu, 02 Oct 2008 11:40:16 +0200
Received: from mail-in-07-z2.arcor-online.net (mail-in-07-z2.arcor-online.net
	[151.189.8.19])
	by mail-in-10.arcor-online.net (Postfix) with ESMTP id 1BAAB1F4FB4
	for <linux-dvb@linuxtv.org>; Thu,  2 Oct 2008 11:40:12 +0200 (CEST)
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mail-in-07-z2.arcor-online.net (Postfix) with ESMTP id BFB652C6E6D
	for <linux-dvb@linuxtv.org>; Thu,  2 Oct 2008 11:40:11 +0200 (CEST)
Received: from webmail10.arcor-online.net (webmail10.arcor-online.net
	[151.189.8.93])
	by mail-in-06.arcor-online.net (Postfix) with ESMTP id 90AE917F44
	for <linux-dvb@linuxtv.org>; Thu,  2 Oct 2008 11:40:11 +0200 (CEST)
Message-ID: <8575231.1222940411522.JavaMail.ngmail@webmail10.arcor-online.net>
Date: Thu, 2 Oct 2008 11:40:11 +0200 (CEST)
From: yolgecen@arcor.de
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Please correct the error in hg repository of v4l-dvb in
 v4l/Makefile.media
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

Could somebody please change line 446 in v4l/Makefile.media of v4l-dvb hg repository

from:
obj-$(CONFIG_DVB_STV0299) += stv0288.o

to:
obj-$(CONFIG_DVB_STV0288) += stv0288.o

It seems to be a copy&paste error.

Regards,
Yolgecen

PS: I hope this was the right way to ask for this because it's my first mail here - otherwise sorry and please tell me how to do else

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
