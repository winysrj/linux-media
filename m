Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34940 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaIXO0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 10:26:11 -0400
Received: by mail-pa0-f49.google.com with SMTP id lf10so8905695pab.36
        for <linux-media@vger.kernel.org>; Wed, 24 Sep 2014 07:26:10 -0700 (PDT)
Message-ID: <5422D47E.2080809@gmail.com>
Date: Wed, 24 Sep 2014 23:26:06 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 3/4] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1410196843-26168-1-git-send-email-tskd08@gmail.com>	<1410196843-26168-4-git-send-email-tskd08@gmail.com>	<20140923170730.4d5d167e@recife.lan>	<542233E5.5070201@gmail.com>	<20140924062812.6308f584@recife.lan>	<5422A779.8030901@gmail.com>	<20140924083030.3fdcfe3e@recife.lan>	<5422B3D3.80209@gmail.com> <20140924103233.2efc00ed@recife.lan>
In-Reply-To: <20140924103233.2efc00ed@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Ok, but see the definition at the API spec:
> 
> 	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html#isdb-hierq-layers
> 
> Basically, we use 0, 1, 2, 4 no matter what mode, e. g.

I understand.
(though I wonder why "4" is assigned instead of "3"
when it is not a flag bit that can be OR'ed
 and a kind of "raw" values are used anyway).

> Ah, I wasn't aware that ISDB-Tsb was cancelled in Japan.

The band used by ISDB-Tsb is now assigned to ISDB-Tmm
(which is also very unpopular),
and there is a plan to use ISDB-Tsb in another freq band
in the future, but no concrete one yet.

--
akihiro
