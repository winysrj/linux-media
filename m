Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:38747 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932448AbeCGTaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 14:30:24 -0500
Subject: Re: [PATCH] Fix for hanging si2168 in PCTV 292e, making code match
To: Ron Economos <w6rz@comcast.net>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <0e541d39-1e6c-03fc-e6a5-592f50cdaedc@comcast.net>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <1d65ea12-0bbf-c43b-8e18-cf864a909c1b@iki.fi>
Date: Wed, 7 Mar 2018 21:30:16 +0200
MIME-Version: 1.0
In-Reply-To: <0e541d39-1e6c-03fc-e6a5-592f50cdaedc@comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/2018 06:39 PM, Ron Economos wrote:
> I'm almost 100% sure that the patch I submitted (and was committed in 
> Linux 4.16-rc1) for the si2168 fixes Nigel's issue. I would suggest that 
> Nigel's patch be retired.
> 
> https://github.com/torvalds/linux/blob/master/drivers/media/dvb-frontends/si2168.c
> 
> media: [RESEND] media: dvb-frontends: Add delay to Si2168 restart
> 
> On faster CPUs a delay is required after the resume command and the 
> restart command. Without the delay, the restart command often returns 
> -EREMOTEIO and the Si2168 does not restart. Note that this patch fixes 
> the same issue as https://patchwork.linuxtv.org/patch/44304/, but I 
> believe my udelay() fix addresses the actual problem.
> 
> Signed-off-by: Ron Economos <w6rz@comcast.net>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> Ron


Yes, you are likely correct!

Patch is already applied, but however I think it should be something 
like usleep_range(100, ~0) in order to allow scheduler optimize 
resources as upper limit of delay is not critical at all. See 
Documentation/timers/timers-howto.txt


regards
Antti


-- 
http://palosaari.fi/
