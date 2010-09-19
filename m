Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0ISMHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 08:07:10 -0400
Message-ID: <4C95FCD7.5060001@redhat.com>
Date: Sun, 19 Sep 2010 09:06:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Deti Fliegl <deti@fliegl.de>, archer@in.tum.de, fliegl@in.tum.de
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: removal of dabusb driver from Linux Kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Deti and Georg,

The dabusb driver at the Linux kernel seems to be pretty much unmaintained. Since 2006, when I
moved it to /drivers/media, I received no patches from the driver authors. All the patches
we've got since then were usual trivial fixes and a few other drivers correcting some core
API changes.

Also, I never found anyone with the hardware, in order to test if the driver keeps working.
Is there any commercial hardware using it?

With the removal of BKL, the driver will need fixes or will likely be removed. 

So, if you still care about the driver, please contact me asap. Otherwise, I'll move it to
drivers/staging and mark it to die for 2.6.38.

Thanks,
Mauro
