Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1306 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaGQVEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 17:04:16 -0400
Message-ID: <53C83A49.7060501@xs4all.nl>
Date: Thu, 17 Jul 2014 23:04:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 03/23] v4l: Support extending the v4l2_pix_format structure
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Something that just caught my eye:

On 06/24/2014 01:54 AM, Laurent Pinchart wrote:
> The v4l2_pix_format structure has no reserved field. It is embedded in
> the v4l2_framebuffer structure which has no reserved fields either, and
> in the v4l2_format structure which has reserved fields that were not
> previously required to be zeroed out by applications.
> 
> To allow extending v4l2_pix_format, inline it in the v4l2_framebuffer
> structure, and use the priv field as a magic value to indicate that the
> application has set all v4l2_pix_format extended fields and zeroed all
> reserved fields following the v4l2_pix_format field in the v4l2_format
> structure.
> 
> The availability of this API extension is reported to userspace through
> the new V4L2_CAP_EXT_PIX_FORMAT capability flag. Just checking that the
> priv field is still set to the magic value at [GS]_FMT return wouldn't
> be enough, as older kernels don't zero the priv field on return.
> 
> To simplify the internal API towards drivers zero the extended fields
> and set the priv field to the magic value for applications not aware of
> the extensions.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 91dcbc8..8c56cacd 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -112,9 +112,28 @@ see <xref linkend="colorspaces" />.</entry>
>  	<row>
>  	  <entry>__u32</entry>
>  	  <entry><structfield>priv</structfield></entry>
> -	  <entry>Reserved for custom (driver defined) additional
> -information about formats. When not used drivers and applications must
> -set this field to zero.</entry>
> +	  <entry><para>This field indicates whether the remaining fields of the
> +<structname>v4l2_pix_format</structname> structure, also called the extended
> +fields, are valid. When set to <constant>V4L2_PIX_FMT_PRIV_MAGIC</constant>, it
> +indicates that the extended fields have been correctly initialized. When set to
> +any other value it indicates that the extended fields contain undefined values.
> +</para>
> +<para>Applications that wish to use the pixel format extended fields must first
> +ensure that the feature is supported by querying the device for the
> +<link linkend="querycap"><constant>V4L2_CAP_EXT_PIX_FORMAT</constant></link>
> +capability. If the capability isn't set the pixel format extended fields are not
> +supported and using the extended fields will lead to undefined results.</para>
> +<para>To use the extended fields, applications must set the
> +<structfield>priv</structfield> field to
> +<constant>V4L2_PIX_FMT_PRIV_MAGIC</constant>, initialize all the extended fields
> +and zero the unused bytes of the <structname>v4l2_format</structname>
> +<structfield>raw_data</structfield> field.</para>

Easy to write, much harder to implement. You would end up with something like:

memset(&fmt.fmt.pix.flags + sizeof(fmt.fmt.pix.flags), 0,
	sizeof(fmt.fmt.raw_data) - sizeof(fmt.fmt.pix));

Not user-friendly and error-prone.

I would suggest adding a reserved array to pix_format instead, of at least
size (10 + 2 * 7) / 4 = 6 __u32. So: __u32 reserved[6]. Better would be to go
with 10 + 17 = 27 elements (same as the number of reserved elements in
v4l2_pix_format_mplane and one struct v4l2_plane_pix_format).

That will allow you to just say that the app should zero the reserved array.

> +<para>When the <structfield>priv</structfield> field isn't set to
> +<constant>V4L2_PIX_FMT_PRIV_MAGIC</constant> drivers must act as if all the
> +extended fields were set to zero. On return drivers must set the
> +<structfield>priv</structfield> field to
> +<constant>V4L2_PIX_FMT_PRIV_MAGIC</constant> and all the extended field to
> +applicable values.</para></entry>
>  	</row>
>        </tbody>
>      </tgroup>

Regards,

	Hans

