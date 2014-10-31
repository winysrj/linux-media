Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:21019 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaJaUCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 16:02:31 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEB00KL1RO6W420@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Oct 2014 16:02:30 -0400 (EDT)
Date: Fri, 31 Oct 2014 18:02:27 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 6/7] v4l-utils/libdvbv5: don't discard config-supplied
 parameters
Message-id: <20141031180227.4de8c4bc.m.chehab@samsung.com>
In-reply-to: <5453A9BE.7060806@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
 <1414323983-15996-7-git-send-email-tskd08@gmail.com>
 <20141027151104.427630df.m.chehab@samsung.com> <5453A9BE.7060806@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 01 Nov 2014 00:24:46 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> I withdrew this patch as it's meaningless.
> 
> Originally I mis-understood that when dvbv5-scan was run
> with "-G" option, the props in channel config file that
> are not specified in dvb-v5-std.c::sys_foo_props[] were
> once loaded to "parms" structure to be scanned,
> but later discarded in dvb_fe_get_parms()
> (without experiments/tests :P ).
> 
> I noticed that there's no effect in this patch by experiments,
> and non "sys_foo_props[]"-defined props are discarded at
> its read in the first place.
> sorry to have bothered you with the meaningless patch.
> maybe it was because I had a cold recently;)

No problem :)

Regards,
Mauro
