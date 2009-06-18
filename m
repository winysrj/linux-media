Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <whelky-82852@mypacks.net>) id 1MHN2b-0002TA-Ru
	for linux-dvb@linuxtv.org; Thu, 18 Jun 2009 21:12:54 +0200
Received: from [209.86.224.35] (helo=elwamui-huard.atl.sa.earthlink.net)
	by elasmtp-scoter.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <whelky-82852@mypacks.net>) id 1MHN22-0004uW-Lw
	for linux-dvb@linuxtv.org; Thu, 18 Jun 2009 15:12:18 -0400
Message-ID: <19719804.1245352338587.JavaMail.root@elwamui-huard.atl.sa.earthlink.net>
Date: Thu, 18 Jun 2009 15:12:18 -0400 (EDT)
From: whelky-82852@mypacks.net
To: linux-dvb@linuxtv.org
Mime-Version: 1.0
Subject: [linux-dvb] HVR-1250 IR Support? (CX23885)
Reply-To: linux-media@vger.kernel.org
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

I was wondering if anyone is working on IR support for this card? I looked through cx23885-cards.c and its not supported.

627         switch (dev->board) {
628         case CX23885_BOARD_HAUPPAUGE_HVR1250:
629         case CX23885_BOARD_HAUPPAUGE_HVR1500:
630         case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
631         case CX23885_BOARD_HAUPPAUGE_HVR1800:
632         case CX23885_BOARD_HAUPPAUGE_HVR1200:
633         case CX23885_BOARD_HAUPPAUGE_HVR1400:
634                 /* FIXME: Implement me */
635                 break;

Thanks!

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
