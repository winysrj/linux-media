Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2063 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3DVHBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 03:01:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv3 03/10] [media] V4L2 api: Add a buffer capture type for SDR
Date: Mon, 22 Apr 2013 09:00:44 +0200
References: <1366570839-662-1-git-send-email-mchehab@redhat.com> <1366570839-662-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-4-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304220900.44145.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun April 21 2013 21:00:32 Mauro Carvalho Chehab wrote:
> As SDR devices are not video, VBI or RDS devices, it needs
> its own buffer type for capture.
> 
> Also, as discussed at:
> 	http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/63123
> 
> It should be a way to enumerate and select the formats that the
> hardware supports, as one hardware may accept more than one format
> (cx88, for example, can likely support several different formats,
> as it will depend on how the RISC code for it will be written).
> 
> So, add a a new stream type (V4L2_BUF_TYPE_SDR_CAPTURE) at the
> V4L2 API, and the corresponding buffer function handlers.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  Documentation/DocBook/media/v4l/dev-capture.xml | 26 ++++++++++++--------
>  Documentation/DocBook/media/v4l/io.xml          |  6 +++++
>  drivers/media/v4l2-core/v4l2-ioctl.c            | 32 +++++++++++++++++++++++++
>  include/media/v4l2-ioctl.h                      |  8 +++++++
>  include/uapi/linux/videodev2.h                  |  3 ++-
>  5 files changed, 64 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/dev-capture.xml b/Documentation/DocBook/media/v4l/dev-capture.xml
> index e1c5f94..7797d2d 100644
> --- a/Documentation/DocBook/media/v4l/dev-capture.xml
> +++ b/Documentation/DocBook/media/v4l/dev-capture.xml
> @@ -44,7 +44,7 @@ all video capture devices.</para>
>    </section>
>  
>    <section>
> -    <title>Image Format Negotiation</title>
> +    <title>Streaming Format Negotiation</title>
>  
>      <para>The result of a capture operation is determined by
>  cropping and image format parameters. The former select an area of the
> @@ -65,13 +65,18 @@ linkend="crop" />.</para>
>  
>      <para>To query the current image format applications set the
>  <structfield>type</structfield> field of a &v4l2-format; to
> -<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant> or
> -<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant> and call the
> -&VIDIOC-G-FMT; ioctl with a pointer to this structure. Drivers fill
> -the &v4l2-pix-format; <structfield>pix</structfield> or the
> -&v4l2-pix-format-mplane; <structfield>pix_mp</structfield> member of the
> +<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
> +<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant> or
> +<constant>V4L2_BUF_TYPE_VIDEO_SDR_CAPTURE</constant> or

s/V4L2_BUF_TYPE_VIDEO_SDR_CAPTURE/V4L2_BUF_TYPE_SDR_CAPTURE/

> +and call the &VIDIOC-G-FMT; ioctl with a pointer to this structure.</para>
> +

Regards,

	Hans
