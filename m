Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtp16-06-2.prod.phx3.secureserver.net ([173.201.193.64]:55250
	"EHLO p3plwbeout16-06.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbcDGPls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2016 11:41:48 -0400
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Message-Id: <20160407083643.fccade4f64c1f11ce2bc6da07fd9ab91.977bcc175f.wbe@email16.secureserver.net>
From: "Matthew Giassa" <matthew@giassa.net>
To: linux-media@vger.kernel.org
Cc: "Mathias Nyman" <mathias.nyman@intel.com>, greg@kroah.com
Subject: USB xHCI regression after upgrading from kernel 3.19.0-51 to 4.2.0-34.
Date: Thu, 07 Apr 2016 08:36:43 -0700
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good day,

I maintain an SDK for USB2.0 and USB3.0 U3V machine vision cameras, and
several of my customers have reported severe issues since upgrading from
kernel 3.19.0-51 (Ubuntu 14.04.3 LTS) to kernel 4.2.0-34 (Ubuntu 14.04.4
LTS). I've received helpful advice from members of the libusb and
linux-usb mailing list and development groups on how to generate useful
logs to help diagnose the issue, and have filed a bug to track this
issue at:

  https://bugzilla.kernel.org/show_bug.cgi?id=115961

It seems that with kernels newer than the 3.19 series (I've tested on
4.2.0-34, and just repeated the tests on the latest 4.5.0 release), the
cameras lock up, and cannot stream image data to the user application. I
am able to resolve the issue on 4.2.0-34 by disabling USB power
management by adding "usbcore.autosuspend=-1". On the 4.5 kernel, this
"trick" doesn't work at all, and I have no way to get the cameras to
stream data. I can do simple USB control requests to query things like
register values and serial numbers, but that's it. Asynchronous bulk
transfers never succeed.

Special Cases:
 * The issue does not occur when using USB2.0 cameras on a USB2.0 port,
regardless of the kernel in use.
 * The issues occur only on Intel 8 Series and Intel 9 Series USB3.0
host controllers with 4.x kernels.
 * Intel 10 Series host controllers have not yet been tested.
 * The issues never occur on Fresco or Renesas host controllers,
regardless of the kernel in use.
 * From visual inspection of lsusb output, the issue only appears to
happen when the U1 and U2 options are available to the device.

I would like to request assistance with diagnosing and resolving the
issue, as it requires our customers to either not use Intel host
controllers, or sticking to older kernel releases.

Thank you for your time and assistance.

============================================================
Matthew Giassa, MASc, BASc, EIT
Security and Embedded Systems Specialist
linkedin: https://ca.linkedin.com/in/giassa
e-mail:   matthew@giassa.net
website:  www.giassa.net

