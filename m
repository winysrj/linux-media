Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:65397 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879Ab3GDUWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jul 2013 16:22:07 -0400
Received: by mail-ea0-f169.google.com with SMTP id h15so1041159eak.14
        for <linux-media@vger.kernel.org>; Thu, 04 Jul 2013 13:22:05 -0700 (PDT)
Message-ID: <51D5D967.1030306@zenburn.net>
Date: Thu, 04 Jul 2013 22:21:59 +0200
From: =?UTF-8?B?SmFrdWIgUGlvdHIgQ8WCYXBh?= <jpc-ml@zenburn.net>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [omap3isp] xclk deadlock
References: <51D37796.2000601@zenburn.net>
In-Reply-To: <51D37796.2000601@zenburn.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

Sorry for the noise, but I believe the information below may be useful 
until everything is merged into mainline.

I write to say that I managed to find a fix for the ISP clock deadlock. 
  My branch can be found at:
https://github.com/LoEE/linux/tree/omap3isp/xclk
(SHA: 36286390193922d148e7a3db0676747a20f2ed66 at the time of writing)

For reference:
1. This was a known problem since early January [1] (reported by Laurent).
2. Mike Turquette had submitted patches that made the clock framework 
(partially) reentrant. [2][3][4]
3. My code is just a rebase of the Laurent's omap3isp/xclk branch on the 
Mike's clk-next (so it's based on 3.10-rc3).

[1]: https://lkml.org/lkml/2013/1/6/169
[2]: http://thread.gmane.org/gmane.linux.kernel/1448446/focus=1448448
[3]: http://thread.gmane.org/gmane.linux.ports.arm.kernel/182198
[4]: http://patches.linaro.org/15676/

-- 
regards,
Jakub Piotr Cłapa
LoEE.pl
