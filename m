Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33653 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXMGs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 08:06:48 -0400
Received: by mail-pa0-f54.google.com with SMTP id fb1so8578787pad.41
        for <linux-media@vger.kernel.org>; Wed, 24 Sep 2014 05:06:48 -0700 (PDT)
Message-ID: <5422B3D3.80209@gmail.com>
Date: Wed, 24 Sep 2014 21:06:43 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 3/4] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1410196843-26168-1-git-send-email-tskd08@gmail.com>	<1410196843-26168-4-git-send-email-tskd08@gmail.com>	<20140923170730.4d5d167e@recife.lan>	<542233E5.5070201@gmail.com>	<20140924062812.6308f584@recife.lan>	<5422A779.8030901@gmail.com> <20140924083030.3fdcfe3e@recife.lan>
In-Reply-To: <20140924083030.3fdcfe3e@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> And TMCC returns it as 0, 1, 2, 3, 4, instead of 0, 1, 2, 4, 8.

According to ARIB STD B31 3.15.6.7 (table 3.30),
The value is encoded and depends on the "mode".
so demods have to encode/decode anyway.

> AFAIKT, that doesn't work in Sound Broadcast mode, as the demod won't
> be able to read the TMCC (at least on most demods - don't have any
> details about tc90522).

I forgat ISDB-Tsb;P, as in Japan terrestrial digital sound broadcast
was cancelled in 2011 and it was unpopular.

--
akihiro
