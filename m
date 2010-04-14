Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:60066 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756064Ab0DNSnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 14:43:16 -0400
Message-ID: <4BC60C72.6020901@arcor.de>
Date: Wed, 14 Apr 2010 20:41:54 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: tm6000: firmware
References: <4BC5ECB8.2060208@arcor.de> <4BC5FF15.10605@redhat.com>
In-Reply-To: <4BC5FF15.10605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.04.2010 19:44, schrieb Mauro Carvalho Chehab:
> Hi Stefan,
>
> Em 14-04-2010 09:26, Stefan Ringel escreveu:
>   
>> Hi Mauro,
>>
>> Can you added these three firmwares? The third is into archive file,
>> because I'm extracted for an user (Bee Hock Goh).
>>     
> Sorry, but for us to put the firmwares at the server and/or add them at linux-firmware 
> git tree, we need to get the distribution rights from the manufacturer,
> as described on:
> 	http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches#Firmware_submission
>
> So, we need Xceive's ack, in order to add the firmware files somewhere. That's why
> currently we're using the procedure described on the comments at the extraction
> tool:
> 	Documentation/video4linux/extract_xc3028.pl  
>
> Cheers,
> Mauro
>   
OK. In the archive is the modified extract_xc3028 tool for
tm6000-xc3028.fw . Is that useful?

-- 
Stefan Ringel <stefan.ringel@arcor.de>

