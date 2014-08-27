Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42751 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaH0Imu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 04:42:50 -0400
Received: by mail-pa0-f52.google.com with SMTP id bj1so25113633pad.25
        for <linux-media@vger.kernel.org>; Wed, 27 Aug 2014 01:42:44 -0700 (PDT)
Message-ID: <53FD99FA.4030207@linaro.org>
Date: Wed, 27 Aug 2014 16:42:34 +0800
From: zhangfei <zhangfei.gao@linaro.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	arnd@arndb.de, haifeng.yan@linaro.org, jchxue@gmail.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [media] rc: remove change_protocol in rc-ir-raw.c
References: <1408613086-12538-1-git-send-email-zhangfei.gao@linaro.org>	<1408613086-12538-4-git-send-email-zhangfei.gao@linaro.org> <20140821065006.6d831ec4@concha.lan>
In-Reply-To: <20140821065006.6d831ec4@concha.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/21/2014 07:50 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 21 Aug 2014 17:24:45 +0800
> Zhangfei Gao <zhangfei.gao@linaro.org> escreveu:
>
>> With commit 4924a311a62f ("[media] rc-core: rename ir-raw.c"),
>> empty change_protocol was introduced.
>
> No. This was introduced on this changeset:
>
> commit da6e162d6a4607362f8478c715c797d84d449f8b
> Author: David Härdeman <david@hardeman.nu>
> Date:   Thu Apr 3 20:32:16 2014 -0300
>
>      [media] rc-core: simplify sysfs code
>
>> As a result, rc_register_device will set dev->enabled_protocols
>> addording to rc_map->rc_type, which prevent using all protocols.
>
> I strongly suspect that this patch will break some things, as
> the new code seems to expect that this is always be set.
>
> See the code at store_protocols(): if this callback is not set,
> then it won't allow to disable a protocol.
>
> Also, this doesn't prevent using all protocols. You can still use
> "ir-keytable -p all" to enable all protocols (the "all" protocol
> type were introduced recently at the userspace tool).
>
>  From the way I see, setting the protocol when a table is loaded
> is not a bad thing, as:
> - if RC tables are loaded, the needed protocol to decode it is
>    already known;
> - by running just one IR decoder, the IR handling routine will
>    be faster and will consume less power;
> - on a real case scenario, it is a way more likely that just one
>    decoder will ever be needed by the end user.
>
> So, I think that this is just annoying for developers when are checking
> if all decoders are working, by sending keycodes from different IR types
> at the same time.
>

Thanks Mauro for the kind explanation.

ir-keytable seems also enalbe specific protocol
-p, --protocol=PROTOCOL

Currently we use lirc user space decoder/keymap and only need 
pulse-length information from kernel.

Thanks for the info.

