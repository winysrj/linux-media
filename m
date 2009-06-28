Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:52048 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbZF1SQI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 14:16:08 -0400
Date: Sun, 28 Jun 2009 20:14:47 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with 046d:08af Logitech Quickcam Easy/Cool - broken
 with in-kernel drivers, works with gspcav1
Message-ID: <20090628201447.792efe63@free.fr>
In-Reply-To: <200906281514.10689.PeterHuewe@gmx.de>
References: <200906281514.10689.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 28 Jun 2009 15:14:10 +0200
Peter Hüwe <PeterHuewe@gmx.de> wrote:

> I just tried out the in-kernel gspca drivers for my 046d:08af
> Logitech, Inc. QuickCam Easy/Cool, however I don't get any picture
> with cheese and only green noise with skype.
> 
> Before using the in-kernel drivers the webcam used to work quite well
> with the old out-of-kernel gspcav1 drivers.
> 
> I compared both drivers and the old ones used the SENSOR_HV7131B,
> whereas the new driver detects the  HV7131R(c)
> 
> snippet old driver:
> 		case 0x08af:
> 			spca50x->desc = LogitechQCCool;
> 			spca50x->bridge = BRIDGE_ZC3XX;
> 			spca50x->sensor = SENSOR_HV7131B;
> 
> 
> output dmesg after plugin camera in
> 	usb 4-2: new full speed USB device using uhci_hcd and address
> 6 usb 4-2: configuration #1 chosen from 1 choice
> 	gspca: probing 046d:08af
> 	zc3xx: probe 2wr ov vga 0x0000
> 	zc3xx: probe sensor -> 11
> 	zc3xx: Find Sensor HV7131R(c)
> 	gspca: probe ok
> 	usbcore: registered new interface driver zc3xx
> 	zc3xx: registered
> 
> I already tried out the module_param force_sensor for the values
> 4,5,6 - but neither gave an appropriate result.
> 
> I hope you can help me resolve this issue - I would be glad if I
> could help testing/debugging the problem.

Hi Peter,

Did you use the v4l2 wrapper when running the applications? (look in my
page for more information)

Otherwise, the sensor value set in the old gspcav1 driver was not used:
the sensor was and is still found by probing the webcam hardware.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
