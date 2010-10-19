Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36799 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab0JSRmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 13:42:33 -0400
Received: by eyx24 with SMTP id 24so61678eyx.19
        for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 10:42:31 -0700 (PDT)
From: Damjan Marion <damjan.marion@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: rtl2832u support
Date: Tue, 19 Oct 2010 19:42:28 +0200
Message-Id: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi,

Is there any special reason why driver for rtl2832u DVB-T receiver chipset is not included into v4l-dvb?

Realtek published source code under GPL:

MODULE_AUTHOR("Realtek");
MODULE_DESCRIPTION("Driver for the RTL2832U DVB-T / RTL2836 DTMB USB2.0 device");
MODULE_VERSION("1.4.2");
MODULE_LICENSE("GPL");

Thanks,

Damjan