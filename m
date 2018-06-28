Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59588 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965954AbeF1MrN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 08:47:13 -0400
Subject: Re: [PATCH v2 2/2] v4l: Add support for STD ioctls on subdev nodes
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
 <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
 <20180628083732.3679d730@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <536a05bd-372e-a509-a6b6-0a3e916e48ae@xs4all.nl>
Date: Thu, 28 Jun 2018 14:47:05 +0200
MIME-Version: 1.0
In-Reply-To: <20180628083732.3679d730@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/18 13:37, Mauro Carvalho Chehab wrote:
> Em Thu, 17 May 2018 16:30:16 +0200
> Niklas Söderlund         <niklas.soderlund+renesas@ragnatech.se> escreveu:
> 
>> There is no way to control the standard of subdevices which are part of
>> a media device. The ioctls which exists all target video devices
>> explicitly and the idea is that the video device should talk to the
>> subdevice. For subdevices part of a media graph this is not possible and
>> the standard must be controlled on the subdev device directly.
> 
> Why isn't it possible? A media pipeline should have at least a video
> devnode where the standard ioctls will be issued.

Not for an MC-centric device like the r-car or imx. It's why we have v4l-subdev
ioctls for the DV_TIMINGS API, but the corresponding SDTV standards API is
missing.

And in a complex scenario there is nothing preventing you from having multiple
SDTV inputs, some of which need PAL-BG, some SECAM, some NTSC (less likely)
which are all composed together (think security cameras or something like that).

You definitely cannot set the standard from a video device. If nothing else,
it would be completely inconsistent with how HDMI inputs work.

The whole point of MC centric devices is that you *don't* control subdevs
from video nodes.

Regards,

	Hans

> So, I don't see why you would need to explicitly set the standard inside
> a sub-device.
> 
> The way I see, inside a given pipeline, all subdevs should be using the
> same video standard (maybe except for a m2m device with would have some
> coded that would be doing format conversion).
> 
> Am I missing something?
> 
> Thanks,
> Mauro
> 
