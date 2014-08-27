Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:22386 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbaH0Ley convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 07:34:54 -0400
Date: Wed, 27 Aug 2014 08:34:47 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: zhangfei <zhangfei.gao@linaro.org>
Cc: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>, arnd@arndb.de,
	haifeng.yan@linaro.org, jchxue@gmail.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [media] rc: remove change_protocol in rc-ir-raw.c
Message-id: <20140827083447.6af0157f.m.chehab@samsung.com>
In-reply-to: <53FD99FA.4030207@linaro.org>
References: <1408613086-12538-1-git-send-email-zhangfei.gao@linaro.org>
 <1408613086-12538-4-git-send-email-zhangfei.gao@linaro.org>
 <20140821065006.6d831ec4@concha.lan> <53FD99FA.4030207@linaro.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Aug 2014 16:42:34 +0800
zhangfei <zhangfei.gao@linaro.org> escreveu:

> 
> 
> On 08/21/2014 07:50 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 21 Aug 2014 17:24:45 +0800
> > Zhangfei Gao <zhangfei.gao@linaro.org> escreveu:
> >
> >> With commit 4924a311a62f ("[media] rc-core: rename ir-raw.c"),
> >> empty change_protocol was introduced.
> >
> > No. This was introduced on this changeset:
> >
> > commit da6e162d6a4607362f8478c715c797d84d449f8b
> > Author: David Härdeman <david@hardeman.nu>
> > Date:   Thu Apr 3 20:32:16 2014 -0300
> >
> >      [media] rc-core: simplify sysfs code
> >
> >> As a result, rc_register_device will set dev->enabled_protocols
> >> addording to rc_map->rc_type, which prevent using all protocols.
> >
> > I strongly suspect that this patch will break some things, as
> > the new code seems to expect that this is always be set.
> >
> > See the code at store_protocols(): if this callback is not set,
> > then it won't allow to disable a protocol.
> >
> > Also, this doesn't prevent using all protocols. You can still use
> > "ir-keytable -p all" to enable all protocols (the "all" protocol
> > type were introduced recently at the userspace tool).
> >
> >  From the way I see, setting the protocol when a table is loaded
> > is not a bad thing, as:
> > - if RC tables are loaded, the needed protocol to decode it is
> >    already known;
> > - by running just one IR decoder, the IR handling routine will
> >    be faster and will consume less power;
> > - on a real case scenario, it is a way more likely that just one
> >    decoder will ever be needed by the end user.
> >
> > So, I think that this is just annoying for developers when are checking
> > if all decoders are working, by sending keycodes from different IR types
> > at the same time.
> >
> 
> Thanks Mauro for the kind explanation.
> 
> ir-keytable seems also enalbe specific protocol
> -p, --protocol=PROTOCOL
> 
> Currently we use lirc user space decoder/keymap and only need 
> pulse-length information from kernel.

Well, you can use ir-keytable to disable everything but lirc, not
compile the other hardware decoders or directly write "lirc" to 
/sys/class/rc/rc0/protocols (see Documentation/ABI/testing/sysfs-class-rc).

Anyway, I suggest you to use the hardware decoder instead of lirc,
as the in-kernel decoders should be lighter than lirc and works pretty
well, but this is, of course, your decision. 

Btw, it would make sense, IMHO, to have a way to setup LIRC daemon to
enable LIRC output on a given remote controller, and, optionally,
disabling the hardware decoders that are needlessly enabled.

Regards,
Mauro
