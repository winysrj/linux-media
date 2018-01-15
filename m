Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0112.outbound.protection.outlook.com ([104.47.33.112]:50176
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753122AbeAOB12 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 20:27:28 -0500
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        "Bird, Timothy" <Tim.Bird@sony.com>
CC: Philippe Ombredanne <pombredanne@nexb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: RE: [PATCH v4 00/12] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Mon, 15 Jan 2018 01:27:20 +0000
Message-ID: <02699364973B424C83A42A84B04FDA85450828@JPYOKXMS113.jp.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
        <20171213173633.57edca85@vento.lan>
        <02699364973B424C83A42A84B04FDA85431742@JPYOKXMS113.jp.sony.com>
        <20171214085503.289f06f8@vento.lan>
        <CAOFm3uEYfMH8Zj8uEx-D9yYrTyDMTG_j02619esHu-j0brQKaA@mail.gmail.com>
        <ECADFF3FD767C149AD96A924E7EA6EAF40AE4BB5@USCULXMSG01.am.sony.com>
 <20171214160411.32f23456@vento.lan>
 <02699364973B424C83A42A84B04FDA8544F7E1@JPYOKXMS113.jp.sony.com>
In-Reply-To: <02699364973B424C83A42A84B04FDA8544F7E1@JPYOKXMS113.jp.sony.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro

> 
> I am creating patch files for version 5 of our driver.
> I need to add our driver information into
> /drivers/media/dvb-frontends/Kconfig.
> This Kconfig has no SPDX license Identifier now.
> Is it unnecessary for us to add SPDX into
> /drivers/media/dvb-frontends/Kconfig?
> (Should we add our driver information only into
> /drivers/media/dvb-frontends/Kconfig?)

Additionally, 
I need to add our driver information into 
driver/media/spi/Makefile and driver/media/spi/Kconfig,
But these Makefile and Kconfig also has 
no SPDX license Identifier now.
Should I keep no SPDX for them also?

Best Regards,
Takiguchi
