Return-path: <linux-media-owner@vger.kernel.org>
Received: from web94912.mail.in2.yahoo.com ([203.104.17.180]:24608 "HELO
	web94912.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757462Ab0GBHIS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jul 2010 03:08:18 -0400
Message-ID: <31718.25391.qm@web94912.mail.in2.yahoo.com>
Date: Fri, 2 Jul 2010 12:31:34 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: V4L2 radio drivers for TI-WL7
To: linux-media@vger.kernel.org, matti.j.aaltonen@nokia.com,
	mchehab@infradead.org
Cc: pavan savoy <pavan_savoy@yahoo.co.in>, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

We have/in process of developing a V4L2 driver for the FM Radio on the Texas Instruments WiLink 7 module.

For transport/communication with the chip, we intend to use the shared transport driver currently staged in mainline at drivers/staging/ti-st/.

To which tree should I generate patches against? is the tree
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
fine ? to be used with the v4l_for_2.6.35 branch ?

Also, this is over the UART/TTY unlike the WL1273 i2c mfd driver...

Please suggest.

Thanks & Regards,
Pavan Savoy


