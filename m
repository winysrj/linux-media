Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:55585 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbbIYHWs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2015 03:22:48 -0400
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com [209.85.215.46])
	by imap.netup.ru (Postfix) with ESMTPA id 48A7B72FB1E
	for <linux-media@vger.kernel.org>; Fri, 25 Sep 2015 10:22:45 +0300 (MSK)
Received: by lacao8 with SMTP id ao8so88562780lac.3
        for <linux-media@vger.kernel.org>; Fri, 25 Sep 2015 00:22:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABxcv==4OQce73RGPstvHQWt0sbHyx5Hv114rweOtpyb2F+fcQ@mail.gmail.com>
References: <201509201159.QAcxzCyr%fengguang.wu@intel.com> <CABxcv==4OQce73RGPstvHQWt0sbHyx5Hv114rweOtpyb2F+fcQ@mail.gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Fri, 25 Sep 2015 10:22:25 +0300
Message-ID: <CAK3bHNW4DBB3VBeEWZE_B2CmtK=31iEXZnZru9A3Mngr-cD-tg@mail.gmail.com>
Subject: Re: drivers/media/dvb-frontends/lnbh25.h:46:15: error: unknown type
 name 'dvb_frontend'
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier, Mauro,

Acked-by: Abylay Ospan <aospan@netup.ru>


2015-09-21 11:20 GMT+03:00 Javier Martinez Canillas <javier@dowhile0.org>:
> Hello,
>
> On Sun, Sep 20, 2015 at 5:17 AM, kbuild test robot
> <fengguang.wu@intel.com> wrote:
>> Hi Kozlov,
>>
>> FYI, the error/warning still remains. You may either fix it or ask me to silently ignore in future.
>>
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> head:   133bb59585140747fd3938002670cb395f40dc76
>> commit: 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver
>> date:   6 weeks ago
>> config: x86_64-randconfig-h0-09201020 (attached as .config)
>> reproduce:
>>   git checkout 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e
>>   # save the attached .config to linux build tree
>>   make ARCH=x86_64
>>
>> All error/warnings (new ones prefixed by >>):
>>
>>    In file included from drivers/media/pci/netup_unidvb/netup_unidvb_core.c:36:0:
>>>> drivers/media/dvb-frontends/lnbh25.h:46:15: error: unknown type name 'dvb_frontend'
>>     static inline dvb_frontend *lnbh25_attach(
>>                   ^
>>
>> vim +/dvb_frontend +46 drivers/media/dvb-frontends/lnbh25.h
>>
>> e025273b Kozlov Sergey 2015-07-28  40  #if IS_REACHABLE(CONFIG_DVB_LNBH25)
>> e025273b Kozlov Sergey 2015-07-28  41  struct dvb_frontend *lnbh25_attach(
>> e025273b Kozlov Sergey 2015-07-28  42   struct dvb_frontend *fe,
>> e025273b Kozlov Sergey 2015-07-28  43   struct lnbh25_config *cfg,
>> e025273b Kozlov Sergey 2015-07-28  44   struct i2c_adapter *i2c);
>> e025273b Kozlov Sergey 2015-07-28  45  #else
>> e025273b Kozlov Sergey 2015-07-28 @46  static inline dvb_frontend *lnbh25_attach(
>> e025273b Kozlov Sergey 2015-07-28  47   struct dvb_frontend *fe,
>> e025273b Kozlov Sergey 2015-07-28  48   struct lnbh25_config *cfg,
>> e025273b Kozlov Sergey 2015-07-28  49   struct i2c_adapter *i2c)
>>
>> :::::: The code at line 46 was first introduced by commit
>> :::::: e025273b86fb4a6440192b809e05332777c3faa5 [media] lnbh25: LNBH25 SEC controller driver
>>
>> :::::: TO: Kozlov Sergey <serjk@netup.ru>
>> :::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>
>
> I had already posted a patch to fix this issue about a week ago:
>
> https://patchwork.linuxtv.org/patch/31402/
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
