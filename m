Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35525 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab0HCP0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 11:26:53 -0400
Received: by fxm14 with SMTP id 14so2037920fxm.19
        for <linux-media@vger.kernel.org>; Tue, 03 Aug 2010 08:26:52 -0700 (PDT)
Message-ID: <4C583538.8060504@gmail.com>
Date: Tue, 03 Aug 2010 09:26:48 -0600
From: Lane Brooks <lane@brooks.nu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: OMAP3 Bridge Problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent and team,

I am using the OMAP3 ISP code from the devel branch on gitorious that I 
back ported to a 2.6.31 kernel. Raw bayer streaming to the CCDC output 
works fine. I am using parallel input with the bridge disabled in that mode.

I am having a problem when I switch the sensor to output YUV422 data. 
The YUV422 stream is a 8x2. If I only switch the sensor to YUV422 mode, 
then I can get the YUV422 data at the CCDC output, but the CCDC pads an 
extra zero byte in there and I only get half the image. So that works as 
expected. I was then hoping all I would have to do is enable the bridge 
to get the YUV422_8x2 data packed into the YUV422_16x1 automatically, 
but instead I get select timeouts.

My question:

- Are there other things I need to when I enable the parallel bridge? 
For example, do I need to change a clock rate somewhere? From the TRM, 
it seems like it should just work without any changes, but maybe I am 
missing something.

Thanks,
Lane
