Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:22154 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaCVWDb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Mar 2014 18:03:31 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Message-id: <532E08AF.5030008@samsung.com>
Date: Sat, 22 Mar 2014 16:03:27 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	shuahkhan@gmail.com
Subject: Re: [PATCH] media: em28xx-video - change em28xx_scaler_set() to use
 em28xx_reg_len()
References: <1395435890-15100-1-git-send-email-shuah.kh@samsung.com>
 <532D82C9.6010401@googlemail.com> <532DAAD0.6060209@samsung.com>
 <532DCB06.9040601@googlemail.com>
In-reply-to: <532DCB06.9040601@googlemail.com>
Content-transfer-encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2014 11:40 AM, Frank Schäfer wrote:
>
> I'm more concerned about the fact that readers of the code could think
> that this is a write with a variable length, while the length is
> actually always the same.

Fair enough.

>
> em28xx_reg_len() is a somewhat dirty hack for vidioc_[g,s]_register
> debugging ioctls only.

I didn't realize that. In that case, it doesn't make sense to propagate 
the change to non-debug code. This patch can be dropped. I thought 
em28xx_reg_len() is good example of finding register length for these 
registers.

> Btw, what happens when you try to compile the code with this patch
> applied and CONFIG_VIDEO_ADV_DEBUG disabled ? ;-)

CONFIG_VIDEO_ADV_DEBUG is disabled in my config.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
