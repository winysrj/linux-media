Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:53248 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752285AbdFLNdi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 09:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <0e192530-9b56-e8fb-6210-ab619ddde1de@sony.com>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
 <5188b958-9a34-4519-5845-a318273592e0@sony.com> <d7c70c53-3fb0-a045-5e1a-1a736bdeda1f@sony.com>
 <0e192530-9b56-e8fb-6210-ab619ddde1de@sony.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Mon, 12 Jun 2017 09:33:12 -0400
Message-ID: <CAK3bHNXgbZ0oXbUAYCznpW-iLwQeStFcYRERfRPQcVrk18Pm6g@mail.gmail.com>
Subject: Re: [PATCH v2 0/15] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
To: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Takiguchi,

I'm working on 'drivers/media/dvb-frontends/cxd2841er.c' (universal
demod) and 'linux/drivers/media/dvb-frontends/helene.c' (universal
TERR/CABLE/SAT tuner).

How do you think - is your cxd2880 proposed driver have possibilities
to cover cxd2841er demod functionality too ?

I have quickly checked your cxd2880_top.c and looks like cxd2880 works
over SPI (not I2C) ?Also, looks like registers map, sequences
is different. Am I right ?

How do you think ?

Thanks a lot !

2017-05-31 21:41 GMT-04:00 Takiguchi, Yasunari <Yasunari.Takiguchi@sony.com>:
> Hi, all
>
> I sent the patch series of Sony CXD2880 DVB-T2/T tuner + demodulator driver on Apr/14.
> Are there any comments, advices and review results for them?
>
> I'd like to get better understanding of current review status for our codes.
>
> Regards,
> Takiguchi



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
