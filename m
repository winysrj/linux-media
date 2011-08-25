Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39624 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1HYCRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 22:17:39 -0400
Received: by ywf7 with SMTP id 7so1355537ywf.19
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 19:17:39 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Aug 2011 10:17:39 +0800
Message-ID: <CACPcZCNRvqn0o93HWxn-sRTo19XiTQVwbc0+cjtMPwAMmk88-w@mail.gmail.com>
Subject: A S3/S4 issue about em28xx driver
From: hbomb ustc <hbomb.ustc@gmail.com>
To: linux-media@vger.kernel.org, mrechberger@gmail.com,
	mchehab@redhat.com, cavedon@sssup.it
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

I find an issue about the USB TV tuner, WinTV HVR950, which use em28xx
driver. The linux can't going to S3/S4 when the device attach to
USB2.0/USB3.0 ports.

        [Step]
        - Boot linux (either with or without x-windows)
        - Attach the HVR950 to USB port.
        - dmesg and lsusb to make sure the device driver has been load
sucessfully
        - pm-suspend [--quirk-s3-bios]
        - the screen show black light and hung

Then I do some research about it and find it seems caused by the
em28xx-alsa module that can't implement some call back function about
suspend and resume.
After I make the em28xx-alsa.ko not installed by comment one line in
em28xx-cards.c below.

     else if (dev->has_alsa_audio)
           // request_modules("em28xx-alsa");

Then the linux can go into S3/S4. I uses kernel 3.1.0-rc1 on
Scientific Linux 6.1 do the debug. The issue can be reproduce on
Ubuntu10,04 too.
I am not familiar with linux-media driver. Is there someone know this issue?


Thanks,
Alex He
