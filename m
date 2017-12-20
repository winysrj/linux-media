Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0102.outbound.protection.outlook.com ([104.47.36.102]:54460
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753781AbdLTBCE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 20:02:04 -0500
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
Subject: RE: [PATCH v4 05/12] [media] cxd2880: Add tuner part of the driver
Date: Wed, 20 Dec 2017 01:01:59 +0000
Message-ID: <02699364973B424C83A42A84B04FDA85440BB1@JPYOKXMS113.jp.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
        <20171013060725.21439-1-Yasunari.Takiguchi@sony.com>
 <20171213164039.7eb5ad79@vento.lan>
In-Reply-To: <20171213164039.7eb5ad79@vento.lan>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Mauro


> > +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> > +				     CXD2880_IO_TGT_SYS,
> > +				     0x10, data, 1);
> > +	if (ret)
> > +		return ret;
> > +	if ((data[0] & 0x01) == 0x00)
> > +		return -EBUSY;
> 
> I don't know anything about this hardware, but it sounds weird to return
> -EBUSY here, except if the hardware reached a permanent busy condition,
> and would require some sort of reset to work again.
> 
> As this is in the middle of lots of things, I *suspect* that this is
> not the case.
> 
> If I'm right, and this is just a transitory solution that could happen
> for a limited amount of time, e. g. if what's there at data[0] is a flag
> saying that the device didn't finish the last operation yet, maybe the
> best would be to do something like:
> 
> 	for (i = 0; i < 10; i++) {
> 		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> 					     CXD2880_IO_TGT_SYS,
> 					     0x10, data, 1);
> 		if (ret)
> 			return ret;
> 		if (data[0] & 0x01)
> 			break;
> 		msleep(10);
> 	}
> 	if (!(data[0] & 0x01))
> 		return -EBUSY;
> 
> > +
> > +	ret = cxd2880_io_write_multi_regs(tnr_dmd->io,
> > +					  CXD2880_IO_TGT_SYS,
> > +					  rf_init1_seq5,
> > +					  ARRAY_SIZE(rf_init1_seq5));
> > +	if (ret)
> > +		return ret;
> > +
> > +	usleep_range(1000, 2000);
> > +
> > +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> > +				     CXD2880_IO_TGT_SYS,
> > +				     0x00, 0x0a);
> > +	if (ret)
> > +		return ret;
> > +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> > +				     CXD2880_IO_TGT_SYS,
> > +				     0x11, data, 1);
> > +	if (ret)
> > +		return ret;
> > +	if ((data[0] & 0x01) == 0x00)
> > +		return -EBUSY;
> 
> Same here and on similar places.

As the hardware specification, It is abnormal if certain register doesn't become 1 even if sleep time passes.
Perhaps it should not be return EBUSY.
We will reconsider error code.

Thanks,
Takiguchi
