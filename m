Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:41188 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab0ESQOD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 12:14:03 -0400
Message-ID: <4BF40DDC.1010604@arcor.de>
Date: Wed, 19 May 2010 18:12:12 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 video image
References: <4BF40649.5090900@arcor.de> <4BF40889.4090809@redhat.com>
In-Reply-To: <4BF40889.4090809@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.05.2010 17:49, schrieb Mauro Carvalho Chehab:
> Stefan Ringel wrote:
>   
>> Hi Mauro,
>>
>> I have found what wrong is with video image. 
>>     
> Great!
>
>   
>> You generate video buffer
>> in function tm6000_isoc_copy, but that is not right. I move that in
>> function copy_multiplexed and copy_streams. And that works without this
>> http://www.stefan.ringel.de/pub/tm6000_image_10_05_2010.jpg (The lines
>> with little left shift) . 
>>     
> Didn't work:
>
> 404: Not Found - www.stefan.ringel.de
>
>   
Sorry. A point  to much.

http://www.stefanringel.de/pub/tm6000_image_10_05_2010.jpg

>> Now, I generate a patch.
>>     
> Ok. It would be great to have this issue finally fixed.
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

