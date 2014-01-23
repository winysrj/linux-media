Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52500 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAWNqd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 08:46:33 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZU001Q6WXGIW10@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Jan 2014 13:46:28 +0000 (GMT)
Message-id: <52E11D34.4050300@samsung.com>
Date: Thu, 23 Jan 2014 14:46:28 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 19/21] DocBook media: update VIDIOC_G/S/TRY_EXT_CTRLS.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
 <1390221974-28194-20-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1390221974-28194-20-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/01/14 13:46, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 43 ++++++++++++++++++----
>  1 file changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> index b3bb957..bb383b9 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> @@ -72,23 +72,30 @@ initialize the <structfield>id</structfield>,
>  <structfield>size</structfield> and <structfield>reserved2</structfield> fields
>  of each &v4l2-ext-control; and call the
>  <constant>VIDIOC_G_EXT_CTRLS</constant> ioctl. String controls controls
> -must also set the <structfield>string</structfield> field.</para>
> +must also set the <structfield>string</structfield> field. Controls
> +of complex types (<constant>V4L2_CTRL_FLAG_IS_PTR</constant> is set)
> +must set the <structfield>p</structfield> field.</para>
>  
>      <para>If the <structfield>size</structfield> is too small to
>  receive the control result (only relevant for pointer-type controls
>  like strings), then the driver will set <structfield>size</structfield>
>  to a valid value and return an &ENOSPC;. You should re-allocate the
> -string memory to this new size and try again. It is possible that the
> -same issue occurs again if the string has grown in the meantime. It is
> +memory to this new size and try again. For the string type it is possible that
> +the same issue occurs again if the string has grown in the meantime. It is
>  recommended to call &VIDIOC-QUERYCTRL; first and use
>  <structfield>maximum</structfield>+1 as the new <structfield>size</structfield>
>  value. It is guaranteed that that is sufficient memory.
>  </para>
>  
> +    <para>For matrices it is possible to only get the first <constant>X</constant>
> +elements by setting size to <constant>X * elem_size</constant>, where
> +<structfield>elem_size</structfield> is obtained by calling &VIDIOC-QUERY-EXT-CTRL;.
> +Matrix elements are returned row-by-row.</para>
> +
>      <para>To change the value of a set of controls applications
>  initialize the <structfield>id</structfield>, <structfield>size</structfield>,
>  <structfield>reserved2</structfield> and
> -<structfield>value/string</structfield> fields of each &v4l2-ext-control; and
> +<structfield>value/value64/string/p</structfield> fields of each &v4l2-ext-control; and
>  call the <constant>VIDIOC_S_EXT_CTRLS</constant> ioctl. The controls
>  will only be set if <emphasis>all</emphasis> control values are
>  valid.</para>
> @@ -96,11 +103,17 @@ valid.</para>
>      <para>To check if a set of controls have correct values applications
>  initialize the <structfield>id</structfield>, <structfield>size</structfield>,
>  <structfield>reserved2</structfield> and
> -<structfield>value/string</structfield> fields of each &v4l2-ext-control; and
> +<structfield>value/value64/string/p</structfield> fields of each &v4l2-ext-control; and
>  call the <constant>VIDIOC_TRY_EXT_CTRLS</constant> ioctl. It is up to
>  the driver whether wrong values are automatically adjusted to a valid
>  value or if an error is returned.</para>
>  
> +    <para>For matrices it is possible to only set or check only the first
> +<constant>X</constant> elements by setting size to <constant>X * elem_size</constant>,
> +where <structfield>elem_size</structfield> is obtained by calling &VIDIOC-QUERY-EXT-CTRL;.
> +Matrix elements are set row-by-row. Matrix elements that are not explicitly
> +set will be initialized to their default value.</para>

Presumably this could be more problematic than leaving the remaining part
of the matrix unchanged. I assume this paragraph is going to be removed ?

>      <para>When the <structfield>id</structfield> or
>  <structfield>ctrl_class</structfield> is invalid drivers return an
>  &EINVAL;. When the value is out of bounds drivers can choose to take
> @@ -158,19 +171,33 @@ applications must set the array to zero.</entry>
>  	    <entry></entry>
>  	    <entry>__s32</entry>
>  	    <entry><structfield>value</structfield></entry>
> -	    <entry>New value or current value.</entry>
> +	    <entry>New value or current value. Valid if this control is not of
> +type <constant>V4L2_CTRL_TYPE_INTEGER64</constant> and
> +<constant>V4L2_CTRL_FLAG_IS_PTR</constant> is not set.</entry>
>  	  </row>
>  	  <row>
>  	    <entry></entry>
>  	    <entry>__s64</entry>
>  	    <entry><structfield>value64</structfield></entry>
> -	    <entry>New value or current value.</entry>
> +	    <entry>New value or current value. Valid if this control is of
> +type <constant>V4L2_CTRL_TYPE_INTEGER64</constant> and
> +<constant>V4L2_CTRL_FLAG_IS_PTR</constant> is not set.</entry>
>  	  </row>
>  	  <row>
>  	    <entry></entry>
>  	    <entry>char *</entry>
>  	    <entry><structfield>string</structfield></entry>
> -	    <entry>A pointer to a string.</entry>
> +	    <entry>A pointer to a string. Valid if this control is of
> +type <constant>V4L2_CTRL_TYPE_STRING</constant>.</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry>void *</entry>
> +	    <entry><structfield>p</structfield></entry>
> +	    <entry>A pointer to a complex type which can be a matrix and/or a
> +complex type (the control's type is >= <constant>V4L2_CTRL_COMPLEX_TYPES</constant>).
> +Valid if <constant>V4L2_CTRL_FLAG_IS_PTR</constant> is set for this control.
> +</entry>
>  	  </row>
>  	</tbody>
>        </tgroup>

--
Regards,
Sylwester
