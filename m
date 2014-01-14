Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.unixsol.org ([193.110.159.2]:57278 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbaANPzV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 10:55:21 -0500
Message-ID: <52D55DE7.4050309@unixsol.org>
Date: Tue, 14 Jan 2014 17:55:19 +0200
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: FE_READ_SNR and FE_READ_SIGNAL_STRENGTH docs
References: <52D554BA.3070906@unixsol.org> <20140114133044.1d5276f4@samsung.com>
In-Reply-To: <20140114133044.1d5276f4@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Around 01/14/2014 05:30 PM, Mauro Carvalho Chehab scribbled:
> Em Tue, 14 Jan 2014 17:16:10 +0200
> Georgi Chorbadzhiyski <gf@unixsol.org> escreveu:
> 
>> Hi guys, I'm confused the documentation on:
>>
>> http://linuxtv.org/downloads/v4l-dvb-apis/frontend_fcalls.html#FE_READ_SNR
>> http://linuxtv.org/downloads/v4l-dvb-apis/frontend_fcalls.html#FE_READ_SIGNAL_STRENGTH
>>
>> states that these ioctls return int16_t values but frontend.h states:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/dvb/frontend.h
>>
>> #define FE_READ_SIGNAL_STRENGTH  _IOR('o', 71, __u16)
>> #define FE_READ_SNR              _IOR('o', 72, __u16)
>>
>> So which one is true?
> 
> Documentation is wrong. The returned values are unsigned. Would you mind send
> us a patch fixing it?

I would be happy to, but I can't find the repo that holds the documentation.

> Btw, the better is to use the new statistics API, when it is
> available:
> 	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html#frontend-stat-properties
> 
> As it properly specifies the scale of each value.

When it's ready, I'll add support for the API in dvblast.

-- 
Georgi Chorbadzhiyski | http://georgi.unixsol.org/ | http://github.com/gfto/
