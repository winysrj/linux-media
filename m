Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35967 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932961AbcLNPxD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 10:53:03 -0500
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
To: =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd> <20161214130310.GA15405@pali>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, sre@kernel.org,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <fd2e91a2-35e3-3ba8-d3c6-8963b504dd65@gmail.com>
Date: Wed, 14 Dec 2016 17:52:59 +0200
MIME-Version: 1.0
In-Reply-To: <20161214130310.GA15405@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On 14.12.2016 15:03, Pali Rohár wrote:
> Hi! See inlined some my notes.
>

>> +
>> +#ifdef USE_CRC
>> +	rval = et8ek8_i2c_read_reg(client, ET8EK8_REG_8BIT, 0x1263, &val);
>> +	if (rval)
>> +		goto out;
>> +#if USE_CRC /* TODO get crc setting from DT */
>> +	val |= BIT(4);
>> +#else
>> +	val &= ~BIT(4);
>> +#endif
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1263, val);
>> +	if (rval)
>> +		goto out;
>> +#endif
>
> USE_CRC is defined to 1. Do we need that #ifdef check at all?
>
> What with above TODO?
>
>> +

It becomes a bit more complicated :) - on n900, front camera doesn't use 
CRC, while back camera does. Right now there is no way, even if we use 
video bus switch driver, to tell ISP to have 2 ports with different 
settings, not only for CRC, but for strobe, etc. Look at that commit 
https://github.com/freemangordon/linux-n900/commit/e5582fa56bbc0161d6c567157df42433829ee4de. 
What I think here is that ISP should take settings from the remote 
endpoints rather from it's local port. So far it does not.

So, until there is a way for ISP to have more than one CCP channel with 
different settings, I can't think of anything we can do here but to 
place TODO.

Ivo
