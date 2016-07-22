Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:55576 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbcGVJh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 05:37:28 -0400
Subject: Re: [PATCH v6 0/4] Lager/Koelsch board HDMI input support
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
References: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	william.towle@codethink.co.uk, geert@linux-m68k.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <67e414b4-7e1d-946e-2975-b3e3bb32c966@xs4all.nl>
Date: Fri, 22 Jul 2016 11:37:19 +0200
MIME-Version: 1.0
In-Reply-To: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good to me. I plan to queue this for 4.9.

Regards,

	Hans

On 07/22/2016 11:09 AM, Ulrich Hecht wrote:
> Hi!
> 
> This revision implements the pad translation between rcar-vin and subdevices
> as suggested by Niklas.  It also moves around the i2c devices, following the
> introduction of i2c multiplexing in the Gen2 device trees.
> 
> Based on renesas-drivers-2016-07-19-v4.7-rc7.
> 
> CU
> Uli
> 
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
> Hans Verkuil (1):
>   ARM: dts: koelsch: add HDMI input
> 
> Ulrich Hecht (2):
>   media: adv7604: automatic "default-input" selection
>   rcar-vin: implement EDID control ioctls
> 
> William Towle (1):
>   ARM: dts: lager: Add entries for VIN HDMI input support
> 
>  arch/arm/boot/dts/r8a7790-lager.dts         | 39 +++++++++++++++++++++++++++
>  arch/arm/boot/dts/r8a7791-koelsch.dts       | 41 +++++++++++++++++++++++++++++
>  drivers/media/i2c/adv7604.c                 |  5 +++-
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 33 +++++++++++++++++++++++
>  4 files changed, 117 insertions(+), 1 deletion(-)
> 
