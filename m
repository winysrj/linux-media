Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:64915 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab0DVSl0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 14:41:26 -0400
Message-ID: <4BD0984E.4070609@vorgon.com>
Date: Thu, 22 Apr 2010 11:41:18 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DViCo Dual Fusion Express (cx23885) remote control issue
References: <201004151519.58012.darius@dons.net.au> <201004222241.28624.darius@dons.net.au>
In-Reply-To: <201004222241.28624.darius@dons.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 4/22/2010 6:11 AM, Daniel O'Connor wrote:
> On Thu, 15 Apr 2010, Daniel O'Connor wrote:
>> I haven't delved much further yet (planning to printf my way through
>> the probe routines) as I am a Linux kernel noob (plenty of FreeBSD
>> experience though!).
>
> I found that it is intermittent with no pattern I can determine.
>
> When it doesn't work the probe routine is not called, but I am not sure
> how i2c_register_driver decides to call the probe routine.
>
> Does anyone have an idea what the cause could be? Or at least somewhere
> to start looking :)
>
> Thanks.
>

A patch was posted that was suposed to be merged that fixed the ir 
problem, at least for me. Though my problem was not intermittent. The 
patch worked for me. Now if I could just get both tuners to keep working
