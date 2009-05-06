Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:58248 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZEFEPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 00:15:00 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2905067ywb.1
        for <linux-media@vger.kernel.org>; Tue, 05 May 2009 21:14:59 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 6 May 2009 00:14:59 -0400
Message-ID: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
Subject: XC5000 improvements: call for testers!
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I'm happy to announce that there have been some considerable
improvements to the xc5000 driver, and I am looking for people with
xc5000 based devices to test:

== Noteworthy changes ==

* Power management is now properly supported - no more sucking up your
laptop battery and burning your fingers on the tuner's f-connector
when the device is idle (can be disabled with the "no_poweroff"
modprobe option).

* Faster tuning - average 10x improvement in time to lock.  Average
lock time now around 350ms, down from 3200ms.  No more multi-second
delays when trying to channel surf in tvtime.

* Redistributable firmware - Xceive has graciously allowed us to
redistribute the firmware and bundle it in the distros.  No more need
for users to manually extract the blob from the Hauppauge Windows
driver.

* Various fixes to bridges and dvb core found during power management testing.

* Support for DVB-T tuning, thanks to David T.L. Wong <davidtlwong@gmail.com>

To test the code, clone from the following hg repository:

http://linuxtv.org/hg/~dheitmueller/xc5000-improvements-beta/

Unfortunately, current users are going to have to upgrade to the new
firmware.  However, this is a one time cost and I will work with the
distros to get it bundled so that users won't have to do this in the
future:

http://www.devinheitmueller.com/xc5000/dvb-fe-xc5000-1.6.114.fw
http://www.devinheitmueller.com/xc5000/README.xc5000

Thanks go out to Xceive for providing access to the xc5000
specification, reference driver code, and firmware under the
appropriate license.  Thanks also go out to Michael Krufky for his
considerable effort in helping test/debug different xc5000 hardware.

I look forward to hearing back from testers with any problems they may
encounter.  Now is the time to bring these up before it gets merged
into the mainline.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
