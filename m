Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:36871 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbZLAXyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 18:54:55 -0500
Received: from epmmp2 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KTZ002JQZRG64@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2009 08:54:52 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KTZ00D0YZQE2P@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2009 08:54:14 +0900 (KST)
Date: Wed, 02 Dec 2009 08:54:15 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 1/3] radio-si470x: fix SYSCONFIG1 register set on
 si470x_start()
In-reply-to: <200912020039.02737.tobias.lorenz@gmx.net>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com
Message-id: <4B15ACA7.6070807@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4B039265.1020906@samsung.com>
 <200912020039.02737.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Tobias.

On 12/2/2009 8:39 AM, Tobias Lorenz wrote:
> Hi,
> 
> what is the advantage in not setting SYSCONFIG1 into a known state?
> 

At patch 3/3, i am setting the SYSCONFIG1 register for RDS interrupt in
i2c probe function, so i need this patch. Do you have other idea?

> Bye,
> Toby
> 
> Am Mittwoch 18 November 2009 07:21:25 schrieb Joonyoung Shim:
>> We should use the or operation to set value to the SYSCONFIG1 register
>> on si470x_start().
>>
>> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
>> ---
>>  drivers/media/radio/si470x/radio-si470x-common.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
>> index f33315f..09f631a 100644
>> --- a/drivers/media/radio/si470x/radio-si470x-common.c
>> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
>> @@ -357,7 +357,7 @@ int si470x_start(struct si470x_device *radio)
>>  		goto done;
>>  
>>  	/* sysconfig 1 */
>> -	radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
>> +	radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
>>  	retval = si470x_set_register(radio, SYSCONFIG1);
>>  	if (retval < 0)
>>  		goto done;
>>
> 

