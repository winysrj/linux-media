Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34113 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbbINPF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2015 11:05:26 -0400
Received: by padhy16 with SMTP id hy16so146500374pad.1
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2015 08:05:26 -0700 (PDT)
Subject: Re: [PATCH][resend] rc: gpio-ir-recv: allow flush space on idle
To: Sean Young <sean@mess.org>
References: <1441980024-1944-1-git-send-email-eric@nelint.com>
 <20150914100044.GA21149@gofer.mess.org> <55F6DAE2.6080901@nelint.com>
 <20150914145436.GA23973@gofer.mess.org>
Cc: linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mchehab@osg.samsung.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	patrice.chotard@st.com, fabf@skynet.be, wsa@the-dreams.de,
	heiko@sntech.de, devicetree@vger.kernel.org,
	otavio@ossystems.com.br
From: Eric Nelson <eric@nelint.com>
Message-ID: <55F6E234.5050502@nelint.com>
Date: Mon, 14 Sep 2015 08:05:24 -0700
MIME-Version: 1.0
In-Reply-To: <20150914145436.GA23973@gofer.mess.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks again Sean,

On 09/14/2015 07:54 AM, Sean Young wrote:
> On Mon, Sep 14, 2015 at 07:34:10AM -0700, Eric Nelson wrote:
>> Thanks Shawn,
>>
>> On 09/14/2015 03:00 AM, Sean Young wrote:
>>> On Fri, Sep 11, 2015 at 07:00:24AM -0700, Eric Nelson wrote:
>>>> Many decoders require a trailing space (period without IR illumination)
>>>> to be delivered before completing a decode.
>>>>
>>>> Since the gpio-ir-recv driver only delivers events on gpio transitions,
>>>> a single IR symbol (caused by a quick touch on an IR remote) will not
>>>> be properly decoded without the use of a timer to flush the tail end
>>>> state of the IR receiver.
>>>
>>> This is a problem other IR drivers suffer from too. It might be better
>>> to send a IR timeout event like st_rc_send_lirc_timeout() in st_rc.c,
>>> with the duration set to what the timeout was. That is what irraw 
>>> timeouts are for; much better than fake transitions.
>>>
>>
>> If I'm understanding this correctly, this would require modification
>> of each decoder to handle what seems to be a special case regarding
>> the GPIO IR driver (which needs an edge to trigger an interrupt).
> 
> No, this is not a special case. Many drivers do have extra code to generate
> some sort of end-of-signal message: redrat3; igorplugusb; st_rc. They don't
> handle it consistently but this should be fixed.
> 
> Secondly, the decoders already handle it. A timeout event matches 
> is_timing_event(), so it's processed by the decoders. The duration should 
> be set correctly.
> 

I think I did misunderstand you.

You're suggesting that I re-work the patch to gpio-ir-recv.c to
produce a timeout instead of an edge. Is that right?

>> Isn't it better to have the device interface handle this in one place?
> 
>>>> This patch adds an optional device tree node "flush-ms" which, if
>>>> present, will use a jiffie-based timer to complete the last pulse
>>>> stream and allow decode.
>>>
>>> A common value for this is 100ms, I'm not sure what use it has to have
>>> it configurable. It's nice to have it exposed in rc_dev->timeout.
>>>
>>
>> I'm enough of a n00b regarding the details of the various decoders
>> not to know that...
>>
>> I looked through the couple of decoders my customer was using (NEC and
>> RC6) and came up with a value of 100ms though...
>>
>> Implementing this through DT and having the default as 0 (disabled)
>> provides an interim solution if the choice is made to change each of
>> the decoders, since I would expect that to take a while and a bunch of
>> remote control devices for testing.
> 
> Many other drivers use 100ms just fine and I don't remember ever seeing
> any bug reports on that.
> 

So you'd like to see this as a constant?

Please advise,


Eric

