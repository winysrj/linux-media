Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44046 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbbCPI6p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 04:58:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH 12/15] dt: bindings: Add lane-polarity property to endpoint nodes
Date: Mon, 16 Mar 2015 10:58:51 +0200
Message-ID: <2147266.can3HBBKOu@avalon>
In-Reply-To: <1426465570-30295-13-git-send-email-sakari.ailus@iki.fi>
References: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi> <1426465570-30295-13-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 16 March 2015 02:26:07 Sakari Ailus wrote:
> Add lane-polarity property to endpoint nodes. This essentially tells that
> the order of the differential signal wires is inverted.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt
> b/Documentation/devicetree/bindings/media/video-interfaces.txt index
> 571b4c6..27cfa4e 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -106,6 +106,12 @@ Optional endpoint properties
>  - link-frequencies: Allowed data bus frequencies. For MIPI CSI-2, for
>    instance, this is the actual frequency of the bus, not bits per clock per
> lane value. An array of 64-bit unsigned integers.
> +- lane-polarity: an array of polarities of the lanes starting from the
> clock +  lane and followed by the data lanes in the same order as in
> data-lanes. +  Valid values are 0 (normal) and 1 (inverted). The length of
> the array +  should be the combined length of data-lanes and clock-lanes
> properties. +  If the lane-polarity property is omitted, the value must be
> interpreted as 0 +  (normal). This property is valid for serial busses
> only.
> 
> 
>  Example

-- 
Regards,

Laurent Pinchart

