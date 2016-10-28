Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34158 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933416AbcJ1RRn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 13:17:43 -0400
Received: by mail-pf0-f173.google.com with SMTP id n85so40432771pfi.1
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 10:17:43 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/6] media: davinci: VPIF: add DT support
References: <20161025235536.7342-1-khilman@baylibre.com>
Date: Fri, 28 Oct 2016 10:17:41 -0700
In-Reply-To: <20161025235536.7342-1-khilman@baylibre.com> (Kevin Hilman's
        message of "Tue, 25 Oct 2016 16:55:30 -0700")
Message-ID: <m2k2cs75qi.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin Hilman <khilman@baylibre.com> writes:

> This series attempts to add DT support to the davinci VPIF capture
> driver.
>
> I'm not sure I've completely grasped the proper use of the ports and
> endpoints stuff, so this RFC is primarily to get input on whether I'm
> on the right track.
>
> The last patch is the one where all my questions are, the rest are
> just prep work to ge there.
>
> Tested on da850-lcdk and was able to do basic frame capture from the
> composite input.
>
> Series applies on v4.9-rc1

And FYI for anyone wanting to test, it needs a few config options
enabled[1] that are not (yet) part of davinci_all_defconfig.  I'll
update the defconfig when I'm ready to send non-RFC patches.

Kevin

[1]
CONFIG_MEDIA_SUPPORT=y
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_VIDEO_DEV=y

CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y

CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE=y

# manually select codecs
CONFIG_MEDIA_SUBDRV_AUTOSELECT=n

# da850-lcdk
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_ADV7343=y
