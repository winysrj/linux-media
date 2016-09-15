Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38035 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752528AbcIORoN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 13:44:13 -0400
Subject: Re: [PATCH v9 0/2] rcar-vin EDID control ioctls
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
References: <20160915173324.24539-1-ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
        william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6a2a38e7-fa41-618e-f631-e3ecb897b61a@xs4all.nl>
Date: Thu, 15 Sep 2016 19:44:05 +0200
MIME-Version: 1.0
In-Reply-To: <20160915173324.24539-1-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/15/2016 07:33 PM, Ulrich Hecht wrote:
> Hi!
> 
> This revision sits on top of Hans's rcar branch and adds pad sanity checks
> for g_edid and s_edid, the sink pad fix for the DV timings suggested by
> Niklas, and documents sink_pad_idx. Good night!
> 
> CU
> Uli
> 
> 
> Changes since v8:
> - dumped merged default-input patch

I've 'unmerged' this due to a comment from Laurent.

Can you look at Laurent's reply?

	Hans

> - added pad sanity check
> - added DV timings sink pad fix
> - documented sink_pad_idx
> - added Acked-By
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
>   rcar-vin: implement EDID control ioctls
>   media: rcar-vin: use sink pad index for DV timings
> 
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 52 +++++++++++++++++++++++++++--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  2 ++
>  2 files changed, 52 insertions(+), 2 deletions(-)
> 
