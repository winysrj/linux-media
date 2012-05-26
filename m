Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47634 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2EZIjx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 04:39:53 -0400
Received: by bkcji2 with SMTP id ji2so1261497bkc.19
        for <linux-media@vger.kernel.org>; Sat, 26 May 2012 01:39:52 -0700 (PDT)
Message-ID: <4FC096D6.3040504@gmail.com>
Date: Sat, 26 May 2012 10:39:50 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	mchehab@infradead.org, patches@linaro.org
Subject: Re: [PATCH 1/4] [media] s5p-fimc: Add missing static storage class
 in fimc-lite-reg.c file
References: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 05/25/2012 07:38 PM, Sachin Kamat wrote:
> Fixes the following sparse warning:
> drivers/media/video/s5p-fimc/fimc-lite-reg.c:218:6: warning: symbol
> 'flite_hw_set_out_order' was not declared. Should it be static?

Thanks for the patches. However I'm inclined to squash this whole
series into one patch, since it addresses same issue in one driver,
just in different. I don't see a good reason to split those changes
like this. Could you make it just one patch instead ?


Regards,
Sylwester
