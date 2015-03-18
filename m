Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35232 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbbCRAL4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2015 20:11:56 -0400
Message-ID: <5508C2C8.4090407@iki.fi>
Date: Wed, 18 Mar 2015 02:11:52 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kozlov Sergey <serjk@netup.ru>
CC: linux-media@vger.kernel.org, aospan1@gmail.com
Subject: Re: [PATCH 1/5] [media] horus3a: Sony Horus3A DVB-S/S2 tuner driver
References: <20150202092806.7B4D81BC32CD@debian> <20150305055414.1b02a0c1@recife.lan>
In-Reply-To: <20150305055414.1b02a0c1@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/2015 10:54 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 02 Feb 2015 12:22:32 +0300
> Kozlov Sergey <serjk@netup.ru> escreveu:

>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ddb9ac8..a3a1767 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -4365,6 +4365,15 @@ W:	http://linuxtv.org
>>   S:	Odd Fixes
>>   F:	drivers/media/usb/hdpvr/
>>
>> +HORUS3A MEDIA DRIVER
>
> Not a big issue, but could you please rename it to:
> 	MEDIA DRIVERS FOR HORUS3A
>
> We're trying to better organize the media entries at MAINTAINERS, at
> least for the new drivers.

What the *ell is that new rule? MAINTAINERS file clearly says entries 
should be alphabetical order, but on the other-hand there seems to be 
PCI and ARM specific stuff already grouped. Is that some new way?

regards
Antti

-- 
http://palosaari.fi/
