Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward20.mail.yandex.net ([95.108.253.145]:46551 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2HKBWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 21:22:44 -0400
From: CrazyCat <crazycat69@yandex.ru>
To: Antti Palosaari <crope@iki.fi>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	CrazyCat <crazycat69@yandex.ru>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manu Abraham <manu@linuxtv.org>
In-Reply-To: <5025B05F.8090809@iki.fi>
References: <59951342221302@web18g.yandex.ru> <50258758.8050902@redhat.com> <5025A3FD.8020001@iki.fi> <CAHFNz9KA1pHgxyjX5KdKgsy8nWgREkVFTVg38cox1TFNGJVqew@mail.gmail.com> <5025B05F.8090809@iki.fi>
Subject: Re: [PATCH] DVB-S2 multistream support
MIME-Version: 1.0
Message-Id: <1758481344648159@web26g.yandex.ru>
Date: Sat, 11 Aug 2012 04:22:39 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stream can be anything :) But for DVB standards this anyway DVBS transport stream 188 byte. Most media-bridges can handle only this stream. Specific generic-continous DVB-S2/T2/C2 streams require extended bus for passing frame-based stream, so this out of V4L DVB.

Now MIS used often for distribution multiple digital terrestial muxes over one satellite carrier (implemented in my patch, now i make patches for VDR and TVHeadend for MIS). DVB-T2 PLP is same, but i not see any real-life implementation (have some tda18712/cxd2820r-based hardware and T2/256QAM-in-air, but only one PLP). Don't know anything about ISDB :)

11.08.2012, 04:07, "Antti Palosaari" <crope@iki.fi>:
>>>>> šššš#define DTV_ISDBS_TS_ID šššššššššššššš42
>>>>> šššš#define DTV_DVBT2_PLP_ID ššššš43
>>>>> š+#define DTV_DVBS2_MIS_ID šššššš43
>>>> šIt would be better to define it as:
>>>>
>>>> š#define DTV_DVBS2_MIS_ID šššššššDTV_DVBT2_PLP_ID
>>>>
>>>> šEven better, we should instead find a better name that would cover both
>>>> šDVB-T2 and DVB-S2 program ID fields, like:
