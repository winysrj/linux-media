Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4848 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaCKPeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 11:34:18 -0400
Message-ID: <531F2CCB.4050804@xs4all.nl>
Date: Tue, 11 Mar 2014 16:33:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 26/48] v4l: Add support for DV timings ioctls on subdev
 nodes
References: <1394493359-14115-27-git-send-email-laurent.pinchart@ideasonboard.com> <1394550568-25152-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394550568-25152-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2014 04:09 PM, Laurent Pinchart wrote:
> Validate the pad field in the core code whenever specified.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    | 27 +++++++++++++++----
>  .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   | 30 +++++++++++++++++-----
>  drivers/media/v4l2-core/v4l2-subdev.c              | 27 +++++++++++++++++++
>  include/uapi/linux/v4l2-subdev.h                   |  5 ++++
>  4 files changed, 77 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
> index cd7720d..28a8c1e 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
> @@ -1,11 +1,12 @@
>  <refentry id="vidioc-dv-timings-cap">
>    <refmeta>
> -    <refentrytitle>ioctl VIDIOC_DV_TIMINGS_CAP</refentrytitle>
> +    <refentrytitle>ioctl VIDIOC_DV_TIMINGS_CAP, VIDIOC_SUBDEV_DV_TIMINGS_CAP</refentrytitle>
>      &manvol;
>    </refmeta>
>  
>    <refnamediv>
>      <refname>VIDIOC_DV_TIMINGS_CAP</refname>
> +    <refname>VIDIOC_SUBDEV_DV_TIMINGS_CAP</refname>
>      <refpurpose>The capabilities of the Digital Video receiver/transmitter</refpurpose>
>    </refnamediv>
>  
> @@ -33,7 +34,7 @@
>        <varlistentry>
>  	<term><parameter>request</parameter></term>
>  	<listitem>
> -	  <para>VIDIOC_DV_TIMINGS_CAP</para>
> +	  <para>VIDIOC_DV_TIMINGS_CAP, VIDIOC_SUBDEV_DV_TIMINGS_CAP</para>
>  	</listitem>
>        </varlistentry>
>        <varlistentry>
> @@ -54,10 +55,19 @@
>        interface and may change in the future.</para>
>      </note>
>  
> -    <para>To query the capabilities of the DV receiver/transmitter applications can call
> -this ioctl and the driver will fill in the structure. Note that drivers may return
> +    <para>To query the capabilities of the DV receiver/transmitter applications
> +can call the <constant>VIDIOC_DV_TIMINGS_CAP</constant> ioctl on a video node
> +and the driver will fill in the structure. Note that drivers may return
>  different values after switching the video input or output.</para>
>  
> +    <para>When implemented by the driver DV capabilities of subdevices can be
> +queried by calling the <constant>VIDIOC_SUBDEV_DV_TIMINGS_CAP</constant> ioctl
> +directly on a subdevice node. The capabilities are specific to inputs (for DV
> +receivers) or outputs (for DV transmitters), applications must specify the
> +desired pad number in the &v4l2-dv-timings-cap; <structfield>pad</structfield>
> +field. Attempts to query capabilities on a pad that doesn't support them will
> +return an &EINVAL;.</para>
> +
>      <table pgwide="1" frame="none" id="v4l2-bt-timings-cap">
>        <title>struct <structname>v4l2_bt_timings_cap</structname></title>
>        <tgroup cols="3">
> @@ -127,7 +137,14 @@ different values after switching the video input or output.</para>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>reserved</structfield>[3]</entry>
> +	    <entry><structfield>pad</structfield></entry>
> +	    <entry>Pad number as reported by the media controller API. This field
> +	    is only used when operating on a subdevice node. When operating on a
> +	    video node applications must set this field to zero.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[2]</entry>
>  	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
>  	  </row>
>  	  <row>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
> index b3e17c1..b9fdfea 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
> @@ -1,11 +1,12 @@
>  <refentry id="vidioc-enum-dv-timings">
>    <refmeta>
> -    <refentrytitle>ioctl VIDIOC_ENUM_DV_TIMINGS</refentrytitle>
> +    <refentrytitle>ioctl VIDIOC_ENUM_DV_TIMINGS, VIDIOC_SUBDEV_ENUM_DV_TIMINGS</refentrytitle>
>      &manvol;
>    </refmeta>
>  
>    <refnamediv>
>      <refname>VIDIOC_ENUM_DV_TIMINGS</refname>
> +    <refname>VIDIOC_SUBDEV_ENUM_DV_TIMINGS</refname>
>      <refpurpose>Enumerate supported Digital Video timings</refpurpose>
>    </refnamediv>
>  
> @@ -33,7 +34,7 @@
>        <varlistentry>
>  	<term><parameter>request</parameter></term>
>  	<listitem>
> -	  <para>VIDIOC_ENUM_DV_TIMINGS</para>
> +	  <para>VIDIOC_ENUM_DV_TIMINGS, VIDIOC_SUBDEV_ENUM_DV_TIMINGS</para>
>  	</listitem>
>        </varlistentry>
>        <varlistentry>
> @@ -61,14 +62,21 @@ standards or even custom timings that are not in this list.</para>
>  
>      <para>To query the available timings, applications initialize the
>  <structfield>index</structfield> field and zero the reserved array of &v4l2-enum-dv-timings;
> -and call the <constant>VIDIOC_ENUM_DV_TIMINGS</constant> ioctl with a pointer to this
> -structure. Drivers fill the rest of the structure or return an
> +and call the <constant>VIDIOC_ENUM_DV_TIMINGS</constant> ioctl on a video node with a
> +pointer to this structure. Drivers fill the rest of the structure or return an
>  &EINVAL; when the index is out of bounds. To enumerate all supported DV timings,
>  applications shall begin at index zero, incrementing by one until the
>  driver returns <errorcode>EINVAL</errorcode>. Note that drivers may enumerate a
>  different set of DV timings after switching the video input or
>  output.</para>
>  
> +    <para>When implemented by the driver DV timings of subdevices can be queried
> +by calling the <constant>VIDIOC_SUBDEV_ENUM_DV_TIMINGS</constant> ioctl directly
> +on a subdevice node. The DV timings are specific to inputs (for DV receivers) or
> +outputs (for DV transmitters), applications must specify the desired pad number
> +in the &v4l2-enum-dv-timings; <structfield>pad</structfield> field. Attempts to
> +enumerate timings on a pad that doesn't support them will return an &EINVAL;.</para>
> +
>      <table pgwide="1" frame="none" id="v4l2-enum-dv-timings">
>        <title>struct <structname>v4l2_enum_dv_timings</structname></title>
>        <tgroup cols="3">
> @@ -82,8 +90,16 @@ application.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>reserved</structfield>[3]</entry>
> -	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
> +	    <entry><structfield>pad</structfield></entry>
> +	    <entry>Pad number as reported by the media controller API. This field
> +	    is only used when operating on a subdevice node. When operating on a
> +	    video node applications must set this field to zero.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[2]</entry>
> +	    <entry>Reserved for future extensions. Drivers and applications must
> +	    set the array to zero.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>&v4l2-dv-timings;</entry>
> @@ -103,7 +119,7 @@ application.</entry>
>  	<term><errorcode>EINVAL</errorcode></term>
>  	<listitem>
>  	  <para>The &v4l2-enum-dv-timings; <structfield>index</structfield>
> -is out of bounds.</para>
> +is out of bounds or the <structfield>pad</structfield> number is invalid.</para>
>  	</listitem>
>        </varlistentry>
>        <varlistentry>
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 60d2550..853fb84 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -354,6 +354,33 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  
>  	case VIDIOC_SUBDEV_S_EDID:
>  		return v4l2_subdev_call(sd, pad, set_edid, arg);
> +
> +	case VIDIOC_SUBDEV_DV_TIMINGS_CAP: {
> +		struct v4l2_dv_timings_cap *cap = arg;
> +
> +		if (cap->pad >= sd->entity.num_pads)
> +			return -EINVAL;
> +
> +		return v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
> +	}
> +
> +	case VIDIOC_SUBDEV_ENUM_DV_TIMINGS: {
> +		struct v4l2_enum_dv_timings *dvt = arg;
> +
> +		if (dvt->pad >= sd->entity.num_pads)
> +			return -EINVAL;
> +
> +		return v4l2_subdev_call(sd, pad, enum_dv_timings, dvt);
> +	}
> +
> +	case VIDIOC_SUBDEV_QUERY_DV_TIMINGS:
> +		return v4l2_subdev_call(sd, video, query_dv_timings, arg);
> +
> +	case VIDIOC_SUBDEV_G_DV_TIMINGS:
> +		return v4l2_subdev_call(sd, video, g_dv_timings, arg);
> +
> +	case VIDIOC_SUBDEV_S_DV_TIMINGS:
> +		return v4l2_subdev_call(sd, video, s_dv_timings, arg);
>  #endif
>  	default:
>  		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
> index 9fe3493..8dadb16 100644
> --- a/include/uapi/linux/v4l2-subdev.h
> +++ b/include/uapi/linux/v4l2-subdev.h
> @@ -169,5 +169,10 @@ struct v4l2_subdev_edid {
>  #define VIDIOC_SUBDEV_S_SELECTION		_IOWR('V', 62, struct v4l2_subdev_selection)
>  #define VIDIOC_SUBDEV_G_EDID			_IOWR('V', 40, struct v4l2_subdev_edid)
>  #define VIDIOC_SUBDEV_S_EDID			_IOWR('V', 41, struct v4l2_subdev_edid)
> +#define VIDIOC_SUBDEV_S_DV_TIMINGS		_IOWR('V', 87, struct v4l2_dv_timings)
> +#define VIDIOC_SUBDEV_G_DV_TIMINGS		_IOWR('V', 88, struct v4l2_dv_timings)
> +#define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_enum_dv_timings)
> +#define VIDIOC_SUBDEV_QUERY_DV_TIMINGS		_IOR('V', 99, struct v4l2_dv_timings)
> +#define VIDIOC_SUBDEV_DV_TIMINGS_CAP		_IOWR('V', 100, struct v4l2_dv_timings_cap)
>  
>  #endif
> 

