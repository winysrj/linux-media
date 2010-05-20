Return-path: <linux-media-owner@vger.kernel.org>
Received: from 2advanced.blue.kundencontroller.de ([85.31.186.149]:49108 "EHLO
	mail.2advanced.at" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932093Ab0ETVTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 May 2010 17:19:16 -0400
Received: from framePC (chello062178116054.8.12.vie.surfer.at [62.178.116.54])
	by mail.2advanced.at (Postfix) with ESMTPSA id 90B318348E7
	for <linux-media@vger.kernel.org>; Thu, 20 May 2010 23:19:14 +0200 (CEST)
From: "Rene Kremser // Event Solutions OG" <rene@event-solutions.at>
To: <linux-media@vger.kernel.org>
Subject: Loosing connection on hauppauge hdvpr (fixed firmware)
Date: Thu, 20 May 2010 23:18:57 +0200
Message-ID: <006a01caf862$0f763910$2e62ab30$@at>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I got a problem with my Hauppauge hdpvr device:

After getting an involuntary firmware update of my cable-tv box (UPC
Austria), the hdvpr device looses connection when a commercial appears or
when the channel will be changed. They have installed a commercial-marker or
other stupid thing.

The hdpvr-configuration is YPbPr-analog-input and
S/PDIF/toslink-digital-input.

I am using the HD Fury 2-device to get the HDMI-source from the cable box.
This might be the problem device and the Fury maybe cut off the connection
for short time - but it isn't visible by me. Anyway, the firmware should be
able to CATCH such connection-abort-problems?

Plugging the HDMI-source to the TV directly will not show any problems.

There are no information in the log (hdpvr debug setting is highest: 7)

There is another phenomenon with the digital sound: Plugging the toslink
cable from tv-box to the hdpvr device will interrupt the sound for 1-2
seconds after 5 seconds repeatedly.

I'dont know if this problem is part of the kernel module but it would be
nice if this could be fixed.

I'm available for some testing and try-out-sessions to find out more..

Best Rene

