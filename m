Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62092 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab2HXJEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 05:04:45 -0400
Received: by lbbgj3 with SMTP id gj3so1002696lbb.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 02:04:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503737DD.2020802@iki.fi>
References: <1345665041-15211-1-git-send-email-timo.t.kokkonen@iki.fi>
	<1345665041-15211-8-git-send-email-timo.t.kokkonen@iki.fi>
	<CAORVsuXDpnP+QdfQDJMEAUGO3ekr+eGnt46SCqO9K2bsWpMdrw@mail.gmail.com>
	<503737DD.2020802@iki.fi>
Date: Fri, 24 Aug 2012 11:04:43 +0200
Message-ID: <CAORVsuX_J0xkYOaTN_v3KG7MLeaeFgf1zGMbQNoXikzur_MKSA@mail.gmail.com>
Subject: Re: [PATCH 7/8] ir-rx51: Remove MPU wakeup latency adjustments
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Timo,

On Fri, Aug 24, 2012 at 10:14 AM, Timo Kokkonen <timo.t.kokkonen@iki.fi> wrote:
> Hi Jean,
>
> On 08/23/12 14:58, Jean Pihet wrote:
>> Hi Timo,
>>
>> On Wed, Aug 22, 2012 at 9:50 PM, Timo Kokkonen <timo.t.kokkonen@iki.fi> wrote:
>> That is correct. The API to use is the PM QoS API which cpuidle uses
>> to determine the next MPU state based on the allowed latency.
>>
>>> A more appropriate fix for the problem would be to modify the idle
>>> layer so that it does not allow MPU going to too deep sleep modes when
>>> it is expected that the timers need to wake up MPU.
>> The idle layer already uses the PM QoS framework to decide the next
>> MPU state. I think the right solution is to convert from
>> omap_pm_set_max_mpu_wakeup_lat to the PM QoS API.
>>
>> Cf. http://marc.info/?l=linux-omap&m=133968658305580&w=2 for an
>> example of the conversion.
>>
>
> Thanks. It looks like really easy and straightforward conversion.
> However, I couldn't find the patch you were referring to from any trees
Correct, this patch is not applied to the mainline code yet, it is
provided as an example of the conversion.

> I could find. So, I take that this API does not really have omap2
> support in it yet? I tried git grepping through the source and to me it
> appears there is nothing in place yet that actually restricts the MPU
> sleep states on omap2 when requested.
The MPU state is controlled from the cpuidle framework, which
retrieves the MPU allowed latency from the PM QoS framework. This is
supported on OMAP2.
Cf. the table of states and the associated latency in
arch/arm/mach-omap2/cpuidle34xx.c.

> Which puzzles me.. The patch you are referring to transfers the omap I2C
> from the old omap PM API to the new QOS API is not applied yet in
> mainline. The I2C is definitely working with the old API too, I'm just
> wondering why I can't make it working with either of the APIs.. Am I
> missing something here?
AFAIK the old API is a noop in mainline. Using the PM QoS API
defnitely is supported, that is why I think the conversion needs to be
performed.

>>> Therefore, it makes sense to actually remove this call entirely from
>>> the ir-rx51 driver as it is both wrong and does nothing useful at the
>>> moment.
>>>
>>> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
>>
>> Regards,
>> Jean
>>

Thanks,
Jean
