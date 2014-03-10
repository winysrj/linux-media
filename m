Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:59941 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaCJNEq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 09:04:46 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N28009KZ1NX8460@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Mar 2014 09:04:45 -0400 (EDT)
Date: Mon, 10 Mar 2014 10:04:40 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 00/15] drx-j: Cleanups, fixes and support for DVBv5 stats
Message-id: <20140310100440.7d5d757a@samsung.com>
In-reply-to: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Mar 2014 08:58:52 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> This patch series is meant to:
> 1) fix some reported issues (sparse, smatch);
> 
> 2) Fix one compilation issue with em28xx when drx-j is not selected;
> 
> 3) Get rid of unused code. It is always possible to restore the code
>    from git history. Removing the unused code helps to better understand
>    what's actually there.
> 
> 4) Add support for DVBv5 stats.
> 
> On my tests here with an AWGN noise generator, the CNR measure made by
> drx-j was close enough to the SNR injected (with a difference of about
> 1 dB).
> 
> Mauro Carvalho Chehab (15):
>   drx-j: Don't use 0 as NULL
>   drx-j: Fix dubious usage of "&" instead of "&&"
>   drx39xxj.h: Fix undefined reference to attach function
>   drx-j: don't use mc_info before checking if its not NULL
>   drx-j: get rid of dead code

This patch seems to be rejected by vger... likely too big.
Well the patch is here:
	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/49bac5876df20f74238bfccf3ef9cbaefcaa2ca9

For anyone wanting to test, all patches are at:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/drx-j-v3

>   drx-j: remove external symbols
>   drx-j: Fix usage of drxj_close()
>   drx-j: propagate returned error from request_firmware()
>   drx-j: get rid of some unused vars
>   drx-j: Don't use "state" for DVB lock state
>   drx-j: re-add get_sig_strength()
>   drx-j: Prepare to use DVBv5 stats
>   drx-j: properly handle bit counts on stats
>   drx-j: Fix detection of no signal
>   drx-j: enable DVBv5 stats
> 
>  drivers/media/dvb-frontends/drx39xyj/drx39xxj.h   |     6 +
>  drivers/media/dvb-frontends/drx39xyj/drx_driver.h |    24 -
>  drivers/media/dvb-frontends/drx39xyj/drxj.c       | 11146 +++-----------------
>  drivers/media/dvb-frontends/drx39xyj/drxj.h       |    30 -
>  4 files changed, 1343 insertions(+), 9863 deletions(-)
> 


-- 

Regards,
Mauro
