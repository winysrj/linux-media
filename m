Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53677 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751117Ab3KFRCC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 12:02:02 -0500
Date: Wed, 6 Nov 2013 19:01:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	"open list:MT9M032 APTINA SE..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4] videodev2: Set vb2_rect's width and height as unsigned
Message-ID: <20131106170157.GI24988@valkosipuli.retiisi.org.uk>
References: <1383756278-29642-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383756278-29642-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thanks for the update. (Dropping LKML again.)

On Wed, Nov 06, 2013 at 05:44:38PM +0100, Ricardo Ribalda Delgado wrote:
> As addressed on the media summit 2013, there is no reason for the width

s/addressed/discussed/ ?

> and height to be signed.
> 
> Therefore this patch is an attempt to convert those fields into unsigned.

s/into unsigned/from __s32 to __u32/ ?

> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> v3: Comments by Sakari
> -Update also doc
> 
> v2: Comments by Sakari Ailus and Laurent Pinchart
> 
> -Fix alignment on all drivers
> -Replace min with min_t where possible and remove unneeded checks
> 
>  Documentation/DocBook/media/v4l/compat.xml         | 12 ++++++++
>  Documentation/DocBook/media/v4l/dev-overlay.xml    |  8 ++---
>  Documentation/DocBook/media/v4l/vidioc-cropcap.xml |  8 ++---
>  drivers/media/i2c/mt9m032.c                        | 16 +++++-----
>  drivers/media/i2c/mt9p031.c                        | 28 ++++++++++--------
>  drivers/media/i2c/mt9t001.c                        | 26 ++++++++++-------
>  drivers/media/i2c/mt9v032.c                        | 34 ++++++++++++----------
>  drivers/media/i2c/smiapp/smiapp-core.c             |  8 ++---
>  drivers/media/i2c/soc_camera/mt9m111.c             |  4 +--
>  drivers/media/i2c/tvp5150.c                        | 14 ++++-----
>  drivers/media/pci/bt8xx/bttv-driver.c              |  6 ++--
>  drivers/media/pci/saa7134/saa7134-video.c          |  4 ---
>  drivers/media/platform/soc_camera/soc_scale_crop.c |  4 +--
>  include/uapi/linux/videodev2.h                     |  4 +--
>  14 files changed, 97 insertions(+), 79 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 0c7195e..5dbe68b 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2523,6 +2523,18 @@ that used it. It was originally scheduled for removal in 2.6.35.
>        </orderedlist>
>      </section>
>  
> +    <section>
> +      <title>V4L2 in Linux 3.12</title>
> +      <orderedlist>
> +        <listitem>
> +		<para> In struct <structname>v4l2_rect</structname>, the type
> +of <structfield>width</structfield> and <structfield>height</structfield>
> +fields changed from _s32 to _u32.

__s32 and __u32.

With these changes, for documentation and smiapp,

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
