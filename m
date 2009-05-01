Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51140 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbZEAHTR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 03:19:17 -0400
Message-ID: <49FAA269.6090107@s5r6.in-berlin.de>
Date: Fri, 01 May 2009 09:19:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: firedtv driver development status
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi lists,

I planned to adapt drivers/media/dvb/firewire/firedtv* to use the 
drivers/firewire stack alternatively to drivers/ieee1394, and wanted to 
be done with it sooner than later.  But business distracted too much, so 
nothing happened.  This is how far I got, in case anybody is interested 
in finishing it before I am able to get back to it (don't know exactly 
when that will be):

http://user.in-berlin.de/~s5r6/linux1394/pending/firewire-share-device-id-table-type-with-ieee1394.patch
http://user.in-berlin.de/~s5r6/linux1394/pending/firewire-also-use-vendor-id-in-root-directory-for-driver-matches.patch
http://user.in-berlin.de/~s5r6/linux1394/work-in-progress/firedtv-port-to-new-firewire-core.patch

Device--driver matching, device probe and removal, and AV/C traffic all 
work.  To do:
   - In firedtv:  Implement allocation/initialization + deallocation of
     an iso reception context; implement iso reception callback.

Also to do but independent of the port to firewire:
   - In firewire-core:  Allow multiple users of the FCP register range
     (kernelspace and userspace users) in order to access more than one
     AV/C device.  (I can do this too when I get the time.)
   - In firedtv:  Implement reception of HD channels.  (Somebody else
     needs to do it since I'm not familiar with the DVB subsystem.)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
