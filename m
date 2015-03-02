Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40237 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbbCBVy5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 16:54:57 -0500
Message-ID: <54F4DC2F.1030904@codeaurora.org>
Date: Mon, 02 Mar 2015 13:54:55 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 05/10] clkdev: add clkdev_create() helper
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk> <E1YSTnW-0001Jk-Tm@rmk-PC.arm.linux.org.uk> <54F4B50E.4070104@codeaurora.org> <20150302210121.GE29584@n2100.arm.linux.org.uk>
In-Reply-To: <20150302210121.GE29584@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/15 13:01, Russell King - ARM Linux wrote:
> On Mon, Mar 02, 2015 at 11:07:58AM -0800, Stephen Boyd wrote:
>> On 03/02/15 09:06, Russell King wrote:
>>> Add a helper to allocate and add a clk_lookup structure.  This can not
>>> only be used in several places in clkdev.c to simplify the code, but
>>> more importantly, can be used by callers of the clkdev code to simplify
>>> their clkdev creation and registration.
>>>
>>> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>>> ---
>>>  drivers/clk/clkdev.c   | 52 ++++++++++++++++++++++++++++++++++++++------------
>>>  include/linux/clkdev.h |  3 +++
>>>  2 files changed, 43 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
>>> index 043fd3633373..611b9acbad78 100644
>>> --- a/drivers/clk/clkdev.c
>>> +++ b/drivers/clk/clkdev.c
>>> @@ -294,6 +294,19 @@ vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
>>>  	return &cla->cl;
>>>  }
>>>  
>>> +static struct clk_lookup *
>>> +vclkdev_create((struct clk *clk, const char *con_id, const char *dev_fmt,
>>> +	va_list ap)
>>> +{
>>> +	struct clk_lookup *cl;
>>> +
>>> +	cl = vclkdev_alloc(clk, con_id, dev_fmt, ap);
>>> +	if (cl)
>>> +		clkdev_add(cl);
>>> +
>>> +	return cl;
>>> +}
>>> +
>>>  struct clk_lookup * __init_refok
>>>  clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
>>>  {
>>> @@ -308,6 +321,28 @@ clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
>>>  }
>>>  EXPORT_SYMBOL(clkdev_alloc);
>>>  
>>> +/**
>>> + * clkdev_create - allocate and add a clkdev lookup structure
>>> + * @clk: struct clk to associate with all clk_lookups
>>> + * @con_id: connection ID string on device
>>> + * @dev_fmt: format string describing device name
>>> + *
>>> + * Returns a clk_lookup structure, which can be later unregistered and
>>> + * freed.
>> And returns NULL on failure? Any reason why we don't return an error
>> pointer on failure?
> Why should it when it's only error is "no memory" ?  It follows the
> clkdev_alloc() and memory allocator pattern.
>
> It'd also make the error handling in places like clk_add_alias() more
> difficult (how that happened, I don't know...) though that could probably
> be fixed as no one seems to bother checking the return value... maybe
> that's a reason to make it return void ;)
>

Ok, fair enough. Right now clk_add_alias() leaks if a driver decides to
add an alias and then fail probe for something like probe deferral. We
should probably make that return the clk_lookup structure too so that
drivers can clean up.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

