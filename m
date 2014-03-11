Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:37121 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbaCKLCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 07:02:10 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N290089MQNLHN20@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Mar 2014 07:02:09 -0400 (EDT)
Date: Tue, 11 Mar 2014 08:02:04 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re: [linuxtv-media:master 499/499]
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h:22:0: error: unterminated
 #ifndef
Message-id: <20140311080204.2961ff83@samsung.com>
In-reply-to: <531eea15.KJn7IlN6hvOVHxI/%fengguang.wu@intel.com>
References: <531eea15.KJn7IlN6hvOVHxI/%fengguang.wu@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Mar 2014 18:48:53 +0800
kbuild test robot <fengguang.wu@intel.com> escreveu:

> tree:   git://linuxtv.org/media_tree.git master
> head:   164e5cfb7d37e4826a8337029716f4885657d859
> commit: 164e5cfb7d37e4826a8337029716f4885657d859 [499/499] [media] drx39xxj.h: Fix undefined reference to attach function
> config: make ARCH=m68k allmodconfig

Sorry, I had to rebase everything, due to some OF patches that 
caused some mess. I ended by merging a wrong version of this patch.

Anyway, this was fixed already.

Regards,
Mauro
