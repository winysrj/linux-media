Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab0J2Nyq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 09:54:46 -0400
Message-ID: <4CCAD21A.9040100@redhat.com>
Date: Fri, 29 Oct 2010 11:54:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarkko Nikula <jhnikula@gmail.com>
CC: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [git:v4l-dvb/v2.6.37] [media] radio-si4713: Add regulator framework
 support
References: <E1P7ZwW-0003bq-Uv@www.linuxtv.org> <20101029092935.b6dd7693.jhnikula@gmail.com>
In-Reply-To: <20101029092935.b6dd7693.jhnikula@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-10-2010 04:29, Jarkko Nikula escreveu:
> Hi
> 
> On Sun, 17 Oct 2010 22:34:32 +0200
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> This is an automatic generated email to let you know that the following patch were queued at the 
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] radio-si4713: Add regulator framework support
>> Author:  Jarkko Nikula <jhnikula@gmail.com>
>> Date:    Tue Sep 21 05:49:43 2010 -0300
>>
>> Convert the driver to use regulator framework instead of set_power callback.
>> This with gpio_reset platform data provide cleaner way to manage chip VIO,
>> VDD and reset signal inside the driver.
>>
>> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
>> Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>  drivers/media/radio/si4713-i2c.c |   74 ++++++++++++++++++++++++++++++++------
>>  drivers/media/radio/si4713-i2c.h |    5 ++-
>>  2 files changed, 67 insertions(+), 12 deletions(-)
>>
>> ---
>>
>> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=d455b639c1fb09f8ea888371fb6e04b490e115fb
>>
> Was this patch lost somewhere? I don't see it in mainline for 2.6.37
> but e.g. 85c55ef is there.
> 
> 

I had to remove it from my queue, as the patch broke compilation:

	http://git.linuxtv.org/media_tree.git?a=commit;h=350df81ebaccc651fa4dfad27738db958e067ded

What's the sense of adding a patch that breaks a driver?

Even assuming that you would later send a patch fixing it, there are still some problems:

1) A latter patch will break git bisect;
2) A broken driver means that I can't test anymore if there are any other problems on other
   drivers.

So, please test your patches against breakages, before sending them to me.

Thanks,
Mauro
