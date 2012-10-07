Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2318 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2JGJ4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 05:56:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Michael West <michael@iposs.co.nz>
Subject: Re: Media_build broken by [PATCH RFC v3 5/5] m5mols: Implement .get_frame_desc subdev callback
Date: Sun, 7 Oct 2012 11:55:52 +0200
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com> <5070A3C9.8040409@gmail.com> <DCBB30B3D32C824F800041EE82CABAAE03203D63BB2A@duckworth.iposs.co.nz>
In-Reply-To: <DCBB30B3D32C824F800041EE82CABAAE03203D63BB2A@duckworth.iposs.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210071155.52691.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun October 7 2012 03:19:48 Michael West wrote:
> This patch changes versions.txt and disables  VIDEO_M5MOLS which fixed the build for my 3.2 kernel but looking at the logs it looks like this is not the way to fix it as it's not just a 3.6+ problem as it does not build on 3.6 as well...  So probably best to find why it doesn't build on the current kernel first.

FYI, I'll be fixing this and other build problems in media_build on Monday.

Regards,

	Hans

> 
> ---
>  v4l/versions.txt |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/v4l/versions.txt b/v4l/versions.txt
> index 328651e..349695c 100644
> --- a/v4l/versions.txt
> +++ b/v4l/versions.txt
> @@ -4,6 +4,8 @@
>  [3.6.0]
>  # needs devm_clk_get, clk_enable, clk_disable
>  VIDEO_CODA
> +# broken add reason here
> +VIDEO_M5MOLS
>  
>  [3.4.0]
>  # needs devm_regulator_bulk_get
> >On 10/06/2012 08:43 PM, Jan Hoogenraad wrote:
> >> Thanks.
> >>
> >> I see several drivers disabled for lower kernel versions in my Kconfig file.
> >> I am not sure how this is accomplished, but it would be helpful if the 
> >> Fujitsu M-5MOLS 8MP sensor support is automatically disabled for 
> >> kernel<  3.6
> >>
> >> I fixed it in my version by replacing SZ_1M by (1024*1024).
> >> I did not need the driver, but at least it compiled ...
> >
> >A patch for v4l/versions.txt is needed [1].
> >I'll see if I can prepare that.
> >http://git.linuxtv.org/media_build.git/history/5d00dba6aaf0f91a742d90fd1e12e0fb2d36253e:/v4l/versions.txt 
> 
> 
