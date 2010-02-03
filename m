Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab0BCH35 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 02:29:57 -0500
Message-ID: <4B6925EB.7000601@redhat.com>
Date: Wed, 03 Feb 2010 05:29:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de
Subject: Re: [PATCH v2 00/10] add linux driver for chip TLG2300
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com> <4B6817E6.4070709@redhat.com> <4B69159D.2040606@gmail.com>
In-Reply-To: <4B69159D.2040606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huang Shijie wrote:
> 
>> I'm assuming that you're referring to the analog part, right?
>>    
> right.
>  The country code only effects the Analog TV and radio, it has no effect
> on DVB-T.
> 
>> Instead of a country code, the driver should use the V4L2_STD_ macros to
>>    
> If we are in the radio mode, I do not have any video standard, how can I
> choose
> the right audio setting in this situation?

In the case of radio, the frequency ranges are controlled via the tuner
ioctls. There's no standard way to control the preemphasis, but I recommend
adding a ctrl to select between 50us/75us and no preemphasis.


-- 

Cheers,
Mauro
