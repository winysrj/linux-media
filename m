Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59574 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaDPOJf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 10:09:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	k.debski@samsung.com, s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	posciak@chromium.org, arunkk.samsung@gmail.com
Subject: Re: [PATCH 1/2] v4l: Add resolution change event.
Date: Wed, 16 Apr 2014 16:09:37 +0200
Message-ID: <4943000.PTOl0cPirQ@avalon>
In-Reply-To: <1397653162-10179-1-git-send-email-arun.kk@samsung.com>
References: <1397653162-10179-1-git-send-email-arun.kk@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Thank you for the patch.
On Wednesday 16 April 2014 18:29:21 Arun Kumar K wrote:
> From: Pawel Osciak <posciak@chromium.org>
> 
> This event indicates that the decoder has reached a point in the stream,
> at which the resolution changes. The userspace is expected to provide a new
> set of CAPTURE buffers for the new format before decoding can continue.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |    8 ++++++++
>  include/uapi/linux/videodev2.h                     |    1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml index
> 5c70b61..d848628 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> @@ -155,6 +155,14 @@
>  	    </entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>V4L2_EVENT_RESOLUTION_CHANGE</constant></entry>
> +	    <entry>5</entry>
> +	    <entry>This event is triggered when a resolution change is detected
> +	    during runtime by the video decoder. Application may need to
> +	    reinitialize buffers before proceeding further.
> +	    </entry>
> +	  </row>

Would it make sense to report the new resolution in the event data ? I suppose 
it might not be available in all cases though. If we can't report it, would it 
make sense to document how applications should proceed to retrieve it ?

A similar resolution change event might be useful on subdevs, in which case we 
would need to add a pad number to the event data. We could possibly leave that 
for later, but it would be worth considering the problem already.

> +	  <row>
>  	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
>  	    <entry>0x08000000</entry>
>  	    <entry>Base event number for driver-private events.</entry>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 6ae7bbe..58488b7 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1733,6 +1733,7 @@ struct v4l2_streamparm {
>  #define V4L2_EVENT_EOS				2
>  #define V4L2_EVENT_CTRL				3
>  #define V4L2_EVENT_FRAME_SYNC			4
> +#define V4L2_EVENT_RESOLUTION_CHANGE		5
>  #define V4L2_EVENT_PRIVATE_START		0x08000000
> 
>  /* Payload for V4L2_EVENT_VSYNC */

-- 
Regards,

Laurent Pinchart

