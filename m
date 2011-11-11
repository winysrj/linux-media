Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53257 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab1KKSmR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 13:42:17 -0500
Received: by ywt32 with SMTP id 32so484026ywt.19
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2011 10:42:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB33W8dW0Yts_dxz=WyYEK9-bcoQ_9gM-t3+aR5s-G_5QswOyA@mail.gmail.com>
References: <CAB33W8dW0Yts_dxz=WyYEK9-bcoQ_9gM-t3+aR5s-G_5QswOyA@mail.gmail.com>
Date: Fri, 11 Nov 2011 18:42:16 +0000
Message-ID: <CAB33W8eMEG6cxM9x0aGRe+1xx6TwvjBZL4KSdRY4Ti2sTHk9hg@mail.gmail.com>
Subject: Fwd: AF9015 Dual tuner i2c write failures
From: Tim Draper <veehexx@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

i've recently bought an AF9015 usb module from ebay, and am struggling
to get it working correctly. i've been recommended to post here on the
mythtv MailingList.

i'm running mytbuntu 11.04 x64, and the mythbackend service shows
af9013: I2C read failed reg:d607
af9015: command failed:1
and will refuse to establish a lock. so far i've only been able to
find a temporary fix to this by re-inserting the USB stick (ie: it has
to loose power on the USB stick)

i've been googling a fair bit, and i've only found somewhat old info
reguarding (firmware?) source code that is no longer available (it has
been merged into another codeset), and thus the patch file is not
applicable to it....
http://ubuntuforums.org/showpost.php?p=9712937&postcount=126 is what
i'm working from.

i am confident the device does work as if i test it immediately after
being re-inserted i get both tuners working fine. after a while though
i start seeing the above errors in the mythtv logs, and i am no longer
able to tune into channels.

just to be clear, i am sure the issue is down to a firmware/driver
issue, and not a config or a problem is yet to be discovered as the
last few nights of googling does show this as an issue on certain
devices.

how do i get this issue sorted?
thanks for any help!
