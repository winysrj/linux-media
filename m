Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:59396 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaCXT7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:59:03 -0400
Date: Mon, 24 Mar 2014 16:58:56 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	kbuild-all@01.org
Subject: Re: cx23885-dvb.c:undefined reference to `tda18271_attach'
Message-id: <20140324165856.738bd750@samsung.com>
In-reply-to: <CA+MoWDrGGE4X9aX0=_iaacXUar17fb1B+CR5VcsPAwLFFiPCCA@mail.gmail.com>
References: <532c2aaa.lXHUJ9RIRCRIxqPO%fengguang.wu@intel.com>
 <20140321130917.GA8667@localhost>
 <CA+MoWDrGGE4X9aX0=_iaacXUar17fb1B+CR5VcsPAwLFFiPCCA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Em Mon, 24 Mar 2014 16:34:17 +0100
Peter Senna Tschudin <peter.senna@gmail.com> escreveu:

> Hi,
> 
> I'm being blamed for some bugs for more than one year, and this
> weekend I was able to reproduce the error for the first time. I have
> the impression that the issue is related to Kconfig because when
> compiling the Kernel for x86(not x86_64), and
> when:
> CONFIG_VIDEO_CX23885=y
> 
> and
> 
> CONFIG_MEDIA_TUNER_TDA18271=m
> 
> the build fails as the tuner code was compiled as a module when it
> should have been compiled as part of the Kernel. 

No. It is valid to have those I2C drivers compiled as module while
the main driver is compiled builtin.

The trick is to use dvb_attach() macro. This macro is very bad
named. It should be named as something like:
	request_module_and_execute_symbol()
In order to express what it really does.

> On the Kconfig file
> drivers/media/pci/cx23885/Kconfig:
> config VIDEO_CX23885
>         tristate "Conexant cx23885 (2388x successor) support"
>         ...
>         select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
> 
> which I think is the problem. Can I just remove this 'if
> MEDIA_SUBDRV_AUTOSELECT'? Or what is the correct way of telling
> Kconfig to set CONFIG_MEDIA_TUNER_TDA18271 based on the value of
> CONFIG_VIDEO_CX23885?

You shouldn't be doing any of this. In this specific setup,
we have:

# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_VIDEO_CX23885=y

With should be a valid configuration. 

I'll try to reproduce and fix this one locally and send a fix for it
latter.

> There are at least 6 similar cases which I'm willing to send patches.
> 
> Thank you,
> 
> Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Regards,
Mauro
