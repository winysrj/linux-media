Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45330 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbaEKVB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 17:01:29 -0400
Received: by mail-ee0-f51.google.com with SMTP id e51so4109366eek.24
        for <linux-media@vger.kernel.org>; Sun, 11 May 2014 14:01:28 -0700 (PDT)
Message-ID: <536FE53D.5050905@googlemail.com>
Date: Sun, 11 May 2014 23:01:49 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/19] em28xx: clean up the main device struct and move
 sub-module specific data to its own data structs
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com> <536C9A32.10703@xs4all.nl>
In-Reply-To: <536C9A32.10703@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Hans,

Am 09.05.2014 11:04, schrieb Hans Verkuil:
> Hi Frank,
>
> This looks good to me. I do have some comments for future cleanups and I'll
> reply to the relevant patches for that.
>
> However, before I can apply this patch series you need to take a look at my comments
> for this pre-requisite patch:
>
> https://patchwork.linuxtv.org/patch/23179/
>
> That needs to be sorted before I can apply this series.

Done:
https://patchwork.linuxtv.org/patch/23882/

I've also sent a rebased version of patch 15/19:
https://patchwork.linuxtv.org/patch/23883/

All other patches still apply.

Many thanks for reviewing the patches and your comments !

Regards,
Frank


>
> Regards,
>
> 	Hans
>
> On 03/24/2014 08:33 PM, Frank Schäfer wrote:
>> This patch series cleans up the main device struct of the em28xx driver.
>>
>> Most of the patches (patches 3-16) are about moving the em28xx-v4l specific data
>> to it's own dynamically allocated data structure.
>> Patch 19 moves two em28xx-alsa specific fields to the em28xx_audio struct.
>> Patches 17 and 18 remove two fields which aren't needed.
>>
>>
>> Frank Schäfer (19):
>>   em28xx: move sub-module data structs to a common place in the main
>>     struct
>>   em28xx-video: simplify usage of the pointer to struct
>>     v4l2_ctrl_handler in em28xx_v4l2_init()
>>   em28xx: start moving em28xx-v4l specific data to its own struct
>>   em28xx: move struct v4l2_ctrl_handler ctrl_handler from struct em28xx
>>     to struct v4l2
>>   em28xx: move struct v4l2_clk *clk from struct em28xx to struct v4l2
>>   em28xx: move video_device structs from struct em28xx to struct v4l2
>>   em28xx: move videobuf2 related data from struct em28xx to struct v4l2
>>   em28xx: move v4l2 frame resolutions and scale data from struct em28xx
>>     to struct v4l2
>>   em28xx: move vinmode and vinctrl data from struct em28xx to struct
>>     v4l2
>>   em28xx: move TV norm from struct em28xx to struct v4l2
>>   em28xx: move struct em28xx_fmt *format from struct em28xx to struct
>>     v4l2
>>   em28xx: move progressive/interlaced fields from struct em28xx to
>>     struct v4l2
>>   em28xx: move sensor parameter fields from struct em28xx to struct v4l2
>>   em28xx: move capture state tracking fields from struct em28xx to
>>     struct v4l2
>>   em28xx: move v4l2 user counting fields from struct em28xx to struct
>>     v4l2
>>   em28xx: move tuner frequency field from struct em28xx to struct v4l2
>>   em28xx: remove field tda9887_conf from struct em28xx
>>   em28xx: remove field tuner_addr from struct em28xx
>>   em28xx: move fields wq_trigger and streaming_started from struct
>>     em28xx to struct em28xx_audio
>>
>>  drivers/media/usb/em28xx/em28xx-audio.c  |  39 +-
>>  drivers/media/usb/em28xx/em28xx-camera.c |  51 +--
>>  drivers/media/usb/em28xx/em28xx-cards.c  |   9 -
>>  drivers/media/usb/em28xx/em28xx-vbi.c    |  10 +-
>>  drivers/media/usb/em28xx/em28xx-video.c  | 592 +++++++++++++++++--------------
>>  drivers/media/usb/em28xx/em28xx.h        | 120 ++++---
>>  6 files changed, 452 insertions(+), 369 deletions(-)
>>

