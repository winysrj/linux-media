Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51587 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3AGTya (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 14:54:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCHv1 1/2] DocBook: improve the error_idx field documentation.
Date: Mon, 07 Jan 2013 20:56:07 +0100
Message-ID: <5589342.kjDUmhmVqU@avalon>
In-Reply-To: <50256813dbb6df25776aed847787d1eac9dbc9fa.1357560529.git.hans.verkuil@cisco.com>
References: <1357560588-5263-1-git-send-email-hverkuil@xs4all.nl> <50256813dbb6df25776aed847787d1eac9dbc9fa.1357560529.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Monday 07 January 2013 13:09:47 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The documentation of the error_idx field was incomplete and confusing.
> This patch improves it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   51 ++++++++++++++---
>  1 file changed, 44 insertions(+), 7 deletions(-)

(Text reflowed for easier review)

> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml index
> 0a4b90f..c07c657 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> @@ -199,13 +199,50 @@ also be zero.</entry>
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>error_idx</structfield></entry>
> -	    <entry>Set by the driver in case of an error. If it is equal
> -to <structfield>count</structfield>, then no actual changes were made to
> -controls. In other words, the error was not associated with setting a
> -particular control. If it is another value, then only the controls up to
> -<structfield>error_idx-1</structfield> were modified and control
> -<structfield>error_idx</structfield> is the one that caused the error. The
> -<structfield>error_idx</structfield> value is undefined if the ioctl
> -returned 0 (success).</entry>
> +	    <entry><para>Set by the driver in case of an error. If the error is
> +associated with a particular control, then
> +<structfield>error_idx</structfield> is set to the index of that control.
> +If the error is not related to a specific control, then
> +<structfield>error_idx</structfield> is set to
> +<structfield>count</structfield>.</para>
> +<para>The behavior is different for <constant>VIDIOC_G_EXT_CTRLS</constant>
> +and <constant>VIDIOC_S_EXT_CTRLS</constant>: if
> +<structfield>error_idx</structfield> is equal to
> +<structfield>count</structfield>, then no actual changes were made to the
> +controls. For example, if you try to write to a read-only control, then
> +<constant>VIDIOC_TRY_EXT_CTRLS</constant> will set
> +<structfield>error_idx</structfield> to the index of that read-only
> +control, but <constant>VIDIOC_S_EXT_CTRLS</constant> will set
> +<structfield>error_idx</structfield> to <structfield>count</structfield>
> +instead and none of the controls in the list will be set.</para>

I find this a bit confusing (although I understand what you mean, as I'm 
familiar with the API). You start by mentioning [GS]_EXT_CTRLS only, and then 
you introduce TRY_EXT_CTRLS in the example. I think it would be clearer if you 
restructed the explanation as follows:

- explain the error_idx principle globally, withotu examples
- explain that [GS]_EXT_CTRLS will perform pre-validation and will thus set 
error_idx to count in specific cases (they should be listed)
- explain that TRY_EXT_CTRLS doesn't perform pre-validation and will thus set 
error_idx to the index of the erroneous control in all cases, including the 
specific cases listed for [GS]_EXT_CTRLS

> +<para>The same is true when trying to e.g. read a write-only control:
> +<constant>VIDIOC_G_EXT_CTRLS</constant> will set
> +<structfield>error_idx</structfield> to <structfield>count</structfield>
> +and none of the controls in the list will have been retrieved.</para>
> +
> +<para>The reason for this behavior is that it is important when setting and
> +getting controls to do this as atomically as possible, so simple sanity
> +checks like testing for read-only controls are done first before an
> +attempt is made to apply/retrieve the new control values to/from the
> +hardware. It is important for an application to know whether
> +<constant>VIDIOC_S_EXT_CTRLS</constant> or
> +<constant>VIDIOC_G_EXT_CTRLS</constant> actually made changes to controls
> +or not. So if <structfield>error_idx</structfield> is equal to
> +<structfield>count</structfield>, then you know that no actual controls
> +were set or retrieved. In the case of
> +<constant>VIDIOC_S_EXT_CTRLS</constant> you can call
> +<constant>VIDIOC_TRY_EXT_CTRLS</constant> with the same control list to
> +see if the problem was with a specific control or not
> +(<constant>VIDIOC_TRY_EXT_CTRLS</constant> never modifies controls, so
> +that ioctl will just set <structfield>error_idx</structfield> to the
> +control that caused the problem). No such option exists for
> +<constant>VIDIOC_G_EXT_CTRLS</constant> though, unfortunately.</para>

It's very unfortunate indeed :-) Given that the hardware state must not be 
changed by a read operation, are you sure G_EXT_CTRLS couldn't retrieve 
controls up to the erroneous one ? ;-)

I think some flexibility should still probably be left to drivers (and I'm not 
talking about UVC here), as some drivers might not be able to know that a 
control is write-only before trying to read it and getting an error.

> +<para>If <structfield>error_idx</structfield> as returned by
> +<constant>VIDIOC_S_EXT_CTRLS</constant> or
> +<constant>VIDIOC_G_EXT_CTRLS</constant> is less than
> +<structfield>count</structfield>, then only the controls up to
> +<structfield>error_idx-1</structfield> were modified and control
> +<structfield>error_idx</structfield> is the one that caused the error. In
> +the case of <constant>VIDIOC_S_EXT_CTRLS</constant> this might have left
> +the hardware in an inconsistent state. These types of errors should not
> +normally happen, and such errors are typically caused by problems in
> +communicating with the hardware.</para>
> +
> +<para>Finally, note that the <structfield>error_idx</structfield> value is
> +undefined if the ioctl returned 0 (success).</para></entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
-- 
Regards,

Laurent Pinchart

