Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx496501.smtp-engine.com ([87.106.145.58]:49978 "EHLO
	mx496501.smtp-engine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbcBKUHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 15:07:21 -0500
Received: from exchange02.cblinux.co.uk (host31-48-29-113.range31-48.btcentralplus.com [31.48.29.113])
	by mx496501.smtp-engine.com (Postfix) with ESMTPSA id BEAC21800470
	for <linux-media@vger.kernel.org>; Thu, 11 Feb 2016 20:00:12 +0000 (GMT)
From: Carl Brunning <carlb@cblinux.co.uk>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: cxd2843 how far the driver got
Date: Thu, 11 Feb 2016 20:00:09 +0000
Message-ID: <0c408020f572417bb19b9dfdb9cdcae1@exchange02.cblinux.co.uk>
References: <57e8ac1e7a684ffeab9bc5e3a8072623@exchange02.cblinux.co.uk>
 <22201.1297.403374.342819@morden.metzler>
 <44fd3a3ffa3c46a29402744781aba9e7@exchange02.cblinux.co.uk>
In-Reply-To: <44fd3a3ffa3c46a29402744781aba9e7@exchange02.cblinux.co.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry to be a pain 

Could someone say what tools best for debugging the driver I do have the datasheet for the chip and am checking thought the driver 

But am a little stuck as it  been a while for me on Linux driver As am sure it something silly on why it not locking on any channel on the scan

Thanks
Carl Brunning

-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Carl Brunning
Sent: 08 February 2016 21:18
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org
Subject: RE: cxd2843 how far the driver got

Thanks for that
I have them driver and have got loaded but for some reason when using w_scan it very quick but not tunning any DVBT or DVBT2 So was checking to see if there was newer Not sure how to debug the code to see why it not doing any scan

Thanks
Carl Brunning




-----Original Message-----
From: Ralph Metzler [mailto:rjkm@metzlerbros.de]
Sent: 08 February 2016 21:14
To: Carl Brunning <carlb@cblinux.co.uk>
Cc: linux-media@vger.kernel.org
Subject: cxd2843 how far the driver got

Hi,

Carl Brunning writes:
 > Hi all
 > I saw that someone did some driver for the cxd2843 but was wanting to know if this has had any more work done  > and was there newer version of the driver around that I could test with  >  > so if there newer version of this driver where can I find or who can I talk to get the drivers working and have supported in linux  > 

This is where you can always find the latest version:

https://github.com/DigitalDevices/dddvb/tree/master/frontends


Regards,
Ralph
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
