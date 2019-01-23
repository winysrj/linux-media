Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07328C282C2
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 11:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D348820861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 11:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbfAWL3B (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 06:29:01 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47841 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726322AbfAWL3B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 06:29:01 -0500
Received: from [IPv6:2001:420:44c1:2579:d8f:48e2:1dc9:37b8] ([IPv6:2001:420:44c1:2579:d8f:48e2:1dc9:37b8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id mGiEg34AJBDyImGiIgYmt0; Wed, 23 Jan 2019 12:28:59 +0100
Subject: Re: [PATCH v2 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?UGF3ZcWCIE/Fm2NpYWs=?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
References: <20181022144901.113852-1-tfiga@chromium.org>
 <20181022144901.113852-3-tfiga@chromium.org>
 <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl>
 <5fb0f2db44ba7aa3788b61f2aa9a30d4f4984de5.camel@ndufresne.ca>
 <d853eb91-c05d-fb10-f154-bc24e4ebb89d@xs4all.nl>
 <CAAFQd5COddN-YosKyfBJ7n=qt40ONP=YEjBo5HQBOPGhs19h+g@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fcad4ca0-cfdd-d0fb-4b18-808426584755@xs4all.nl>
Date:   Wed, 23 Jan 2019 12:28:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAAFQd5COddN-YosKyfBJ7n=qt40ONP=YEjBo5HQBOPGhs19h+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfL2j4m31apzUYdjHRm+SScb8WykhcU3HpTLwvySOy3ifquyxp+4aMORogLafMw1FD2q7kmZtrq9w3CeaEjxaNrda09AoNkvvmqNzLPZUh/7+14bSIKSd
 8CPWeHxrK/1d5Xc6HEWyH4PZkpLqC52YsMqSK3wpS7ywWKLt/clABDPDFfcB5rhm4h9cu7sGqPShhw5VoOGzzxbeyOeBjixYQjCjgXKqtj2wClxNk9AYrstl
 UW12NMnWHE5OSrdYYBvzenDy4kGWdkYcIJTRqduK0M6Oh+s4VdowWhhi6HHdb+q2p31ou2sWmyLnAHjHKsIrUFWgsUEF0Ri2jdACnO7paLOhmDBrg1R7356r
 7yuGfy32dQBfba+c725H4CTIDU9FyenHVxoRkxWroXvmfpdU81uadGBb/2AM6gDiR+m9u1NGifaeIwlICMHZJKwx2rKjYOHJmy+bPTOhrAc03f/ae+0CHGFb
 wAweC1zn2/KbWIc4qYNshRXR+4imiUtmKe4zpkrLH/VkTAwHSVG5/VFRwMxPlYAspuPyn5DuV7eyfRt/tB/sqH7tCWXmqLXc6WFmCOAUB/+fkMRiQ8bNZIny
 ks0o+S8vrkWEPYoMPDllQhOPdLLJ2scurSNKeDVfPpx4nveV8JhFf6W8daAL/NUwTclcS8fAIbY2p9MGJdvsI3XgV6WzTzXmQUy+PyRYOd+KxxzVcxbLPrja
 UHDji5trrni8cTmTQMRVoznn1eFnNSQxvayFnn6ymVyPYpeCzQ1oJn1NYqqpVDfn4fDSFNJlID2LcKnXG1Dzdkaxgh8/Yu+T5KiKSX183hX50GyNFWDOcPDA
 RSbMzzyTBp9rA0ysi80U/l2IUqiFUYTM4NCx5jFZhVqnKK7s0W+ZR9AwS3n/HWnFMhGrfhP5xmp4EcEqGbsuubTsMfFc7VmBP1X4rOOh+s1z3adeKXfO6QKd
 XNylrEdiJ4yLzFsXutevKDZFF/f7SyS1Y6Fgw3cbpAre/1/h5+JuTbLlTAWKk/h4DqTs/g==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/23/19 11:00, Tomasz Figa wrote:
> On Sat, Nov 17, 2018 at 8:37 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> On 11/17/2018 05:18 AM, Nicolas Dufresne wrote:
>>> Le lundi 12 novembre 2018 à 14:23 +0100, Hans Verkuil a écrit :
>>>> On 10/22/2018 04:49 PM, Tomasz Figa wrote:
> [snip]
>>>>> +      rely on it. The ``V4L2_BUF_FLAG_LAST`` buffer flag should be used
>>>>> +      instead.
>>>>
>>>> Question: should new codec drivers still implement the EOS event?
>>>
>>> I'm been asking around, but I think here is a good place. Do we really
>>> need the FLAG_LAST in userspace ? Userspace can also wait for the first
>>> EPIPE return from DQBUF.
>>
>> I'm interested in hearing Tomasz' opinion. This flag is used already, so there
>> definitely is a backwards compatibility issue here.
>>
> 
> FWIW, it would add the overhead of 1 more system call, although I
> don't think it's of our concern.
> 
> My personal feeling is that using error codes for signaling normal
> conditions isn't very elegant, though.

I agree. Let's keep this flag.

Regards,

	Hans

> 
>>>
>>>>
>>>>> +
>>>>> +3. Once all ``OUTPUT`` buffers queued before the ``V4L2_ENC_CMD_STOP`` call and
>>>>> +   the last ``CAPTURE`` buffer are dequeued, the encoder is stopped and it will
>>>>> +   accept, but not process any newly queued ``OUTPUT`` buffers until the client
>>>>> +   issues any of the following operations:
>>>>> +
>>>>> +   * ``V4L2_ENC_CMD_START`` - the encoder will resume operation normally,
>>>>
>>>> Perhaps mention that this does not reset the encoder? It's not immediately clear
>>>> when reading this.
>>>
>>> Which drivers supports this ? I believe I tried with Exynos in the
>>> past, and that didn't work. How do we know if a driver supports this or
>>> not. Do we make it mandatory ? When it's not supported, it basically
>>> mean userspace need to cache and resend the header in userspace, and
>>> also need to skip to some sync point.
>>
>> Once we agree on the spec, then the next step will be to add good compliance
>> checks and update drivers that fail the tests.
>>
>> To check if the driver support this ioctl you can call VIDIOC_TRY_ENCODER_CMD
>> to see if the functionality is supported.
> 
> There is nothing here for the hardware to support. It's an entirely
> driver thing, since it just needs to wait for the encoder to complete
> all the pending frames and stop enqueuing more frames to the decoder
> until V4L2_ENC_CMD_START is called. Any driver that can't do it must
> be fixed, since otherwise you have no way to ensure that you got all
> the encoded output.
> 
> Best regards,
> Tomasz
> 

