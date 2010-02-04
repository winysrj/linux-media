Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab0BDBem (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 20:34:42 -0500
Message-ID: <4B6A242C.8060104@infradead.org>
Date: Wed, 03 Feb 2010 23:34:36 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Tobias Lorenz <tobias.lorenz@gmx.net>
CC: Roel Kluin <roel.kluin@gmail.com>, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] radio-si470x-common: -EINVAL overwritten in si470x_vidioc_s_tuner()
References: <4B69D2F5.2050100@gmail.com> <201002032252.36514.tobias.lorenz@gmx.net>
In-Reply-To: <201002032252.36514.tobias.lorenz@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tobias Lorenz wrote:
> Hello Roel,
> 
> no, the default value of retval makes no difference to the function.
> 
> Retval is set by si470x_disconnect_check and si470x_set_register.
> After each call, retval is checked.
> There is no need to reset it passed.
> 
> The only reason, there is a default value is my static code checker, saying variables should have default values.
> Setting it to -EINVAL seems more reasonable to me than setting it 0.
> In fact the patch would bring up the warning on setting default values again.

Well, your static code checker is then broken ;)

>>  	struct si470x_device *radio = video_drvdata(file);
>> -	int retval = -EINVAL;
>> +	int retval;
>>  
>>  	/* safety checks */
>>  	retval = si470x_disconnect_check(radio);

You may just do then:

	int retval = si470x_disconnect_check(radio);

>>  	if (retval)
>>  		goto done;
>> +	retval = -EINVAL;
>>  
>>  	if (tuner->index != 0)
>>  		goto done;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
