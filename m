Return-path: <mchehab@localhost>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40013 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1GGIP1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 04:15:27 -0400
Received: by yia27 with SMTP id 27so289575yia.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2011 01:15:27 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Jul 2011 16:15:27 +0800
Message-ID: <CACVXFVORKDuHgJZ_yHuO2g-HdPxrHs5-s0Pry_D+9d-Qbszrkw@mail.gmail.com>
Subject: No stream from uvc camera after resume from system sleep
From: Ming Lei <tom.leiming@gmail.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Laurent,

I found one problem about the uvc camera in my laptop on 3.0-rc6 and
previous kernel:

- no stream data received from camera after resume from system sleep
- will be ok again if reloading uvcvideo after resume
- no odd things are found from usb suspend and pm debug messages

Could you give any suggestions about how to debug the issue?

thanks,
-- 
Ming Lei
