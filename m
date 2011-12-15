Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55220 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1LOVqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 16:46:30 -0500
Received: by eaaj10 with SMTP id j10so2393479eaa.19
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 13:46:29 -0800 (PST)
Message-ID: <4EEA6AAE.80405@gmail.com>
Date: Thu, 15 Dec 2011 22:46:22 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl
Subject: Re: [RFC 1/3] v4l: Add pixel clock to struct v4l2_mbus_framefmt
References: <20111201143044.GI29805@valkosipuli.localdomain> <1323876147-18107-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1323876147-18107-1-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thanks for the patch.

On 12/14/2011 04:22 PM, Sakari Ailus wrote:
> Pixel clock is an essential part of the image data parameters. Add this.
> Together, the current parameters also define the frame rate.
> 
> Sensors do not have a concept of frame rate; pixel clock is much more
> meaningful in this context. Also, it is best to combine the pixel clock with
> the other format parameters since there are dependencies between them.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml |    9 ++++++++-
>  include/linux/v4l2-mediabus.h                      |    4 +++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 49c532e..b4591ef 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -35,7 +35,14 @@
>  	</row>
>  	<row>
>  	  <entry>__u32</entry>
> -	  <entry><structfield>reserved</structfield>[7]</entry>
> +	  <entry><structfield>pixel_clock</structfield></entry>
> +	  <entry>Pixel clock in kHz. This clock is the maximum rate at
> +	  which pixels are transferred on the bus. The pixel_clock
> +	  field is read-only.</entry>

I searched a couple of datasheets to find out where I could use this pixel_clock
field but didn't find any so far. I haven't tried too hard though ;)
There seems to be more benefits from having the link frequency control.

It might be easy to confuse pixel_clock with the bus clock. The bus clock is
often referred in datasheets as Pixel Clock (PCLK, AFAIU it's described with
link frequency in your RFC). IMHO your original proposal was better, i.e.
using more explicit pixel_rate. Also why it is in kHz ? Doesn't it make more
sense to use bits or pixels  per second ?


> +	</row>
> +	<row>
> +	  <entry>__u32</entry>
> +	  <entry><structfield>reserved</structfield>[6]</entry>
>  	  <entry>Reserved for future extensions. Applications and drivers must
>  	  set the array to zero.</entry>
>  	</row>
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 5ea7f75..76a0df2 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>   * @field:	used interlacing type (from enum v4l2_field)
>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> + * @pixel_clock: pixel clock, in kHz
>   */
>  struct v4l2_mbus_framefmt {
>  	__u32			width;
> @@ -108,7 +109,8 @@ struct v4l2_mbus_framefmt {
>  	__u32			code;
>  	__u32			field;
>  	__u32			colorspace;
> -	__u32			reserved[7];
> +	__u32			pixel_clock;

I'm wondering, whether it is worth to make it 'pixelclock' for consistency
with other fields? Perhaps it would make more sense to have color_space and
pixel_clock.
             		
> +	__u32			reserved[6];
>  };
>  
>  #endif

--

Regards,
Sylwester
