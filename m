Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:48956 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaCCTrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 14:47:03 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1V00AHVLMQKZ70@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Mar 2014 14:47:14 -0500 (EST)
Date: Mon, 03 Mar 2014 16:46:51 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: The Bit Pit <thebitpit@earthlink.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Driver for KWorld UB435Q Version 3 (ATSC)  USB id: 1b80:e34c
Message-id: <20140303164651.09f6123f@samsung.com>
In-reply-to: <52F524A8.9000008@earthlink.net>
References: <52F524A8.9000008@earthlink.net>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 07 Feb 2014 12:23:36 -0600
The Bit Pit <thebitpit@earthlink.net> escreveu:

> Last May I started writing a driver for a KWorld UB435Q Version 3
> tuner.  I was able to make the kernel recognize the device, light it's
> LED, and try to enable the decoder and tuner.
> 
> I was unable to locate any information for the tda18272 tuner chip until
> last week.  I received an email at another address with a pointer to a
> GPL driver that used a tda18272 in a pcie based tuner.  It appears that
> a bit of refactoring has been done to v4l2 since it was written.  I want
> to try to incorporate it into the kernel tree properly while making the
> KWorld UB435Q Version 3 usable under linux.
> 
> Would the tda18271 be a good model?
> 
> The tda18271 organized with part in tuners and part in dvb-frontends. 
> What is the dvb-frontends stuff used for?
> 
> The tda18271 files in kernel are:
> 
> ./media/tuners/tda18271-maps.c
> ./media/tuners/tda18271-fe.c
> ./media/tuners/tda18271.h
> ./media/tuners/tda18271-priv.h
> ./media/tuners/tda18271-common.c
> ./media/dvb-frontends/tda18271c2dd.c
> ./media/dvb-frontends/tda18271c2dd.h
> ./media/dvb-frontends/tda18271c2dd_maps.h
> 
> The tda18272 files I located are:
> 
> ./media/dvb/frontends/tda18272_reg.h
> ./media/dvb/frontends/tda18272.h
> ./media/dvb/frontends/tda18272.c
> 
> The tuner is only used in digital mode with KWorld UB435Q Version 3. 
> The tda18272 supports both digital and analog.  Should I include the
> analog support in the tda18272 files without testing it?

tda18272 is a variant of tda18212. Adding support for ATSC there is as
trivial as:
	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/14d276136221f98e2351841adb841cd420665090

Anyway, I just added support for ub435q v3 on my experimental tree:
	 http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/ub435q_v3

For now, I tested only 8VSB modulation. I'll test later for ClearQAM.

Regards,
Mauro
