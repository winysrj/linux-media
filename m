Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32954 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbaIZMcr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 08:32:47 -0400
Message-ID: <54255CEB.60807@iki.fi>
Date: Fri, 26 Sep 2014 15:32:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH 04/12] cx231xx: give each master i2c bus a seperate name
References: <1411621684-8295-1-git-send-email-zzam@gentoo.org> <1411621684-8295-4-git-send-email-zzam@gentoo.org> <54242F0F.9020702@iki.fi> <5424ECC9.4070409@gentoo.org>
In-Reply-To: <5424ECC9.4070409@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/26/2014 07:34 AM, Matthias Schwarzott wrote:
> On 25.09.2014 17:04, Antti Palosaari wrote:
>> So this patch adds bus number to adapter name as postfix?
>>
>> "cx231xx" => "cx231xx-1"
>>
> Yes, it is attached, and the result looks like
> * cx231xx #0-0
> * cx231xx #0-1
> * cx231xx #0-2
>
>> I have no clear opinion for that. I think name should be given when
>> adapter is crated, not afterwards.
>>
> It is written to the i2c_adapter before calling i2c_add_adapter. Is this
> good enough?

ah, OK, yes.

Antti

>
> Regards
> Matthias
>

-- 
http://palosaari.fi/
