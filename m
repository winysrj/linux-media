Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:38021 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbbHULcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 07:32:12 -0400
Message-ID: <55D70C10.2050602@xs4all.nl>
Date: Fri, 21 Aug 2015 13:31:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] Docbook: media: Document changes on struct v4l2_ext_controls
References: <1440149386-19783-1-git-send-email-ricardo.ribalda@gmail.com> <1440149386-19783-9-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1440149386-19783-9-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2015 11:29 AM, Ricardo Ribalda Delgado wrote:
> Vidioc-g-ext-ctrls can now be used to get the default value of the
> controls.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  Documentation/DocBook/media/v4l/v4l2.xml               |  9 +++++++++
>  Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml | 14 ++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index e98caa1c39bd..be52bd2fb335 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -153,6 +153,15 @@ structs, ioctls) must be noted in more detail in the history chapter
>  applications. -->
>  
>        <revision>
> +	<revnumber>4.4</revnumber>
> +	<date>2015-08-20</date>
> +	<authorinitials>rr</authorinitials>
> +	<revremark>Extend vidioc-g-ext-ctrls;. Replace ctrl_class with a new
> +union with ctrl_class and which. Which is used to select the current value of
> +the control or the default value.
> +	</revremark>
> +      </revision>
> +      <revision>
>  	<revnumber>3.21</revnumber>
>  	<date>2015-02-13</date>
>  	<authorinitials>mcc</authorinitials>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> index c5bdbfcc42b3..224fa2bd1481 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> @@ -216,7 +216,12 @@ Valid if <constant>V4L2_CTRL_FLAG_HAS_PAYLOAD</constant> is set for this control
>        <tgroup cols="3">
>  	&cs-str;
>  	<tbody valign="top">
> +	 <row>
> +	    <entry>union</entry>
> +	    <entry>(anonymous)</entry>
> +	  </row>
>  	  <row>
> +	    <entry></entry>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>ctrl_class</structfield></entry>
>  	    <entry>The control class to which all controls belong, see
> @@ -228,6 +233,15 @@ with a <structfield>count</structfield> of 0. If that succeeds, then the driver
>  supports this feature.</entry>

All I would say here is that ctrl_class is an alias for 'which', kept for backwards compatibility.
Applications should use 'which' instead.


>  	  </row>
>  	  <row>
> +	    <entry></entry>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>which</structfield></entry>
> +	    <entry> Which control are get/set/tried. <constant>V4L2_CTRL_WHICH_CUR_VAL</constant>

I'd say: "Which value of the control to get/set/try."

> +will return the current value of the control and <constant>V4L2_CTRL_WHICH_DEF_VAL</constant> will
> +return the default value of the control. Please note that the default value of the control cannot
> +be set or tried, only get.</entry>

I'd rephrase that:

"Please note that you can only get the default value of the control, you cannot
set or try it."

Add this:

"For backwards compatibility you can also use a control class here (see
<xref linkend="ctrl-class" />. In that case all controls have to belong to that
control class. This usage is deprecated, instead just use <constant>V4L2_CTRL_WHICH_CUR_VAL</constant>.
There are some very old drivers that do not yet support <constant>V4L2_CTRL_WHICH_CUR_VAL</constant>
and that require a control class here. You can test for such drivers by setting ctrl_class to
<constant>V4L2_CTRL_WHICH_CUR_VAL</constant> and calling VIDIOC_TRY_EXT_CTRLS with a count of 0.
If that fails, then the driver does not support <constant>V4L2_CTRL_WHICH_CUR_VAL</constant>."

I think the only driver that still doesn't support this is saa7164. I really need
to convert it to the control framework.

Regards,

	Hans

> +	  </row>
> +	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>count</structfield></entry>
>  	    <entry>The number of controls in the controls array. May
> 

