Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:16445 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbcIONZy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 09:25:54 -0400
Subject: Re: [PATCH v8 0/2] rcar-vin EDID control ioctls
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
References: <20160915132408.20776-1-ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
        william.towle@codethink.co.uk
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <29832cd4-9380-9cde-a868-90764daeea04@cisco.com>
Date: Thu, 15 Sep 2016 15:25:52 +0200
MIME-Version: 1.0
In-Reply-To: <20160915132408.20776-1-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/2016 03:24 PM, Ulrich Hecht wrote:
> Hi!
>
> This is a spinoff of "Lager/Koelsch board HDMI input support" that excludes
> the DT portions, and that works without the unmerged subdevice abstraction
> layer.

Are you going to post another patch series for the DT portions?

Regards,

	Hans

>
> This revision improves over v7 from earlier today in that it does not break
> analog input devices...
>
> CU
> Uli
>
>
> Changes since v7:
> - do not fail if there is no sink pad
>
> Changes since v6:
> - work without subdev abstraction layer
> - split off DT parts, to be handled separately
>
> Changes since v5:
> - implement vin/subdev pad translation
> - move i2c devices
>
> Changes since v4:
> - drop merged patches
> - adv7604: always fall back to input 0 if nothing else is specified
> - rcar-vin: implement G_EDID, S_EDID in place of hard-coded EDID blob
>
> Changes since v3:
> - rvin_enum_dv_timings(): use vin->src_pad_idx
> - rvin_dv_timings_cap(): likewise
> - rvin_s_dv_timings(): update vin->format
> - add Koelsch support
>
> Changes since v2:
> - rebased on top of rcar-vin driver v4
> - removed "adv7604: fix SPA register location for ADV7612" (picked up)
> - changed prefix of dts patch to "ARM: dts: lager: "
>
>
> Ulrich Hecht (2):
>   media: adv7604: automatic "default-input" selection
>   rcar-vin: implement EDID control ioctls
>
>  drivers/media/i2c/adv7604.c                 |  5 +++-
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 42 +++++++++++++++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  1 +
>  3 files changed, 47 insertions(+), 1 deletion(-)
>

