Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0101.outbound.protection.outlook.com ([104.47.40.101]:42176
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750968AbeCTDsQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 23:48:16 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <arnd@arndb.de>, <mchehab@kernel.org>
CC: <msebor@gmail.com>, <Toshihiko.Matsumoto@sony.com>,
        <Kota.Yonezawa@sony.com>, <Satoshi.C.Watanabe@sony.com>,
        <Masayuki.Yamamoto@sony.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Yasunari.Takiguchi@sony.com>
Subject: RE: [PATCH] media: cxd2880-spi: avoid out-of-bounds access warning
Date: Tue, 20 Mar 2018 03:47:57 +0000
Message-ID: <02699364973B424C83A42A84B04FDA85484BC2@JPYOKXMS113.jp.sony.com>
References: <20180313120931.2667235-1-arnd@arndb.de>
In-Reply-To: <20180313120931.2667235-1-arnd@arndb.de>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

We check the patch. 

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, March 13, 2018 9:09 PM
> To: Takiguchi, Yasunari (SSS); Mauro Carvalho Chehab
> Cc: Arnd Bergmann; Martin Sebor; Matsumoto, Toshihiko (SSS); Yonezawa,
> Kota (SSS); Watanabe, Satoshi (SSS); Yamamoto, Masayuki (SSS);
> linux-media@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] media: cxd2880-spi: avoid out-of-bounds access warning
> 
> The -Warray-bounds warning in gcc-8 triggers for a newly added file:
> 
> drivers/media/spi/cxd2880-spi.c: In function 'cxd2880_write_reg':
> drivers/media/spi/cxd2880-spi.c:111:3: error: 'memcpy' forming offset
> [133, 258] is out of the bounds [0, 132] of object 'send_data' with type
> 'u8[132]' {aka 'unsigned char[132]'} [-Werror=array-bounds]
> 
> The problem appears to be that we have two range checks in this function,
> first comparing against BURST_WRITE_MAX (128) and then comparing against
> a literal '255'. The logic checking the buffer size looks at the second
> one and decides that this might be the actual maximum data length.
> 
> This is understandable behavior from the compiler, but the code is
> actually safe. Since the first check is already shorter, we can remove
> the loop and only leave that. To be on the safe side in case BURST_WRITE_MAX
> might be increased, I'm leaving the check against U8_MAX.
> 
> Fixes: bd24fcddf6b8 ("media: cxd2880-spi: Add support for CXD2880 SPI
> interface")
> Cc: Martin Sebor <msebor@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/spi/cxd2880-spi.c | 24 +++++++-----------------
>  1 file changed, 7 insertions(+), 17 deletions(-)

Reviewed-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
