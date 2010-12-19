Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35934 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab0LSBYw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 20:24:52 -0500
Received: by wwa36 with SMTP id 36so1887976wwa.1
        for <linux-media@vger.kernel.org>; Sat, 18 Dec 2010 17:24:50 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 19 Dec 2010 01:24:49 +0000
Message-ID: <AANLkTim0uLBpk0RiGS9YbteoLFyWLK_c_k_wTEa0w4Dh@mail.gmail.com>
Subject: "failed to open frontend"
From: Mikhail Ramendik <mr@ramendik.ru>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

I have a DVB-S card, don't remember the brand offhand but the saa7134
driver works for it. I also have Debian lenny, which, with kernel
2.6.30 from backports.org, displayed satelite video successfully.

However, once I installed kernel 2.6.32 from backports.org (which I
needed for certain network hardware), DVB no longer works, even though
the card is unchanged.

I have added saa7134_dvb to /etc/modules and it does load, and is
visible in lsmod. Still, dvbscan shows "failed to open frontend" (even
under root). And /dev/dvb does not exist. It does not even appear when
I boot 2.6.30 - so it seems that the configuration that came with the
2.6.32 package broke things.

How can I make /dev/dvb available again?

-- 
Yours, Mikhail Ramendik

Unless explicitly stated, all opinions in my mail are my own and do
not reflect the views of any organization
