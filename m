Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:34399 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbbIUIV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 04:21:26 -0400
Received: by ykdg206 with SMTP id g206so95756173ykd.1
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2015 01:21:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201509201655.YWNNEnBb%fengguang.wu@intel.com>
References: <201509201655.YWNNEnBb%fengguang.wu@intel.com>
Date: Mon, 21 Sep 2015 10:21:25 +0200
Message-ID: <CABxcv=kxojA4Tuv-Vas8KkAh8SUJ-cbM8rPW3Auk7H6RP9aAxA@mail.gmail.com>
Subject: Re: drivers/media/pci/netup_unidvb/netup_unidvb_core.c:417:18: error:
 too many arguments to function 'horus3a_attach'
From: Javier Martinez Canillas <javier@dowhile0.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sun, Sep 20, 2015 at 10:56 AM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> Hi Kozlov,
>
> FYI, the error/warning still remains. You may either fix it or ask me to silently ignore in future.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   99bc7215bc60f6cd414cf1b85cd9d52cc596cccb
> commit: 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver
> date:   6 weeks ago
> config: i386-randconfig-b0-09201649 (attached as .config)
> reproduce:
>   git checkout 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e
>   # save the attached .config to linux build tree
>   make ARCH=i386
>
> All error/warnings (new ones prefixed by >>):
>
>    In file included from drivers/media/pci/netup_unidvb/netup_unidvb_core.c:34:0:
>    drivers/media/dvb-frontends/horus3a.h:51:13: warning: 'struct cxd2820r_config' declared inside parameter list
>          struct i2c_adapter *i2c)
>

I had already posted a patch to fix this issue about a week ago:

https://patchwork.linuxtv.org/patch/31401/

Best regards,
Javier
