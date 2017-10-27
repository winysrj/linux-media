Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:58241 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752348AbdJ0Mlm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 08:41:42 -0400
Subject: Re: [PATCH v5 0/5] media: atmel-isc: Rework the format list and clock
 provider
To: Wenyou Yang <wenyou.yang@microchip.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20171027032132.16418-1-wenyou.yang@microchip.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c7344ea2-dd71-8f42-1a11-188eb843c787@xs4all.nl>
Date: Fri, 27 Oct 2017 14:41:36 +0200
MIME-Version: 1.0
In-Reply-To: <20171027032132.16418-1-wenyou.yang@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wenyou,

Unfortunately the v4 patch series was just merged instead of v5. Can you make a new
patch applying just the v4 -> v5 changes?

Thanks!

	Hans

On 10/27/2017 05:21 AM, Wenyou Yang wrote:
> To improve the readability of code, rework the format list table,
> split the format array into two. Meanwhile, fix the issue of the
> clock provider operation and the pm runtime support.
> 
> Changes in v5:
>  - Fix the clock ID which enters the runtime suspend should be
>    ISC_ISPCK, instead of ISC_MCK for clk_prepare/clk_unprepare().
>  - Fix the clock ID to ISC_ISPCK, instead of ISC_MCK for
>    isc_clk_is_enabled().
> 
> Changes in v4:
>  - Call pm_runtime_get_sync() and pm_runtime_put_sync() in ->prepare
>    and ->unprepare callback.
>  - Move pm_runtime_enable() call from the complete callback to the
>    end of probe.
>  - Call pm_runtime_get_sync() and pm_runtime_put_sync() in
>    ->is_enabled() callbacks.
>  - Call clk_disable_unprepare() in ->remove callback.
> 
> Changes in v3:
>  - Fix the wrong used spinlock.
>  - s/_/- on the subject.
>  - Add a new flag for Raw Bayer format to remove MAX_RAW_FMT_INDEX define.
>  - Add the comments for define of the format flag.
>  - Rebase media_tree/master.
> 
> Changes in v2:
>  - Add the new patch to remove the unnecessary member from
>    isc_subdev_entity struct.
>  - Rebase on the patch set,
>         [PATCH 0/6] [media] Atmel: Adjustments for seven function implementations
>         https://www.mail-archive.com/linux-media@vger.kernel.org/msg118342.html
> 
> Wenyou Yang (5):
>   media: atmel-isc: Add spin lock for clock enable ops
>   media: atmel-isc: Add prepare and unprepare ops
>   media: atmel-isc: Enable the clocks during probe
>   media: atmel-isc: Remove unnecessary member
>   media: atmel-isc: Rework the format list
> 
>  drivers/media/platform/atmel/atmel-isc-regs.h |   1 +
>  drivers/media/platform/atmel/atmel-isc.c      | 629 ++++++++++++++++++++------
>  2 files changed, 498 insertions(+), 132 deletions(-)
> 
