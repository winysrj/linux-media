Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:43820 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755271AbeEHRW2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 13:22:28 -0400
Subject: Re: [PATCH v2] media: v4l2-ioctl: fix function types for
 IOCTL_INFO_STD
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <44310a2b-2797-223c-fab4-0214490e5201@xs4all.nl>
 <20180507205135.88398-1-samitolvanen@google.com>
 <a627c61e-f227-297c-087e-c2a701b46a64@xs4all.nl>
 <20180508171759.GA184279@samitolvanen.mtv.corp.google.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2a04c948-82ba-c69f-891e-303db85b66a4@xs4all.nl>
Date: Tue, 8 May 2018 19:22:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180508171759.GA184279@samitolvanen.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2018 07:17 PM, Sami Tolvanen wrote:
> On Tue, May 08, 2018 at 10:18:24AM +0200, Hans Verkuil wrote:
>> Just call this v4l_stub_g_fbuf, conform the naming of the other functions.
>>
>> So just replace vidioc_ by v4l_stub_ in all these DEFINE_IOCTL_FNC macros.
>>
>> This way the function name in the big array matches the name in this macro,
>> and the 'stub' part indicates that it is just a stub function.
> 
> vidioc_ is actually part of the function name in struct v4l2_ioctl_ops,

I'm stupid, I should have seen that.

> which the stub needs to call. I can change the stub name to start with
> v4l_stub_, but if you prefer to drop vidioc_ entirely from the name,
> the macro still wouldn't end up matching the array. It would have to be
> something like this:
> 
>   #define DEFINE_IOCTL_FNC(_vidioc) \
> 	static int v4l_stub_ ## _vidioc( \
> 	...
> 		return ops->vidioc_ ## _vidioc(file, fh, p); \
>   ...
>   DEFINE_IOCTL_FNC(g_fbuf)
>   ...
>   static struct v4l2_ioctl_info v4l2_ioctls[] = {
> 	...
> 	IOCTL_INFO(VIDIOC_G_FBUF, v4l_stub_g_fbuf, ...),

This looks good, I would just rename DEFINE_IOCTL_FNC to DEFINE_V4L_STUB_FUNC.
This makes it clear that it defines a v4l stub function.

Regards,

	Hans
