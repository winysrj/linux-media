Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36782 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbcBWQPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 11:15:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] tvp5150: remove signal generator as input from the DT binding
Date: Tue, 23 Feb 2016 18:16:11 +0200
Message-ID: <3469550.VVKtG3tqH6@avalon>
In-Reply-To: <1456243798-12453-1-git-send-email-javier@osg.samsung.com>
References: <1456243798-12453-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tuesday 23 February 2016 13:09:58 Javier Martinez Canillas wrote:
> The chip internal signal generator was modelled as an input connector
> and represented as a media entity but isn't really a connector so the
> driver was changed to use the V4L2_CID_TEST_PATTERN control instead.
> 
> Remove the signal generator input from the list of connectors in the
> tvp5150 DT binding document as well since isn't a connector anymore.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> Hello,
> 
> I think is OK to change this DT binding because is only in the media tree
> for now and not in mainline yet and also is expected to change more since
> there are still discussions about how input connectors will be supported
> by the Media Controller framework in the media subsystem.

I think that's fine, yes

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I haven't noticed the patch that introduced this early enough I'm afraid, and 
I think we still have issues with those bindings.

The tvp5150 node should *not* contain connector subnodes, the connectors nodes 
should use the bindings defined in 
Documentation/devicetree/bindings/display/connector/ and be linked to the 
tvp5150 node using the OF graph bindings (ports and endpoints).

Do you think you could fix that ?

>  Documentation/devicetree/bindings/media/i2c/tvp5150.txt | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt index
> daa20e43a8e3..d13f8b8e235d 100644
> --- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> @@ -30,9 +30,6 @@ The possible values for the "input" property are:
>  	1: Composite1
>  	2: S-Video
> 
> -and on a tvp5150am1 and tvp5151 there is another:
> -	4: Signal generator
> -
>  The list of valid input connectors are defined in
> dt-bindings/media/tvp5150.h header file and can be included by device tree
> source files.

-- 
Regards,

Laurent Pinchart

