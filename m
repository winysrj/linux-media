Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0096.outbound.protection.outlook.com ([104.47.40.96]:64768
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751496AbdLTBGo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 20:06:44 -0500
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
        "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Subject: RE: [PATCH v4 06/12] [media] cxd2880: Add integration layer for the
 driver
Date: Wed, 20 Dec 2017 01:06:25 +0000
Message-ID: <02699364973B424C83A42A84B04FDA85440BCF@JPYOKXMS113.jp.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
        <20171013060834.21526-1-Yasunari.Takiguchi@sony.com>
 <20171213171319.675b39a6@vento.lan>
In-Reply-To: <20171213171319.675b39a6@vento.lan>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Mauro.

> >
> > These functions monitor the driver and watch for task completion.
> > This is part of the Sony CXD2880 DVB-T2/T tuner + demodulator driver.
> 
> If I understand well, the goal here is to have thread that would be waking
> up from time to time, right? Just use the infrastructure that the Kernel
> has for it, like a kthread, or timer_setup() & friends.
> 
> Take a look at include/linux/timer.h, and just use what's already defined.

This code is initialize process.
Therefore, it is executed only once and it will not execute other processing at the same time.
We think that the current implementation is enough.
What do you think?
furthermore, we will modify this code by using ktime_foo().

Thanks,
Takiguchi
