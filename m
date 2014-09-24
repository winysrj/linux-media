Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61798 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIXLOG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 07:14:06 -0400
Received: by mail-pd0-f175.google.com with SMTP id v10so7285543pde.6
        for <linux-media@vger.kernel.org>; Wed, 24 Sep 2014 04:14:05 -0700 (PDT)
Message-ID: <5422A779.8030901@gmail.com>
Date: Wed, 24 Sep 2014 20:14:01 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 3/4] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1410196843-26168-1-git-send-email-tskd08@gmail.com>	<1410196843-26168-4-git-send-email-tskd08@gmail.com>	<20140923170730.4d5d167e@recife.lan>	<542233E5.5070201@gmail.com> <20140924062812.6308f584@recife.lan>
In-Reply-To: <20140924062812.6308f584@recife.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Btw, please check if your driver is handling it well, as the valid
> values for interleave are 0, 1, 2, 4 (actually, dib8000 also
> supports interleaving equal to 8, if sound_broadcast).

I have no info on how to set time interleaving parameters,
although I can read them as a part of TMCC info.
I guess I can also set them in the same registers, but I'm not sure.

Since the demod is intelligent and automatically reads TMCC and
sets the related parameters accordingly,
I think it is safe to ignore user settings and let the demod set it.
If someone would get more info in the future,
[s]he could set those parameters in advance and make a lock faster.

regards,
akihiro
