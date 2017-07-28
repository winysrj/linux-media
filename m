Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33584 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdG1MvC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 08:51:02 -0400
Received: by mail-wm0-f47.google.com with SMTP id e199so5724032wmd.0
        for <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 05:51:02 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] media: Add Amlogic Meson AO CEC Controller support
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1501168830-5308-1-git-send-email-narmstrong@baylibre.com>
 <d9aecd99-47d7-6a72-8d07-d64e185ea60e@xs4all.nl>
 <36cab0eb-0986-58d6-9cec-9bf4ab099495@xs4all.nl>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <c1a9518c-88e7-cc20-e64a-d8056fad448f@baylibre.com>
Date: Fri, 28 Jul 2017 14:50:57 +0200
MIME-Version: 1.0
In-Reply-To: <36cab0eb-0986-58d6-9cec-9bf4ab099495@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2017 02:37 PM, Hans Verkuil wrote:
> On 07/28/2017 02:35 PM, Hans Verkuil wrote:
>> Hi Neil,
>>
>> On 07/27/2017 05:20 PM, Neil Armstrong wrote:
>>> The Amlogic SoC embeds a standalone CEC controller, this patch adds a driver
>>> for such controller.
>>> The controller does not need HPD to be active, and could support up to max
>>> 5 logical addresses, but only 1 is handled since the Suspend firmware can
>>> make use of this unique logical address to wake up the device.
>>>
>>> The Suspend firmware configuration will be added in an other patchset.
>>
>> Note that to get the right module dependencies you will also need to add
>> this line:
>>
>> 	select CEC_CORE if CEC_NOTIFIER
>>
>> to DRM_MESON_DW_HDMI in drivers/gpu/drm/meson/Kconfig.
>>
>> This ensures that if DRM_MESON_DW_HDMI is 'y' but VIDEO_MESON_AO_CEC is 'm'
>> the CEC_CORE config is set to 'y'.
>>
>> Obviously this is a patch for dri-devel.
> 
> I was too quick sending this: I expect this line to appear in DRM_DW_HDMI,
> not DRM_MESON_DW_HDMI. Sorry about the noise.

Indeed, I will respin russell's notifier patch with this.

Thanks,
Neil

> 
> 	Hans
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Changes since v2 at [2] :
>>>  - change meson_ao_cec_read/write prototype to simplify error handling
>>>
>>> Changes since v1 at [1] :
>>>  - add timeout to wait busy, with error return
>>>  - handle busy error in all read/write operations
>>>  - add CEC_CAP_PASSTHROUGH
>>>  - add bindings ack
>>>
>>> [1] https://lkml.kernel.org/r/1499336870-24118-1-git-send-email-narmstrong@baylibre.com
>>> [2] https://lkml.kernel.org/r/1499673696-21372-1-git-send-email-narmstrong@baylibre.com
>>>
>>> Neil Armstrong (2):
>>>   platform: Add Amlogic Meson AO CEC Controller driver
>>>   dt-bindings: media: Add Amlogic Meson AO-CEC bindings
>>>
>>>  .../devicetree/bindings/media/meson-ao-cec.txt     |  28 +
>>>  drivers/media/platform/Kconfig                     |  11 +
>>>  drivers/media/platform/Makefile                    |   2 +
>>>  drivers/media/platform/meson/Makefile              |   1 +
>>>  drivers/media/platform/meson/ao-cec.c              | 744 +++++++++++++++++++++
>>>  5 files changed, 786 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/meson-ao-cec.txt
>>>  create mode 100644 drivers/media/platform/meson/Makefile
>>>  create mode 100644 drivers/media/platform/meson/ao-cec.c
>>>
>>
> 
