Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5F0C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 00:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F9D20684
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 00:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfBVA1t (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 19:27:49 -0500
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:56207 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfBVA1t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 19:27:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP id 32C0F6500C6;
        Thu, 21 Feb 2019 17:27:48 -0700 (MST)
Received: from mail-svr1.cs.utah.edu ([127.0.0.1])
        by localhost (mail-svr1.cs.utah.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7VbkIAs+VqP8; Thu, 21 Feb 2019 17:27:47 -0700 (MST)
Received: from [192.168.3.5] (dhcp-155-97-238-209.usahousing.utah.edu [155.97.238.209])
        by smtps.cs.utah.edu (Postfix) with ESMTPSA id 709236500C2;
        Thu, 21 Feb 2019 17:27:47 -0700 (MST)
Subject: Re: Problematic code in media/v4l2-core/v4l2-mem2mem.c
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com
References: <4c01f7987951d7a66350a069f471c129@cs.utah.edu>
 <20190221215048.GA3485@pendragon.ideasonboard.com>
From:   Shaobo He <shaobo@cs.utah.edu>
Message-ID: <2e745886-4f83-1135-a8e2-11b3a8b40cc2@cs.utah.edu>
Date:   Thu, 21 Feb 2019 17:27:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190221215048.GA3485@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thank you very much for your reply. While I was working on a patch, I realized 
that if we drop the two problematic NULL checks, we essentially eliminate one 
path of `v4l2_m2m_get_vq` where a NULL pointer is returned. So here comes a 
question, we may want to remove all the NULL checks of the return values of this 
function, for example in line 574 of media/platform/coda/coda-common.c. The 
reason is that if we conclude that `get_queue_ctx` cannot return a NULL pointer, 
then &q_ctx->q cannot be a NULL pointer as well because it points to the same 
address as `q_ctx` does.

If we agree on the NULL checks of the return values of `v4l2_m2m_get_vq` being 
unnecessary, I'll remove them in the patch.

Best,
Shaobo
On 2019/2/21 14:50, Laurent Pinchart wrote:
> Hi Shaobo,
> 
> On Thu, Feb 21, 2019 at 11:11:32AM -0700, Shaobo wrote:
>> Hello everyone,
>>
>> I think I brought up this issue before but didn't resolve it completely.
>> Now I'd like to double check this and if we can agree on it, I'd also
>> like to submit a patch to fix it. The problem is that function
>> `get_queue_ctx` can never return a NULL pointer unless pointer overflow
>> occurs, which is very unlikely. To be more specific,
>>
>> ```
>> static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx
>> *m2m_ctx,
>> 						enum v4l2_buf_type type)
>> {
>> 	if (V4L2_TYPE_IS_OUTPUT(type))
>> 		return &m2m_ctx->out_q_ctx;
>> 	else
>> 		return &m2m_ctx->cap_q_ctx;
>> }
>> ```
>>
>> The address returned by this function is either `(char*)m2m_ctx+968` or
>> `(char*)m2m_ctx+16`, so for it to be NULL, `m2m_ctx` must be a large
>> unsigned value. Yet the return value of this function is NULL-checked,
>> for example in v4l2_m2m_get_vq.
>>
>> Please let me know if it makes sense.
> 
> It makes complete sense.
> 
> There are only two callers of get_queue_ctx() that check the return
> value of the function. It may be argued that the intent was to check for
> a NULL m2m_ctx, so you could replace those two checks with a NULL check
> for m2m_ctx before calling get_queue_ctx(). However, given that nothing
> is crashing, it may also be argued that the checks are unnecessary and
> can be dropped completely. The best would be to review the call paths to
> ensure the functions can indeed never be called with NULL, but a quick
> look at the code shows no other NULL check in functions taking a m2m_ctx
> pointer as argument, so I'd vote for just dropping the two offending
> checks.
> 
> Care to submit a patch ? :-)
> 
