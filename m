Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35200 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbbCGXqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 18:46:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC 12/18] dt: bindings: Add lane-polarity property to endpoint nodes
Date: Sun, 08 Mar 2015 01:46:02 +0200
Message-ID: <2025225.4flgD7jFWe@avalon>
In-Reply-To: <1425764475-27691-13-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi> <1425764475-27691-13-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

(CC'ing Sylwester)

On Saturday 07 March 2015 23:41:09 Sakari Ailus wrote:
> Add lane-polarity property to endpoint nodes. This essentially tells that
> the order of the differential signal wires is inverted.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt
> b/Documentation/devicetree/bindings/media/video-interfaces.txt index
> 571b4c6..058d1e6 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -106,6 +106,11 @@ Optional endpoint properties
>  - link-frequencies: Allowed data bus frequencies. For MIPI CSI-2, for
>    instance, this is the actual frequency of the bus, not bits per clock per
> lane value. An array of 64-bit unsigned integers.
> +- lane-polarity: an array of polarities of the lanes starting from the
> clock
> +  lane and followed by the data lanes in the same order as in data-lanes.
> +  Valid values are 0 (normal) and 1 (inverted).

Would it make sense to add #define's for this ?

> The length of the array
> +  should be the combined length of data-lanes and clock-lanes
> properties.
> +  This property is valid for serial busses only.

You should also document what happens when the property is omitted.

>  Example

-- 
Regards,

Laurent Pinchart

