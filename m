Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42335 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753417AbbCIJW2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 05:22:28 -0400
Date: Mon, 9 Mar 2015 11:21:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-framework.txt: debug -> dev_debug
Message-ID: <20150309092155.GA11954@valkosipuli.retiisi.org.uk>
References: <54FBFA7B.9040904@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54FBFA7B.9040904@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 08, 2015 at 08:30:03AM +0100, Hans Verkuil wrote:
> The debug attribute was renamed to dev_debug. Update the doc accordingly.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/video4linux/v4l2-framework.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index f586e29..59e619f 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -793,8 +793,8 @@ video_register_device_no_warn() instead.
>  
>  Whenever a device node is created some attributes are also created for you.
>  If you look in /sys/class/video4linux you see the devices. Go into e.g.
> -video0 and you will see 'name', 'debug' and 'index' attributes. The 'name'
> -attribute is the 'name' field of the video_device struct. The 'debug' attribute
> +video0 and you will see 'name', 'dev_debug' and 'index' attributes. The 'name'
> +attribute is the 'name' field of the video_device struct. The 'dev_debug' attribute
>  can be used to enable core debugging. See the next section for more detailed
>  information on this.
>  
> @@ -821,7 +821,7 @@ unregister the device if the registration failed.
>  video device debugging
>  ----------------------
>  
> -The 'debug' attribute that is created for each video, vbi, radio or swradio
> +The 'dev_debug' attribute that is created for each video, vbi, radio or swradio
>  device in /sys/class/video4linux/<devX>/ allows you to enable logging of
>  file operations.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
