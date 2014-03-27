Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.mail.pcextreme.nl ([109.72.87.137]:51613 "EHLO
	smtp01.mail.pcextreme.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbaC0TeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 15:34:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Mar 2014 20:28:30 +0100
From: Beralt Meppelink <beralt@beralt.nl>
To: <linux-media@vger.kernel.org>
Cc: <fschaefer.oss@googlemail.com>
Subject: em28xx: too many ISO URB's queued
Message-ID: <cb2fb87211e8df1267cb96e91589c9d2@beralt.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recent changes in the em28xx module introduced a bug which I'm 
encountering with my PCTV 510e DVB-C stick. It seems that starting a 
stream increases the queue in the host controller up to the point to 
which it would overflow (at least for ehci).

I'v done some preliminary work to trace the issue, and produced the 
following trace:

kernel: em2884 #0/2-dvb: Using 5 buffers each with 64 x 940 bytes
kernel: em2884 #0 em28xx_init_usb_xfer :em28xx: called 
em28xx_init_usb_xfer in mode 2
kernel: ehci-pci 0000:00:1d.0: request ffff8800ccc59000 would overflow 
(8136+63 >= 8192)
kernel: submit of urb 0 failed (error=-27)
kernel: em2884 #0 em28xx_uninit_usb_xfer :em28xx: called 
em28xx_uninit_usb_xfer in mode 2

This is with a 3.13 kernel, but I can reproduce the same issue when 
using a backport of the git tree using media_build. Unfortunately my USB 
knowledge is limited, so it would be great if someone could point me in 
the right direction. I filed a bug report too [1].

[1] https://bugzilla.kernel.org/show_bug.cgi?id=72891
