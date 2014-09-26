Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43976 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752149AbaIZNMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 09:12:38 -0400
Date: Fri, 26 Sep 2014 14:12:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: m.chehab@samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rc: fix hix5hd2 compile-test issue
Message-ID: <20140926131229.GS5182@n2100.arm.linux.org.uk>
References: <1411571401-30664-1-git-send-email-zhangfei.gao@linaro.org> <1411736250-29252-1-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411736250-29252-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 26, 2014 at 08:57:30PM +0800, Zhangfei Gao wrote:
> Add dependence to solve build error in arch like ia64
> error: implicit declaration of function 'readl_relaxed' & 'writel_relaxed'
> 
> Change CONFIG_PM to CONFIG_PM_SLEEP to solve
> warning: 'hix5hd2_ir_suspend' & 'hix5hd2_ir_resume' defined but not used

There is work currently in progress (in linux-next) to provide
asm-generic accessors for the above.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
