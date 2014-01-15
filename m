Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:35186 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaAOQms (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 11:42:48 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZG0077RBRBWS80@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Jan 2014 11:42:47 -0500 (EST)
Date: Wed, 15 Jan 2014 14:42:38 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Patch for TechnoTrend S2-4600
Message-id: <20140115144238.07f7261f@samsung.com>
In-reply-to: <52C9975A.2060900@tu-dortmund.de>
References: <52C9975A.2060900@tu-dortmund.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Jan 2014 18:33:14 +0100
Alexander Lochmann <alexander.lochmann@tu-dortmund.de> escreveu:

> Hi guys,
> 
> i'm sending you a patch that adds support for the TechnoTrend S2-4600 
> DVB-S2 device to a 3.12 (5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52) 
> mainline kernel.
> I just extracted the drivers for the two frontends (ds3103 and ts2202) 
> from [1] and added them to a mainline kernel. Furthermore, i modified 
> the dw2102 driver to support the new frontends (= copied the necessary 
> lines of code from the origin dw2102) . In addition, i attached a 
> firmware for the dw2102 extracted from [3].
> I appreciate, if you review my patch and may integrate it into the 
> mainline tree.

Hi Alexander,

You can't simply extract those patches from some other tree and send, without
the driver's author ack.

Also, recently a driver for ts2202 and ds3103 was merged in the Kernel. It
may not have the IDs for your device, but it shouldn't likely be hard to
add support for it, if you have some programming skills.

Regards,
Mauro

> 
> Thank you!
> Greetings
> Alex
> 
> [1] 
> https://bitbucket.org/liplianin/s2-liplianin-v37/get/67ce08afdbe7.tar.bz2
> [2] http://www.tt-downloads.de/Linux/s2-TT4600-linux-20120815.tgz
> [3] http://www.tt-downloads.de/Linux/linux_tt-connect_s2-4600.pdf


-- 

Cheers,
Mauro
