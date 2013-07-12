Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:44686 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932612Ab3GLQ0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 12:26:35 -0400
Received: from fls-nb.lan.streibelt.net (91-64-122-25-dynip.superkabel.de [91.64.122.25])
	by mail.net.t-labs.tu-berlin.de (Postfix) with ESMTPSA id CD9CD4C63E0
	for <linux-media@vger.kernel.org>; Fri, 12 Jul 2013 18:26:33 +0200 (CEST)
Date: Fri, 12 Jul 2013 18:26:32 +0200
From: Florian Streibelt <florian@inet.tu-berlin.de>
To: linux-media@vger.kernel.org
Subject: CX23103  Video Grabber seems to be supported by cx231xx  driver
Message-ID: <20130712182632.667842dc@fls-nb.lan.streibelt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the chip CX23103 that is used in various devices sold e.g. in germany works with the cx231xx stock driver.

The author of that driver is not reachable via the email adress stated in the source file: srinivasa.deevi@conexant.com
[ host cnxtsmtp1.conexant.com [198.62.9.252]: 550 5.1.1 <srinivasa.deevi@conexant.com>:  Recipient address rejected: User unknown in relay recipient table]

In drivers/media/video/cx231xx/cx231xx-cards.c the struct usb_device_id cx231xx_id_table[] needs these lines added:

   {USB_DEVICE(0x1D19, 0x6109),
   .driver_info = CX231XX_BOARD_PV_XCAPTURE_USB},

While the change is minimal due to the fact that no real technical documentation is available on the chip the support was guessed - but worked for video.

The videostream can pe played using mplayer tv:///0  - proof: http://streibelt.de/blog/2013/06/23/kernel-patch-for-cx23103-video-grabber-linux-support/

However when trying to capture audio using audacity while playing the video stream in mplayer my system locked (no message in syslog, complete freeze). 


I posted this one month ago to this list without any reaction so I ask if this is the correct way to get that grabber really supported.

I am willing to do any tests neccessary and try out patches.


/Florian
