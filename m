Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40941 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1I0Lre (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 07:47:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jonghun.han@samsung.com
Subject: Re: [PATCH] media: DocBook: Fix trivial typo in Sub-device Interface
Date: Tue, 27 Sep 2011 13:47:31 +0200
Cc: linux-media@vger.kernel.org
References: <1317014044-17462-1-git-send-email-jonghun.han@samsung.com>
In-Reply-To: <1317014044-17462-1-git-send-email-jonghun.han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271347.32649.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonghun,

On Monday 26 September 2011 07:14:04 jonghun.han@samsung.com wrote:
> From: Jonghun Han <jonghun.han@samsung.com>
> 
> When satisfied with the try results, applications can set the active
> formats by setting the which argument to V4L2_SUBDEV_FORMAT_ACTIVE
> not V4L2_SUBDEV_FORMAT_TRY.
> 
> Signed-off-by: Jonghun Han <jonghun.han@samsung.com>

Thanks for the patch.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/v4l/dev-subdev.xml |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/dev-subdev.xml
> b/Documentation/DocBook/v4l/dev-subdev.xml index 05c8fef..0916a73 100644
> --- a/Documentation/DocBook/v4l/dev-subdev.xml
> +++ b/Documentation/DocBook/v4l/dev-subdev.xml
> @@ -266,7 +266,7 @@
> 
>        <para>When satisfied with the try results, applications can set the
> active formats by setting the <structfield>which</structfield> argument to
> -      <constant>V4L2_SUBDEV_FORMAT_TRY</constant>. Active formats are
> changed +      <constant>V4L2_SUBDEV_FORMAT_ACTIVE</constant>. Active
> formats are changed exactly as try formats by drivers. To avoid modifying
> the hardware state during format negotiation, applications should
> negotiate try formats first and then modify the active settings using the
> try formats returned during

-- 
Regards,

Laurent Pinchart
