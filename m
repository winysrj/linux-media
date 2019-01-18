Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B77C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E9EE20883
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 14:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfAROLg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 09:11:36 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52775 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726881AbfAROLg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 09:11:36 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kUrtgld0ANR5ykUrugWpNp; Fri, 18 Jan 2019 15:11:34 +0100
Subject: Re: [PATCH v2 0/3] Add ZynqMP VCU/Allegro DVT H.264 encoder driver
To:     Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <38660b5f-bce3-8ffb-8804-1fb145ed6703@xs4all.nl>
Date:   Fri, 18 Jan 2019 15:11:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190118133716.29288-1-m.tretter@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFjermQ2pRlo/+92BkCvEm4vQRk0guGXbIpEhR0xJ/BJE4EUKy5HA8+QlIZ0yZdwITv/R/0big0ep8qm3SysEIfXpH8FAsi9E7d4w5AjwGdX2FPNOpYk
 YpVyYnmBiB5wlxqhPMYO87Yt4QRKmByo1VSIPLjHvddRw0xd/LlggNp34ncuM+FRlz6vZdPqCBXpYvcPf357rdjqnu9XOIxlRlEa1wo301PFaBvomyRBB9gV
 QZKGMALqGFqc/15I7P5fSsTpZYnJgIyRBMf6aB4g47T222+NVTsyr+Aqv7v/oY7cCn99DKthmwCHfPvF8p/ilhnbxfIxVlDR/FZTJxlEqvEiKxWceDKavtcu
 TgoQ6Bvb88278CPA8ca0GayEKFnz3cyUrVgdsIsxv+Ds/DUj1Iq2qfvzvOWv3WZYZIY5RJs8SHesQQbzbRS0QXRKLh9NluSx+Xy+cxXbEZxMKIShoG9esK55
 y68N4VbtPxrDzjmm
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Michael,

On 1/18/19 2:37 PM, Michael Tretter wrote:
> This is v2 of the series to add support for the Allegro DVT H.264 encoder
> found in the EV family of the Xilinx ZynqMP platform.
> 
> See v1 [0] of the patch series for a description of the hardware.
> 
> I fixed the handling of frames with various sizes and driver is now able to
> encode H.264 video in the baseline profile up to 1920x1080 pixels. I also
> addressed the issues reported by the kbuild robot for the previous series,
> implemented a few extended controls and changed the interface to the mcu to
> follow the register documentation rather than the downstream driver
> implementation.
> 
> I would especially appreciate feedback to the device tree bindings and the
> overall architecture of the driver.

I'll try to review this next week. Ping me if you didn't see a review by the
end of next week.

BTW, can you post the output of 'v4l2-compliance -s'? (make sure you use the
very latest version of v4l2-compliance!)

Regards,

	Hans

> 
> The driver still only works with the vcu-firmware release 2018.2. I am not yet
> sure how to address the different firmware versions, because in addition to
> the mailbox sizes, there are also changes within the messages themselves.
> 
> I also did not address the integration with the xlnx-vcu driver, yet.
> 
> Michael
> 
> [0] https://lore.kernel.org/linux-media/20190109113037.28430-1-m.tretter@pengutronix.de/
> 
> Changes since v1:
> - clean up debug log levels
> - fix unused variable in allegro_mbox_init
> - fix uninitialized variable in allegro_mbox_write
> - fix global module parameters
> - fix Kconfig dependencies
> - return h264 as default codec for mcu
> - implement device reset as documented
> - document why irq does not wait for clear
> - rename ENCODE_ONE_FRM to ENCODE_FRAME
> - allow error codes for mcu_channel_id
> - move control handler to channel
> - add fw version check
> - add support for colorspaces
> - enable configuration of H.264 levels
> - enable configuration of frame size
> - enable configuration of bit rate and CPB size
> - enable configuration of GOP size
> - rework response handling
> - fix missing error handling in allegro_h264_write_sps
> 
> Michael Tretter (3):
>   media: dt-bindings: media: document allegro-dvt bindings
>   [media] allegro: add Allegro DVT video IP core driver
>   [media] allegro: add SPS/PPS nal unit writer
> 
>  .../devicetree/bindings/media/allegro.txt     |   35 +
>  MAINTAINERS                                   |    6 +
>  drivers/staging/media/Kconfig                 |    2 +
>  drivers/staging/media/Makefile                |    1 +
>  drivers/staging/media/allegro-dvt/Kconfig     |   16 +
>  drivers/staging/media/allegro-dvt/Makefile    |    6 +
>  .../staging/media/allegro-dvt/allegro-core.c  | 2828 +++++++++++++++++
>  drivers/staging/media/allegro-dvt/nal-h264.c  | 1278 ++++++++
>  drivers/staging/media/allegro-dvt/nal-h264.h  |  188 ++
>  9 files changed, 4360 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
>  create mode 100644 drivers/staging/media/allegro-dvt/Kconfig
>  create mode 100644 drivers/staging/media/allegro-dvt/Makefile
>  create mode 100644 drivers/staging/media/allegro-dvt/allegro-core.c
>  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.c
>  create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.h
> 

