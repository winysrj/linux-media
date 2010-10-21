Return-path: <mchehab@pedra>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:59394 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757376Ab0JUNqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 09:46:55 -0400
Received: from mail-in-06-z2.arcor-online.net (mail-in-06-z2.arcor-online.net [151.189.8.18])
	by mx.arcor.de (Postfix) with ESMTP id B7AB41AB9E1
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 15:46:54 +0200 (CEST)
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net [151.189.21.44])
	by mail-in-06-z2.arcor-online.net (Postfix) with ESMTP id AD85E157809
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 15:46:54 +0200 (CEST)
Received: from [192.168.10.10] (dslb-088-076-250-016.pools.arcor-ip.net [88.76.250.16])
	(Authenticated sender: felix_droste@arcor.de)
	by mail-in-04.arcor-online.net (Postfix) with ESMTPA id 8BCCDAA44D
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 15:46:54 +0200 (CEST)
Message-ID: <4CC0444E.1040902@arcor.de>
Date: Thu, 21 Oct 2010 15:46:54 +0200
From: Felix Droste <felixdroste@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: USB DVBT af9015: tuner id:177 not supported, please report!
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I could not get this DVBT-Stick (USB) to work:

auvisio USB-DVB-T-Receiver & -Recorder "DR-340"

h t t  p : / / w w w 
.pearl.de/product.jsp?pdid=HPM1520&catid=8909&vid=922&curr=DEM

dmesg:

[25239.410175] usb 2-1: new high speed USB device using ehci_hcd and 
address 6
[25239.569729] Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 
10 -> 7
[25239.570294] input: Afatech DVB-T 2 as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.1/input/input12
[25239.570642] generic-usb 0003:15A4:9016.0003: input,hidraw2: USB HID 
v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:1d.7-1/input1
[25239.982243] af9015: tuner id:177 not supported, please report!
[25239.982339] usbcore: registered new interface driver dvb_usb_af9015


Cheers!
