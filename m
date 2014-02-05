Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40933 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaBELtn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 06:49:43 -0500
Date: Wed, 5 Feb 2014 19:49:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dinesh Ram <Dinesh.Ram@cern.ch>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [linuxtv-media:master 224/499] WARNING: Comparing jiffies is almost
 always wrong; prefer time_after, time_before and friends
Message-ID: <20140205114941.GC27938@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Dinesh,

FYI, there are new warnings show up in

tree:   git://linuxtv.org/media_tree.git master
head:   c29b8f3149f2916e98fc3b8d6c1df2137d003979
commit: 5173332c1e420d49829bd7e4bc5c83b0205037c5 [224/499] [media] si4713: Modified i2c driver to handle cases where interrupts are not used
:::::: branch date: 2 hours ago
:::::: commit date: 7 weeks ago

scripts/checkpatch.pl 0001-media-si4713-Modified-i2c-driver-to-handle-cases-whe.patch
# many are suggestions rather than must-fix

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+		msleep(1);
WARNING: Comparing jiffies is almost always wrong; prefer time_after, time_before and friends
#95: drivers/media/radio/si4713/si4713.c:262:
+	} while (jiffies <= until_jiffies);

WARNING: line over 80 characters
#153: drivers/media/radio/si4713/si4713.c:489:
+	    !wait_for_completion_timeout(&sdev->work, usecs_to_jiffies(usecs) + 1))

WARNING: line over 80 characters
#175: drivers/media/radio/si4713/si4713.c:491:
+			"(%s) Device took too much time to answer.\n", __func__);

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+		msleep(3);

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
