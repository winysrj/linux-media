Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0128.outbound.protection.outlook.com ([104.47.38.128]:13889
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755417AbcHSPQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 11:16:09 -0400
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        "Bird, Timothy" <Tim.Bird@am.sony.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Shimizu, Kazuhiro" <Kazuhiro.Shimizu@sony.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
        "Berry, Tom" <Tom.Berry@sony.com>,
        "Rowand, Frank" <Frank.Rowand@am.sony.com>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Subject: RE: Sony tuner chip driver questions
Date: Fri, 19 Aug 2016 09:44:06 +0000
Message-ID: <02699364973B424C83A42A84B04FDA852B0AB5@JPYOKXMS113.jp.sony.com>
References: <ECADFF3FD767C149AD96A924E7EA6EAF053BB5DA@USCULXMSG02.am.sony.com>
 <20160729075741.15e1a05b@recife.lan>
 <02699364973B424C83A42A84B04FDA852AA1FB@JPYOKXMS113.jp.sony.com>
In-Reply-To: <02699364973B424C83A42A84B04FDA852AA1FB@JPYOKXMS113.jp.sony.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro

We discuss about
> At the DVB frontend, the tuner and demodulators should be implemented
> on different drivers, even when both are encapsulated on the same silicon.
with our HW developers and SW designers.

Our codes for tuner and demodulator driver of user-space driver are encapsulated 
in order to optimize tuner control sequence.
(Our tuner driver often have to set rf tuner registers and demodulator alternately. )
And there are some registers which simultaneously set parameter for tuner and demodulator block.
Additionally, we think about current TV tuner IC trend and linux tuner driver.

I summarized our study results and proposals as follows.

・In our case the tuner and demodulator are single chip architecture, so the tuner control cannot be distinguished from demodulator functionality. It is therefore difficult to separate tuner code and demodulator code.
・We understand that single chip solutions may become more popular for smartphone and low power tuner device (USB, etc) so mixed driver will be main stream.
・We intend to add the driver incorporating tuner and demodulator code to /media/dvb-frontend/XXXX (XXXX is our tuner name folder)
・We will create our driver to have same API structure as the current tuner and demodulator driver code.
  (drivers/media/dvb-frontends/m88rs2000.c and tda10071.c also seem to have tuner and demodulator code.
  We would like to refer to their codes for our creating.)

Could you give us your advice and comments?

Best Regards & Thanks
Takiguchi

