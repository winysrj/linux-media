Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44694 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaKGWoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Nov 2014 17:44:30 -0500
MIME-Version: 1.0
In-Reply-To: <1411399309-16418-1-git-send-email-j.anaszewski@samsung.com>
References: <1411399309-16418-1-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 7 Nov 2014 14:44:09 -0800
Message-ID: <CAK5ve-JJykowyAb6CGQfbzO8+6b1LNQxOSfeZe5uWNYnFx70Rg@mail.gmail.com>
Subject: Re: [PATCH/RFC v6 0/2] LED / flash API integration - V4L2 Flash
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	b.zolnierkie@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 22, 2014 at 8:21 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> This patch set is the follow-up of the LED / flash API integration
> series [1]. For clarity reasons the patchset has been split into
> four subsets:
>
> - LED Flash Class
> - V4L2 Flash

Hi Jacek,

For this series I think you'd better get review by V4L2 core
developer. I don't have much experience about this V4L2 APIs. But
generally I think you should make sure we merge those 3 patches for
LED FLASH class firstly. And this wrapper patchset can be merged
later.

-Bryan

> - LED Flash Class drivers
> - Documentation
>
> ========================
> Changes since version 5:
> ========================
>
> - removed flash manager framework - its implementation needs
>   further thorough discussion.
> - removed external strobe facilities from the LED Flash Class
>   and provided external_strobe_set op in v4l2-flash. LED subsystem
>   should be strobe provider agnostic.
>
> Thanks,
> Jacek Anaszewski
>
> [1] https://lkml.org/lkml/2014/7/11/914
>
> Jacek Anaszewski (2):
>   media: Add registration helpers for V4L2 flash
>   exynos4-is: Add support for v4l2-flash subdevs
>
>  drivers/media/platform/exynos4-is/media-dev.c |   36 +-
>  drivers/media/platform/exynos4-is/media-dev.h |   13 +-
>  drivers/media/v4l2-core/Kconfig               |   11 +
>  drivers/media/v4l2-core/Makefile              |    2 +
>  drivers/media/v4l2-core/v4l2-flash.c          |  502 +++++++++++++++++++++++++
>  include/media/v4l2-flash.h                    |  135 +++++++
>  6 files changed, 696 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
>  create mode 100644 include/media/v4l2-flash.h
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-leds" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
