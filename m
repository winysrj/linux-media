Return-path: <mchehab@pedra>
Received: from v-smtp-auth-relay-6.gradwell.net ([79.135.125.112]:34747 "EHLO
	v-smtp-auth-relay-6.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab0HYUFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 16:05:24 -0400
Received: from zntrx-gw.adsl.newnet.co.uk ([80.175.181.245] helo=echelon.upsilon.org.uk country=GB ident=dave$pop3#upsilon*org^uk)
          by v-smtp-auth-relay-6.gradwell.net with esmtpa (Gradwell gwh-smtpd 1.290) id 4c757557.66f3.2c
          for linux-media@vger.kernel.org; Wed, 25 Aug 2010 20:56:07 +0100
          (envelope-sender <news004@upsilon.org.uk>)
Message-ID: <+ay15VCWVXdMFw1S@echelon.upsilon.org.uk>
Date: Wed, 25 Aug 2010 20:56:06 +0100
To: linux-media@vger.kernel.org
From: dave cunningham <news004@upsilon.org.uk>
Subject: Problems with Freecom USB DVB-T dongles
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii;format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

I'm having problems with a pair of Freecom USB dongles and am wondering 
if anyone has any pointers?

The dongles appear identical, Freecom Art No. 25452. and have the same 
USB descriptors, ID 14aa:0221.

In the boot log they show as "WideView WT-220U PenType Receiver 
(Typhoon/Freecom)", using firmware dvb-usb-wt220u-02.fw.

I have been using these dongles in a Via Epia 15000 system, running 
Debian Lenny i686 for the last 18ish months without issue.

I've just moved them to an AMD 760 based motherboard (Sempron processor) 
running Debian Squeeze x86_64.

The dongles do function up to a point.

In dmesg at boot I see one message for each device
"dvb-usb: recv bulk message failed: -110"

Other than this everything seems OK.

The system is running MythTV Backend (0.23) and I can have them both 
recording simultaneously as I would expect.

At some point however I start to get floods of messages to the console 
(repeats of "dvb-usb: recv bulk message failed: -110") and the system 
slows down to a crawl.

The only way I've found to recover from this is to shutdown mythbackend 
and physically remove the dongles from the system. At this point I get a 
few messages "dvb-usb: recv bulk message failed: -23" then I guess the 
driver is unloaded and the system appears to recover fully.

I can now plug the dongles back in and they appear to function again 
until the next time.

I've tried unloading the dvb_usb_dtt200u when I get the flood but I get 
an error saying the device is in use.

I'm not sure what's triggering the problem - sometimes it'll kick in 
after 10 minutes, the last fail came after ~10 hours.

I've tried a few versions of the V4L code base but am seeing the same in 
each.

 From googling it seems that various people have experienced similar 
issues but I've yet to find anyone offering a solution.

Any ideas?

-- 
Dave Cunningham                                  dave at upsilon org uk
                                                  PGP KEY ID: 0xA78636DC
