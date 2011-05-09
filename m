Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:20631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab1EIJZo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 05:25:44 -0400
Message-ID: <4DC7B308.5000206@redhat.com>
Date: Mon, 09 May 2011 11:25:28 +0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] drxd: Fix warning caused by new entries in an
 enum
References: <4DC6BF28.8070006@redhat.com>	 <1304882240-23044-3-git-send-email-steve@stevekerrison.com>	 <4DC714EC.2060606@linuxtv.org> <1304932548.2920.33.camel@ares>
In-Reply-To: <1304932548.2920.33.camel@ares>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 09-05-2011 11:15, Steve Kerrison escreveu:
> Hi Andreas,
> 
>> I'd prefer returning -EINVAL for unsupported parameters.
>>
>> [snip]
>>
>> I already had a patch for this, but forgot to submit it together with
>> the frontend.h bits.
> 
> That seems reasonable. Do I need to do anything with this? I'm happy for
> Mauro to scrub my drxd and mxl patches and use yours instead.
> 
>> Btw., "status = status;" looks odd.
> 
> Heh, yes it does. I wonder if that was put in to deal with an "unused
> variable" compiler warning before the switch statement had a default
> case? Otherwise, perhaps it's from the department of redundancy
> department.

Yes, there is. Linux defines a macro for it:
	uninitialized_var()

(it basically will do status = status internally with newer gcc versions,
but it helps to document what's happening there)

it is sometimes better to initialize the var, as the warning may help
to detect troubles after some changes. 

Cheers,
Mauro.
