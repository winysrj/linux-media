Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:57445 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3ATSrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 13:47:42 -0500
Received: by mail-bk0-f48.google.com with SMTP id jk14so138454bkc.35
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2013 10:47:41 -0800 (PST)
Message-ID: <50FC3BCA.9080301@gmail.com>
Date: Sun, 20 Jan 2013 19:47:38 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 1/1] [media] s5k6aa: Use devm_regulator_bulk_get API
References: <1357627704-14269-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1357627704-14269-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 01/08/2013 07:48 AM, Sachin Kamat wrote:
> devm_regulator_bulk_get is device managed and saves some cleanup
> and exit code.

Applied to my tree for 3.9, thanks.

I had some doubts initially, since this driver ideally needs to have
regulator_bulk_enable/disable function calls replaced with explicit
regulator_enable/regulator_disable calls, to ensure proper voltage
regulator enable/disable sequence (the bulk API doesn't guarantee
any specific sequence).

But this patch is just about regulator_get/regulator_put and it looks
fine.

--

Thanks,
Sylwester
