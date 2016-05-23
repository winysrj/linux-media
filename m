Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47873 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbcEWJKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 05:10:23 -0400
Subject: Re: [PATCH v4 2/6] media: Add video statistics computation functions
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1463701232-22008-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1463701232-22008-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5742C8F8.3070300@xs4all.nl>
Date: Mon, 23 May 2016 11:10:16 +0200
MIME-Version: 1.0
In-Reply-To: <1463701232-22008-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2016 01:40 AM, Laurent Pinchart wrote:
> The video statistics function describes entities such as video histogram
> engines or 3A statistics engines.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/DocBook/media/v4l/media-types.xml | 9 +++++++++
>  include/uapi/linux/media.h                      | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
> index 60fe841f8846..95aa1f9c836a 100644
> --- a/Documentation/DocBook/media/v4l/media-types.xml
> +++ b/Documentation/DocBook/media/v4l/media-types.xml
> @@ -176,6 +176,15 @@
>  		   skipping are considered as scaling.
>  	    </entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_STATISTICS</constant></entry>
> +	    <entry>Video statistics computation (histogram, 3A, ...). An entity
> +		   capable of statistics computation must have one sink pad and
> +		   one source pad. It computes statistics over the frames
> +		   received on its sink pad and outputs the statistics data on
> +		   its source pad.
> +	    </entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index bff3ffdfd55f..4580328c4093 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -103,6 +103,7 @@ struct media_device_info {
>  #define MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV	(MEDIA_ENT_F_BASE + 0x4003)
>  #define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
>  #define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
> +#define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
>  
>  /*
>   * Connectors
> 
