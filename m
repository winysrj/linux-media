Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:34396 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1L3VKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 16:10:55 -0500
Date: Fri, 30 Dec 2011 23:10:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "HeungJun, Kim" <riverful.kim@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, kyungmin.park@samsung.com
Subject: Re: [RFC PATCH 3/4] v4l: Add V4L2_CID_WDR button control
Message-ID: <20111230211051.GZ3677@valkosipuli.localdomain>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-4-git-send-email-riverful.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325053428-2626-4-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi HeungJun,

On Wed, Dec 28, 2011 at 03:23:47PM +0900, HeungJun, Kim wrote:
> It adds the new CID for setting White Balance Preset. This CID is provided as
> button type. This can commands only if the camera turn on/off this function.
> 
> Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |   12 ++++++++++++
>  drivers/media/video/v4l2-ctrls.c             |    2 ++
>  include/linux/videodev2.h                    |    2 ++
>  3 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index afe1845..bed6c66 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2958,6 +2958,18 @@ it one step further. This is a write-only control.</entry>
>  	  <row><entry></entry></row>
>  
>  	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_WDR</constant></entry>

Just a simple comment: how about V4L2_CID_WIDE_DYNAMIC_RANGE instead? I
dont't think it'd be too long.

> +	    <entry>button</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Wide Dynamic Range. It makes
> +	    the image be more clear by adjusting the image's intensity
> +	    of the illumination. This function can be provided according to
> +	    the capability of the hardware(sensor or AP's multimedia block).
> +	    </entry>
> +	  </row>
> +
> +	  <row>
>  	    <entry spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
>  	    <entry>boolean</entry>
>  	  </row><row><entry spanname="descr">Prevent video from being acquired
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index fef58c2..66110bc 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -598,6 +598,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
>  	case V4L2_CID_PRESET_WHITE_BALANCE:	return "White Balance, Preset";
>  	case V4L2_CID_SCENEMODE:		return "Scenemode";
> +	case V4L2_CID_WDR:			return "Wide Dynamic Range";
>  
>  	/* FM Radio Modulator control */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> @@ -687,6 +688,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  		break;
>  	case V4L2_CID_PAN_RESET:
>  	case V4L2_CID_TILT_RESET:
> +	case V4L2_CID_WDR:
>  	case V4L2_CID_FLASH_STROBE:
>  	case V4L2_CID_FLASH_STROBE_STOP:
>  		*type = V4L2_CTRL_TYPE_BUTTON;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index bc14feb..f85ad6c 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1646,6 +1646,8 @@ enum v4l2_scenemode {
>  	V4L2_SCENEMODE_CANDLE = 14,
>  };
>  
> +#define V4L2_CID_WDR				(V4L2_CID_CAMERA_CLASS_BASE+21)
> +
>  /* FM Modulator class control IDs */
>  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
>  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
> -- 
> 1.7.4.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
