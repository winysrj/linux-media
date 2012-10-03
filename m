Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56180 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2JCKRO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 06:17:14 -0400
Message-id: <506C10A7.4010606@samsung.com>
Date: Wed, 03 Oct 2012 12:17:11 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	andrzej.p@samsung.com, kgene.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] [media] s5p-jpeg: use clk_prepare_enable and
 clk_disable_unprepare
References: <1349222102-3183-1-git-send-email-thomas.abraham@linaro.org>
In-reply-to: <1349222102-3183-1-git-send-email-thomas.abraham@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/2012 01:55 AM, Thomas Abraham wrote:
> Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
> calls as required by common clock framework.
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>

Applied, thanks.
