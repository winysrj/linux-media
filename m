Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64756 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1H2NY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 09:24:27 -0400
Received: by yie30 with SMTP id 30so3512613yie.19
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 06:24:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+s_+RrGE2T0H+XSSjg81zh514g1oQePLCfV-y3nJC8DqXjWjQ@mail.gmail.com>
References: <CA+s_+RqtWZuj5b55Vk5A==VqbPEnDoqFfSVGtA2n-pdR85mc8g@mail.gmail.com>
	<CA+s_+RrGE2T0H+XSSjg81zh514g1oQePLCfV-y3nJC8DqXjWjQ@mail.gmail.com>
Date: Mon, 29 Aug 2011 09:24:27 -0400
Message-ID: <CA+s_+RpekDfRSWEQMZObjiR-RTgLeFUk1tc-g6ieQYLzcTqwdw@mail.gmail.com>
Subject: Usb digital TV
From: Gabriel Sartori <gabriel.sartori@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

  I am from Brazil and my english is not very good.
  First of all, I am new on the list.
  I work with embedded system development here in Brazil.
  I have a lot to learn but I expect to help too!

  I don't know if it is the right place to ask. Sorry if it is not.
  I have a i.mx28EVK board and I would like to get a usb digital tv
module to work on it. It should work in 1seg.

  First of all I bought a two usb devices:
  - pixelview sbtvd hybrid
  - Leadership

  The first one uses driver cx231xx and the second one smsdvb.
  My board have a 2.6.35 kernel with specific paths from freescale.

  First off all I tried to plug the first device in my pc. It only
worked with an newer kernel version 2.6.38 or with some specific
pathes for brazil patterns in a 2.6.36.
  I was able to see some channels here.
  But It seems very dificult to me to port all these changes and make
it work on my old 2.6.35 kernel.

  The second device has a strange behavior. It worked on my PC with
older kernels like 2.6.32. It should work in my mx28 board too.
  But I cannot scan any channel!?!?!?

  In dmesg i got:

  [  332.620053] smscore_set_device_mode: firmware download success:
isdbt_nova_12mhz_b0.inp
  [  332.620615] usbcore: registered new interface driver smsusb
  [  350.721231] DVB: registering new adapter (Siano Nova B Digital Receiver)
  [  350.724588] DVB: registering adapter 0 frontend 0 (Siano Mobile
Digital MDTV Receiver)...

  In my /dev/dvb/adapter0 I have three devices:
  - demux0
  - dvr0
  - frontend0

 If I tried to scan with:

 sudo w_scan -ft -x -c BR

 I got the follow messages:

 ERROR: Sorry - i couldn't get any working frequency/transponder

Can someone help me with this last thing?
It seems everything is ok but I cannot scan channel.
It there some devices that has more chance to work on a 2.6.35 kernel
version so I can just cross compile the driver to my mx28 board in a
easier way?

Thanks in advance.

Gabriel Sartori
