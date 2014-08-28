Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44851 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783AbaH1JSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 05:18:47 -0400
Received: by mail-pa0-f44.google.com with SMTP id rd3so1810167pab.3
        for <linux-media@vger.kernel.org>; Thu, 28 Aug 2014 02:18:46 -0700 (PDT)
Message-ID: <53FEF3EE.1040708@linaro.org>
Date: Thu, 28 Aug 2014 17:18:38 +0800
From: zhangfei <zhangfei.gao@linaro.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	arnd@arndb.de, haifeng.yan@linaro.org, jchxue@gmail.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [media] rc: remove change_protocol in rc-ir-raw.c
References: <1408613086-12538-1-git-send-email-zhangfei.gao@linaro.org> <1408613086-12538-4-git-send-email-zhangfei.gao@linaro.org> <20140821065006.6d831ec4@concha.lan> <53FD99FA.4030207@linaro.org> <20140827083447.6af0157f.m.chehab@samsung.com>
In-Reply-To: <20140827083447.6af0157f.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/27/2014 07:34 PM, Mauro Carvalho Chehab wrote:

>>>> With commit 4924a311a62f ("[media] rc-core: rename ir-raw.c"),
>>>> empty change_protocol was introduced.
>>>
>>> No. This was introduced on this changeset:
>>>
>>> commit da6e162d6a4607362f8478c715c797d84d449f8b
>>> Author: David Härdeman <david@hardeman.nu>
>>> Date:   Thu Apr 3 20:32:16 2014 -0300
>>>
>>>       [media] rc-core: simplify sysfs code
>>>
>>>> As a result, rc_register_device will set dev->enabled_protocols
>>>> addording to rc_map->rc_type, which prevent using all protocols.
>>>
>>> I strongly suspect that this patch will break some things, as
>>> the new code seems to expect that this is always be set.
>>>
>>> See the code at store_protocols(): if this callback is not set,
>>> then it won't allow to disable a protocol.
>>>
>>> Also, this doesn't prevent using all protocols. You can still use
>>> "ir-keytable -p all" to enable all protocols (the "all" protocol
>>> type were introduced recently at the userspace tool).
>>>
>>>   From the way I see, setting the protocol when a table is loaded
>>> is not a bad thing, as:
>>> - if RC tables are loaded, the needed protocol to decode it is
>>>     already known;
>>> - by running just one IR decoder, the IR handling routine will
>>>     be faster and will consume less power;
>>> - on a real case scenario, it is a way more likely that just one
>>>     decoder will ever be needed by the end user.
>>>
>>> So, I think that this is just annoying for developers when are checking
>>> if all decoders are working, by sending keycodes from different IR types
>>> at the same time.
>>>
>>
>> Thanks Mauro for the kind explanation.
>>
>> ir-keytable seems also enalbe specific protocol
>> -p, --protocol=PROTOCOL
>>
>> Currently we use lirc user space decoder/keymap and only need
>> pulse-length information from kernel.
>
> Well, you can use ir-keytable to disable everything but lirc, not
> compile the other hardware decoders or directly write "lirc" to
> /sys/class/rc/rc0/protocols (see Documentation/ABI/testing/sysfs-class-rc).
>
> Anyway, I suggest you to use the hardware decoder instead of lirc,
> as the in-kernel decoders should be lighter than lirc and works pretty
> well, but this is, of course, your decision.
>
> Btw, it would make sense, IMHO, to have a way to setup LIRC daemon to
> enable LIRC output on a given remote controller, and, optionally,
> disabling the hardware decoders that are needlessly enabled.
>

Thanks Mauro

Double checked, both ir-keytable and /sys/class/rc/rc0/protocols can 
enable/disable protocols, which is much easier than dts passing 
information, and by default all protocols are disabled.

Thanks for this kind information.

