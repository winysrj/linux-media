Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57298 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbcDYNuM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 09:50:12 -0400
Date: Mon, 25 Apr 2016 08:50:07 -0500
From: Rob Herring <robh@kernel.org>
To: Eric Engestrom <eric@engestrom.ch>
Cc: linux-kernel@vger.kernel.org, Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Michal Simek <michal.simek@xilinx.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 14/41] Documentation: dt: media: fix spelling mistake
Message-ID: <20160425135007.GA8585@rob-hp-laptop>
References: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
 <1461543878-3639-15-git-send-email-eric@engestrom.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461543878-3639-15-git-send-email-eric@engestrom.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 25, 2016 at 01:24:11AM +0100, Eric Engestrom wrote:
> Signed-off-by: Eric Engestrom <eric@engestrom.ch>

Applied, thanks.

Rob

> ---
>  Documentation/devicetree/bindings/media/xilinx/video.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/xilinx/video.txt b/Documentation/devicetree/bindings/media/xilinx/video.txt
> index cbd46fa..68ac210 100644
> --- a/Documentation/devicetree/bindings/media/xilinx/video.txt
> +++ b/Documentation/devicetree/bindings/media/xilinx/video.txt
> @@ -20,7 +20,7 @@ The following properties are common to all Xilinx video IP cores.
>  - xlnx,video-format: This property represents a video format transmitted on an
>    AXI bus between video IP cores, using its VF code as defined in "AXI4-Stream
>    Video IP and System Design Guide" [UG934]. How the format relates to the IP
> -  core is decribed in the IP core bindings documentation.
> +  core is described in the IP core bindings documentation.
>  
>  - xlnx,video-width: This property qualifies the video format with the sample
>    width expressed as a number of bits per pixel component. All components must
> -- 
> 2.8.0
> 
