Return-path: <linux-media-owner@vger.kernel.org>
Received: from unicorn.mansr.com ([81.2.72.234]:50580 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964935AbdIYQeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 12:34:07 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Sean Young <sean@mess.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v4 2/2] media: rc: Add driver for tango HW IR decoder
References: <308711ef-0ba8-d533-26fd-51e5b8f32cc8@free.fr>
        <e3d91250-e6bd-bb8c-5497-689c351ac55f@free.fr>
        <yw1xzi9ieuqe.fsf@mansr.com>
        <d4bf7e00-12f0-58a1-a209-247a3dde5094@sigmadesigns.com>
Date: Mon, 25 Sep 2017 17:34:05 +0100
In-Reply-To: <d4bf7e00-12f0-58a1-a209-247a3dde5094@sigmadesigns.com> (Marc
        Gonzalez's message of "Mon, 25 Sep 2017 17:00:22 +0200")
Message-ID: <yw1xvak6eo02.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marc Gonzalez <marc_gonzalez@sigmadesigns.com> writes:

> On 25/09/2017 16:08, Måns Rullgård wrote:
>
>> Marc Gonzalez writes:
>> 
>> Why did you put this way early now?  Registering the device should be
>> the last thing you do (LIKE I DID IT, DAMMIT).  Otherwise something might
>> try to use it before it is fully configured.
>> 
>>> +	err = clk_prepare_enable(ir->clk);
>>> +	if (err)
>>> +		return err;
>> 
>> Why did you move this call later?  Seriously, why do you constantly move
>> things around seemingly at random?
>
> This mistake was present in v1, v2, v3.

Is that supposed to be an excuse?

> I got into this mess because I (incorrectly) tried to do all the
> devm inits before clk_prepare_enable().
>
> Why do we need clk_prepare_enable() and why would that function
> fail? The clock is a crystal oscillator which cannot be disabled
> or powered down, and which is the input for every system PLL.

You can't know that.  It happens to be the case for all systems you know
about today, but the driver has to work with any clock configuration.

>>> +	writel_relaxed(0xc0000000, ir->rc6_base + RC6_CTRL);
>> 
>> Since you've added somewhat descriptive macros for some things, why did
>> you skip this magic number?
>
> This write is supposed to clear interrupts, but there are none
> to clear at this point. I'll remove it.

Wrong answer.

-- 
Måns Rullgård
