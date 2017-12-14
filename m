Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61762 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751173AbdLNKzM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 05:55:12 -0500
Date: Thu, 14 Dec 2017 08:55:03 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
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
        "Bird, Timothy" <Tim.Bird@sony.com>
Subject: Re: [PATCH v4 00/12] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
Message-ID: <20171214085503.289f06f8@vento.lan>
In-Reply-To: <02699364973B424C83A42A84B04FDA85431742@JPYOKXMS113.jp.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
        <20171213173633.57edca85@vento.lan>
        <02699364973B424C83A42A84B04FDA85431742@JPYOKXMS113.jp.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Dec 2017 09:59:32 +0000
"Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com> escreveu:

> Dear Mauro
> 
> Thanks for your review.
> 
> We will refer to your comments and consider how to respond for them.
> I want to confirm one thing about  SPDX license text
> 
> We will add SPDX license text to our files, 
> Is it necessary to add SPDX not only .c .h Makefile but also Kconfig?
> When I checked current files in driver/media, there is no Kconfig file which has SPDX.

SPDX is a new requirement that started late on Kernel 4.14 development
cycle (and whose initial changes were merged directly at Linus tree).
Not all existing files have it yet, as identifying the right license
on existing files is a complex task, but if you do a:

	$ git grep SPDX $(find . -name Makefile) $(find . -name Kconfig)

You'll see that lot of such files have it already.

So, yes, please add it to both Makefile and Kconfig.

Thanks,
Mauro
