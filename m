Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:22335 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaJHQWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 12:22:14 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND400KC8W4ZO070@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 12:22:11 -0400 (EDT)
Date: Wed, 08 Oct 2014 13:22:07 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] v4l-utils:libdvbv5,dvb: add basic support for ISDB-S
Message-id: <20141008132207.2afc6ff8.m.chehab@samsung.com>
In-reply-to: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Oct 2014 21:09:37 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> This patch series adds tuning and scanning features for ISDB-S.
> Other part of the libdvbv5 API may not work for ISDB-S.

Thanks for the patchset! I sent you some comments about them.

> At least the charset conversion and the parser for extended
> event descriptors do not work now,
> as they require some ISDB-S(/T) specific modifications.

Yeah, it will likely require a table just like the one we've added
for EN 300 468 specific charset with the euro sign.

There are some patches for charset decoding like this one:

http://marc.info/?l=mplayer-dev-eng&m=125642040004816

Not sure how hard would be to port one of those things to libdvbv5.

Regards,
Mauro

> 
> Akihiro Tsukada (4):
>   v4l-utils/libdvbv5: avoid crash when failed to get a channel name
>   v4l-utils/libdvbv5: add support for ISDB-S tuning
>   v4l-utils/libdvbv5: add support for ISDB-S scanning
>   v4l-utils/dvbv5-scan: add support for ISDB-S scanning
> 
>  lib/include/libdvbv5/dvb-scan.h |   2 +
>  lib/libdvbv5/dvb-fe.c           |   6 +-
>  lib/libdvbv5/dvb-file.c         |  32 +++++++---
>  lib/libdvbv5/dvb-sat.c          |  11 ++++
>  lib/libdvbv5/dvb-scan.c         | 125 +++++++++++++++++++++++++++++++++++++++-
>  lib/libdvbv5/parse_string.c     |  23 ++++++++
>  utils/dvb/dvb-format-convert.c  |   3 +-
>  utils/dvb/dvbv5-scan.c          |  14 +++++
>  8 files changed, 203 insertions(+), 13 deletions(-)
> 
