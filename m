Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58058 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750873AbdE2JIX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 05:08:23 -0400
Subject: Re: [PATCH v3 0/4] r8a7793 Gose video input support
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, geert@linux-m68k.org,
        magnus.damm@gmail.com, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, sergei.shtylyov@cogentembedded.com,
        horms@verge.net.au, devicetree@vger.kernel.org
References: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ed9be832-21f5-ac8c-56cf-02afd14f5a34@xs4all.nl>
Date: Mon, 29 May 2017 11:08:12 +0200
MIME-Version: 1.0
In-Reply-To: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/19/2017 03:07 PM, Ulrich Hecht wrote:
> Hi!
> 
> This is a by-the-datasheet implementation of analog and digital video input
> on the Gose board.
> 
> This revision adds new bindings that distinguish between ADV7180 variants
> with three and six input ports. There are numerous variants of this chip,
> but since all that have "CP" in their names have three inputs, and all that
> have "ST" have six, I have limited myself to two new compatible strings,
> "adv7180cp" and "adv7180st".
> 
> The digital input patch has received minor tweaks of the port names for
> consistency, and the Gose analog input patch has been modified to use the
> new bindings, and a composite video connector has been added.

Looks good. I assume the dts changes go through linux-renesas-soc@vger.kernel.org?
I'll pick up the adv7180 changes.

Regards,

	Hans

> 
> CU
> Uli
> 
> 
> Changes since v2:
> - hdmi: port hdmi_con renamed to hdmi_con_out
> - adv7180: added new compatibility strings and bindings
> - composite: added connector, use new bindings
> 
> Changes since v1:
> - r8a7793.dtsi: added VIN2
> - modeled HDMI decoder input/output and connector
> - added "renesas,rcar-gen2-vin" compat strings
> - removed unnecessary "remote" node and aliases
> - set ADV7612 interrupt to GP4_2
> 
> 
> Ulrich Hecht (4):
>    ARM: dts: gose: add HDMI input
>    media: adv7180: add adv7180cp, adv7180st compatible strings
>    media: adv7180: Add adv7180cp, adv7180st bindings
>    ARM: dts: gose: add composite video input
> 
>   .../devicetree/bindings/media/i2c/adv7180.txt      |  15 +++
>   arch/arm/boot/dts/r8a7793-gose.dts                 | 127 ++++++++++++++++++++-
>   drivers/media/i2c/adv7180.c                        |   2 +
>   3 files changed, 142 insertions(+), 2 deletions(-)
> 
