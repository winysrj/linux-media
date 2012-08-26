Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58664 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab2HZLVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 07:21:15 -0400
References: <alpine.DEB.2.02.1208260923570.2065@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1208260923570.2065@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: question about drivers/media/dvb-frontends/rtl2830.c
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 26 Aug 2012 07:20:00 -0400
To: Julia Lawall <julia.lawall@lip6.fr>, mchehab@infradead.org,
	crope@iki.fi, linux-media@vger.kernel.org
Message-ID: <c67025bd-4c41-462f-88ee-b534b733d320@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Julia Lawall <julia.lawall@lip6.fr> wrote:

>The function rtl2830_init contains the code:
>
>         buf[0] = tmp << 6;
>         buf[0] = (if_ctl >> 16) & 0x3f;
>         buf[1] = (if_ctl >>  8) & 0xff;
>         buf[2] = (if_ctl >>  0) & 0xff;
>
>Is there any purpose to initializing buf[0] twice?
>
>julia
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hmm.  Since 0x3f is the lowest 6 bits, it looks like the second line should use |= instead of = .   I don't know anything about the rt2830 though.

-Andy
