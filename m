Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28518 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3H3MIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 08:08:06 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MSC005Z3F1CSP00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Aug 2013 13:08:03 +0100 (BST)
Message-id: <52208B22.4080106@samsung.com>
Date: Fri, 30 Aug 2013 14:08:02 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>, hans.verkuil@cisco.com,
	Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 1/1] [media] v4l2-ctrls: Remove duplicate const
References: <1377861082-17312-1-git-send-email-sachin.kamat@linaro.org>
 <522082D1.1080206@samsung.com>
 <CAK9yfHzthS9mcK+3CSPYcCeexxs5mCAARKvrRQJWJss47WkhDw@mail.gmail.com>
In-reply-to: <CAK9yfHzthS9mcK+3CSPYcCeexxs5mCAARKvrRQJWJss47WkhDw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2013 01:42 PM, Sachin Kamat wrote:
> On 30 August 2013 17:02, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
>> Hi Sachin,
>>
>> On 08/30/2013 01:11 PM, Sachin Kamat wrote:
>>> The function returns a pointer to a const array. Duplicate use of const
>>> led to the following warning.
>>> drivers/media/v4l2-core/v4l2-ctrls.c:574:32: warning: duplicate const
>>>
>>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>
>> Thanks for the patch. I have already submitted a fix for this:
>> https://patchwork.linuxtv.org/patch/19902/
> 
> Oops.. missed out on that. Looks like it is not yet applied to your
> for-3.12-3 branch?

Yup, I didn't apply it since it touches the control framework. Thus
I assumed Hans will want to pick it up to his tree.

Regards,
Sylwester
