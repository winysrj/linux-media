Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39876 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1IUHJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 03:09:53 -0400
Received: by fxe4 with SMTP id 4so1321450fxe.19
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 00:09:52 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 21 Sep 2011 15:09:52 +0800
Message-ID: <CAOc6HJ4GkT=Qdx11v-sJZnO_AjzhUpNm1VgRN1AVSDqBuauhiA@mail.gmail.com>
Subject: The USB device VID in Linux is difference with in Windows
From: Zhouping Liu <sanweidaying@gmail.com>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi, guys,
I have a Hauppauge product, but it can't support on Linux, and I'd
like have a try
to compose a new driver for it.
the product details info:
 - name: Hauppauge DMB-T MiniStick(it only use on HongKong and China)
 - VID: 2040
 - PID: 5020
...
I got the above info from Win 7, but when I hot plug it into Linux, it
can't enable but with
these info:
$ dmesg
...
...
[406600.393164] usb 1-8: new high speed USB device using ehci_hcd and address 13
[406600.507446] usb 1-8: config 1 interface 0 altsetting 1 bulk
endpoint 0x81 has invalid maxpacket 64
[406600.507454] usb 1-8: config 1 interface 0 altsetting 1 bulk
endpoint 0x1 has invalid maxpacket 64
[406600.507459] usb 1-8: config 1 interface 0 altsetting 1 bulk
endpoint 0x2 has invalid maxpacket 64
[406600.507464] usb 1-8: config 1 interface 0 altsetting 1 bulk
endpoint 0x8A has invalid maxpacket 64
[406600.507687] usb 1-8: New USB device found, idVendor=3344, idProduct=5020
[406600.507692] usb 1-8: New USB device strings: Mfr=0, Product=0,
SerialNumber=3
[406600.507695] usb 1-8: SerialNumber: 䥈児

yes, the idVendor is 3344, not 2040, but I'm sure it's 2040 in
Windows, and the Hauppauge's vendor id is 2040,
and it can't read out the SerialNumber.
so I'm doubt the firmware in the product has some special data. I'm a
newer to usb, can anyone know why?
or what's the trouble with it?
any comments are welcome.

thanks,
best Regards.
Zhouping
