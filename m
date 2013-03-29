Return-path: <linux-media-owner@vger.kernel.org>
Received: from infra.metatux.net ([78.46.58.246]:55034 "EHLO infra.metatux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282Ab3C2TYf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 15:24:35 -0400
Message-ID: <5155E8D2.9030707@metatux.net>
Date: Fri, 29 Mar 2013 20:17:38 +0100
From: Lars Buerding <lindvb@metatux.net>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Dirk E. Wagner" <linux@wagner-budenheim.de>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Fw: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio
References: <20121228102928.4103390e@redhat.com> <CALW4P+KzhmzAeQUQDRxEyfiHNSkCeua81p=xzukp0k3tF7JEEg@mail.gmail.com> <63b74db2773903666ea02810e1e6c047@mail.mx6-sysproserver.de> <CALW4P+LtcO_=c9a30xgFvQ+61r8=BxNifsn6x_8bbtceNkJ-jA@mail.gmail.com> <alpine.LNX.2.00.1303181449140.9529@pobox.suse.cz> <CALW4P+L1QKe=1wNkr90LsZY89OFnGBKB2N6yVeDhnyab_rSsnA@mail.gmail.com> <alpine.LNX.2.00.1303271117570.23442@pobox.suse.cz> <CALW4P+L53ea5eqktdOkNms3ZmBzmg9dX3NJJEx89Yog_4UqLMg@mail.gmail.com>
In-Reply-To: <CALW4P+L53ea5eqktdOkNms3ZmBzmg9dX3NJJEx89Yog_4UqLMg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.03.2013 21:33, Alexey Klimov wrote:


> [patch 1/2] hid: fix Masterkit MA901 hid quirks
> [patch 2/2] media: radio-ma901: return ENODEV in probe if usb_device
> doesn't match

> I spend some time testing them trying to figure out right scenarios
> and i hope i did correct checks.
> It will be nice if someone can test patches because i don't have any
> devices with same USB IDs as radio-ma901.

Thanks Alexey, I am using an infrared receiver running the same software
Dirk uses, applied your [patch 1/2] against a vanilla kernel v3.4.38 on my
vdr machine. The hidraw device is generated again as expected.

This is my USB device:

   idVendor           0x16c0 VOTI
   idProduct          0x05df
   bcdDevice            1.08
   iManufacturer           1 www.mikrocontroller.net/articles/USB_IR_Remote_Receiver
   iProduct                2 USB IR Remote Receiver


>
> Thanks and best regards,
> Alexey.
>

Thanks,
Lars

