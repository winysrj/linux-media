Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0127.outbound.protection.outlook.com ([104.47.41.127]:14716
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751179AbeDFA2y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 20:28:54 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <mchehab@s-opensource.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <tbird20d@gmail.com>,
        <frowand.list@gmail.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>,
        <Yasunari.Takiguchi@sony.com>
Subject: RE: [PATCH v5 02/12] [media] cxd2880-spi: Add support for CXD2880
 SPI interface
Date: Fri, 6 Apr 2018 00:28:46 +0000
Message-ID: <02699364973B424C83A42A84B04FDA8548B8E7@JPYOKXMS113.jp.sony.com>
References: <20180118084016.20689-1-Yasunari.Takiguchi@sony.com>
        <20180118084610.20967-1-Yasunari.Takiguchi@sony.com>
 <20180307071529.66e33f54@vento.lan>
In-Reply-To: <20180307071529.66e33f54@vento.lan>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,　Mauro

> > +	u8 send_data[BURST_WRITE_MAX + 4];
> > +	const u8 *write_data_top = NULL;
> > +	int ret = 0;
> > +
> > +	if (!spi || !data) {
> > +		pr_err("invalid arg\n");
> > +		return -EINVAL;
> > +	}
> > +	if (size > BURST_WRITE_MAX) {
> > +		pr_err("data size > WRITE_MAX\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (sub_address + size > 0x100) {
> > +		pr_err("out of range\n");
> > +		return -EINVAL;
> > +	}
> 
> It is better to use dev_err(spi->dev, ...) instead of pr_err().

I got comment for this previous version patch as below
--------------------------------------------------------------------------------------
The best would be to se dev_err() & friends for printing messages, as they print the device's name as filled at struct device.
If you don't use, please add a define that will print the name at the logs, like:

  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

either at the begining of the driver or at some header file.

Btw, I'm noticing that you're also using dev_err() on other places of the code. 
Please standardize. OK, on a few places, you may still need to use pr_err(), if you need to print a message before initializing struct device, but I suspect that you can init
--------------------------------------------------------------------------------------

You pointed out here before. Because dev_foo () and pr_foo () were mixed.
We standardize with pr_foo() because the logs is outputted before getting the device structure.
Is it better to use dev_foo() where we can use it?

Takiguchi
