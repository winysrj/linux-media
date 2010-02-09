Return-path: <linux-media-owner@vger.kernel.org>
Received: from web35803.mail.mud.yahoo.com ([66.163.179.172]:28315 "HELO
	web35803.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751987Ab0BIWXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 17:23:04 -0500
Message-ID: <215789.18894.qm@web35803.mail.mud.yahoo.com>
Date: Tue, 9 Feb 2010 14:16:22 -0800 (PST)
From: Amy Overmyer <aovermy@yahoo.com>
Subject: Kworld ATSC usb 435Q device and RF tracking filter calibration
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have one of these devices. It works OK in windows, but I'd like to stick it on my myth backend as a 3rd tuner, just in case. I'm using it for 8VSB OTA. I took a patch put forth a while back on this list and was able to put that on the kernel 2.6.31.6. I am able to tune and lock channels with it, but, like the people earlier, I see the RF tracking filter calibration in the syslogs and tuning takes some time. 

Is there anything I can do to debug this? I'm a programmer by trade (err my systems are usually a bit more special purpose than a linux box as I'm an embedded systems type guy, but it's all bits anyway), so don't be afraid to suggest code changes or point me in a direction.

Thanks,


      
