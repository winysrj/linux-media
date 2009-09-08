Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:39135 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZIHSSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2009 14:18:32 -0400
Message-ID: <4AA69BBE.3050501@wimmer-christian.de>
Date: Tue, 08 Sep 2009 20:00:30 +0200
From: Christian Wimmer <office2@wimmer-christian.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: strange colors in webcam with driver gspca_pac7311
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I use the driver gspca_pac7311 from kernel  linux-2.6.30.5 but the video 
of my webcam
is very blue, or, if I swap the colors in gqcam they are very yellow.
Is it possible to change the driver to compensate for this?

Info:
If I do lsusb I get
Bus 002 Device 025: ID 093a:2620 Pixart Imaging, Inc.
When inserting the device I see in the log:

usb 2-1.1.4: new full speed USB device using ehci_hcd and address 27
usb 2-1.1.4: New USB device found, idVendor=093a, idProduct=2620
usb 2-1.1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-1.1.4: configuration #1 chosen from 1 choice
gspca: probing 093a:2620
gspca: probe ok

Thanks for your help,

Chris
