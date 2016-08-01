Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0109.outbound.protection.outlook.com ([104.47.32.109]:9280
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753305AbcHAMdc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 08:33:32 -0400
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
Date: Mon, 1 Aug 2016 06:55:18 +0000
Message-ID: <02699364973B424C83A42A84B04FDA852AA1FB@JPYOKXMS113.jp.sony.com>
References: <ECADFF3FD767C149AD96A924E7EA6EAF053BB5DA@USCULXMSG02.am.sony.com>
 <20160729075741.15e1a05b@recife.lan>
In-Reply-To: <20160729075741.15e1a05b@recife.lan>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro

Thanks for your replying.

I am checking your comments and linux/media codes.

I need to discuss with our members about our driver's structure.
Especially,
1. SPI
> There aren't many DVB drivers that aren't either PCI or USB.
> There's one at drivers/media/mmc/siano/smssdio.c, but I guess this is not the
> best example. ST is working on upstreaming drivers for some of their SoCs. They're
> placing their drivers under drivers/media/platform/sti. Maybe this could help you more on that.

2.Tuner & Demodulator
> At the DVB frontend, the tuner and demodulators should be implemented on different
> drivers, even when both are encapsulated on the same silicon.
> By using two drivers, it makes easier to review the code. It also helps to better
> encapsulate the functions on each part of the chip.
Our codes for tuner and demodulator driver of user-space are encapsulated in order to optimize tuner control sequence.

I will send comments and additional questions after we have internal discussion.

Thanks,
Takiguchi

