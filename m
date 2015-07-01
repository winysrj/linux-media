Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44846 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbbGAJFF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jul 2015 05:05:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ZADx1-0007Z9-FS
	for linux-media@vger.kernel.org; Wed, 01 Jul 2015 11:05:03 +0200
Received: from 195.74.17.95.dynamic.jazztel.es ([95.17.74.195])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 01 Jul 2015 11:05:03 +0200
Received: from onrollo-2233 by 195.74.17.95.dynamic.jazztel.es with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 01 Jul 2015 11:05:03 +0200
To: linux-media@vger.kernel.org
From: Golmer Palmer <onrollo-2233@yahoo.es>
Subject: AF9015 driver force reload firmware
Date: Wed, 1 Jul 2015 08:57:50 +0000 (UTC)
Message-ID: <loom.20150701T105330-383@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Time to time my DVB-T usb dual tuner based on AF9015 stops to receive 
data. The symptom is: you can send any command to the driver and the 
device responds OK, but it don't sends packets. I suspect that the 
problem is inside the firmware, as when I force to use the second tuner, 
the device works as expected... until some time later the second tuner 
also suffers the same problem.

In this case the only solution is disconnect the device and reconnect 
it. After this "cold" reboot, it returns to work.

I try to substitute this solution to a "hot" reset of the device with 
these commands:

# rmmod dvb_usb_af9015
# modprobe dvb_usb_af9015

But the dmesg shows:

[398121.465865] dvb-usb: found a 'Dual DVB-T Stick' in warm state.

And in this case the firmware isn't loaded in the device, then the 
device don't resets.

So I suggest to modify the driver for supporting "force reload" of 
firmware, that I suspect will be equivalent to a "cold" reset of the 
device.

Please, someone can try to implement this?
Thank you!


