Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46851 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605Ab2C3IWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Mar 2012 04:22:03 -0400
Received: by wgbdr13 with SMTP id dr13so353783wgb.1
        for <linux-media@vger.kernel.org>; Fri, 30 Mar 2012 01:22:01 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Matias Aguirre <fastslack@gmail.com>
Subject: Re: Module dvb-usb
Date: Fri, 30 Mar 2012 10:21:57 +0200
Cc: linux-media@vger.kernel.org
References: <CAKBz3my92vV5gEMsN2kfbEGeHGd=q9A2zmYuYN7pn703cNG6RA@mail.gmail.com>
In-Reply-To: <CAKBz3my92vV5gEMsN2kfbEGeHGd=q9A2zmYuYN7pn703cNG6RA@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201203301021.57083.pboettcher@kernellabs.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matias,

On Friday 30 March 2012 09:42:14 Matias Aguirre wrote:
> My name is Matias and im a programmer. I need to ask some things to
> you about the creation of new modules into the kernel for TV
> adapters. I have a new TV adapter with the chipset DM1305.
> 
> I have the firmware of this chipset.. can i start with that or i need
> more info?

First of all you should ask on the linux-media mailing list whether 
there is already someone working on a driver for this device. (CC'd)

If not having the firmware-binary is not enough, you also need to know 
how to communicate with it and what kind of messages have to be sent to 
the firmware to make it do something. If you do not have any 
documentation about it (and you cannot get hold of it from the vendor), 
you need to reverse-engineer the communication.

This is where the vp7045-example comes into the game: the vp7045 has a 
relatively simple firmware interface which can help you to quickly make 
a driver for you device.

But, there is two different dvb usb device types:

1) the USB-firmware contains the demod/tuner-drivers and the firmware 
interface is high-level. (this is the case for the vp7045)
or

2) the USB-firmware only implements a bridge for I2C/SPI or other 
control protocols and the demod/tuner-drivers have to be handled from 
the host. 

If your device is of the 2nd kind you should rather look at cxusb.c .

HTH
--
Patrick

Kernel Labs Inc.
http://www.kernellabs.com/
