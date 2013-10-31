Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51543 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3JaOp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Oct 2013 10:45:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, sylwester.nawrocki@gmail.com,
	a.hajda@samsung.com
Subject: Re: [PATCH v2.2 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Date: Thu, 31 Oct 2013 15:45:54 +0100
Message-ID: <3977240.SUD62DEGqA@avalon>
In-Reply-To: <1381873617-5481-1-git-send-email-sakari.ailus@iki.fi>
References: <3422963.Ua6Z8kTtzN@avalon> <1381873617-5481-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Wednesday 16 October 2013 00:46:57 Sakari Ailus wrote:
> Pads that set this flag must be connected by an active link for the entity
> to stream.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/media/v4l/media-ioc-enum-links.xml |    9 +++++++++
>  include/uapi/linux/media.h                               |    1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
> b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml index
> 355df43..cf85485 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
> @@ -134,6 +134,15 @@
>  	    <entry>Output pad, relative to the entity. Output pads source data
>  	    and are origins of links.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_PAD_FL_MUST_CONNECT</constant></entry>
> +	    <entry>If this flag is set and the pad is linked to any other
> +	    pad, then at least one of those links must be enabled for the
> +	    entity to be able to stream. There could be temporary reasons
> +	    (e.g. device configuration dependent) for the pad to need
> +	    enabled links even when this flag isn't set; the absence of the
> +	    flag doesn't imply there is none.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index ed49574..d847c76 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -98,6 +98,7 @@ struct media_entity_desc {
> 
>  #define MEDIA_PAD_FL_SINK		(1 << 0)
>  #define MEDIA_PAD_FL_SOURCE		(1 << 1)
> +#define MEDIA_PAD_FL_MUST_CONNECT	(1 << 2)
> 
>  struct media_pad_desc {
>  	__u32 entity;		/* entity ID */
-- 
Regards,

Laurent Pinchart

