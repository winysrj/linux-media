Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:55342 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751587Ab1AHRz4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Jan 2011 12:55:56 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org
Subject: mchehab/new_built and kernels < 2.6.35
Date: Sat, 8 Jan 2011 18:55:54 +0100
Cc: mchehab@redhat.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101081855.54622.martin.dauskardt@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I tried to compile git://linuxtv.org/mchehab/new_build.git on a 2.6.32

As alread reported by somebody earlier, there is a problem with hdpvr-i2c.c :

/home/martin/linuxtv_new_build/new_build/v4l/hdpvr-i2c.c: In function 
'hdpvr_new_i2c_ir':
/home/martin/linuxtv_new_build/new_build/v4l/hdpvr-i2c.c:62: error: too many 
arguments to function 'i2c_new_probed_device'
make[3]: *** [/home/martin/linuxtv_new_build/new_build/v4l/hdpvr-i2c.o] Error 
1

It seems this driver was simply forgotten in the patch 
backports/v2.6.35_i2c_new_probed_device.patch

Removing the last argument (NULL) -like it was done in the other drivers- 
fixes compilation. I could build the drivers against Ubuntus 2.6.32-27-
generic-pae (which is the latest kernel for the 10.04 LTS)
