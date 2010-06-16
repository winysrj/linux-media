Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48257 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619Ab0FPUj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 16:39:28 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinUnmKIvaWasBot_iy0Sk5_Ba54zfpEscKu2N74@mail.gmail.com>
References: <20100613202718.6044.29599.stgit@localhost.localdomain>
	<20100613202936.6044.99651.stgit@localhost.localdomain>
	<AANLkTinUnmKIvaWasBot_iy0Sk5_Ba54zfpEscKu2N74@mail.gmail.com>
Date: Wed, 16 Jun 2010 16:39:27 -0400
Message-ID: <AANLkTim5AVO67s20VjOew8L4QyhsELpURMZ6hEd0iXYZ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ir-core: move decoding state to ir_raw_event_ctrl
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: jarod@redhat.com, linux-media@vger.kernel.org, mchehab@redhat.com,
	linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 16, 2010 at 4:06 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> On Sun, Jun 13, 2010 at 4:29 PM, David Härdeman <david@hardeman.nu> wrote:
>> This patch moves the state from each raw decoder into the
>> ir_raw_event_ctrl struct.
>>
>> This allows the removal of code like this:
>>
>>        spin_lock(&decoder_lock);
>>        list_for_each_entry(data, &decoder_list, list) {
>>                if (data->ir_dev == ir_dev)
>>                        break;
>>        }
>>        spin_unlock(&decoder_lock);
>>        return data;
>>
>> which is currently run for each decoder on each event in order
>> to get the client-specific decoding state data.
>>
>> In addition, ir decoding modules and ir driver module load
>> order is now independent. Centralizing the data also allows
>> for a nice code reduction of about 30% per raw decoder as
>> client lists and client registration callbacks are no longer
>> necessary (but still kept around for the benefit of the lirc
>> decoder).
>>
>> Out-of-tree modules can still use a similar trick to what
>> the raw decoders did before this patch until they are merged.
>>
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>
> Acked-by: Jarod Wilson <jarod@redhat.com>
> Tested-by: Jarod Wilson <jarod@redhat.com>
>
> Note that I was running a version rebased atop the linuxtv staging/rc
> branch though.

Which can be seen here:

http://git.wilsonet.com//linux-2.6-ir-wip.git?a=commitdiff;h=faee132179abe884a6e995acb1f5106cb2d5afa2


-- 
Jarod Wilson
jarod@wilsonet.com
