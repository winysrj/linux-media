Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48058 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755549AbZF1NOK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 09:14:10 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jean-Francois Moine <moinejf@free.fr>
Subject: Problem with 046d:08af Logitech Quickcam Easy/Cool - broken with in-kernel drivers, works with gspcav1
Date: Sun, 28 Jun 2009 15:14:10 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906281514.10689.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I just tried out the in-kernel gspca drivers for my 046d:08af Logitech, Inc. 
QuickCam Easy/Cool, however I don't get any picture with cheese and only 
green noise with skype.

Before using the in-kernel drivers the webcam used to work quite well with the 
old out-of-kernel gspcav1 drivers.

I compared both drivers and the old ones used the SENSOR_HV7131B, whereas the 
new driver detects the  HV7131R(c)

snippet old driver:
		case 0x08af:
			spca50x->desc = LogitechQCCool;
			spca50x->bridge = BRIDGE_ZC3XX;
			spca50x->sensor = SENSOR_HV7131B;


output dmesg after plugin camera in
	usb 4-2: new full speed USB device using uhci_hcd and address 6
	usb 4-2: configuration #1 chosen from 1 choice
	gspca: probing 046d:08af
	zc3xx: probe 2wr ov vga 0x0000
	zc3xx: probe sensor -> 11
	zc3xx: Find Sensor HV7131R(c)
	gspca: probe ok
	usbcore: registered new interface driver zc3xx
	zc3xx: registered


I already tried out the module_param force_sensor for the values 4,5,6 - but 
neither gave an appropriate result.


I hope you can help me resolve this issue - I would be glad if I could help 
testing/debugging the problem.


Best Regards,
Peter



