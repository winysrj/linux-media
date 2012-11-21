Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62318 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2KVTur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:50:47 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3065417eek.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 11:50:46 -0800 (PST)
Message-ID: <50AD4CBE.9030806@gmail.com>
Date: Wed, 21 Nov 2012 22:50:54 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: 'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [GIT PULL FOR v3.8] [RESEND] V4L2 driver for S3C24XX/S3C64XX SoC
 series camera interface
References: <50AD4845.5080209@gmail.com>
In-Reply-To: <50AD4845.5080209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(resending as it seems the original message didn't make it through
  to the mailing list)

The following changes since commit 2c4e11b7c15af70580625657a154ea7ea70b8c76:

   [media] siano: fix RC compilation (2012-11-07 11:09:08 +0100)

are available in the git repository at:
   git://linuxtv.org/snawrocki/media.git mainline/s3c-camif

This is a V4L2 driver for camera host interface embedded in some
older generation Samsung SoC series - S3C24XX and S3C64XX.

Some more information about the driver can be found in a cover letter
to the first patch version [1].

Sylwester Nawrocki (2):
       V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface
       MAINTAINERS: Add entry for S3C24XX/S3C64XX SoC CAMIF driver

  MAINTAINERS                                      |    8 +
  drivers/media/platform/Kconfig                   |   12 +
  drivers/media/platform/Makefile                  |    1 +
  drivers/media/platform/s3c-camif/Makefile        |    5 +
  drivers/media/platform/s3c-camif/camif-capture.c | 1675
++++++++++++++++++++++
  drivers/media/platform/s3c-camif/camif-core.c    |  662 +++++++++
  drivers/media/platform/s3c-camif/camif-core.h    |  393 +++++
  drivers/media/platform/s3c-camif/camif-regs.c    |  606 ++++++++
  drivers/media/platform/s3c-camif/camif-regs.h    |  269 ++++
  include/media/s3c_camif.h                        |   45 +
  10 files changed, 3676 insertions(+), 0 deletions(-)
  create mode 100644 drivers/media/platform/s3c-camif/Makefile
  create mode 100644 drivers/media/platform/s3c-camif/camif-capture.c
  create mode 100644 drivers/media/platform/s3c-camif/camif-core.c
  create mode 100644 drivers/media/platform/s3c-camif/camif-core.h
  create mode 100644 drivers/media/platform/s3c-camif/camif-regs.c
  create mode 100644 drivers/media/platform/s3c-camif/camif-regs.h
  create mode 100644 include/media/s3c_camif.h

[1] 
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg11849.html

Thanks,
Sylwester
