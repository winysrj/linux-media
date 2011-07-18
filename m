Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33963 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1GRKt0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 06:49:26 -0400
Received: by gxk21 with SMTP id 21so1215532gxk.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 03:49:26 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Jul 2011 06:49:26 -0400
Message-ID: <CAHiZ1abKhmOJt9BS6yghmwPSMooiX2GoF8HsSB9gs2jt9xW8Tw@mail.gmail.com>
Subject: Happuage HDPVR 0 byte files.
From: Greg Williamson <cheeseboy16@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,  I'm on Archlinux running 2.6.39-ARCH.  When I plug in my hdpvr I
see it registers.

Here is the dmesg output:
[  778.518866] hdpvr 1-3:1.0: firmware version 0x15 dated Jun 17 2010 09:26:53
[  778.704965] hdpvr 1-3:1.0: device now attached to video0
[  778.705006] usbcore: registered new interface driver hdpvr


However 'cat /dev/video0 > test.ts' creates 0 byte files every time.
