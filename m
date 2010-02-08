Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab0BHR61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 12:58:27 -0500
Message-ID: <4B7050B8.6000508@redhat.com>
Date: Mon, 08 Feb 2010 15:58:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 8/12] tm6000: add tuner parameter
References: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-2-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-3-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-4-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-5-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-6-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-7-git-send-email-stefan.ringel@arcor.de> <4B6F7D37.50404@redhat.com> <4B7033FC.7000404@arcor.de>
In-Reply-To: <4B7033FC.7000404@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> Am 08.02.2010 03:55, schrieb Mauro Carvalho Chehab:
>> stefan.ringel@arcor.de wrote:
>>
>>   
>>> +		ctl.vhfbw7 = 1;
>>> +		ctl.uhfbw8 = 1;
>>>     
>> I don't think you need to set this, as the driver will automatically do the firmware
>> tricks for the firmwares. This will probably just change the default to start
>> wit firmware 7/8.
>>
>>   
> 
> if it's going to bw 7 it doesn't use DTV 7, it's use DTV 7 not DTV78, I
> have it tested. I think if it's switch between DTV7 and DTV 8 it's not
> always set DTV78. ( it's set DTV 7 DTV 8 or DTV78)
> 

Sorry but I didn't understand what you meant. Anyway, the patch were committed as-is.
We may eventually need to revisit this code later.


-- 

Cheers,
Mauro
