Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42518 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755424AbdJJIMp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 04:12:45 -0400
Date: Tue, 10 Oct 2017 11:12:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] media: atmel-isc: Rework the format list and
 clock provider
Message-ID: <20171010081242.jxoyb3i5hr5q6zkg@valkosipuli.retiisi.org.uk>
References: <20171010024640.5733-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010024640.5733-1-wenyou.yang@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 10, 2017 at 10:46:35AM +0800, Wenyou Yang wrote:
> To improve the readability of code, rework the format list table,
> split the format array into two. Meanwhile, fix the issue of the
> clock provider operation and the pm runtime support.
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

Thanks for the update!!

For patches 0--4:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
