Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39277 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753695Ab2FLWza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 18:55:30 -0400
Date: Wed, 13 Jun 2012 01:55:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v3.5] Fix VIDIOC_DQEVENT docbook entry
Message-ID: <20120612225525.GI12505@valkosipuli.retiisi.org.uk>
References: <201206091259.45508.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206091259.45508.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 09, 2012 at 12:59:45PM +0200, Hans Verkuil wrote:
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> index e8714aa..98a856f 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> @@ -89,7 +89,7 @@
>  	  <row>
>  	    <entry></entry>
>  	    <entry>&v4l2-event-frame-sync;</entry>
> -            <entry><structfield>frame</structfield></entry>
> +            <entry><structfield>frame_sync</structfield></entry>
>  	    <entry>Event data for event V4L2_EVENT_FRAME_SYNC.</entry>
>  	  </row>
>  	  <row>

Thanks, Hans!! I really wonder how that can have slipped through back
then... :P

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
