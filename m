Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48312 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756039AbdJJDq4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 23:46:56 -0400
Subject: Re: [PATCHv3 0/2] drm/bridge/adv7511: add CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
References: <20171007104658.14528-1-hverkuil@xs4all.nl>
From: Archit Taneja <architt@codeaurora.org>
Message-ID: <539a317b-6c68-d6fe-20e1-0f1afe1165e0@codeaurora.org>
Date: Tue, 10 Oct 2017 09:16:51 +0530
MIME-Version: 1.0
In-Reply-To: <20171007104658.14528-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/07/2017 04:16 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series adds CEC support to the drm adv7511/adv7533 drivers.
> 
> I have tested this with the Qualcomm Dragonboard C410 (adv7533 based)
> and the Renesas R-Car Koelsch board (adv7511 based).
> 
> I only have the Koelsch board to test with, but it looks like other
> R-Car boards use the same adv7511. It would be nice if someone can
> add CEC support to the other R-Car boards as well. The main thing
> to check is if they all use the same 12 MHz fixed CEC clock source.
> 

queued to drm-misc-next.

Thanks,
Archit

> Anyone who wants to test this will need the CEC utilities that
> are part of the v4l-utils git repository:
> 
> git clone git://linuxtv.org/v4l-utils.git
> cd v4l-utils
> ./bootstrap.sh
> ./configure
> make
> sudo make install
> 
> Now configure the CEC adapter as a Playback device:
> 
> cec-ctl --playback
> 
> Discover other CEC devices:
> 
> cec-ctl -S
> 
> Regards,
> 
> 	Hans
> 
> Changes since v2:
> - A small rewording of the 'clocks' property description in the bindings
>    as per Sergei's comment.
> 
> Changes since v1:
> - Incorporate Archit's comments:
> 	use defines for irq masks
> 	combine the adv7511/33 regmap_configs
> 	adv7511_cec_init now handles dt parsing & CEC registration
> - Use the new (4.14) CEC_CAP_DEFAULTS define
> 
> Hans Verkuil (2):
>    dt-bindings: adi,adv7511.txt: document cec clock
>    drm: adv7511/33: add HDMI CEC support
> 
>   .../bindings/display/bridge/adi,adv7511.txt        |   4 +
>   drivers/gpu/drm/bridge/adv7511/Kconfig             |   8 +
>   drivers/gpu/drm/bridge/adv7511/Makefile            |   1 +
>   drivers/gpu/drm/bridge/adv7511/adv7511.h           |  43 ++-
>   drivers/gpu/drm/bridge/adv7511/adv7511_cec.c       | 337 +++++++++++++++++++++
>   drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 116 ++++++-
>   drivers/gpu/drm/bridge/adv7511/adv7533.c           |  38 +--
>   7 files changed, 489 insertions(+), 58 deletions(-)
>   create mode 100644 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
> 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
