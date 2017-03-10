Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37643 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934227AbdCJMEG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 07:04:06 -0500
Subject: Re: [PATCH v5 15/39] [media] v4l2: add a frame interval error event
To: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-16-git-send-email-steve_longerbeam@mentor.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5b0a0e76-2524-4140-5ccc-380a8f949cfa@xs4all.nl>
Date: Fri, 10 Mar 2017 13:03:30 +0100
MIME-Version: 1.0
In-Reply-To: <1489121599-23206-16-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/17 05:52, Steve Longerbeam wrote:
> Add a new FRAME_INTERVAL_ERROR event to signal that a video capture or
> output device has measured an interval between the reception or transmit
> completion of two consecutive frames of video that is outside the nominal
> frame interval by some tolerance value.

Reading back what was said on this I agree with Sakari that this doesn't
belong here.

Userspace can detect this just as easily (if not easier) with a timeout.

Regards,

	Hans

> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-dqevent.rst | 6 ++++++
>  Documentation/media/videodev2.h.rst.exceptions  | 1 +
>  include/uapi/linux/videodev2.h                  | 1 +
>  3 files changed, 8 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
> index 8d663a7..dc77363 100644
> --- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
> @@ -197,6 +197,12 @@ call.
>  	the regions changes. This event has a struct
>  	:c:type:`v4l2_event_motion_det`
>  	associated with it.
> +    * - ``V4L2_EVENT_FRAME_INTERVAL_ERROR``
> +      - 7
> +      - This event is triggered when the video capture or output device
> +	has measured an interval between the reception or transmit
> +	completion of two consecutive frames of video that is outside
> +	the nominal frame interval by some tolerance value.
>      * - ``V4L2_EVENT_PRIVATE_START``
>        - 0x08000000
>        - Base event number for driver-private events.
> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
> index e11a0d0..c7d8fad 100644
> --- a/Documentation/media/videodev2.h.rst.exceptions
> +++ b/Documentation/media/videodev2.h.rst.exceptions
> @@ -459,6 +459,7 @@ replace define V4L2_EVENT_CTRL event-type
>  replace define V4L2_EVENT_FRAME_SYNC event-type
>  replace define V4L2_EVENT_SOURCE_CHANGE event-type
>  replace define V4L2_EVENT_MOTION_DET event-type
> +replace define V4L2_EVENT_FRAME_INTERVAL_ERROR event-type
>  replace define V4L2_EVENT_PRIVATE_START event-type
>  
>  replace define V4L2_EVENT_CTRL_CH_VALUE ctrl-changes-flags
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 45184a2..cf5a0d0 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -2131,6 +2131,7 @@ struct v4l2_streamparm {
>  #define V4L2_EVENT_FRAME_SYNC			4
>  #define V4L2_EVENT_SOURCE_CHANGE		5
>  #define V4L2_EVENT_MOTION_DET			6
> +#define V4L2_EVENT_FRAME_INTERVAL_ERROR		7
>  #define V4L2_EVENT_PRIVATE_START		0x08000000
>  
>  /* Payload for V4L2_EVENT_VSYNC */
> 
