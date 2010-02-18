Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <redtux1@googlemail.com>) id 1Ni5yg-00047O-32
	for linux-dvb@linuxtv.org; Thu, 18 Feb 2010 13:59:35 +0100
Received: from mail-fx0-f220.google.com ([209.85.220.220])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Ni5yd-0007Ni-FG; Thu, 18 Feb 2010 13:59:33 +0100
Received: by fxm20 with SMTP id 20so8628395fxm.1
	for <linux-dvb@linuxtv.org>; Thu, 18 Feb 2010 04:59:30 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 18 Feb 2010 12:59:30 +0000
Message-ID: <ecc841d81002180459t59fcfdd3k26da94b7ef0b351c@mail.gmail.com>
From: Mike Martin <redtux1@googlemail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Question about telnet interface of dvbstream
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi

I develop an application using dvbstream and am looking into the
telnet interface.

My question is whether the telnet interface can attach to a running
instance of dvbstream (on the same multiplex obviously)

Or does it have the same issues with locking dvb card

thanks

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
