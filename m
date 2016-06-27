Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54195 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbcF0M1i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 08:27:38 -0400
Date: Mon, 27 Jun 2016 14:27:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 01/24] v4l: Add metadata buffer type and format
In-Reply-To: <1466449842-29502-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1606271357560.8022@axis700.grange>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1466449842-29502-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Just one question to this patch:

On Mon, 20 Jun 2016, Laurent Pinchart wrote:

> The metadata buffer type is used to transfer metadata between userspace
> and kernelspace through a V4L2 buffers queue. It comes with a new
> metadata capture capability and format description.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/dev-meta.xml  | 93 +++++++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/v4l2.xml      |  1 +
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 19 ++++++
>  drivers/media/v4l2-core/v4l2-dev.c            | 16 +++--
>  drivers/media/v4l2-core/v4l2-ioctl.c          | 34 ++++++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c      |  3 +
>  include/media/v4l2-ioctl.h                    |  8 +++
>  include/uapi/linux/videodev2.h                | 14 ++++
>  8 files changed, 182 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/dev-meta.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/dev-meta.xml b/Documentation/DocBook/media/v4l/dev-meta.xml
> new file mode 100644
> index 000000000000..9b5b1fba2007
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/dev-meta.xml
> @@ -0,0 +1,93 @@
> +  <title>Metadata Interface</title>
> +
> +  <note>
> +    <title>Experimental</title>
> +    <para>This is an <link linkend="experimental"> experimental </link>
> +    interface and may change in the future.</para>
> +  </note>
> +
> +  <para>
> +Metadata refers to any non-image data that supplements video frames with
> +additional information. This may include statistics computed over the image
> +or frame capture parameters supplied by the image source. This interface is
> +intended for transfer of metadata to userspace and control of that operation.
> +  </para>
> +
> +  <para>
> +The metadata interface is implemented on video capture devices. The device can
> +be dedicated to metadata or can implement both video and metadata capture as
> +specified in its reported capabilities.
> +  </para>
> +
> +  <section>
> +    <title>Querying Capabilities</title>
> +
> +    <para>
> +Devices supporting the metadata interface set the
> +<constant>V4L2_CAP_META_CAPTURE</constant> flag in the
> +<structfield>capabilities</structfield> field of &v4l2-capability;
> +returned by the &VIDIOC-QUERYCAP; ioctl. That flag means the device can capture
> +metadata to memory.
> +    </para>
> +    <para>
> +At least one of the read/write or streaming I/O methods must be supported.
> +    </para>
> +  </section>
> +
> +  <section>
> +    <title>Data Format Negotiation</title>
> +
> +    <para>
> +The metadata device uses the <link linkend="format">format</link> ioctls to
> +select the capture format. The metadata buffer content format is bound to that
> +selectable format. In addition to the basic
> +<link linkend="format">format</link> ioctls, the &VIDIOC-ENUM-FMT; ioctl
> +must be supported as well.

Why does ENUM_FMT have to be supported? As far as I understand, you 
haven't implemented it for VSP1, I followed that example and haven't 
implemented it for UVC either.

Thanks
Guennadi
