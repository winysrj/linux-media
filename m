Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55139 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaGaPM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 11:12:28 -0400
Received: by mail-pd0-f180.google.com with SMTP id y13so3633519pdi.25
        for <linux-media@vger.kernel.org>; Thu, 31 Jul 2014 08:12:28 -0700 (PDT)
Received: from DFTWBCREAD (wsip-70-167-188-130.sd.sd.cox.net. [70.167.188.130])
        by mx.google.com with ESMTPSA id ez1sm5811171pbd.91.2014.07.31.08.12.26
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 31 Jul 2014 08:12:27 -0700 (PDT)
From: "Chris R" <chrisrfq@gmail.com>
To: <linux-media@vger.kernel.org>
References: <047d7b16059f97447804ff7e75d5@google.com>
In-Reply-To: <047d7b16059f97447804ff7e75d5@google.com>
Subject: FW: Delivery Status Notification (Failure)
Date: Thu, 31 Jul 2014 08:12:26 -0700
Message-ID: <016d01cfacd1$d752bda0$85f838e0$@gmail.com>
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

