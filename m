Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:56142 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023AbZBYTxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 14:53:22 -0500
Received: from mail-in-10-z2.arcor-online.net (mail-in-10-z2.arcor-online.net [151.189.8.27])
	by mx.arcor.de (Postfix) with ESMTP id F2A5F2AF213
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2009 20:53:19 +0100 (CET)
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net [151.189.21.56])
	by mail-in-10-z2.arcor-online.net (Postfix) with ESMTP id DC9DE23D2EB
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2009 20:53:19 +0100 (CET)
Received: from webmail09.arcor-online.net (webmail09.arcor-online.net [151.189.8.45])
	by mail-in-16.arcor-online.net (Postfix) with ESMTP id C435D257421
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2009 20:53:19 +0100 (CET)
Message-ID: <10076348.1235591599750.JavaMail.ngmail@webmail09.arcor-online.net>
Date: Wed, 25 Feb 2009 20:53:19 +0100 (CET)
From: schollsky@arcor.de
To: linux-media@vger.kernel.org
Subject: Old firmware - again af9013 4.65.0 ?!?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

in the meantime I've switched over to Arch Linux - you probably appreciate the choice. I did this because of the lean system and a more recent kernel (now 2.6.28 series). After compiling the latest v4l-dvb version, an

$ lsmod | grep af

results to the following:

af9013                 21636  1 
dvb_usb_af9015         26400  0 
dvb_usb                20492  1 dvb_usb_af9015
i2c_core               22804  6 mc44s803,af9013,dvb_usb_af9015,dvb_usb,i2c_nforce2,nvidia
usbcore               136848  5 dvb_usb_af9015,dvb_usb,ohci_hcd,ehci_hcd

The correct tuner module seems to be loaded. So far, so good. But dmesg | grep af shows it all:

[..]
af9013: firmware version:4.65.0
usbcore: registered new interface driver dvb_usb_af9015

This is the same when installing no firmware, or installing the file from

http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/

into /lib/firmware, which should load 4.95.0 firmware. 

What's going wrong?


