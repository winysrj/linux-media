Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55191 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbeHUOtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 10:49:18 -0400
Received: by mail-wm0-f68.google.com with SMTP id c14-v6so2568338wmb.4
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 04:29:30 -0700 (PDT)
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Tomasz Figa <tfiga@chromium.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
References: <20180724140621.59624-1-tfiga@chromium.org>
 <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl>
 <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
 <a6af3dc9-1d09-a414-ce31-bc1b3e69894f@xs4all.nl>
 <CAAFQd5AnC+hWy4QUGE-s+qgRvvgGC7rMhH6x8koTfYJzTLw8Cg@mail.gmail.com>
 <f0aa7c84-08e3-9b04-8d1b-95f741d6817b@xs4all.nl>
 <CAAFQd5ACWO0FxzZdxf-N-GStCMOSWzxKxhcpCRUh=BqT7jLJWw@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <41ee7486-9c7c-51ea-9355-1bf6c44f1639@linaro.org>
Date: Tue, 21 Aug 2018 14:29:26 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5ACWO0FxzZdxf-N-GStCMOSWzxKxhcpCRUh=BqT7jLJWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 08/08/2018 05:55 AM, Tomasz Figa wrote:
> On Tue, Aug 7, 2018 at 4:37 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

>>>>>>> +7.  If all the following conditions are met, the client may resume the
>>>>>>> +    decoding instantly, by using :c:func:`VIDIOC_DECODER_CMD` with
>>>>>>> +    ``V4L2_DEC_CMD_START`` command, as in case of resuming after the drain
>>>>>>> +    sequence:
>>>>>>> +
>>>>>>> +    * ``sizeimage`` of new format is less than or equal to the size of
>>>>>>> +      currently allocated buffers,
>>>>>>> +
>>>>>>> +    * the number of buffers currently allocated is greater than or equal to
>>>>>>> +      the minimum number of buffers acquired in step 6.
>>>>>>
>>>>>> You might want to mention that if there are insufficient buffers, then
>>>>>> VIDIOC_CREATE_BUFS can be used to add more buffers.
>>>>>>
>>>>>
>>>>> This might be a bit tricky, since at least s5p-mfc and coda can only
>>>>> work on a fixed buffer set and one would need to fully reinitialize
>>>>> the decoding to add one more buffer, which would effectively be the
>>>>> full resolution change sequence, as below, just with REQBUFS(0),
>>>>> REQBUFS(N) replaced with CREATE_BUFS.
>>>>
>>>> What happens today in those drivers if you try to call CREATE_BUFS?
>>>
>>> s5p-mfc doesn't set the .vidioc_create_bufs pointer in its
>>> v4l2_ioctl_ops, so I suppose that would be -ENOTTY?
>>
>> Correct for s5p-mfc.
> 
> As Philipp clarified, coda supports adding buffers on the fly. I
> briefly looked at venus and mtk-vcodec and they seem to use m2m
> implementation of CREATE_BUFS. Not sure if anyone tested that, though.
> So the only hardware I know for sure cannot support this is s5p-mfc.

In Venus case CREATE_BUFS is tested with Gstreamer.

-- 
regards,
Stan
