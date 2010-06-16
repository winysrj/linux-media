Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33978 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab0FPUjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 16:39:09 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTilI8pmY0Gezv8BdeGKmYr1u4nEFyquFdKa-RrEA@mail.gmail.com>
References: <20100613202718.6044.29599.stgit@localhost.localdomain>
	<20100613202930.6044.97940.stgit@localhost.localdomain>
	<AANLkTilI8pmY0Gezv8BdeGKmYr1u4nEFyquFdKa-RrEA@mail.gmail.com>
Date: Wed, 16 Jun 2010 16:39:05 -0400
Message-ID: <AANLkTimb-xWQFHmMleMeFy_x3EJ3VOkWo4PR49x-P7T8@mail.gmail.com>
Subject: Re: [PATCH 1/2] ir-core: centralize sysfs raw decoder
	enabling/disabling
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: jarod@redhat.com, linux-media@vger.kernel.org, mchehab@redhat.com,
	linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 16, 2010 at 4:05 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> On Sun, Jun 13, 2010 at 4:29 PM, David Härdeman <david@hardeman.nu> wrote:
>> With the current logic, each raw decoder needs to add a copy of the exact
>> same sysfs code. This is both unnecessary and also means that (re)loading
>> an IR driver after raw decoder modules have been loaded won't work as
>> expected.
>>
>> This patch moves that logic into ir-raw-event and adds a single sysfs
>> file per device.
>>
>> Reading that file returns something like:
>>
>>        "rc5 [rc6] nec jvc [sony]"
>>
>> (with enabled protocols in [] brackets)
>>
>> Writing either "+protocol" or "-protocol" to that file will
>> enable or disable the according protocol decoder.
>>
>> An additional benefit is that the disabling of a decoder will be
>> remembered across module removal/insertion so a previously
>> disabled decoder won't suddenly be activated again. The default
>> setting is to enable all decoders.
>>
>> This is also necessary for the next patch which moves even more decoder
>> state into the central raw decoding structs.
>>
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>
> Acked-by: Jarod Wilson <jarod@redhat.com>
> Tested-by: Jarod Wilson <jarod@redhat.com>
>
> Note that I was running a version rebased atop the linuxtv staging/rc
> branch though.

Found here:

http://git.wilsonet.com//linux-2.6-ir-wip.git?a=commitdiff;h=e4166a6c70c4f9a06644ce8b4e9beeea7c336d90


-- 
Jarod Wilson
jarod@wilsonet.com
