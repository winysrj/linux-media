Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns3.dns-engine.com ([87.106.189.53]:39200 "EHLO
	ns3.dns-engine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340AbcBHVSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 16:18:32 -0500
From: Carl Brunning <carlb@cblinux.co.uk>
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: cxd2843 how far the driver got
Date: Mon, 8 Feb 2016 21:18:27 +0000
Message-ID: <44fd3a3ffa3c46a29402744781aba9e7@exchange02.cblinux.co.uk>
References: <57e8ac1e7a684ffeab9bc5e3a8072623@exchange02.cblinux.co.uk>
 <22201.1297.403374.342819@morden.metzler>
In-Reply-To: <22201.1297.403374.342819@morden.metzler>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for that 
I have them driver and have got loaded but for some reason when using w_scan it very quick but not tunning any DVBT or DVBT2
So was checking to see if there was newer
Not sure how to debug the code to see why it not doing any scan

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
