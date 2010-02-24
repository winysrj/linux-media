Return-path: <linux-media-owner@vger.kernel.org>
Received: from kso.tls-tautenburg.de ([194.94.209.8]:27389 "EHLO
	kso.tls-tautenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab0BXUdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 15:33:21 -0500
Received: from localhost (localhost [127.0.0.1])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id DE0545078B
	for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 21:23:54 +0100 (CET)
Received: from kso.tls-tautenburg.de ([127.0.0.1])
	by localhost (kso.tls-tautenburg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0XL35LZJL0OI for <linux-media@vger.kernel.org>;
	Wed, 24 Feb 2010 21:23:49 +0100 (CET)
Received: from [192.168.178.51] (unknown [88.130.156.22])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by kso.tls-tautenburg.de (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 21:23:48 +0100 (CET)
Message-ID: <4B858AD1.5070502@tls-tautenburg.de>
Date: Wed, 24 Feb 2010 21:23:45 +0100
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Elgato EyeTV DTT deluxe v2 - i2c enumeration failed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I recently purchased the Elgato EyeTV DTT deluxe v2 stick. I am running
Ubuntu 8.10 with Linux 2.6.28-15-generic. I installed v4l-dvb from mercurial
with a slight change of linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h to account
for the USB ID of the device (#define USB_PID_ELGATO_EYETV_DTT_Dlx 0x002c).
After insertion the stick is recognized, however no frontend is activated since
the i2c enumeration failed. This might be related to a missing udev rule. Any
support is appreciated. This is the corresponding part from dmesg

kernel: [24106.302688] usb 2-1: new high speed USB device using ehci_hcd and address 45
kernel: [24106.459222] usb 2-1: configuration #1 chosen from 1 choice
kernel: [24106.459730] dvb-usb: found a 'Elgato EyeTV Dtt Dlx PD378S' in cold state, will try to load a firmware
kernel: [24106.459738] usb 2-1: firmware: requesting dvb-usb-dib0700-1.20.fw
kernel: [24106.523808] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
kernel: [24106.733953] dib0700: firmware started successfully.
kernel: [24107.244517] dvb-usb: found a 'Elgato EyeTV Dtt Dlx PD378S' in warm state.
kernel: [24107.244631] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
kernel: [24107.244862] DVB: registering new adapter (Elgato EyeTV Dtt Dlx PD378S)
kernel: [24107.327206] dib0700: stk7070p_frontend_attach: dib7000p_i2c_enumeration failed.  Cannot continue
kernel: [24107.327211]
kernel: [24107.327216] dvb-usb: no frontend was attached by 'Elgato EyeTV Dtt Dlx PD378S'
kernel: [24107.327223] dvb-usb: Elgato EyeTV Dtt Dlx PD378S successfully initialized and connected.
kernel: [24107.327703] dib0700: ir protocol setup failed
kernel: [24130.411288] dvb-usb: Elgato EyeTV Dtt Dlx PD378S successfully deinitialized and disconnected.


