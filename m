Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41233 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935182Ab1IOW0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 18:26:03 -0400
Received: by fxe4 with SMTP id 4so1083494fxe.19
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2011 15:26:02 -0700 (PDT)
From: Krzysztof =?utf-8?B?R2xvd2nFhHNraQ==?= <goviczek@gmail.com>
To: linux-media@vger.kernel.org
Subject: ARDATA My Vision Hybrid TV support
Date: Fri, 16 Sep 2011 00:25:58 +0200
Message-ID: <11546653.u4LCKO9akC@czarny.dom>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've got "My Vision Hybrid TV" DVB-T tuner.

lsub shows:
Bus 002 Device 002: ID 1b80:d412 Afatech 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1b80 Afatech
  idProduct          0xd412 
  bcdDevice           40.01
  iManufacturer           1 Conexant Corporation
  iProduct                2 Polaris AV Capture
  iSerial                 3 0000000000
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          344
    bNumInterfaces          7
    bConfigurationValue     1
    iConfiguration          4 Polaris AV Capture
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA


There are 3 chips inside:
cx3102-11z NOK770.25 
cx24232-11z (or14z) 
tda18271HDC2

Any chance to be it supported.  Is it any well-known device with just strange 
bus-id and need just add it to the driver or it is some exotic device?

Greetings

Krzysztof Głowiński

