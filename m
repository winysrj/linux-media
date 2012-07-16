Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54092 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2GPJJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 05:09:12 -0400
Date: Mon, 16 Jul 2012 11:09:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 04/13] devicetree: Add common video devices bindings
 documentation
In-Reply-To: <1337975573-27117-4-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1207161057050.12302@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
 <1337975573-27117-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 May 2012, Sylwester Nawrocki wrote:

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/devicetree/bindings/video/video.txt |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/video.txt
> 
> diff --git a/Documentation/devicetree/bindings/video/video.txt b/Documentation/devicetree/bindings/video/video.txt
> new file mode 100644
> index 0000000..9f6a637
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/video.txt
> @@ -0,0 +1,10 @@
> +Common properties of video data source devices (image sensor, video encoders, etc.)
> +
> +Video bus types
> +---------------
> +
> +- video-bus-type : must be one of:
> +
> +    - itu-601   : parallel bus with HSYNC and VSYNC - ITU-R BT.601;
> +    - itu-656   : parallel bus with embedded synchronization - ITU-R BT.656;

wikipedia tells me, that bt.601 is mostly a data encoding standard, it 
also defines bus-types, but recent versions also include serial busses.

> +    - mipi-csi2 : MIPI-CSI2 serial bus;

In general: are these at all needed? Wouldn't it be better to specify pads 
on sensors and interfaces to differentiate between serial and parallel 
connections. As for whether HSYNC and VSYNC are used - I see 3 
possibilities there:

1. real sync signals are used - the default.

2. embedded syncs shall be used, because sync signals are missing. This 
should (arguably) be derived from pinctrl - see this discussion:

http://lkml.indiana.edu/hypermail/linux/kernel/1205.2/index.html#03893

3. sync signals are present, but cannot be used, because one of the 
partners doesn't support them - .g_mbus_config() can be used to retrieve 
this information.

4. sync signals are available and supported by both peers, but for some 
reason the user prefers to use embedded sync data - is such a case 
feasible? Even if so, this should be run-time configurable then?

So, maybe we don't need these at all.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
