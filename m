Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:55269 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbbIYHK4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2015 03:10:56 -0400
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com [209.85.215.53])
	by imap.netup.ru (Postfix) with ESMTPA id 8870172FB09
	for <linux-media@vger.kernel.org>; Fri, 25 Sep 2015 10:10:55 +0300 (MSK)
Received: by lacao8 with SMTP id ao8so88298747lac.3
        for <linux-media@vger.kernel.org>; Fri, 25 Sep 2015 00:10:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABxcv=kxojA4Tuv-Vas8KkAh8SUJ-cbM8rPW3Auk7H6RP9aAxA@mail.gmail.com>
References: <201509201655.YWNNEnBb%fengguang.wu@intel.com> <CABxcv=kxojA4Tuv-Vas8KkAh8SUJ-cbM8rPW3Auk7H6RP9aAxA@mail.gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Fri, 25 Sep 2015 10:10:35 +0300
Message-ID: <CAK3bHNWwH+AN7+siXymALwgARPJEDARWyRQqzef7Gn2DuURS9w@mail.gmail.com>
Subject: Re: drivers/media/pci/netup_unidvb/netup_unidvb_core.c:417:18: error:
 too many arguments to function 'horus3a_attach'
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier, Mauro,

seems like I have sent duplicate patch to fix this problem ( Subject:
[PATCH] fix compile error when CONFIG_DVB_HORUS3A is disabled). It's
totally identical so, please ignore my patch and apply Javier's patch
https://patchwork.linuxtv.org/patch/31401/

thanks !

2015-09-21 11:21 GMT+03:00 Javier Martinez Canillas <javier@dowhile0.org>:
> Hello,
>
> On Sun, Sep 20, 2015 at 10:56 AM, kbuild test robot
> <fengguang.wu@intel.com> wrote:
>> Hi Kozlov,
>>
>> FYI, the error/warning still remains. You may either fix it or ask me to silently ignore in future.
>>
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> head:   99bc7215bc60f6cd414cf1b85cd9d52cc596cccb
>> commit: 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver
>> date:   6 weeks ago
>> config: i386-randconfig-b0-09201649 (attached as .config)
>> reproduce:
>>   git checkout 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e
>>   # save the attached .config to linux build tree
>>   make ARCH=i386
>>
>> All error/warnings (new ones prefixed by >>):
>>
>>    In file included from drivers/media/pci/netup_unidvb/netup_unidvb_core.c:34:0:
>>    drivers/media/dvb-frontends/horus3a.h:51:13: warning: 'struct cxd2820r_config' declared inside parameter list
>>          struct i2c_adapter *i2c)
>>
>
> I had already posted a patch to fix this issue about a week ago:
>
> https://patchwork.linuxtv.org/patch/31401/
>
> Best regards,
> Javier
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
