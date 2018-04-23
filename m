Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52804 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755112AbeDWNaU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:30:20 -0400
Subject: Re: [RFCv11 PATCH 27/29] vim2m: support requests
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-28-hverkuil@xs4all.nl>
 <CAAFQd5DsctmO4WNq+WWWK82+1nbwcnFk6aC6g9D0R4o0f4LbAw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <97a0c925-5435-a221-67b1-1c13346c505a@xs4all.nl>
Date: Mon, 23 Apr 2018 15:30:13 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DsctmO4WNq+WWWK82+1nbwcnFk6aC6g9D0R4o0f4LbAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2018 11:15 AM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
>> Add support for requests to vim2m.
> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/platform/vim2m.c | 25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
> 
>> diff --git a/drivers/media/platform/vim2m.c
> b/drivers/media/platform/vim2m.c
>> index 9b18b32c255d..2dcf0ea85705 100644
>> --- a/drivers/media/platform/vim2m.c
>> +++ b/drivers/media/platform/vim2m.c
>> @@ -387,8 +387,26 @@ static void device_run(void *priv)
>>          src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>>          dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> 
>> +       /* Apply request if needed */
>> +       if (src_buf->vb2_buf.req_obj.req)
>> +               v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
>> +                                       &ctx->hdl);
>> +       if (dst_buf->vb2_buf.req_obj.req &&
>> +           dst_buf->vb2_buf.req_obj.req != src_buf->vb2_buf.req_obj.req)
>> +               v4l2_ctrl_request_setup(dst_buf->vb2_buf.req_obj.req,
>> +                                       &ctx->hdl);
> 
> I'm not sure I understand what's going on here. How is it possible that we
> have 2 different requests?

You can have one request with buffers for both queues, or two requests, one
for each queue. Or a request for just one of the queues and the other without
any requests.

So you can have 0, 1 or 2 requests associated with these two queues.

But you don't want to call v4l2_ctrl_request_setup twice if the same request
is associated with both queues. (Well, you can call it twice and the second
call would not do anything, but that's a waste of CPU cycles)

Regards,

	Hans
