Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd6222.kasserver.com ([85.13.131.10]:46055 "EHLO
	dd6222.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab0FUHaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 03:30:00 -0400
Received: from [0.0.0.0] (frosti.wrongexit.de [213.239.207.76])
	by dd6222.kasserver.com (Postfix) with ESMTP id 595112122FC
	for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 09:29:59 +0200 (CEST)
Message-ID: <4C1F14F6.6020200@coronamundi.de>
Date: Mon, 21 Jun 2010 09:29:58 +0200
From: Silamael <Silamael@coronamundi.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: PROBLEM: 2.6.34-rc7 kernel panics "BUG: unable to handle kernel
 	NULL pointer dereference at (null)" while channel scan runnin
References: <4C14F922.1020802@coronamundi.de> <AANLkTinpwSQlGWtlz8cTCCQyzfWN6qiqLcsJczs87WTZ@mail.gmail.com>
In-Reply-To: <AANLkTinpwSQlGWtlz8cTCCQyzfWN6qiqLcsJczs87WTZ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/18/2010 04:30 PM, David Ellingsworth wrote:
> On Sun, Jun 13, 2010 at 11:28 AM, Silamael <Silamael@coronamundi.de> wrote:
>> Hello!
>>
>> In the meanwhile i tried several different kernel versions:
>> - 2.6.26 (as included in Debian Lenny): crash
>> - 2.6.32-3 (as in Debian Squeeze): crash
>> - 2.6.32-5 (updated version in Debian Squeeze): crash
>> - 2.6.34: crash
>>
>> In every kernel version I've tested, the crashdump looks the same. Each
>> time there's an NULL pointer given to saa7146_buffer_next().
>>
>> Would be nice if someone could give me some hints. I'm not sure whether
>> it's a broken driver or it's due to broken hardware or some other issues.
>>
>> Thanks a lot!
>>
> 
> Matthias,
> 
> While I don't doubt there's probably a bug in this driver, you haven't
> provided nearly enough information to correct it. Please resubmit with
> the full backtrace provided by the kernel at the time of the crash.
> Without this information, it's hard to gauge the exact cause of the
> error and thus no one will attempt to fix it.
> 
> Regards,
> 
> David Ellingsworth


Hello everyone,

This weekend i tried some other Nexus-S card. Same problem again. Has
anyone perhaps some hint, what could be wrong with my system if it's not
the driver? Is it some problem with interrupt sharing? Some ACPI issues?
Thanks a lot!

Greetings,
Matthias
