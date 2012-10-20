Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:65437 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2JTJ4F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 05:56:05 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so361265eaa.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 02:56:03 -0700 (PDT)
Message-ID: <50827530.3030603@gmail.com>
Date: Sat, 20 Oct 2012 11:56:00 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 7/8] [media] s5p-mfc: Make 'clk_ref' static in s5p_mfc_pm.c
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org> <1350472311-9748-7-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-7-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2012 01:11 PM, Sachin Kamat wrote:
> Fixes the following sparse warning:
> drivers/media/platform/s5p-mfc/s5p_mfc_pm.c:31:10: warning:
> symbol 'clk_ref' was not declared. Should it be static?

Applied, thanks.
