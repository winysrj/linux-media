Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58429 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2JTJ5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 05:57:24 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so361470eaa.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 02:57:23 -0700 (PDT)
Message-ID: <50827580.9020302@gmail.com>
Date: Sat, 20 Oct 2012 11:57:20 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 8/8] [media] s5p-fimc: Make 'fimc_pipeline_s_stream' function
 static
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org> <1350472311-9748-8-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-8-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2012 01:11 PM, Sachin Kamat wrote:
> Fixes the following sparse warning:
> drivers/media/platform/s5p-fimc/fimc-mdevice.c:216:5: warning:
> symbol 'fimc_pipeline_s_stream' was not declared. Should it be static?

Thanks Sachin, I've add it to my tree.
