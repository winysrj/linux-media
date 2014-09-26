Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44001 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbaIZOGk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 10:06:40 -0400
Received: by mail-pa0-f42.google.com with SMTP id bj1so2593854pad.15
        for <linux-media@vger.kernel.org>; Fri, 26 Sep 2014 07:06:40 -0700 (PDT)
Message-ID: <542572E6.70803@linaro.org>
Date: Fri, 26 Sep 2014 22:06:30 +0800
From: zhangfei <zhangfei.gao@linaro.org>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: m.chehab@samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rc: fix hix5hd2 compile-test issue
References: <1411571401-30664-1-git-send-email-zhangfei.gao@linaro.org> <1411736250-29252-1-git-send-email-zhangfei.gao@linaro.org> <20140926131229.GS5182@n2100.arm.linux.org.uk>
In-Reply-To: <20140926131229.GS5182@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/26/2014 09:12 PM, Russell King - ARM Linux wrote:
> On Fri, Sep 26, 2014 at 08:57:30PM +0800, Zhangfei Gao wrote:
>> Add dependence to solve build error in arch like ia64
>> error: implicit declaration of function 'readl_relaxed' & 'writel_relaxed'
>>
>> Change CONFIG_PM to CONFIG_PM_SLEEP to solve
>> warning: 'hix5hd2_ir_suspend' & 'hix5hd2_ir_resume' defined but not used
>
> There is work currently in progress (in linux-next) to provide
> asm-generic accessors for the above.

Thanks Russell for the info.

Have found the patch set about "asm-generic: io: implement relaxed 
accessor macros as conditional wrappers".

That's great.

Thanks

