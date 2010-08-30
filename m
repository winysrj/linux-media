Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:40569 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754355Ab0H3V0I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 17:26:08 -0400
Subject: cx23885: Support for IR-Remote on boad TBV-6920
From: Simon Waid <simon_waid@gmx.net>
To: maximlevitsky@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 23:26:05 +0200
Message-ID: <1283203565.5457.34.camel@simon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello!

I am trying to get the remote control of my DVB 6920 (cx23885) to work. 

I found out that the wiring of the sensor is the same as on the TiVii
S470, so there is little work to be done. Unfortunately, the IR part of
cx23885 driver inside the kernel is buggy. You fixed that, right? Could
you please give me access to your current cx23885 driver? 

Best regards,
Simon Waid

