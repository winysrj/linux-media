Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:39709 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932954AbcKKPgg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 10:36:36 -0500
Subject: Re: [RFC PATCH 0/6] media: davinci: VPIF: add DT support
To: Kevin Hilman <khilman@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20161025235536.7342-1-khilman@baylibre.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?Q?Bartosz_Go=c5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6058d790-5409-01c0-1d3f-b1bb45f8f85c@xs4all.nl>
Date: Fri, 11 Nov 2016 16:36:31 +0100
MIME-Version: 1.0
In-Reply-To: <20161025235536.7342-1-khilman@baylibre.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kevin,

On 10/26/2016 01:55 AM, Kevin Hilman wrote:
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
> 
> Kevin Hilman (6):
>   [media] davinci: add support for DT init
>   ARM: davinci: da8xx: VPIF: enable DT init
>   ARM: dts: davinci: da850: add VPIF
>   ARM: dts: davinci: da850-lcdk: enable VPIF capture
>   [media] davinci: vpif_capture: don't lock over s_stream
>   [media] davinci: vpif_capture: get subdevs from DT

Looks good, but wouldn't it be better to do the dts changes last when all the
supporting code is in?

Regards,

	Hans

> 
>  arch/arm/boot/dts/da850-lcdk.dts              |  30 ++++++
>  arch/arm/boot/dts/da850.dtsi                  |  28 +++++
>  arch/arm/mach-davinci/da8xx-dt.c              |  17 +++
>  drivers/media/platform/davinci/vpif.c         |   9 ++
>  drivers/media/platform/davinci/vpif_capture.c | 150 +++++++++++++++++++++++++-
>  include/media/davinci/vpif_types.h            |   9 +-
>  6 files changed, 236 insertions(+), 7 deletions(-)
> 
