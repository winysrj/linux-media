Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.imavis.com ([85.94.219.26]:45243 "EHLO mail.imavis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1JLOJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 10:09:44 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.imavis.com (Postfix) with ESMTP id 4B68A1DAEF4E
	for <linux-media@vger.kernel.org>; Wed, 12 Oct 2011 15:52:47 +0200 (CEST)
Received: from mail.imavis.com ([127.0.0.1])
	by localhost (phx1-ss-2-lb.cnet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mnYLHk3A2vbb for <linux-media@vger.kernel.org>;
	Wed, 12 Oct 2011 15:52:46 +0200 (CEST)
Received: from augusto-laptop.localnet (ldap.imavis.com [89.96.73.90])
	by mail.imavis.com (Postfix) with ESMTPSA id BF8881DAEF4D
	for <linux-media@vger.kernel.org>; Wed, 12 Oct 2011 15:52:46 +0200 (CEST)
From: Augusto Destrero <destrero@imavis.com>
To: linux-media@vger.kernel.org
Subject: Controlling external GPIO in IVC-200G board
Date: Wed, 12 Oct 2011 16:03:46 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110121603.46582.destrero@imavis.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,
we recently purchased a IVC-200G board from IEI:

http://ieiworld.com/product_groups/industrial/content.aspx?gid=09049535992720993533&cid=09049577938864496628&id=08142301152930771045

we would like to use the external GPIO capabilities of such board on Linux. 
This external GPIO is used to control external devices, such as lights, gates, 
doors, ...
We already asked for support from the vendor, but they suggested us to use the 
Windows SDK :(, so we hope that some one in this list have some knowledge 
about the board and can help us.

We are using a quite recent version of Linux Kernel (2.6.35.11) and the bttv 
module is working correctly for what concerns video capturing.

Now we would like to control the external GPIO embedded in the IVC-200G board, 
but we don't know how to do it.
In the driver CD provided with the board we found a directory Linux, 
containing three subdirectories: Demo, Driver and Sdk:

The "Demo" directory contains a demo program which demonstrates how to capture 
video with the IVC-200G board, but doesn't help to understand how to control 
the external GPIO.

The "Driver" directory contains some very old _binary_ bttv drivers (specific 
for Red Hat 7.2, 7.3 and 8 versions), but this is not useful for our purpose.

The "Sdk" directory contains only a C header file (ieibt878.h, pasted here 
http://pastebin.com/cjezwusy) and a text file sdk-howto (pasted here 
http://pastebin.com/H66WzF1G).
The section 4 of sdk-howto explains something related to external GPIO, for 
example we can read "To set GPIO outputs, use structure iei_gpio and 
VIDIOC_IEI_SET_GPIO ioctl call", but it's not clear on which device (we mean 
which node in /dev directory) we should perform the ioctl call.

Can you help us in using the external GPIO in the IVC-200G board on Linux?

Thank you very much for your help!

-- 
Augusto Destrero, PhD
