Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33365 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbeKZTry (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 14:47:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so12317418wrr.0
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 00:54:28 -0800 (PST)
Subject: Re: [PATCH] media: venus: fix reported size of 0-length buffers
To: Alexandre Courbot <acourbot@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20181113093048.236201-1-acourbot@chromium.org>
 <CAKQmDh-91tHP1VxLisW1A3GR9G7du3F-Y2XrrgoFU=gvhGoP6w@mail.gmail.com>
 <CAPBb6MWJ1Qu9YoRRusOGiC7dioMkgvU=1dCF6XZ4xDUxp7ri9A@mail.gmail.com>
 <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
 <CAPBb6MVzqqgUD5faN06=s-UNA9obxjiBQdMDNDK7m=m3=Utk3w@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <f84018c6-1a55-8cdd-0fc5-748f7940da7f@linaro.org>
Date: Mon, 26 Nov 2018 10:54:24 +0200
MIME-Version: 1.0
In-Reply-To: <CAPBb6MVzqqgUD5faN06=s-UNA9obxjiBQdMDNDK7m=m3=Utk3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On 11/22/18 10:31 AM, Alexandre Courbot wrote:
> On Fri, Nov 16, 2018 at 1:49 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
>>
>> Le mercredi 14 novembre 2018 à 13:12 +0900, Alexandre Courbot a écrit :
>>> On Wed, Nov 14, 2018 at 3:54 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
>>>>
>>>>
>>>> Le mar. 13 nov. 2018 04 h 30, Alexandre Courbot <acourbot@chromium.org> a écrit :
>>>>> The last buffer is often signaled by an empty buffer with the
>>>>> V4L2_BUF_FLAG_LAST flag set. Such buffers were returned with the
>>>>> bytesused field set to the full size of the OPB, which leads
>>>>> user-space to believe that the buffer actually contains useful data. Fix
>>>>> this by passing the number of bytes reported used by the firmware.
>>>>
>>>> That means the driver does not know on time which one is last. Why not just returned EPIPE to userspace on DQBUF and ovoid this useless roundtrip ?
>>>
>>> Sorry, I don't understand what you mean. EPIPE is supposed to be
>>> returned after a buffer with V4L2_BUF_FLAG_LAST is made available for
>>> dequeue. This patch amends the code that prepares this LAST-flagged
>>> buffer. How could we avoid a roundtrip in this case?
>>
>> Maybe it has changed, but when this was introduced, we found that some
>> firmware (Exynos MFC) could not know which one is last. Instead, it
>> gets an event saying there will be no more buffers.
>>
>> Sending buffers with payload size to 0 just for the sake of setting the
>> V4L2_BUF_FLAG_LAST was considered a waste. Specially that after that,
>> every polls should return EPIPE. So in the end, we decided the it
>> should just unblock the userspace and return EPIPE.
>>
>> If you look at the related GStreamer code, it completely ignores the
>> LAST flag. With fake buffer of size 0, userspace will endup dequeuing
>> and throwing away. This is not useful to the process of terminating the
>> decoding. To me, this LAST flag is not useful in this context.
> 
> Note that this patch does not interfere with DQBUF returning -EPIPE
> after the last buffer has been dequeued. It just fixes an invalid size
> that was returned for the last buffer.
> 
> Note also that if I understand the doc properly, the kernel driver
> *must* set the V4L2_BUF_FLAG_LAST on the last buffer. With Venus the
> last buffer is signaled by the firmware with an empty buffer. That's

Small correction, the firmware signals EoS with HFI_BUFFERFLAG_EOS flag
with the returned buffer, then we set V4L2_BUF_FLAG_LAST.

Usually with v1 and v3 when HFI_BUFFERFLAG_EOS is set the bytesused is zero.

> not something we can change or predict earlier, so in order to respect
> the specification we need to return that empty buffer. After that
> DQBUF will behave as expected (returning -EPIPE), so GStreamer should
> be happy as well.
> 
> Without the proposed fix however, GStreamer would receive the last
> buffer with an incorrect size, and thus interpret random data as a
> frame.
> 
> So to me this fix seems to be both correct, and needed. Isn't it?
> 
> Cheers,
> Alex.
> 

-- 
regards,
Stan
