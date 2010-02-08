Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:44086 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770Ab0BHP4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 10:56:17 -0500
Message-ID: <4B7033FC.7000404@arcor.de>
Date: Mon, 08 Feb 2010 16:55:40 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 8/12] tm6000: add tuner parameter
References: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-2-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-3-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-4-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-5-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-6-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-7-git-send-email-stefan.ringel@arcor.de> <4B6F7D37.50404@redhat.com>
In-Reply-To: <4B6F7D37.50404@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.02.2010 03:55, schrieb Mauro Carvalho Chehab:
> stefan.ringel@arcor.de wrote:
>
>   
>> +		ctl.vhfbw7 = 1;
>> +		ctl.uhfbw8 = 1;
>>     
> I don't think you need to set this, as the driver will automatically do the firmware
> tricks for the firmwares. This will probably just change the default to start
> wit firmware 7/8.
>
>   

if it's going to bw 7 it doesn't use DTV 7, it's use DTV 7 not DTV78, I
have it tested. I think if it's switch between DTV7 and DTV 8 it's not
always set DTV78. ( it's set DTV 7 DTV 8 or DTV78)

-- 
Stefan Ringel <stefan.ringel@arcor.de>

