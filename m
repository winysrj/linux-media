Return-path: <linux-media-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:17960
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947Ab3DTXvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 19:51:51 -0400
Received: from mail135-va3 (localhost [127.0.0.1])	by
 mail135-va3-R.bigfish.com (Postfix) with ESMTP id E5DE21402BA	for
 <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 23:51:49 +0000 (UTC)
Received: from VA3EHSMHS040.bigfish.com (unknown [10.7.14.233])	by
 mail135-va3.bigfish.com (Postfix) with ESMTP id D0BDC4200E5	for
 <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 23:51:23 +0000 (UTC)
Message-ID: <517329ED.2060202@studio.unibo.it>
Date: Sun, 21 Apr 2013 01:51:09 +0200
From: Luca Risolia <luca.risolia@studio.unibo.it>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: User space Video4Linux drivers
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

for those who might be interested in user space
Video4Linux drivers, here is UV4L:

http://linux-projects.org

UV4L stands for "Userspace Video4Linux framework". It consists of a core
module which loads a specified Video4Linux driver as plug-in.
Each instance of a driver is exactly one process. Drivers can implement
real or virtual video input devices.

No special help from the kernel is required for controlling the
devices and applications should work transparently.

For now two drivers have been developed:
- UVC, for video devices based on the Usb Video Class specification.
- XScreen, a virtual device capturing a given portion of an X screen.

The support for UVC-based hardware is minimal at the moment.

Packages for Ubuntu Raring 13.04 can be installed by following
these instructions:

http://www.linux-projects.org/listing/uv4l_repo/INSTALL

Once they have been installed, "man uv4l" should give
more details about the use of uv4l and its features.

--

