Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37999 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2CEAiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2012 19:38:09 -0500
Date: Sun, 4 Mar 2012 18:38:01 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Skippy le Grand Gourou <lecotegougdelaforce@free.fr>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [bug?] ov519 fails to handle Hercules Deluxe webcam
Message-ID: <20120305003801.GB27427@burratino>
References: <20120304223239.22117.54556.reportbug@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120304223239.22117.54556.reportbug@deepthought>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Skippy le Grand Gourou wrote[1]:

> Hercules Deluxe USB webcam won't work, see the end of the kernel
> log.
[...]
> [521041.808976] gspca: probing 05a9:4519
> [521042.469094] ov519: I2C synced in 3 attempt(s)
> [521042.469097] ov519: starting OV7xx0 configuration
> [521042.469793] ov519: Unknown image sensor version: 2
> [521042.469795] ov519: Failed to configure OV7xx0
> [521042.469797] ov519: OV519 Config failed
> [521042.469807] ov519: probe of 3-1.4:1.0 failed with error -16
> [521042.469884] gspca: probing 05a9:4519
> [521467.885255] usbcore: deregistering interface driver ov519
> [521467.885278] ov519: deregistered
> [521467.900288] gspca: main deregistered
> [521809.376462] dialog[12612]: segfault at 0 ip b77c6125 sp bf8861b0 error 4 in libncursesw.so.5.7[b77b5000+43000]
> [524303.418813] usb 3-1.3: USB disconnect, address 9
[...]
> [528511.174900] usb 3-1.4: USB disconnect, address 10
> [528513.420812] usb 3-1.4: new full speed USB device using ehci_hcd and address 13
> [528513.515013] usb 3-1.4: New USB device found, idVendor=05a9, idProduct=4519
> [528513.515018] usb 3-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [528513.515021] usb 3-1.4: Product: USB Camera
> [528513.515023] usb 3-1.4: Manufacturer: OmniVision Technologies, Inc.
> [528513.515116] usb 3-1.4: configuration #1 chosen from 1 choice
> [528513.524620] Linux video capture interface: v2.00
> [528513.526783] gspca: main v2.7.0 registered
> [528513.527299] gspca: probing 05a9:4519
> [528514.190995] ov519: I2C synced in 3 attempt(s)
> [528514.190998] ov519: starting OV7xx0 configuration
> [528514.192570] ov519: Sensor is an OV7610
> [528514.417110] ov519: probe of 3-1.4:1.0 failed with error -5
> [528514.417139] usbcore: registered new interface driver ov519
> [528514.417143] ov519: registered
[...]
> 00:1a.0 USB Controller [0c03]: Intel Corporation Cougar Point USB Enhanced Host Controller #2 [8086:1c2d] (rev 05) (prog-if 20 [EHCI])
>         Subsystem: ASUSTeK Computer Inc. Device [1043:844d]
[...]
> Bus 001 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 003 Device 012: ID 9e88:9e8f  
> Bus 003 Device 013: ID 05a9:4519 OmniVision Technologies, Inc. Webcam Classic
> Bus 003 Device 005: ID 04a9:221c Canon, Inc. CanoScan LiDE 60
> Bus 003 Device 006: ID 046d:c50e Logitech, Inc. Cordless Mouse Receiver
[...]

Kernel is Debian 2.6.32-41, which is closely based on stable
2.6.32.54.  I don't see any obvious potential fixes in the diff
relative to linux-next.

Known problem?  Any hints for tracking this down?

Thanks,
Jonathan

[1] http://bugs.debian.org/662246
