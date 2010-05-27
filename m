Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:27228 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab0E0KcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 06:32:07 -0400
Received: by ey-out-2122.google.com with SMTP id d26so324763eyd.19
        for <linux-media@vger.kernel.org>; Thu, 27 May 2010 03:32:05 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 27 May 2010 07:32:04 -0300
Message-ID: <AANLkTimiHV-_tbDciEjzmWt1YMO1GFXs2gtQuiteCjsn@mail.gmail.com>
Subject: Xceive XC5000 ISDB-T on Linux ??
From: Fernando Cassia <fcassia@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm asking about this here because I've seen firmware blobs for this
device's chipset, but I'm not sure about driver availability or if
anyone got ISDB-T reception to work.

The device I have is a USB tuner, brand: Geniatech / MyGica USB made in Taiwan.
Model: Geniatech U6813.

It comes with dual tuners, analog (multi-standard it seems) and
digital (ISDB-T), it's also got a FM tuner, although I'm not sure
which chip implements it.

This is the device
http://p.sf.net/dtvargentina/GeniatechDualUSB

The ISDB-T demodulator seems to be a Fujitsu MB86A20 (the chip is
there, I've opened the device to look) and the tuner seems to be an
Xceive XC5000
http://www.xceive.com/technology_XC5000.htm


Here's the Xceive XC5000 mentioned
http://www.linuxtv.org/downloads/firmware/README.txt

And here there's talk about a driver for the XCeive XC5000, although
the card mentioned is PCIe, not USB
http://www.kernellabs.com/blog/?page_id=166

And here a mention of the XCeive XC5000 on kernel 2.6.34-rc6
http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/drivers/media/common/tuners/xc5000.c

So, how do I test if it would work? What are the required steps?.
Anyone here using a XC5000 usb device?

Thanks
FC

-- 
"Los diarios traen sólo dos informaciones que son reales e
indiscutibles: el día, y el precio".
