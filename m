Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:34996 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3H3LmX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 07:42:23 -0400
Received: by mail-oa0-f45.google.com with SMTP id m1so1661396oag.18
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 04:42:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <522082D1.1080206@samsung.com>
References: <1377861082-17312-1-git-send-email-sachin.kamat@linaro.org>
	<522082D1.1080206@samsung.com>
Date: Fri, 30 Aug 2013 17:12:22 +0530
Message-ID: <CAK9yfHzthS9mcK+3CSPYcCeexxs5mCAARKvrRQJWJss47WkhDw@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] v4l2-ctrls: Remove duplicate const
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>, hans.verkuil@cisco.com,
	Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30 August 2013 17:02, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> On 08/30/2013 01:11 PM, Sachin Kamat wrote:
>> The function returns a pointer to a const array. Duplicate use of const
>> led to the following warning.
>> drivers/media/v4l2-core/v4l2-ctrls.c:574:32: warning: duplicate const
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> Thanks for the patch. I have already submitted a fix for this:
> https://patchwork.linuxtv.org/patch/19902/

Oops.. missed out on that. Looks like it is not yet applied to your
for-3.12-3 branch?

-- 
With warm regards,
Sachin
