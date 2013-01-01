Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59119 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3AASfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 13:35:05 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so6485126eek.18
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 10:35:04 -0800 (PST)
Message-ID: <50E32C55.1090003@gmail.com>
Date: Tue, 01 Jan 2013 19:35:01 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Mike Turquette <mturquette@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 5/6] clk: s5p-fimc: Fix incorrect usage of IS_ERR_OR_NULL
References: <1355819321-21914-1-git-send-email-linux@prisktech.co.nz> <1355819321-21914-6-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1355819321-21914-6-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/2012 09:28 AM, Tony Prisk wrote:
> Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.
>
> Signed-off-by: Tony Prisk<linux@prisktech.co.nz>
> CC: Kyungmin Park<kyungmin.park@samsung.com>
> CC: Tomasz Stanislawski<t.stanislaws@samsung.com>
> CC: linux-media@vger.kernel.org

Applied, thanks.
