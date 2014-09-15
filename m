Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:40345 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaIOLzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 07:55:04 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBX002YWYFQDO70@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 07:55:02 -0400 (EDT)
Date: Mon, 15 Sep 2014 08:54:58 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: v4l2 ioctls
Message-id: <20140915085458.1faea714.m.chehab@samsung.com>
In-reply-to: <541391B9.4070708@osg.samsung.com>
References: <54124BDC.3000306@osg.samsung.com> <5412A9DB.8080701@xs4all.nl>
 <20140912121950.7edfee4e.m.chehab@samsung.com>
 <541391B9.4070708@osg.samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

Em Fri, 12 Sep 2014 18:37:13 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Mauro/Hans,
> 
> Thanks for both for your replies. I finally have it working with
> the following:

One additional info: While in DVB mode, opening the device in
readonly mode should not take the tuner locking.

If you need/want to test it, please use:
	$ dvb-fe-tool --femon

I implemented this functionality this weekend, so you'll need
to update your v4l-utils tool to be able to test it.

> 
> S_INPUT
> S_OUTPUT
> S_MODULATOR
> S_TUNER
> S_STD
> S_FREQUENCY
> S_HW_FREQ_SEEK
> S_FMT
>  - get tuner in shared mode and hold it
>  - i.e return with tuner held
> 
> STREAMON
>  - get tuner in shared mode and hold it
>  - i.e return with tuner held
> STREAMOFF
>  - put tuner (get is done in STREAMON)
> 
> QUERYSTD
> G_TUNER (au0828 does tuner init in its g_tuner ops)

As this is something specific for some devices, it is probably better
to implement the locking for G_TUNER inside the driver.

>  - get tuner in shared mode and hold it
>  - service request
>  - put tuner
> 


> With these changes now I have digital stream not get
> disrupted as soon as xawtv starts. I am working through
> issues related to unbalanced nature of tuner holds in
> analog mode.
> 
> -- Shuah
> 
Regards,
Mauro
