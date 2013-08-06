Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:28142 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab3HFKhE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:37:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH v6 02/10] Documentation: media: Clarify the VIDIOC_CREATE_BUFS format requirements
Date: Tue, 6 Aug 2013 12:36:37 +0200
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
References: <1375725209-2674-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375725209-2674-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375725209-2674-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308061236.37412.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 5 August 2013 19:53:21 Laurent Pinchart wrote:
> The VIDIOC_CREATE_BUFS ioctl takes a format argument that must contain a
> valid format supported by the driver. Clarify the documentation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       | 41 ++++++++++++++--------
>  1 file changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> index cd99436..9b700a5 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> @@ -62,18 +62,29 @@ addition to the <constant>VIDIOC_REQBUFS</constant> ioctl, when a tighter
>  control over buffers is required. This ioctl can be called multiple times to
>  create buffers of different sizes.</para>
>  
> -    <para>To allocate device buffers applications initialize relevant fields of
> -the <structname>v4l2_create_buffers</structname> structure. They set the
> -<structfield>type</structfield> field in the
> -&v4l2-format; structure, embedded in this
> -structure, to the respective stream or buffer type.
> -<structfield>count</structfield> must be set to the number of required buffers.
> -<structfield>memory</structfield> specifies the required I/O method. The
> -<structfield>format</structfield> field shall typically be filled in using
> -either the <constant>VIDIOC_TRY_FMT</constant> or
> -<constant>VIDIOC_G_FMT</constant> ioctl(). Additionally, applications can adjust
> -<structfield>sizeimage</structfield> fields to fit their specific needs. The
> -<structfield>reserved</structfield> array must be zeroed.</para>
> +    <para>To allocate the device buffers applications must initialize the
> +relevant fields of the <structname>v4l2_create_buffers</structname> structure.
> +The <structfield>count</structfield> field must be set to the number of
> +requested buffers, the <structfield>memory</structfield> field specifies the
> +requested I/O method and the <structfield>reserved</structfield> array must be
> +zeroed.</para>
> +
> +    <para>The <structfield>format</structfield> field specifies the image format
> +that the buffers must be able to handle. The application has to fill in this
> +&v4l2-format;. Usually this will be done using the
> +<constant>VIDIOC_TRY_FMT</constant> or <constant>VIDIOC_G_FMT</constant> ioctl()
> +to ensure that the requested format is supported by the driver. Unsupported
> +formats will result in an error.</para>
> +
> +    <para>The buffers created by this ioctl will have as minimum size the size
> +defined by the <structfield>format.pix.sizeimage</structfield> field. If the
> +<structfield>format.pix.sizeimage</structfield> field is less than the minimum
> +required for the given format, then <structfield>sizeimage</structfield> will be
> +increased by the driver to that minimum to allocate the buffers. If it is
> +larger, then the value will be used as-is. The same applies to the
> +<structfield>sizeimage</structfield> field of the
> +<structname>v4l2_plane_pix_format</structname> structure in the case of
> +multiplanar formats.</para>
>  
>      <para>When the ioctl is called with a pointer to this structure the driver
>  will attempt to allocate up to the requested number of buffers and store the
> @@ -144,9 +155,9 @@ mapped</link> I/O.</para>
>        <varlistentry>
>  	<term><errorcode>EINVAL</errorcode></term>
>  	<listitem>
> -	  <para>The buffer type (<structfield>type</structfield> field) or the
> -requested I/O method (<structfield>memory</structfield>) is not
> -supported.</para>
> +	  <para>The buffer type (<structfield>format.type</structfield> field),
> +requested I/O method (<structfield>memory</structfield>) or format
> +(<structfield>format</structfield> field) is not valid.</para>
>  	</listitem>
>        </varlistentry>
>      </variablelist>
> 
