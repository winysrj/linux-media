Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:48577 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606Ab3FWWdT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jun 2013 18:33:19 -0400
Received: from fls-nb.lan.streibelt.net (91-64-122-25-dynip.superkabel.de [91.64.122.25])
	by mail.net.t-labs.tu-berlin.de (Postfix) with ESMTPSA id B30934C607B
	for <linux-media@vger.kernel.org>; Mon, 24 Jun 2013 00:25:58 +0200 (CEST)
Date: Mon, 24 Jun 2013 00:25:56 +0200
From: Florian Streibelt <florian@inet.tu-berlin.de>
To: linux-media@vger.kernel.org
Subject: "patch" to support CX23103  Video Grabber - USB_DEVICE(0x1D19,
 0x6109)
Message-ID: <20130624002556.06c7a224@fls-nb.lan.streibelt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
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


regards,

   Florian


-- 
Florian Streibelt
Chair "Intelligent Networks" (INET)
TEL 16
Technische Universität Berlin
Ernst-Reuter-Platz 7
10587 Berlin
