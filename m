Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2141 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3HBJoL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 05:44:11 -0400
Message-ID: <51FB7F58.2070101@xs4all.nl>
Date: Fri, 02 Aug 2013 11:43:52 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v5 2/9] Documentation: media: Clarify the VIDIOC_CREATE_BUFS
 format requirements
References: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375405408-17134-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375405408-17134-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/02/2013 03:03 AM, Laurent Pinchart wrote:
> The VIDIOC_CREATE_BUFS ioctl takes a format argument that must contain a
> valid format supported by the driver. Clarify the documentation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/vidioc-create-bufs.xml | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> index cd99436..407937a 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> @@ -69,10 +69,11 @@ the <structname>v4l2_create_buffers</structname> structure. They set the
>  structure, to the respective stream or buffer type.
>  <structfield>count</structfield> must be set to the number of required buffers.
>  <structfield>memory</structfield> specifies the required I/O method. The
> -<structfield>format</structfield> field shall typically be filled in using
> -either the <constant>VIDIOC_TRY_FMT</constant> or
> -<constant>VIDIOC_G_FMT</constant> ioctl(). Additionally, applications can adjust
> -<structfield>sizeimage</structfield> fields to fit their specific needs. The
> +<structfield>format</structfield> field must be a valid format supported by the
> +driver. Applications shall typically fill it using either the
> +<constant>VIDIOC_TRY_FMT</constant> or <constant>VIDIOC_G_FMT</constant>
> +ioctl(). Any format that would be modified by the
> +<constant>VIDIOC_TRY_FMT</constant> ioctl() will be rejected with an error. The

I'm a bit unhappy with this formulation. How about: "The format must be a valid format,
otherwise an error will be returned."

The main reason for this is that changes made to the 'field' and 'colorspace' format
fields by TRY_FMT do not affect CREATE_BUFS. Does a wrong colorspace mean that
CREATE_BUFS should return an error? I'm not sure we want to do that, frankly.

You also removed the bit about the sizeimage field. That should be kept, although admittedly
it needs some improvement. The reason for that is that applications cannot set sizeimage
when calling S_FMT: that field is set by the driver. Only through CREATE_BUFS can apps
select a different (larger) sizeimage.

I think it would be useful if there was a link to CREATE_BUFS was added to the 'sizeimage'
description of struct v4l2_pix_format in DocBook. It is not exactly obvious that CREATE_BUFS
can be used for that purpose. It's really a workaround for a limitation in the spec, of
course.

Regards,

	Hans

>  <structfield>reserved</structfield> array must be zeroed.</para>
>  
>      <para>When the ioctl is called with a pointer to this structure the driver
> @@ -144,9 +145,9 @@ mapped</link> I/O.</para>
>        <varlistentry>
>  	<term><errorcode>EINVAL</errorcode></term>
>  	<listitem>
> -	  <para>The buffer type (<structfield>type</structfield> field) or the
> -requested I/O method (<structfield>memory</structfield>) is not
> -supported.</para>
> +	  <para>The buffer type (<structfield>type</structfield> field),
> +requested I/O method (<structfield>memory</structfield>) or format
> +(<structfield>format</structfield> field) is not valid.</para>
>  	</listitem>
>        </varlistentry>
>      </variablelist>
> 
