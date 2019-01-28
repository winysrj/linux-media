Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54167C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 12:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26E1C214DA
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 12:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfA1MDN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 07:03:13 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:59632 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfA1MDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 07:03:13 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id o5d4grlswRO5Zo5d7gJpuI; Mon, 28 Jan 2019 13:03:11 +0100
Subject: Re: [PATCH v10 0/4] Media Device Allocator API
To:     Shuah Khan <shuah@kernel.org>, mchehab@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <cover.1548360791.git.shuah@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e8717d11-1eff-2e07-53d5-6cd55356c66a@xs4all.nl>
Date:   Mon, 28 Jan 2019 13:03:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <cover.1548360791.git.shuah@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHBJy9HTonFoWGMJRFmLbhhYEKC8Pgal0+Y1qCk/8wfXu6KIvxhb3VGaJKwqOBpnVdvz+AaELzyuHcpEk8+LOfCmOsOGHCJvuEU+4JwSveXXLLdYcsa4
 Np4ZNmLWANK0nC2NUrX7y0ihmQAgKRT3wibqOajCX4GHgbt0ojPNegIsJ2EoSepLEK2g0wcIlmH5YXOis35aHjnxFGYVYXL9ECKJgeY/diZgfj8V1tu75VbG
 uub6FlLlw61ooETSzqNHPTDaQmBBmSUHThdlfapG7P5WZK+UqUreWjCjDkWGdTXNf1/kg6EOZl0x5UBNIzadstjPINf05Siv3taT+3X2apQgdXucLsfRbOBE
 5vI35MeM7nj/i86V5PG/g2yxbpniWw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Shuah,

On 1/24/19 9:32 PM, Shuah Khan wrote:
> Media Device Allocator API to allows multiple drivers share a media device.
> This API solves a very common use-case for media devices where one physical
> device (an USB stick) provides both audio and video. When such media device
> exposes a standard USB Audio class, a proprietary Video class, two or more
> independent drivers will share a single physical USB bridge. In such cases,
> it is necessary to coordinate access to the shared resource.
> 
> Using this API, drivers can allocate a media device with the shared struct
> device as the key. Once the media device is allocated by a driver, other
> drivers can get a reference to it. The media device is released when all
> the references are released.
> 
> - This patch series is tested on 5.0-rc3 and addresses comments on
>   v9 series from Hans Verkuil.
> - v9 was tested on 4.20-rc6.
> - Tested sharing resources with kaffeine, vlc, xawtv, tvtime, and
>   arecord. When analog is streaming, digital and audio user-space
>   applications detect that the tuner is busy and exit. When digital
>   is streaming, analog and audio applications detect that the tuner is
>   busy and exit. When arecord is owns the tuner, digital and analog
>   detect that the tuner is busy and exit.

I've been doing some testing with my au0828, and I am confused about one
thing, probably because it has been too long ago since I last looked into
this in detail:

Why can't I change the tuner frequency if arecord (and only arecord) is
streaming audio? If arecord is streaming, then it is recording the audio
from the analog TV tuner, right? So changing the analog TV frequency
should be fine.

I understand why you can't switch to DVB mode, but analog TV should be OK.
Or am I missing something?

Regards,

	Hans

> - Tested media device allocator API with bind/unbind testing on
>   snd-usb-audio and au0828 drivers to make sure /dev/mediaX is released
>   only when the last driver is unbound.
> - Addressed review comments from Hans on the RFC v8 (rebased on 4.19)
> - Updated change log to describe the use-case more clearly.
> - No changes to 0001,0002 code since the v7 referenced below.
> - 0003 is a new patch to enable ALSA defines that have been
>   disabled for kernel between 4.9 and 4.19.
> - Minor merge conflict resolution in 0004.
> - Added SPDX to new files.
> 
> Changes since v9:
> - Patch 1: Fix mutex assert warning from find_module() calls. This
>   code was written before the change to find_module() that requires
>   callers to hold module_mutex. I missed this during my testing on
>   4.20-rc6. Hans Verkuil reported the problem.
> - Patch 4: sound/usb: Initializes all the entities it can before
>   registering the device based on comments from Hans Verkuil
> - Carried Reviewed-by tag from Takashi Iwai for the sound from v9.
> - No changes to Patches 2 and 3.
> 
> References:
> https://lkml.org/lkml/2018/11/2/169
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg105854.html
> 
> Shuah Khan (4):
>   media: Media Device Allocator API
>   media: change au0828 to use Media Device Allocator API
>   media: media.h: Enable ALSA MEDIA_INTF_T* interface types
>   sound/usb: Use Media Controller API to share media resources
> 
>  Documentation/media/kapi/mc-core.rst   |  41 ++++
>  drivers/media/Makefile                 |   4 +
>  drivers/media/media-dev-allocator.c    | 144 +++++++++++
>  drivers/media/usb/au0828/au0828-core.c |  12 +-
>  drivers/media/usb/au0828/au0828.h      |   1 +
>  include/media/media-dev-allocator.h    |  53 ++++
>  include/uapi/linux/media.h             |  25 +-
>  sound/usb/Kconfig                      |   4 +
>  sound/usb/Makefile                     |   2 +
>  sound/usb/card.c                       |  14 ++
>  sound/usb/card.h                       |   3 +
>  sound/usb/media.c                      | 327 +++++++++++++++++++++++++
>  sound/usb/media.h                      |  74 ++++++
>  sound/usb/mixer.h                      |   3 +
>  sound/usb/pcm.c                        |  29 ++-
>  sound/usb/quirks-table.h               |   1 +
>  sound/usb/stream.c                     |   2 +
>  sound/usb/usbaudio.h                   |   6 +
>  18 files changed, 723 insertions(+), 22 deletions(-)
>  create mode 100644 drivers/media/media-dev-allocator.c
>  create mode 100644 include/media/media-dev-allocator.h
>  create mode 100644 sound/usb/media.c
>  create mode 100644 sound/usb/media.h
> 

