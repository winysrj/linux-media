Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53597 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaGVTNC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 15:13:02 -0400
Message-ID: <53CEB7BA.3010408@iki.fi>
Date: Tue, 22 Jul 2014 22:12:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Luis Alves <ljalvs@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] si2157: Fix DVB-C bandwidth.
References: <1406027388-10336-1-git-send-email-ljalvs@gmail.com> <20140722131059.4ad26777.m.chehab@samsung.com> <CAGj5WxBiioMVJTgX9zKqMsFTmL3Cjnb3pVkLc6eaCGJHsFf0Zw@mail.gmail.com> <20140722140304.79ba1bcd.m.chehab@samsung.com>
In-Reply-To: <20140722140304.79ba1bcd.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2014 08:03 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 22 Jul 2014 17:28:07 +0100
> Luis Alves <ljalvs@gmail.com> escreveu:
>
>> That's right,
>> A few days ago I also checked that with Antti. I've also had made some
>> debugging and DVB core is in fact passing the correct bandwidth to the
>> driver.
>>
>> But the true is that it doesn't work...
>> The sample I have is a dvb-c mux using QAM128 @ 6 Mbaud (which results
>> in 7MHz bw) using 7MHz filter value will make the TS stream
>> unwatchable (lots of continuity errors).
>>
>> Can this be a hardware fault?
>> All closed source drivers I've seen are hardcoding this value to 8MHz
>> when working in dvb-c (easily seen on i2c sniffs).
>
> Could be. Well, here, the DVB-C channel operators use 6MHz-spaced channels,
> with symbol rate equal to 5,217 Kbaud. I'll see if I can test it latter
> this week with a PCTV 292e.

I could also test it against modulator. However, that patch seems to be 
wrong for my eyes too. Generally speaking RF tuner needs to know 
bandwidth to adjust filters on signal path. For narrow suitable is 
filter, the better will be signal. If you have 7MHz filter then you 
definitely want use it in a case your carrier fits that space. Larger 
filter will work, but CNR is worse. If filter is too narrow and cuts 
your carrier, you are not able to receive mux or at lest performance 
drop notably.

What is you channel raster? Could you tell center frequencies of all 
your DVB-C muxes? Could you test with 7MHz bw, but adjust center 
frequency off from nominal ~0-500kHz to see if it helps.

regards
Antti

-- 
http://palosaari.fi/
