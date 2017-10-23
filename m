Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:48194 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdJWWWM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 18:22:12 -0400
Date: Mon, 23 Oct 2017 17:22:10 -0500
From: Rob Herring <robh@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 2/4] media: dt-bindings: Add bindings for TDA1997X
Message-ID: <20171023222210.gwyxlbvvbcbzbqie@rob-hp-laptop>
References: <1507783506-3884-1-git-send-email-tharvey@gateworks.com>
 <1507783506-3884-3-git-send-email-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507783506-3884-3-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 11, 2017 at 09:45:04PM -0700, Tim Harvey wrote:
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
> v2:
>  - add vendor prefix and remove _ from vidout-portcfg
>  - remove _ from labels
>  - remove max-pixel-rate property
>  - describe and provide example for single output port
>  - use new audio port bindings
> 
> ---
>  .../devicetree/bindings/media/i2c/tda1997x.txt     | 179 +++++++++++++++++++++
>  1 file changed, 179 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tda1997x.txt b/Documentation/devicetree/bindings/media/i2c/tda1997x.txt
> new file mode 100644
> index 0000000..269d7f0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tda1997x.txt
> @@ -0,0 +1,179 @@
> +Device-Tree bindings for the NXP TDA1997x HDMI receiver
> +
> +The TDA19971/73 are HDMI video receivers.
> +
> +The TDA19971 Video port output pins can be used as follows:
> + - RGB 8bit per color (24 bits total): R[11:4] B[11:4] G[11:4]
> + - YUV444 8bit per color (24 bits total): Y[11:4] Cr[11:4] Cb[11:4]
> + - YUV422 semi-planar 8bit per component (16 bits total): Y[11:4] CbCr[11:4]
> + - YUV422 semi-planar 10bit per component (20 bits total): Y[11:2] CbCr[11:2]
> + - YUV422 semi-planar 12bit per component (24 bits total): - Y[11:0] CbCr[11:0]
> + - YUV422 BT656 8bit per component (8 bits total): YCbCr[11:4] (2-cycles)
> + - YUV422 BT656 10bit per component (10 bits total): YCbCr[11:2] (2-cycles)
> + - YUV422 BT656 12bit per component (12 bits total): YCbCr[11:0] (2-cycles)
> +
> +The TDA19973 Video port output pins can be used as follows:
> + - RGB 12bit per color (36 bits total): R[11:0] B[11:0] G[11:0]
> + - YUV444 12bit per color (36 bits total): Y[11:0] Cb[11:0] Cr[11:0]
> + - YUV422 semi-planar 12bit per component (24 bits total): Y[11:0] CbCr[11:0]
> + - YUV422 BT656 12bit per component (12 bits total): YCbCr[11:0] (2-cycles)
> +
> +The Video port output pins are mapped via 4-bit 'pin groups' allowing
> +for a variety fo connection possibilities including swapping pin order within

s/fo /of /

> +pin groups. The video_portcfg device-tree property consists of register mapping
> +pairs which map a chip-specific VP output register to a 4-bit pin group. If
> +the pin group needs to be bit-swapped you can use the *_S pin-group defines.

The rest of the binding looks fine, but I have some reservations about 
this. I think this should be common probably. There's been a few 
bindings for display recently that deal with the interface format. Maybe 
some vendor property is needed here to map a standard interface format 
back to pin configuration.

Rob
