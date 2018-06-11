Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:44839 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932277AbeFKI4Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 04:56:25 -0400
Received: by mail-wr0-f194.google.com with SMTP id x4-v6so11333211wro.11
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2018 01:56:24 -0700 (PDT)
Subject: Re: [PATCH v7 0/6] Add ChromeOS EC CEC Support
To: Lee Jones <lee.jones@linaro.org>, Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, airlied@linux.ie,
        hans.verkuil@cisco.com, olof@lixom.net, seanpaul@google.com,
        sadolfsson@google.com, felixe@google.com, bleung@google.com,
        darekm@google.com, marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        eballetbo@gmail.com
References: <1527841154-24832-1-git-send-email-narmstrong@baylibre.com>
 <04598b47-5099-6695-da43-6e7148145cfa@xs4all.nl>
 <55c2c02d-5675-0821-97ec-6a805659b807@baylibre.com>
 <898f025f-9c59-be61-a2b4-5fbbcbc659c2@cisco.com> <20180611060308.GB5278@dell>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <87562fc8-6c5b-1c9d-4ee4-fd17b652087f@baylibre.com>
Date: Mon, 11 Jun 2018 10:56:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180611060308.GB5278@dell>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lee,

On 11/06/2018 08:03, Lee Jones wrote:
> On Fri, 08 Jun 2018, Hans Verkuil wrote:
>> On 08/06/18 10:17, Neil Armstrong wrote:
>>> On 08/06/2018 09:53, Hans Verkuil wrote:
>>>> On 06/01/2018 10:19 AM, Neil Armstrong wrote:
>>>>> Hi All,
>>>>>
>>>>> The new Google "Fizz" Intel-based ChromeOS device is gaining CEC support
>>>>> through it's Embedded Controller, to enable the Linux CEC Core to communicate
>>>>> with it and get the CEC Physical Address from the correct HDMI Connector, the
>>>>> following must be added/changed:
>>>>> - Add the CEC sub-device registration in the ChromeOS EC MFD Driver
>>>>> - Add the CEC related commands and events definitions into the EC MFD driver
>>>>> - Add a way to get a CEC notifier with it's (optional) connector name
>>>>> - Add the CEC notifier to the i915 HDMI driver
>>>>> - Add the proper ChromeOS EC CEC Driver
>>>>>
>>>>> The CEC notifier with the connector name is the tricky point, since even on
>>>>> Device-Tree platforms, there is no way to distinguish between multiple HDMI
>>>>> connectors from the same DRM driver. The solution I implemented is pretty
>>>>> simple and only adds an optional connector name to eventually distinguish
>>>>> an HDMI connector notifier from another if they share the same device.
>>>>
>>>> This looks good to me, which brings me to the next question: how to merge
>>>> this?
>>>>
>>>> It touches on three subsystems (media, drm, mfd), so that makes this
>>>> tricky.
>>>>
>>>> I think there are two options: either the whole series goes through the
>>>> media tree, or patches 1+2 go through drm and 3-6 through media. If there
>>>> is a high chance of conflicts in the mfd code, then it is also an option to
>>>> have patches 3-6 go through the mfd subsystem.
>>>
>>> I think patches 3-6 should go in the mfd tree, Lee is used to handle this,
>>> then I think the rest could go in the media tree.
>>>
>>> Lee, do you think it would be possible to have an immutable branch with patches 3-6 ?
>>>
>>> Could we have an immutable branch from media tree with patch 1 to be merged in
>>> the i915 tree for patch 2 ?
>>>
>>> Or patch 1+2 could me merged into the i915 tree and generate an immutable branch
>>
>> I think patches 1+2 can just go to the i915 tree. The i915 driver changes often,
>> so going through that tree makes sense. The cec-notifier code is unlikely to change,
>> and I am fine with that patch going through i915.
>>
>>> for media to merge the mfd branch + patch 7 ?
>>
>> Patch 7? I only count 6?
>>
>> If 1+2 go through drm and 3-6 go through mfd, then media isn't affected at all.
>> There is chance of a conflict when this is eventually pushed to mainline for
>> the media Kconfig, but that's all.
> 
> What are the *build* dependencies within the set?

Here are the hard the build dependency :

Patch 2 depends on Patch 1
Patch 5 depends on Patch 4
Patch 6 depends on Patches 1 & 4

> 
> I'd be happy to send out a pull-request for either all of the patches,
> or just the MFD changes once I've had chance to review them.
> 

Great, thanks !

Neil
