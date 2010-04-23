Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:65534 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab0DWHw2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 03:52:28 -0400
Message-ID: <4BD151AB.7070701@vorgon.com>
Date: Fri, 23 Apr 2010 00:52:11 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: darius@dons.net.au
CC: linux-media@vger.kernel.org
Subject: Re: DViCo Dual Fusion Express (cx23885) remote control issue
References: <201004151519.58012.darius@dons.net.au> <201004222241.28624.darius@dons.net.au> <4BD0984E.4070609@vorgon.com> <201004231000.07508.darius@dons.net.au>
In-Reply-To: <201004231000.07508.darius@dons.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 4/22/2010 5:29 PM, Daniel O'Connor wrote:
> On Fri, 23 Apr 2010, Timothy D. Lenz wrote:
>> On 4/22/2010 6:11 AM, Daniel O'Connor wrote:
>>> On Thu, 15 Apr 2010, Daniel O'Connor wrote:
>>>> I haven't delved much further yet (planning to printf my way
>>>> through the probe routines) as I am a Linux kernel noob (plenty of
>>>> FreeBSD experience though!).
>>>
>>> I found that it is intermittent with no pattern I can determine.
>>>
>>> When it doesn't work the probe routine is not called, but I am not
>>> sure how i2c_register_driver decides to call the probe routine.
>>>
>>> Does anyone have an idea what the cause could be? Or at least
>>> somewhere to start looking :)
>>
>> A patch was posted that was suposed to be merged that fixed the ir
>> problem, at least for me. Though my problem was not intermittent. The
>> patch worked for me. Now if I could just get both tuners to keep
>> working
>
> Hmm do you have a subject line or message ID I can search for?
>
> I haven't found any problems with tuners not working although I don't
> often fire them both up at once.
>

[PATCH] FusionHDTV: Use quick reads for I2C IR device probing
