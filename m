Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:58216 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0BCIkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 03:40:40 -0500
Received: by ywh36 with SMTP id 36so1044898ywh.15
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 00:40:39 -0800 (PST)
Message-ID: <4B693681.2030402@gmail.com>
Date: Wed, 03 Feb 2010 16:40:33 +0800
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de
Subject: Re: [PATCH v2 00/10] add linux driver for chip TLG2300
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com> <4B6817E6.4070709@redhat.com> <4B69159D.2040606@gmail.com> <4B6925EB.7000601@redhat.com>
In-Reply-To: <4B6925EB.7000601@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>>> Instead of a country code, the driver should use the V4L2_STD_ macros to
>>>
>>>        
>> If we are in the radio mode, I do not have any video standard, how can I
>> choose
>> the right audio setting in this situation?
>>      
> In the case of radio, the frequency ranges are controlled via the tuner
>    

Do you mean that the frequency range can be used to set the pre-emphasis?
I am not sure about this.

> ioctls. There's no standard way to control the preemphasis, but I recommend
> adding a ctrl to select between 50us/75us and no preemphasis.
>
>
>    

Best Regards
Huang Shijie


