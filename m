Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:53896 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANPav (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 10:30:51 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZE002A6DRD5TA0@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jan 2014 10:30:49 -0500 (EST)
Date: Tue, 14 Jan 2014 13:30:44 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Cc: linux-media@vger.kernel.org
Subject: Re: FE_READ_SNR and FE_READ_SIGNAL_STRENGTH docs
Message-id: <20140114133044.1d5276f4@samsung.com>
In-reply-to: <52D554BA.3070906@unixsol.org>
References: <52D554BA.3070906@unixsol.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Jan 2014 17:16:10 +0200
Georgi Chorbadzhiyski <gf@unixsol.org> escreveu:

> Hi guys, I'm confused the documentation on:
> 
> http://linuxtv.org/downloads/v4l-dvb-apis/frontend_fcalls.html#FE_READ_SNR
> http://linuxtv.org/downloads/v4l-dvb-apis/frontend_fcalls.html#FE_READ_SIGNAL_STRENGTH
> 
> states that these ioctls return int16_t values but frontend.h states:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/dvb/frontend.h
> 
> #define FE_READ_SIGNAL_STRENGTH  _IOR('o', 71, __u16)
> #define FE_READ_SNR              _IOR('o', 72, __u16)
> 
> So which one is true?

Documentation is wrong. The returned values are unsigned. Would you mind send
us a patch fixing it?

Btw, the better is to use the new statistics API, when it is
available:
	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html#frontend-stat-properties

As it properly specifies the scale of each value.

If you're working in userspace, the libdvbv5 has functions that use
the new API automatically when the DVBv5 statistics are available on
a DVB driver, via  dvb_fe_retrieve_stats():

	http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/lib/include/dvb-fe.h

-- 

Cheers,
Mauro
