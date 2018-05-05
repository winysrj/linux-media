Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:45057 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbeEEWWZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 18:22:25 -0400
Received: by mail-pf0-f194.google.com with SMTP id c10so20009430pfi.12
        for <linux-media@vger.kernel.org>; Sat, 05 May 2018 15:22:25 -0700 (PDT)
Subject: Re: [PATCH 0/2] media: imx: add capture support for RGB565_2X8 on
 parallel bus
To: Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de
References: <20180503164120.9912-1-jlu@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <ed3906bf-9682-77c6-011a-31bd1b76be7f@gmail.com>
Date: Sat, 5 May 2018 15:22:23 -0700
MIME-Version: 1.0
In-Reply-To: <20180503164120.9912-1-jlu@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan, Philipp,

I reviewed this patch series, and while I don't have any
objections to the code-level changes, but my question
is more specifically about how the IPU/CSI deals with
receiving RGB565 over a parallel bus.

My understanding was that if the CSI receives RGB565
over a parallel 8-bit sensor bus, the CSI_SENS_DATA_FORMAT
register field is programmed to RGB565, and the CSI outputs
ARGB8888. Then IDMAC component packing can be setup to
write pixels to memory as RGB565. Does that not work?

Assuming that above does not work (and indeed parallel RGB565
must be handled as pass-through), then I think support for capturing
parallel RGB555 as pass-through should be added to this series as
well.

Also what about RGB565 over a 16-bit parallel sensor bus? The
reference manual hints that perhaps this could be treated as
non-passthrough ("on the fly processing"), e.g. could be passed
on to the IC pre-processor:

     16 bit RGB565
         This is the only mode that allows on the fly processing of 16 
bit data. In this mode the
         CSI is programmed to receive 16 bit generic data. In this mode 
the interface is
         restricted to be in "non-gated mode" and the CSI#_DATA_SOURCE 
bit has to be set
         If the external device is 24bit - the user can connect a 16 bit 
sample of it (RGB565
         format). The IPU has to be configured in the same way as the 
case of
         CSI#_SENS_DATA_FORMAT=RGB565


Thanks,
Steve


On 05/03/2018 09:41 AM, Jan Luebbe wrote:
> The IPU can only capture RGB565 with two 8-bit cycles in bayer/generic
> mode on the parallel bus, compared to a specific mode on MIPI CSI-2.
> To handle this, we extend imx_media_pixfmt with a cycles per pixel
> field, which is used for generic formats on the parallel bus.
>
> Before actually adding RGB565_2X8 support for the parallel bus, this
> series simplifies handing of the the different configurations for RGB565
> between parallel and MIPI CSI-2 in imx-media-capture. This avoids having
> to explicitly pass on the format in the second patch.
>
> Jan Luebbe (2):
>    media: imx: capture: refactor enum_/try_fmt
>    media: imx: add support for RGB565_2X8 on parallel bus
>
>   drivers/staging/media/imx/imx-media-capture.c | 38 +++++++--------
>   drivers/staging/media/imx/imx-media-csi.c     | 47 +++++++++++++++++--
>   drivers/staging/media/imx/imx-media-utils.c   |  1 +
>   drivers/staging/media/imx/imx-media.h         |  2 +
>   4 files changed, 63 insertions(+), 25 deletions(-)
>
