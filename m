Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39874 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbcFQWGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 18:06:23 -0400
Date: Sat, 18 Jun 2016 00:06:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: ivo.g.dimitrov.75@gmail.com, pali.rohar@gmail.com, sre@kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20160617220614.GA31380@amd>
References: <20160527205140.GA26767@amd>
 <1465764110-7736-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465764110-7736-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> -</section>
> +
> +    <section id="voice-coil-controls">
> +      <title>Voice Coil Control Reference</title>
> +
> +      <para>The Voice Coil class controls are used to control voice
> +      coil lens devices. These are very simple devices that consist of
> +      a voice coil, a spring and a lens. The current applied on a

"on the"?

> +      voice coil is used to move the lens away from the resting
> +      position which typically is (close to) infinity.</para>

Insert explanation that this all is for autofocus somewhere?

>  /* User-class control IDs */
>  
> @@ -974,4 +975,10 @@ enum v4l2_detect_md_mode {
>  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
>  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
>  
> +/*  Voice coil lens driver control IDs defined by V4L2 */

Too many spaces after '/*'. 

Otherwise, you have my "acked-by".

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
