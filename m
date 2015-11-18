Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34115 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbbKRRtL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 12:49:11 -0500
Subject: Re: [PATCH 1/6] mt2060: add i2c bindings
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1437996130-23735-1-git-send-email-crope@iki.fi>
 <1437996130-23735-2-git-send-email-crope@iki.fi>
 <20151118130146.1ab0490d@recife.lan>
Cc: linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <564CBA14.1020303@iki.fi>
Date: Wed, 18 Nov 2015 19:49:08 +0200
MIME-Version: 1.0
In-Reply-To: <20151118130146.1ab0490d@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/18/2015 05:01 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 27 Jul 2015 14:22:05 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Add proper i2c driver model bindings.
>
> Hi Antti,
>
> What's the status of this patch series? You submitted them on July, but
> never sent me a pull request...

I noticed I2C adapter has nowadays (or has it been always there) some 
configuration logic for I2C message sizes (see struct 
i2c_adapter_quirks). I would like to test those, which means I have to 
make some changes to these patches in order to implement message 
splitting way I2C core supports.

Whole thing is for for ZyDAS ZD1301 DVB-T chip driver related, which is 
~10 years old and near zero users nowadays - so no need to hurry at all :D

regards
Antti

-- 
http://palosaari.fi/
