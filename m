Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:57992 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbbFLG3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 02:29:39 -0400
Message-ID: <557A7C47.40405@xs4all.nl>
Date: Fri, 12 Jun 2015 08:29:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 05/15] media: adv7604: document support for ADV7612 dual
 HDMI input decoder
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk> <1433340002-1691-6-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-6-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 03:59 PM, William Towle wrote:
> From: Ian Molton <ian.molton@codethink.co.uk>
> 
> This documentation accompanies the patch adding support for the ADV7612
> dual HDMI decoder / repeater chip.
> 
> Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> Reviewed-by: William Towle <william.towle@codethink.co.uk>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  .../devicetree/bindings/media/i2c/adv7604.txt        |   18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> index c27cede..7eafdbc 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -1,15 +1,17 @@
> -* Analog Devices ADV7604/11 video decoder with HDMI receiver
> +* Analog Devices ADV7604/11/12 video decoder with HDMI receiver
>  
> -The ADV7604 and ADV7611 are multiformat video decoders with an integrated HDMI
> -receiver. The ADV7604 has four multiplexed HDMI inputs and one analog input,
> -and the ADV7611 has one HDMI input and no analog input.
> +The ADV7604 and ADV7611/12 are multiformat video decoders with an integrated
> +HDMI receiver. The ADV7604 has four multiplexed HDMI inputs and one analog
> +input, and the ADV7611 has one HDMI input and no analog input. The 7612 is
> +similar to the 7611 but has 2 HDMI inputs.
>  
> -These device tree bindings support the ADV7611 only at the moment.
> +These device tree bindings support the ADV7611/12 only at the moment.
>  
>  Required Properties:
>  
>    - compatible: Must contain one of the following
>      - "adi,adv7611" for the ADV7611
> +    - "adi,adv7612" for the ADV7612
>  
>    - reg: I2C slave address
>  
> @@ -22,10 +24,10 @@ port, in accordance with the video interface bindings defined in
>  Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
>  are numbered as follows.
>  
> -  Port			ADV7611
> +  Port			ADV7611    ADV7612
>  ------------------------------------------------------------
> -  HDMI			0
> -  Digital output	1
> +  HDMI			0             0, 1
> +  Digital output	1                2
>  
>  The digital output port node must contain at least one endpoint.
>  
> 

