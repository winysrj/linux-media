Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55708 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaGaPTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 11:19:38 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so3856923pab.1
        for <linux-media@vger.kernel.org>; Thu, 31 Jul 2014 08:19:38 -0700 (PDT)
Received: from DFTWBCREAD (wsip-70-167-188-130.sd.sd.cox.net. [70.167.188.130])
        by mx.google.com with ESMTPSA id pz10sm5842985pbb.33.2014.07.31.08.19.35
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 31 Jul 2014 08:19:36 -0700 (PDT)
From: "Chris R" <chrisrfq@gmail.com>
To: <linux-media@vger.kernel.org>
Subject: Cross Compiling V4L-DVB Device Drivers for Older (2.6.37) Kernel
Date: Thu, 31 Jul 2014 08:19:35 -0700
Message-ID: <018101cfacd2$d77125a0$865370e0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to build the V4L-DVB drivers for an embedded system
(OMAP3530/DM3730) that uses the 2.6.37 kernel.  I'm using the build
instructions from
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-D
VB_Device_Drivers and am following the more manually intensive approach
column.

The first make crashes (make tar DIR=/home/me/mykernel) with missing file
errors.  It lists about 20 missing files such as include/linux/dma-buf.h and
include/trace/events/v4l2.h.  It doesn't look like those files show up in
the kernel source until versions 3.3 and 3.14 respectively.  What is the
best approach to resolve the missing file errors for my 2.6.37 kernel and
still have the drivers build and run?

Thanks,
Chris


