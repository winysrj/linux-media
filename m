Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:41060 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758778Ab2HXKtC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 06:49:02 -0400
Message-ID: <50375C1B.5000308@iki.fi>
Date: Fri, 24 Aug 2012 13:48:59 +0300
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
To: Jean Pihet <jean.pihet@newoldbits.com>
CC: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] ir-rx51: Remove MPU wakeup latency adjustments
References: <1345665041-15211-1-git-send-email-timo.t.kokkonen@iki.fi> <1345665041-15211-8-git-send-email-timo.t.kokkonen@iki.fi> <CAORVsuXDpnP+QdfQDJMEAUGO3ekr+eGnt46SCqO9K2bsWpMdrw@mail.gmail.com> <503737DD.2020802@iki.fi> <CAORVsuX_J0xkYOaTN_v3KG7MLeaeFgf1zGMbQNoXikzur_MKSA@mail.gmail.com>
In-Reply-To: <CAORVsuX_J0xkYOaTN_v3KG7MLeaeFgf1zGMbQNoXikzur_MKSA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/24/12 12:04, Jean Pihet wrote:
> Hi Timo,
> 
> On Fri, Aug 24, 2012 at 10:14 AM, Timo Kokkonen <timo.t.kokkonen@iki.fi> wrote:
>> Hi Jean,
>>
>> On 08/23/12 14:58, Jean Pihet wrote:
>>> Hi Timo,
>>>
>>> On Wed, Aug 22, 2012 at 9:50 PM, Timo Kokkonen <timo.t.kokkonen@iki.fi> wrote:
>>> That is correct. The API to use is the PM QoS API which cpuidle uses
>>> to determine the next MPU state based on the allowed latency.
>>>
>>>> A more appropriate fix for the problem would be to modify the idle
>>>> layer so that it does not allow MPU going to too deep sleep modes when
>>>> it is expected that the timers need to wake up MPU.
>>> The idle layer already uses the PM QoS framework to decide the next
>>> MPU state. I think the right solution is to convert from
>>> omap_pm_set_max_mpu_wakeup_lat to the PM QoS API.
>>>
>>> Cf. http://marc.info/?l=linux-omap&m=133968658305580&w=2 for an
>>> example of the conversion.
>>>
>>
>> Thanks. It looks like really easy and straightforward conversion.
>> However, I couldn't find the patch you were referring to from any trees
> Correct, this patch is not applied to the mainline code yet, it is
> provided as an example of the conversion.
> 
>> I could find. So, I take that this API does not really have omap2
>> support in it yet? I tried git grepping through the source and to me it
>> appears there is nothing in place yet that actually restricts the MPU
>> sleep states on omap2 when requested.
> The MPU state is controlled from the cpuidle framework, which
> retrieves the MPU allowed latency from the PM QoS framework. This is
> supported on OMAP2.
> Cf. the table of states and the associated latency in
> arch/arm/mach-omap2/cpuidle34xx.c.
> 

Thanks for the pointer. I took a look at the state table and adjusted
the latency requirements in my code. If I lower the latency from 50us to
10us, the timers are then waking up as they should be.

I'll replace this patch with one where I convert it using the new API.

Thanks!

-Timo

