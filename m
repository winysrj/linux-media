Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6086FC43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CD0220874
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390083AbfAKO77 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 09:59:59 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:50783 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389655AbfAKO76 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 09:59:58 -0500
Received: from [IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a] ([IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a])
        by smtp-cloud9.xs4all.net with ESMTPA
        id hyHqgnT3nMWvEhyHrgcVJ1; Fri, 11 Jan 2019 15:59:56 +0100
Subject: Re: [alsa-devel] [PATCH v9 4/4] sound/usb: Use Media Controller API
 to share media resources
To:     shuah <shuah@kernel.org>, mchehab@kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <cover.1545154777.git.shuah@kernel.org>
 <2fb40852e4035b2a58010ce7416448918f12804f.1545154778.git.shuah@kernel.org>
 <s5hefadbp5m.wl-tiwai@suse.de>
 <5f9588b5-657a-78ee-9614-ed0ef1fc5839@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f13637a7-5c15-ba43-9929-78fef09e54fb@xs4all.nl>
Date:   Fri, 11 Jan 2019 15:59:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <5f9588b5-657a-78ee-9614-ed0ef1fc5839@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfFkZYbF27O8q+LVhIIrRyxTGO0XRmi7ql17YfW+RJjzQbSivhn3wF2flxqyGOnLpJPEFaXG1OQ1I4Sgmgg8LXyVt4z6uHsnbSuF0S5oK7IsEOmmFNwaV
 GSB8F50n6W7SYRpFUxg/ZC/LVRRsyFXTfj+e2eXhtZwjyNVQF7VVkjcGpVnyOSznzfk5KhYNlbPf5wcIv4deLpPKVrssCT7OFma+ydYHMA/R5XiTCP4K50ug
 DSWs+FlWQgQtC5X6cVhD2Cmr0fSHBp+to5tiVItAtCg3s+s96Dld719MZToX50Pz4F4J6HNELKEoim5galVkiNsyt4nX3GjEMq4+kD4Yi7rQFnihgfpko4Cy
 kOerWCx8XtI6wkqiWTfYpeB9zD1aWIPe535EOM2ycMIGh6QAX37IRFxhL9oCTClCvxXfkAIsbanpHiyKiif5QUFv/be/pdD82RXkJWLMIHne+dAL4OvwT78X
 Ft6SMdvetTlcO7cf
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/11/19 3:57 PM, shuah wrote:
> On 12/19/18 6:51 AM, Takashi Iwai wrote:
>> On Tue, 18 Dec 2018 18:59:39 +0100,
>> shuah@kernel.org wrote:
>>>
>>> From: Shuah Khan <shuah@kernel.org>
>>>
>>> Media Device Allocator API to allows multiple drivers share a media device.
>>> This API solves a very common use-case for media devices where one physical
>>> device (an USB stick) provides both audio and video. When such media device
>>> exposes a standard USB Audio class, a proprietary Video class, two or more
>>> independent drivers will share a single physical USB bridge. In such cases,
>>> it is necessary to coordinate access to the shared resource.
>>>
>>> Using this API, drivers can allocate a media device with the shared struct
>>> device as the key. Once the media device is allocated by a driver, other
>>> drivers can get a reference to it. The media device is released when all
>>> the references are released.
>>>
>>> Change the ALSA driver to use the Media Controller API to share media
>>> resources with DVB, and V4L2 drivers on a AU0828 media device.
>>>
>>> The Media Controller specific initialization is done after sound card is
>>> registered. ALSA creates Media interface and entity function graph nodes
>>> for Control, Mixer, PCM Playback, and PCM Capture devices.
>>>
>>> snd_usb_hw_params() will call Media Controller enable source handler
>>> interface to request the media resource. If resource request is granted,
>>> it will release it from snd_usb_hw_free(). If resource is busy, -EBUSY is
>>> returned.
>>>
>>> Media specific cleanup is done in usb_audio_disconnect().
>>>
>>> Signed-off-by: Shuah Khan <shuah@kernel.org>
>>
>> Feel free to take my ack regarding the sound stuff:
>>    Reviewed-by: Takashi Iwai <tiwai@suse.de>
>>
>>
>> Thanks!
>>
>> Takashi
>>
> 
> Hi Mauro,
> 
> Any update on this patch series?

I'm planning to process this series for 5.1. Haven't gotten around to it yet,
but I expect to do this next week.

Still going through all the pending patches after the Christmas period :-)

Regards,

	Hans
