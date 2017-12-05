Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0124.outbound.protection.outlook.com ([104.47.36.124]:55856
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752291AbdLELrS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Dec 2017 06:47:18 -0500
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
To: Sean Young <sean@mess.org>
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
Subject: RE: [PATCH v4 07/12] [media] cxd2880: Add top level of the driver
Date: Tue, 5 Dec 2017 11:47:11 +0000
Message-ID: <02699364973B424C83A42A84B04FDA8542C075@JPYOKXMS113.jp.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
 <20171013060934.21612-1-Yasunari.Takiguchi@sony.com>
 <20171203225911.v6unmy5b2k3yc2tf@gofer.mess.org>
In-Reply-To: <20171203225911.v6unmy5b2k3yc2tf@gofer.mess.org>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Sean

Hi, Thanks for your review.

We will refer to your comments and consider how to respond for them.

> > +	u8 rdata[2];
> > +	int ret;
> > +
> > +	if ((!tnrdmd) || (!pre_bit_err) || (!pre_bit_count))
> > +		return -EINVAL;
> > +
> > +	if (tnrdmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> > +		return -EINVAL;
> 
> divermode: this should say drivermode, correct?

diver_mode is not typo, because cxd2880 has diversity function.

> > +MODULE_DESCRIPTION(
> > +"Sony CXD2880 DVB-T2/T tuner + demodulator drvier");
> 
> drvier => driver
Yes. It is typo. We will also re-check other patch files.

Thanks
Takiguchi
