Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48041 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2JTJj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 05:39:27 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so358766eaa.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 02:39:26 -0700 (PDT)
Message-ID: <5082714B.3000702@gmail.com>
Date: Sat, 20 Oct 2012 11:39:23 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 4/8] [media] s5p-tv: Use clk_prepare_enable and clk_disable_unprepare
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org> <1350472311-9748-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-4-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2012 01:11 PM, Sachin Kamat wrote:
> Replace clk_enable/clk_disable with clk_prepare_enable/clk_disable_unprepare
> as required by the common clock framework.
> 
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> Cc: Tomasz Stanislawski<t.stanislaws@samsung.com>

Could you add clocks (un)prepare calls at the functions where the clocks
are acquired/released instead ? I think it results in slightly less overhead
this way.

--
Thanks,
Sylwester
