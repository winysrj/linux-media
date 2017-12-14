Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0094.outbound.protection.outlook.com ([104.47.38.94]:11392
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750992AbdLNJ7j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 04:59:39 -0500
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
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
        "Bird, Timothy" <Tim.Bird@sony.com>,
        "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Subject: RE: [PATCH v4 00/12] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Thu, 14 Dec 2017 09:59:32 +0000
Message-ID: <02699364973B424C83A42A84B04FDA85431742@JPYOKXMS113.jp.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
 <20171213173633.57edca85@vento.lan>
In-Reply-To: <20171213173633.57edca85@vento.lan>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro

Thanks for your review.

We will refer to your comments and consider how to respond for them.
I want to confirm one thing about  SPDX license text

We will add SPDX license text to our files, 
Is it necessary to add SPDX not only .c .h Makefile but also Kconfig?
When I checked current files in driver/media, there is no Kconfig file which has SPDX.

Best Regards,
Takiguchi
