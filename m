Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34220 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2JTJc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 05:32:58 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so357709eaa.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 02:32:57 -0700 (PDT)
Message-ID: <50826FC6.20509@gmail.com>
Date: Sat, 20 Oct 2012 11:32:54 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 2/8] [media] s5p-g2d: Use clk_prepare_enable and clk_disable_unprepare
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org> <1350472311-9748-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-2-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 10/17/2012 01:11 PM, Sachin Kamat wrote:
> Replace clk_enable/clk_disable with clk_prepare_enable/clk_disable_unprepare
> as required by the common clock framework.
> 
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> Cc: Kamil Debski<k.debski@samsung.com>

As we discussed previously, this patch is not needed. clk_prepare/unprepare
are done in this driver's probe() and remove() callbacks.

Thanks,
Sylwester
