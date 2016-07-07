Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34032 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbcGGOhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 10:37:22 -0400
Received: by mail-io0-f179.google.com with SMTP id i186so22115946iof.1
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2016 07:37:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 7 Jul 2016 07:37:21 -0700
Message-ID: <CAJ+vNU1uPwoWE-UFoyqUXfc8vZ_stv1KhOfFkq+xD8Tv2O9PGw@mail.gmail.com>
Subject: Re: [PATCH 00/11] adv7180 subdev fixes
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 6, 2016 at 3:59 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Steve Longerbeam (11):
>   media: adv7180: Fix broken interrupt register access
>   Revert "[media] adv7180: fix broken standards handling"
>   media: adv7180: add power pin control
>   media: adv7180: implement g_parm
>   media: adv7180: init chip with AD recommended register settings
>   media: adv7180: add bt.656-4 OF property
>   media: adv7180: change mbus format to UYVY
>   adv7180: send V4L2_EVENT_SOURCE_CHANGE on std change
>   v4l: Add signal lock status to source change events
>   media: adv7180: enable lock/unlock interrupts
>   media: adv7180: fix field type
>
>  Documentation/DocBook/media/v4l/vidioc-dqevent.xml |  12 +-
>  drivers/media/i2c/Kconfig                          |   2 +-
>  drivers/media/i2c/adv7180.c                        | 409 +++++++++++++++------
>  include/uapi/linux/videodev2.h                     |   1 +
>  4 files changed, 308 insertions(+), 116 deletions(-)
>

Steve,

I've tested this series and will provide my ack/tested-by in the
individual patches.

These are well grouped but per the MAINTAINERS file they should all be
sent to 'Lars-Peter Clausen <lars@metafoo.de>' with a cc of
'linux-media@vger.kernel.org' or they are liable to be missed by the
proper maintainer:

ANALOG DEVICES INC ADV7180 DRIVER
M:      Lars-Peter Clausen <lars@metafoo.de>
L:      linux-media@vger.kernel.org
W:      http://ez.analog.com/community/linux-device-drivers
S:      Supported
F:      drivers/media/i2c/adv7180.c

I've cc'd Lars-Peter Clausen so that he see's the patches. Also, the
patch that reverts a previous patch should cc the people that wrote,
tested, ack'd and signed off on that patch. I will add them when I add
my review/ack to that patch.

Regards,

Tim
