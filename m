Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45786 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbaLNT1N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 14:27:13 -0500
Message-ID: <548DE489.9030004@iki.fi>
Date: Sun, 14 Dec 2014 21:27:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 16/18] rtl28xxu: add support for RTL2831U/RTL2830 PID
 filter
References: <1418545723-9536-1-git-send-email-crope@iki.fi> <1418545723-9536-16-git-send-email-crope@iki.fi> <548DE411.5020202@southpole.se>
In-Reply-To: <548DE411.5020202@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/2014 09:25 PM, Benjamin Larsson wrote:
> On 12/14/2014 09:28 AM, Antti Palosaari wrote:
>> RTL2830 demod integrated to RTL2831U has PID filter. PID filtering
>> is provided by rtl2830 demod driver. Add support for it.
>>
>
> Do you plan on adding this for the RTL2832 demod also ?

I already did, but it is on my HD. I just published those rtl2830 codes 
for example as you asked.
I have implemented all those same for rtl2832 too + some more, like 
register caching.

regards
Antti

-- 
http://palosaari.fi/
