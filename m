Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:8656 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZDJOKQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 10:10:16 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1295537qwh.37
        for <linux-media@vger.kernel.org>; Fri, 10 Apr 2009 07:10:15 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Apr 2009 10:10:14 -0400
Message-ID: <de8cad4d0904100710u1cdd9568ud3190b1e97e792e3@mail.gmail.com>
Subject: ir-kbd-i2c Compile Warnings
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

Fresh clone of V4L this morning running on a fully patched ArchLinux
64-bit system:

/root/drivers/v4l-dvb/v4l/ir-kbd-i2c.o
/root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c: In function 'ir_attach':
/root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c:429: warning:
'i2c_attach_client' is deprecated (declared at
include/linux/i2c.h:434)
/root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c:468: warning:
'i2c_detach_client' is deprecated (declared at
include/linux/i2c.h:435)
/root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c: In function 'ir_detach':
/root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c:484: warning:
'i2c_detach_client' is deprecated (declared at
include/linux/i2c.h:435)

Brandon

uname -a
Linux sagetv-server 2.6.29-ARCH #1 SMP PREEMPT Wed Apr 8 12:39:28 CEST
2009 x86_64 Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel
GNU/Linux
