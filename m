Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56414 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727623AbeIMUlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 16:41:20 -0400
Subject: Re: [PATCH v2] staging: cedrus: Fix checkpatch issues
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org
References: <20180913144047.6390-1-maxime.ripard@bootlin.com>
 <20180913115349.608531f8@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <10079610-55a7-7bdf-f12c-0bf2d283e811@xs4all.nl>
Date: Thu, 13 Sep 2018 17:31:14 +0200
MIME-Version: 1.0
In-Reply-To: <20180913115349.608531f8@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2018 04:53 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 13 Sep 2018 16:40:47 +0200
> Maxime Ripard <maxime.ripard@bootlin.com> escreveu:
> 
> 
>> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
>> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
>> @@ -82,10 +82,7 @@ static struct cedrus_format *cedrus_find_format(u32 pixelformat, u32 directions,
>>  static bool cedrus_check_format(u32 pixelformat, u32 directions,
>>  				unsigned int capabilities)
>>  {
>> -	struct cedrus_format *fmt = cedrus_find_format(pixelformat, directions,
>> -						       capabilities);
>> -
>> -	return fmt != NULL;
>> +	return cedrus_find_format(pixelformat, directions, capabilities);
>>  }
> 
> Hmm... just occurred to me... Why do you need this? I mean, you 
> could simply do something like:
> 
> $ git filter-branch -f --tree-filter 'for i in $(git grep -l cedrus_check_format); do \
> 	sed -E s,\\bcedrus_check_format\\b,cedrus_find_format,g -i $i; done ' origin/master..
> 
> (or just do a sed -E s,\\bcedrus_check_format\\b,cedrus_find_format,g as
> a separate patch)
> 
> and get rid of cedrus_check_format() for good.

That looks like a nice follow-up patch. It's a staging driver, it doesn't
have to be perfect.

I'll prepare a pull request tomorrow.

Regards,

	Hans
