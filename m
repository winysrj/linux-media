Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0098.outbound.protection.outlook.com ([104.47.33.98]:29741
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754699AbdIGKNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 06:13:09 -0400
Subject: Re: [PATCH v3 05/14] [media] cxd2880: Add tuner part of the driver
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
 <20170816043714.21394-1-Yasunari.Takiguchi@sony.com>
 <20170827114544.39865dbb@vento.lan>
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
        <yasunari.takiguchi@sony.com>
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Message-ID: <22918ced-b130-abf6-847d-369b7a5c0ebf@sony.com>
Date: Thu, 7 Sep 2017 19:12:57 +0900
MIME-Version: 1.0
In-Reply-To: <20170827114544.39865dbb@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro

Thanks for your review and reply.

We are going to discuss how to change our code with your comments internally.

I reply for your  2 comments,

>> [Change list]
>> Changes in V3
>>    drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
>>       -removed code relevant to ISDB-T
> 
> Just curiosity here: why is it removed?
We decided to withhold the ISDB-T functionality as it contains some company proprietary code.


>> +	if (ret)
>> +		return ret;
>> +	if ((sys == CXD2880_DTV_SYS_DVBT2) && en_fef_intmtnt_ctrl) {
>> +		data[0] = 0x01;
>> +		data[1] = 0x01;
>> +		data[2] = 0x01;
>> +		data[3] = 0x01;
>> +		data[4] = 0x01;
>> +		data[5] = 0x01;
>> +	} else {
>> +		data[0] = 0x00;
>> +		data[1] = 0x00;
>> +		data[2] = 0x00;
>> +		data[3] = 0x00;
>> +		data[4] = 0x00;
>> +		data[5] = 0x00;
>> +	}
> 
> Instead, just do:
> 
> 	if ((sys == CXD2880_DTV_SYS_DVBT2) && en_fef_intmtnt_ctrl)
> 		memset(data, 0x01, sizeof(data));
> 	else
> 		memset(data, 0x00, sizeof(data));
> 
>> +	ret = tnr_dmd->io->write_regs(tnr_dmd->io,
>> +				      CXD2880_IO_TGT_SYS,
>> +				      0xef, data, 6);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
>> +				     CXD2880_IO_TGT_DMD,
>> +				     0x00, 0x2d);
>> +	if (ret)
>> +		return ret;
> 
>> +	if ((sys == CXD2880_DTV_SYS_DVBT2) && en_fef_intmtnt_ctrl)
>> +		data[0] = 0x00;
>> +	else
>> +		data[0] = 0x01;
> 
> Not actually needed, as the previous logic already set data[0]
> accordingly.
> 
>> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
>> +				     CXD2880_IO_TGT_DMD,
>> +				     0xb1, data[0]);

In this case、logic of data[0]( logic of if() ) is different from that of previous one.
And with setting register for address 0xb1, a bug might occur in the future, 
if our software specification (sequence) is changed.
So we would like to keep setting value of data[0] for address 0xb1.

Thanks,
Takiguchi
