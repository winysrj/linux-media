Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4963 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaHFGoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 02:44:00 -0400
Message-ID: <53E1CEA2.3080503@xs4all.nl>
Date: Wed, 06 Aug 2014 08:43:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: Event documentation fixes
References: <1407307069-13480-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1407307069-13480-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2014 08:37 AM, Sakari Ailus wrote:
> Constify event type constants and correct motion detection event number
> (it's 6, not 5).
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/DocBook/media/v4l/vidioc-dqevent.xml         | 7 ++++---
>  Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml | 2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> index cb77325..ce7e700 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> @@ -76,21 +76,22 @@
>  	    <entry></entry>
>  	    <entry>&v4l2-event-vsync;</entry>
>              <entry><structfield>vsync</structfield></entry>
> -	    <entry>Event data for event V4L2_EVENT_VSYNC.
> +	    <entry>Event data for event <constant>V4L2_EVENT_VSYNC</constant>.
>              </entry>
>  	  </row>
>  	  <row>
>  	    <entry></entry>
>  	    <entry>&v4l2-event-ctrl;</entry>
>              <entry><structfield>ctrl</structfield></entry>
> -	    <entry>Event data for event V4L2_EVENT_CTRL.
> +	    <entry>Event data for event <constant>V4L2_EVENT_CTRL</constant>.
>              </entry>
>  	  </row>
>  	  <row>
>  	    <entry></entry>
>  	    <entry>&v4l2-event-frame-sync;</entry>
>              <entry><structfield>frame_sync</structfield></entry>
> -	    <entry>Event data for event V4L2_EVENT_FRAME_SYNC.</entry>
> +	    <entry>Event data for event <constant>V4L2_EVENT_FRAME_SYNC
> +	    </constant>.</entry>

Keep </constant> next to V4L2_EVENT_FRAME_SYNC otherwise you will end up with
"V4L2_EVENT_FRAME_SYNC ." in the html output.

>  	  </row>
>  	  <row>
>  	    <entry></entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> index 9f60956..d7c9365 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> @@ -176,7 +176,7 @@
>  	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_EVENT_MOTION_DET</constant></entry>
> -	    <entry>5</entry>
> +	    <entry>6</entry>

Oops! My mistake.

>  	    <entry>
>  	      <para>Triggered whenever the motion detection state for one or more of the regions
>  	      changes. This event has a &v4l2-event-motion-det; associated with it.</para>
> 

Regards,

	Hans

