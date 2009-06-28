Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39123 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751729AbZF1UaD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 16:30:03 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: Problem with 046d:08af Logitech Quickcam Easy/Cool - broken with in-kernel drivers, works with gspcav1
Date: Sun, 28 Jun 2009 22:30:02 +0200
Cc: linux-media@vger.kernel.org
References: <200906281514.10689.PeterHuewe@gmx.de> <20090628201447.792efe63@free.fr>
In-Reply-To: <20090628201447.792efe63@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906282230.02528.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Did you use the v4l2 wrapper when running the applications? (look in my
> page for more information)

Not that I know - atleast not explicitly.

> Otherwise, the sensor value set in the old gspcav1 driver was not used:
> the sensor was and is still found by probing the webcam hardware.

Yeah - you're right, i'm sorry - I enabled debug messages on the old gspcav1 
driver and it says 
gspca: [zc3xx_config:669] Find Sensor HV7131R(c)
so you're right - mea culpa :)

However I created an usbmon output for both and they seem to differ a bit (not 
only in the usb-enum)
You can find the files here:
http://www.hs-augsburg.de/~phuewe/usbmon-output.tar.gz

Would be very nice if we could find the source of my problem and fix it.

Best Regards,
Peter







