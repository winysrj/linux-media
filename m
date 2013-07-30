Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54692 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751482Ab3G3K55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 06:57:57 -0400
Date: Tue, 30 Jul 2013 13:57:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v3 2/5] v4l: Fix V4L2_MBUS_FMT_YUV10_1X30 media bus pixel
 code value
Message-ID: <20130730105751.GM12281@valkosipuli.retiisi.org.uk>
References: <1374757213-20194-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1374757213-20194-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374757213-20194-3-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 25, 2013 at 03:00:10PM +0200, Laurent Pinchart wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> The V4L2_MBUS_FMT_YUV10_1X30 code is documented as being equal to
> 0x2014, while the v4l2-mediabus.h header defines it as 0x2016. Fix the
> documentation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index adc6198..0c2b1f2 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -2574,7 +2574,7 @@
>  	    </row>
>  	    <row id="V4L2-MBUS-FMT-YUV10-1X30">
>  	      <entry>V4L2_MBUS_FMT_YUV10_1X30</entry>
> -	      <entry>0x2014</entry>
> +	      <entry>0x2016</entry>
>  	      <entry></entry>
>  	      <entry>y<subscript>9</subscript></entry>
>  	      <entry>y<subscript>8</subscript></entry>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
