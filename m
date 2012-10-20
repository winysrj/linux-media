Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41875 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2JTJgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 05:36:11 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so445783eek.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 02:36:10 -0700 (PDT)
Message-ID: <50827088.2010908@gmail.com>
Date: Sat, 20 Oct 2012 11:36:08 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 3/8] [media] s5p-mfc: Use clk_prepare_enable and clk_disable_unprepare
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org> <1350472311-9748-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-3-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2012 01:11 PM, Sachin Kamat wrote:
> Replace clk_enable/clk_disable with clk_prepare_enable/clk_disable_unprepare
> as required by the common clock framework.

Similarly as in case of s5p-g2d driver, there is no need for this change.
