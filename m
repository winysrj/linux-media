Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:4817 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab2HZHZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 03:25:40 -0400
Date: Sun, 26 Aug 2012 09:25:28 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: mchehab@infradead.org, crope@iki.fi, linux-media@vger.kernel.org
Subject: question about drivers/media/dvb-frontends/rtl2830.c
Message-ID: <alpine.DEB.2.02.1208260923570.2065@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function rtl2830_init contains the code:

         buf[0] = tmp << 6;
         buf[0] = (if_ctl >> 16) & 0x3f;
         buf[1] = (if_ctl >>  8) & 0xff;
         buf[2] = (if_ctl >>  0) & 0xff;

Is there any purpose to initializing buf[0] twice?

julia
