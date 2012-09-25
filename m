Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37192 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2IYVIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 17:08:51 -0400
Received: by bkcjk13 with SMTP id jk13so1516659bkc.19
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 14:08:50 -0700 (PDT)
Message-ID: <50621D5D.9020204@gmail.com>
Date: Tue, 25 Sep 2012 23:08:45 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.nawrocki@samsung.com, patches@linaro.org
Subject: Re: [PATCH] [media] s5p-fimc: Use the new linux/sizes.h header file
References: <1348477595-28493-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1348477595-28493-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 09/24/2012 11:06 AM, Sachin Kamat wrote:
> Replaces asm/sizes.h with linux/sizes.h.
>
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>

Thanks, I have already applied similar patch to this one [1].

You can see what's already queued at
http://git.infradead.org/users/kmpark/linux-samsung
branch v4l-next.

As a side note, there is no need to Cc Mauro, please just send
your patches to linux-media and a copy to me so I don't miss them.

Regards,
Sylwester

[1] 
http://git.infradead.org/users/kmpark/linux-samsung/commitdiff/9f3ad11ace7a41cd1b16f1e58601ac37513ad683
