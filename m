Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2FROLk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 10:11:40 -0400
Message-ID: <4FDF3712.5000608@redhat.com>
Date: Mon, 18 Jun 2012 11:11:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	s.nawrocki@samsung.com, mchehab@infradead.org, patches@linaro.org
Subject: Re: [PATCH 1/1] [media] s5p-fimc: Add missing static storage class
References: <1338045114-2477-1-git-send-email-sachin.kamat@linaro.org> <4FC290EC.3010509@gmail.com> <CAK9yfHw=3VhvWVTKBTS1qCd7U9MKU7Zk5rxP9cXNytoApuxWPg@mail.gmail.com>
In-Reply-To: <CAK9yfHw=3VhvWVTKBTS1qCd7U9MKU7Zk5rxP9cXNytoApuxWPg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-06-2012 01:27, Sachin Kamat escreveu:
> On 28/05/2012, Sylwester Nawrocki <snjw23@gmail.com> wrote:
>> On 05/26/2012 05:11 PM, Sachin Kamat wrote:
>>> Fixes the following sparse warnings:
>>
>> Hi Sachin. Thanks, in case somebody else applies this patch
>> before I do:
>> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>
> 
> Thanks Sylwester.
> 
>> I would just change the summary line to:
>> "s5p-fimc: Add missing static storage class specifiers" when
>> applying this patch.

Applied with the above change.
> 
> Ok.
> 
>>
>> --
>> Regards,
>> Sylwester
>>
> 
> 


