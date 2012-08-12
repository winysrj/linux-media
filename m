Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61888 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2HLTM4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 15:12:56 -0400
Received: by wicr5 with SMTP id r5so1932907wic.1
        for <linux-media@vger.kernel.org>; Sun, 12 Aug 2012 12:12:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5027FAF5.7060106@iki.fi>
References: <59951342221302@web18g.yandex.ru>
	<50258758.8050902@redhat.com>
	<1981451344725742@web18g.yandex.ru>
	<5026F209.4030604@iki.fi>
	<2171791344796403@web4d.yandex.ru>
	<5027FAF5.7060106@iki.fi>
Date: Mon, 13 Aug 2012 00:42:54 +0530
Message-ID: <CAHFNz9+LSzO-Zzgk4SqGS+FZ+S8e_Ecf+VhK6MoAQrRVbcNXfw@mail.gmail.com>
Subject: Re: [PATCH] DVB-S2 multistream support
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: CrazyCat <crazycat69@yandex.ru>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Manu Abraham <manu@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 13, 2012 at 12:20 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 08/12/2012 09:33 PM, CrazyCat wrote:
>>
>> Ok, done :) Look like DTV_DVBT2_PLP_ID not implemented for CXD2820r ?
>
>
> yes, true. It uses always PLP 0. I didn't have signal source that uses
> multiple PLPs. I didn't even add that PLP ID to API.

CXD2820 works only with PLP Type 1 or Type A in some other terminology.
PLP Type Common and PLP Type 2 are not supported by the hardware.
ie, it fails to acquire a LOCK with anything else.

Issue confirmed by Sony as well.

Regards,
Manu
