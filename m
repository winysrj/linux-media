Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.re3.yahoo.com ([66.196.96.89]:28882 "HELO
	smtp116.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751934Ab0ADA6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jan 2010 19:58:19 -0500
Message-ID: <4B413B99.3020604@bellsouth.net>
Date: Sun, 03 Jan 2010 19:51:37 -0500
From: Bill Whiting <textux@bellsouth.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Lenovo compact webcam 17ef:4802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have not been able to get an image from a Lenovo webcam under Fedora 11.
It reports to the kernel with USB id 17ef:4802 as below:

  kernel: usb 1-3: new high speed USB device using ehci_hcd and address 9
  kernel: usb 1-3: New USB device found, idVendor=17ef, idProduct=4802
  kernel: usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
  kernel: usb 1-3: Product: Lenovo USB Webcam
  kernel: usb 1-3: Manufacturer: Primax
  kernel: usb 1-3: configuration #1 chosen from 1 choice
  kernel: gspca: probing 17ef:4802
  kernel: vc032x: check sensor header 20
  kernel: vc032x: Sensor ID 143a (3)
  kernel: vc032x: Find Sensor MI1310_SOC
  kernel: gspca: probe ok

When I try to access the web cam with cheese or skype I get the 
following error in /var/log/messages:
     gspca: frame overflow 332800 > 331776
Sometimes cheese shows an image resolution under the preferences menu 
option.

If the resolution is shown, then cheese will display a black image.

If I run gstreamer-properties from the command line, it complains of 
missing plugins:
gstreamer-properties-Message: Skipping unavailable plugin 'artsdsink'
gstreamer-properties-Message: Skipping unavailable plugin 'esdsink'
gstreamer-properties-Message: Skipping unavailable plugin 'glimagesink'
gstreamer-properties-Message: Skipping unavailable plugin 'v4lmjpegsrc'
gstreamer-properties-Message: Skipping unavailable plugin 'qcamsrc'
gstreamer-properties-Message: Skipping unavailable plugin 'esdmon'

Are these significant?
What package would supply them?

//Bill

