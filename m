Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s21.blu0.hotmail.com ([65.55.111.96]:13585 "EHLO
	blu0-omc2-s21.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760325AbZDAQL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 12:11:27 -0400
Message-ID: <BLU0-SMTP24C120D13E754132593F63988B0@phx.gbl>
Subject: Driver for GL861+AF9003+MT2060]
From: C Khmer1 <ckhmer1l@live.it>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Wed, 01 Apr 2009 18:04:45 +0200
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,
I'm trying to write a linux driver for my A-Data DT1 USB2 DVB-T card.
This card has the GL861+AF9003+MT2060 chips.
I've the specification of AF9002/3/5 family, and there is a linux driver
for AF9005 chip that is an USB back-end plus AF9003 front-end.
There is already a front-end driver for AF9003 inside the AF9005 code
(should be the file AF9005-fe.c in the linux kernel tree).
The real problem is that i don't know how to perform the boot process
because it is different from AF9005 and how to handle the chip GL861
+AF9003 together.
I've seen the GL861 linux driver code. It is very simple and support
only two commands_

C0 02 for reading
40 01 for writing

Sniffing the USB data using windows driver I've discovered that the
windows driver is using following commands:

40 01
40 03
40 05
c0 02
c0 08

I don't know what do they mean and how I should use it.

Maybe with the GL861 specification I can understand. Sadly I've no
specification for GL861.

Also the commands '40 01' and 'c0 02' are used in a different way not
foreseen from the GL861 driver (the GL861 driver support up to 2 bytes
to write but I see more data to write).

I'm trying to understand the USB data before to writing the GL861 code
to handle the AF9003 front-end (demod).
Could someone help me?
Thanks
Claudio




