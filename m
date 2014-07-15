Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:53197 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaGOR3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 13:29:35 -0400
Message-id: <53C564F4.8010002@samsung.com>
Date: Tue, 15 Jul 2014 11:29:24 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
MIME-version: 1.0
To: Antti Palosaari <crope@iki.fi>, m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] media: em28xx-dvb unregister i2c tuner and demod after fe
 detach
References: <1405093525-8745-1-git-send-email-shuah.kh@samsung.com>
 <53C1971E.3020200@iki.fi>
In-reply-to: <53C1971E.3020200@iki.fi>
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/12/2014 02:14 PM, Antti Palosaari wrote:
> Moikka Shuah!
> I suspect that patch makes no sense. On DVB there is runtime PM
> controlled by DVB frontend. It wakes up all FE sub-devices when frontend
> device is opened and sleeps when closed.
>
> FE release() is not relevant at all for those sub-devices which are
> implemented as a proper I2C client. I2C client has own remove() for that.
>
> em28xx_dvb_init and em28xx_dvb_fini are counterparts. Those I2C drivers
> are load on em28xx_dvb_init so logical place for unload is em28xx_dvb_fini.
>
> Is there some real use case you need that change?
>
> regards
> Antti
>

Hi Antti,

The reason I made this change is because dvb_frontend_detach()
calls release interfaces for fe as well as tuner. So it made
sense to move the remove after that is all done. Are you saying
fe and tuner release calls aren't relevant when sub-devices
implement a proper i2c client? If that is the case then, and
there is no chance for these release calls to be invoked when a
proper i2c is present, then my patch isn't needed.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
