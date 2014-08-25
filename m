Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:57333 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaHYGqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 02:46:07 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAU00A5SO4TD430@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Aug 2014 02:46:05 -0400 (EDT)
Date: Mon, 25 Aug 2014 03:46:01 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Further clean up libdvbv5
Message-id: <20140825034601.5cc3b037.m.chehab@samsung.com>
In-reply-to: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
References: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Em Sat, 23 Aug 2014 18:42:38 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> Here you'll find some patches to clean up libdvbv5. I tried to
> reduce exported symbols of the shared library to easy
> maintenance in the future.
> 
> Thanks,
> Gregor
> 
> Gregor Jasny (5):
>   libdvbv5: Remove dvbsat_polarization_name (same as dvb_sat_pol_name)
>   libdvbv5: Rename and hide charset definitions
>   libdvbv5: Hide unused and unexposed cnr_to_qual_s tables
>   libdvbv5: Make dvb_xxx_charset const strings
>   libdvbv5: Make dummy_fe static

All patches except patch 4 is ok. I merged them upstream already.

With regards to patch 4 (Make dvb_xxx_charset const strings), those
strings should not be const, but, instead, configurable, as the
default charset decoding may actually var from Country to Country.

For example, on ISDB-T, Japan uses one default, while Brazil uses
another one.

Also, the system may not be using UTF-8 as its charset.

So, the best is to add two functions that would allow the applications
based on libdvbv5 to set it, overriding the default.

I'll work on such patches and post at ML for you to take a look.

Regards,
Mauro

> 
>  lib/include/libdvbv5/descriptors.h             |  2 --
>  lib/include/libdvbv5/dvb-sat.h                 |  2 --
>  lib/libdvbv5/descriptors.c                     |  3 ---
>  lib/libdvbv5/descriptors/desc_event_extended.c |  2 +-
>  lib/libdvbv5/descriptors/desc_event_short.c    |  4 ++--
>  lib/libdvbv5/descriptors/desc_network_name.c   |  2 +-
>  lib/libdvbv5/descriptors/desc_service.c        |  4 ++--
>  lib/libdvbv5/descriptors/desc_ts_info.c        |  2 +-
>  lib/libdvbv5/dvb-fe.c                          |  6 +++---
>  lib/libdvbv5/dvb-sat.c                         |  7 -------
>  lib/libdvbv5/parse_string.c                    | 12 ++++++++----
>  lib/libdvbv5/parse_string.h                    |  7 +++++--
>  lib/libdvbv5/tables/vct.c                      |  2 +-
>  13 files changed, 24 insertions(+), 31 deletions(-)
> 
