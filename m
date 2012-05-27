Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45855 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2E0UjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 16:39:11 -0400
Received: by bkcji2 with SMTP id ji2so1769816bkc.19
        for <linux-media@vger.kernel.org>; Sun, 27 May 2012 13:39:10 -0700 (PDT)
Message-ID: <4FC290EC.3010509@gmail.com>
Date: Sun, 27 May 2012 22:39:08 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	mchehab@infradead.org, patches@linaro.org
Subject: Re: [PATCH 1/1] [media] s5p-fimc: Add missing static storage class
References: <1338045114-2477-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1338045114-2477-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/26/2012 05:11 PM, Sachin Kamat wrote:
> Fixes the following sparse warnings:

Hi Sachin. Thanks, in case somebody else applies this patch 
before I do:
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

I would just change the summary line to:
"s5p-fimc: Add missing static storage class specifiers" when
applying this patch.

--
Regards,
Sylwester
