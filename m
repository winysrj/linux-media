Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpc5-sgyl16-0-0-cust107.sgyl.cable.virginmedia.com ([77.99.223.108]:55075
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756440Ab0BOUIc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 15:08:32 -0500
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id o1FKqJX8006094
	for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 20:52:19 GMT
Received: (from msar@localhost)
	by localhost.localdomain (8.14.3/8.14.3/Submit) id o1FKqJfn006092
	for linux-media@vger.kernel.org; Mon, 15 Feb 2010 20:52:19 GMT
Subject: USB TV stick with 18271HD-C2 chip
From: Michael Robb <msar2020@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Feb 2010 20:52:18 +0000
Message-ID: <1266267138.5956.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   I am trying to get a USB TV stick to work: with Linux - Inside the
case, it has a NXP TDA18271HDC2 tuning chip, but no decoder. Shows up as
a "Cali TV Card" with idVendor 0x438, idProduct 0xac14

Three devices get created under major 189 minor 6 /dev/char/189:6
DEVPATH=/devices/pci0000:00/0000:00:03.3/usb1/1-1
DEVPATH=/devices/pci0000:00/0000:00:03.3/usb1/1-1/1-1:1.0

I figure that it requires the 'tda18271' driver to work
(v4l-dvb/tda18271-common.c ...), but haven't had much such
success trying to use modprobe and lsmod.

The product data sheet for the chip is at:

http://www.nxp.com/documents/data_sheet/TDA18271HD.pdf
Can anyone help?

Cheers,
   Michael

