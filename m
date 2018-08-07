Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:32827 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388730AbeHGJip (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Aug 2018 05:38:45 -0400
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To: Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
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
 <20180724140621.59624-3-tfiga@chromium.org>
 <4168da98-fa01-ea2f-8162-385501e666be@xs4all.nl>
 <CAAFQd5BqtKFeJniNaqahi9h_zKR+rPrWUiyx004Z=MWDj7q++w@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0863717d-debe-09c1-24b0-05eb8e202dc0@xs4all.nl>
Date: Tue, 7 Aug 2018 09:25:38 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BqtKFeJniNaqahi9h_zKR+rPrWUiyx004Z=MWDj7q++w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/07/2018 08:54 AM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Wed, Jul 25, 2018 at 10:57 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 24/07/18 16:06, Tomasz Figa wrote:
>>> Due to complexity of the video encoding process, the V4L2 drivers of
>>> stateful encoder hardware require specific sequences of V4L2 API calls
>>> to be followed. These include capability enumeration, initialization,
>>> encoding, encode parameters change, drain and reset.
>>>
>>> Specifics of the above have been discussed during Media Workshops at
>>> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
>>> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
>>> originated at those events was later implemented by the drivers we already
>>> have merged in mainline, such as s5p-mfc or coda.
>>>
>>> The only thing missing was the real specification included as a part of
>>> Linux Media documentation. Fix it now and document the encoder part of
>>> the Codec API.
>>>
>>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>>> ---
>>>  Documentation/media/uapi/v4l/dev-encoder.rst | 550 +++++++++++++++++++
>>>  Documentation/media/uapi/v4l/devices.rst     |   1 +
>>>  Documentation/media/uapi/v4l/v4l2.rst        |   2 +
>>>  3 files changed, 553 insertions(+)
>>>  create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst
>>>
>>> diff --git a/Documentation/media/uapi/v4l/dev-encoder.rst b/Documentation/media/uapi/v4l/dev-encoder.rst
>>> new file mode 100644
>>> index 000000000000..28be1698e99c
>>> --- /dev/null
>>> +++ b/Documentation/media/uapi/v4l/dev-encoder.rst
>>> @@ -0,0 +1,550 @@
>>> +.. -*- coding: utf-8; mode: rst -*-
>>> +
>>> +.. _encoder:
>>> +
>>> +****************************************
>>> +Memory-to-memory Video Encoder Interface
>>> +****************************************
>>> +
>>> +Input data to a video encoder are raw video frames in display order
>>> +to be encoded into the output bitstream. Output data are complete chunks of
>>> +valid bitstream, including all metadata, headers, etc. The resulting stream
>>> +must not need any further post-processing by the client.
>>
>> Due to the confusing use capture and output I wonder if it would be better to
>> rephrase this as follows:
>>
>> "A video encoder takes raw video frames in display order and encodes them into
>> a bitstream. It generates complete chunks of the bitstream, including
>> all metadata, headers, etc. The resulting bitstream does not require any further
>> post-processing by the client."
>>
>> Something similar should be done for the decoder documentation.
>>
> 
> First, thanks a lot for review!
> 
> Sounds good to me, it indeed feels much easier to read, thanks.
> 
> [snip]
>>> +
>>> +IDR
>>> +   a type of a keyframe in H.264-encoded stream, which clears the list of
>>> +   earlier reference frames (DPBs)
>>
>> Same problem as with the previous patch: it doesn't say what IDR stands for.
>> It also refers to DPBs, but DPB is not part of this glossary.
> 
> Ack.
> 
>>
>> Perhaps the glossary of the encoder/decoder should be combined.
>>
> 
> There are some terms that have slightly different nuance between
> encoder and decoder, so while it would be possible to just include
> both meanings (as it was in RFC), I wonder if it wouldn't make it more
> difficult to read, also given that it would move it to a separate
> page. No strong opinion, though.

I don't have a strong opinion either. Let's keep it as is, we can always
change it later.

>>> +   * Setting the source resolution will reset visible resolution to the
>>> +     adjusted source resolution rounded up to the closest visible
>>> +     resolution supported by the driver. Similarly, coded resolution will
>>
>> coded -> the coded
> 
> Ack.
> 
>>
>>> +     be reset to source resolution rounded up to the closest coded
>>
>> reset -> set
>> source -> the source
> 
> Ack.
> 
>>
>>> +     resolution supported by the driver (typically a multiple of
>>> +     macroblock size).
>>
>> The first sentence of this paragraph is very confusing. It needs a bit more work,
>> I think.
> 
> Actually, this applies to all crop rectangles, not just visible
> resolution. How about the following?
> 
>     Setting the source resolution will reset the crop rectangles to
> default values

default -> their default

>     corresponding to the new resolution, as described further in this document.

Does 'this document' refer to this encoder chapter, or the whole v4l2 spec? It
might be better to provide an explicit link here.

>     Similarly, the coded resolution will be reset to match source

source -> the source

> resolution rounded up
>     to the closest coded resolution supported by the driver (typically
> a multiple of

of -> of the

>     macroblock size).

Anyway, this is much better.

>>> +Both queues operate independently, following standard behavior of V4L2
>>> +buffer queues and memory-to-memory devices. In addition, the order of
>>> +encoded frames dequeued from ``CAPTURE`` queue may differ from the order of
>>> +queuing raw frames to ``OUTPUT`` queue, due to properties of selected coded
>>> +format, e.g. frame reordering. The client must not assume any direct
>>> +relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
>>> +reported by :c:type:`v4l2_buffer` ``timestamp``.
>>
>> Same question as for the decoder: are you sure about that?
>>
> 
> I think it's the same answer here. That's why we have the timestamp
> copy mechanism, right?

See my reply from a few minutes ago. I'm not convinced copying timestamps
makes sense for codecs.

>>> +3. Once all ``OUTPUT`` buffers queued before ``V4L2_ENC_CMD_STOP`` are
>>> +   processed:
>>> +
>>> +   * Once all decoded frames (if any) are ready to be dequeued on the
>>> +     ``CAPTURE`` queue the driver must send a ``V4L2_EVENT_EOS``. The
>>> +     driver must also set ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buffer`
>>> +     ``flags`` field on the buffer on the ``CAPTURE`` queue containing the
>>> +     last frame (if any) produced as a result of processing the ``OUTPUT``
>>> +     buffers queued before
>>> +     ``V4L2_ENC_CMD_STOP``.
>>
>> Hmm, this is somewhat awkward phrasing. Can you take another look at this?
>>
> 
> How about this?
> 
> 3. Once all ``OUTPUT`` buffers queued before ``V4L2_ENC_CMD_STOP`` are
>    processed:
> 
>    * The driver returns all ``CAPTURE`` buffers corresponding to processed
>      ``OUTPUT`` buffers, if any. The last buffer must have
> ``V4L2_BUF_FLAG_LAST``
>      set in its :c:type:`v4l2_buffer` ``flags`` field.
> 
>    * The driver sends a ``V4L2_EVENT_EOS`` event.

I'd rephrase that last sentence to:

* Once the last buffer is returned the driver sends a ``V4L2_EVENT_EOS`` event.

>> One general comment:
>>
>> you often talk about 'the driver must', e.g.:
>>
>> "The driver must process and encode as normal all ``OUTPUT`` buffers
>> queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was issued."
>>
>> But this is not a driver specification, it is an API specification.
>>
>> I think it would be better to phrase it like this:
>>
>> "All ``OUTPUT`` buffers queued by the client before the :c:func:`VIDIOC_ENCODER_CMD`
>> was issued will be processed and encoded as normal."
>>
>> (or perhaps even 'shall' if you want to be really formal)
>>
>> End-users do not really care what drivers do, they want to know what the API does,
>> and that implies rules for drivers.
> 
> While I see the point, I'm not fully convinced that it makes the
> documentation easier to read. We defined "client" for the purpose of
> not using the passive form too much, so possibly we could also define
> "driver" in the glossary. Maybe it's just me, but I find that
> referring directly to both sides of the API and using the active form
> is much easier to read.
> 
> Possibly just replacing "driver" with "encoder" would ease your concern?

Actually, yes. I think that would work quite well.

Also, the phrase "the driver must" can be replaced by "the encoder will"
which describes the behavior of the encoder, which in turn defines what
the underlying driver must do.

Regards,

	Hans
