Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:59036 "EHLO
        resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933728AbeCGQyW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 11:54:22 -0500
To: linux-media@vger.kernel.org
From: Ron Economos <w6rz@comcast.net>
Subject: Re: [PATCH] Fix for hanging si2168 in PCTV 292e, making code match
Message-ID: <420dbd99-30f7-7d4b-5af0-36065b5a3434@comcast.net>
Date: Wed, 7 Mar 2018 08:54:20 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm almost 100% sure that the patch I submitted (and was committed in 
Linux 4.16-rc1) for the si2168 fixes Nigel's issue. I would suggest that 
Nigel's patch be retired.

https://github.com/torvalds/linux/blob/master/drivers/media/dvb-frontends/si2168.c

media: [RESEND] media: dvb-frontends: Add delay to Si2168 restart

On faster CPUs a delay is required after the resume command and the 
restart command. Without the delay, the restart command often returns 
-EREMOTEIO and the Si2168 does not restart. Note that this patch fixes 
the same issue as https://patchwork.linuxtv.org/patch/44304/, but I 
believe my udelay() fix addresses the actual problem.

Signed-off-by: Ron Economos <w6rz@comcast.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Ron
