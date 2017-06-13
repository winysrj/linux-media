Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0127.outbound.protection.outlook.com ([104.47.32.127]:23960
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751921AbdFMFfl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 01:35:41 -0400
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Subject: Re: [PATCH v2 0/15] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
To: Abylay Ospan <aospan@netup.ru>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
 <5188b958-9a34-4519-5845-a318273592e0@sony.com>
 <d7c70c53-3fb0-a045-5e1a-1a736bdeda1f@sony.com>
 <0e192530-9b56-e8fb-6210-ab619ddde1de@sony.com>
 <CAK3bHNXgbZ0oXbUAYCznpW-iLwQeStFcYRERfRPQcVrk18Pm6g@mail.gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@s-opensource.com>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
        <yasunari.takiguchi@sony.com>
Message-ID: <6586e809-417f-bb4b-5ca5-e38b9641894b@sony.com>
Date: Tue, 13 Jun 2017 14:35:18 +0900
MIME-Version: 1.0
In-Reply-To: <CAK3bHNXgbZ0oXbUAYCznpW-iLwQeStFcYRERfRPQcVrk18Pm6g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Abylay Ospan

Thank you for your review and proposal.

Unfortunately, we supposed it's difficult to cover CXD2841 functionality by CXD2880 driver.
CXD2880 is for mobile IC, tuner (RF) and demodulator convined IC.
On the other hand, CXD2841 is demodulator only IC for stationary use.
CXD2841 supports terrestrial, cable and satellite broadcasting systems.
But CXD2880 supports terrestrial broadcasting systems only.
And as you suggested, the driver supports SPI interface only.

Regards & Thanks a lot
Takiguchi


On 2017/06/12 22:33, Abylay Ospan wrote:
> Dear Takiguchi,
> 
> I'm working on 'drivers/media/dvb-frontends/cxd2841er.c' (universal
> demod) and 'linux/drivers/media/dvb-frontends/helene.c' (universal
> TERR/CABLE/SAT tuner).
> 
> How do you think - is your cxd2880 proposed driver have possibilities
> to cover cxd2841er demod functionality too ?
> 
> I have quickly checked your cxd2880_top.c and looks like cxd2880 works
> over SPI (not I2C) ?Also, looks like registers map, sequences
> is different. Am I right ?
> 
> How do you think ?
> 
> Thanks a lot !
