Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40576 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755151AbaDPSXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 14:23:11 -0400
Date: Wed, 16 Apr 2014 21:23:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH v3 00/11] Timestamp source and mem-to-mem device
 support
Message-ID: <20140416182307.GH8753@valkosipuli.retiisi.org.uk>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
 <3531905.nrTue8ouRr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3531905.nrTue8ouRr@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 16, 2014 at 08:21:54PM +0200, Laurent Pinchart wrote:
> Applied with whitespace fixes and the following change to 07/11.
> 
> @@ -867,6 +868,9 @@ static int video_queue_buffer(struct device *dev,
>  	buf.type = dev->type;
>  	buf.memory = dev->memtype;
>  
> -	if (dev->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +	if (video_is_output(dev))
>  		buf.flags = dev->buffer_output_flags;
>  
>  	if (video_is_mplane(dev)) {
> 

Thank you!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
