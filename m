Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38764 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2FKHJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 03:09:29 -0400
Received: by bkcji2 with SMTP id ji2so3223204bkc.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 00:09:28 -0700 (PDT)
Message-ID: <4FD599A6.8060601@googlemail.com>
Date: Mon, 11 Jun 2012 09:09:26 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, ron@insweb.dyndns.org
Subject: Fwd: [Bug 871427] Re: 1164:7efd YUANRD STK7700D DVB TV card
References: <20120611014154.6602.99490.malone@chaenomeles.canonical.com>
In-Reply-To: <20120611014154.6602.99490.malone@chaenomeles.canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this bug is lingering in the Ubuntu bugtracker since over half a year. 
Does anyone know if this dongle just lacks an usb id entry in some 
driver, a completely new driver or will never be supported due to the 
lack of specs?

Thanks,
Gregor

-------- Original Message --------
Subject: [Bug 871427] Re: 1164:7efd YUANRD STK7700D DVB TV card
Date: Mon, 11 Jun 2012 01:41:54 -0000
From: Ralph Richardson <ralph.richardson@internode.on.net>
Reply-To: Bug 871427 <871427@bugs.launchpad.net>
To: gjasny@googlemail.com

So what is the current status? It still is not working on my Toshiba
Satelite P770

-- 
You received this bug notification because you are a member of libv4l,
which is subscribed to the bug report.
https://bugs.launchpad.net/bugs/871427

Title:
   1164:7efd YUANRD STK7700D DVB TV card

Status in “linux” package in Ubuntu:
   Incomplete

Bug description:
   Hi,

   would it be possible to get support for YUAN idProduct 0x7efd DVB TV
   card in the new kernel ? idProduct seems missing in dvb-usb-ids.h

   Bus 001 Device 004: ID 1164:7efd YUAN High-Tech Development Co., Ltd
   Device Descriptor:
     bLength                18
     bDescriptorType         1
     bcdUSB               2.00
     bDeviceClass            0 (Defined at Interface level)
     bDeviceSubClass         0
     bDeviceProtocol         0
     bMaxPacketSize0        64
     idVendor           0x1164 YUAN High-Tech Development Co., Ltd
     idProduct          0x7efd
     bcdDevice            1.00
     iManufacturer           1 YUANRD
     iProduct                2 STK7700D
     iSerial                 3 0000000001
     bNumConfigurations      1

   BR
   Ron
