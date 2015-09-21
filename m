Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:33276 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbbIUIUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 04:20:09 -0400
Received: by ykft14 with SMTP id t14so95874911ykf.0
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2015 01:20:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201509201159.QAcxzCyr%fengguang.wu@intel.com>
References: <201509201159.QAcxzCyr%fengguang.wu@intel.com>
Date: Mon, 21 Sep 2015 10:20:08 +0200
Message-ID: <CABxcv==4OQce73RGPstvHQWt0sbHyx5Hv114rweOtpyb2F+fcQ@mail.gmail.com>
Subject: Re: drivers/media/dvb-frontends/lnbh25.h:46:15: error: unknown type
 name 'dvb_frontend'
From: Javier Martinez Canillas <javier@dowhile0.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sun, Sep 20, 2015 at 5:17 AM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> Hi Kozlov,
>
> FYI, the error/warning still remains. You may either fix it or ask me to silently ignore in future.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   133bb59585140747fd3938002670cb395f40dc76
> commit: 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver
> date:   6 weeks ago
> config: x86_64-randconfig-h0-09201020 (attached as .config)
> reproduce:
>   git checkout 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e
>   # save the attached .config to linux build tree
>   make ARCH=x86_64
>
> All error/warnings (new ones prefixed by >>):
>
>    In file included from drivers/media/pci/netup_unidvb/netup_unidvb_core.c:36:0:
>>> drivers/media/dvb-frontends/lnbh25.h:46:15: error: unknown type name 'dvb_frontend'
>     static inline dvb_frontend *lnbh25_attach(
>                   ^
>
> vim +/dvb_frontend +46 drivers/media/dvb-frontends/lnbh25.h
>
> e025273b Kozlov Sergey 2015-07-28  40  #if IS_REACHABLE(CONFIG_DVB_LNBH25)
> e025273b Kozlov Sergey 2015-07-28  41  struct dvb_frontend *lnbh25_attach(
> e025273b Kozlov Sergey 2015-07-28  42   struct dvb_frontend *fe,
> e025273b Kozlov Sergey 2015-07-28  43   struct lnbh25_config *cfg,
> e025273b Kozlov Sergey 2015-07-28  44   struct i2c_adapter *i2c);
> e025273b Kozlov Sergey 2015-07-28  45  #else
> e025273b Kozlov Sergey 2015-07-28 @46  static inline dvb_frontend *lnbh25_attach(
> e025273b Kozlov Sergey 2015-07-28  47   struct dvb_frontend *fe,
> e025273b Kozlov Sergey 2015-07-28  48   struct lnbh25_config *cfg,
> e025273b Kozlov Sergey 2015-07-28  49   struct i2c_adapter *i2c)
>
> :::::: The code at line 46 was first introduced by commit
> :::::: e025273b86fb4a6440192b809e05332777c3faa5 [media] lnbh25: LNBH25 SEC controller driver
>
> :::::: TO: Kozlov Sergey <serjk@netup.ru>
> :::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>

I had already posted a patch to fix this issue about a week ago:

https://patchwork.linuxtv.org/patch/31402/

Best regards,
Javier
