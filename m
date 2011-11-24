Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab1KXXSC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 18:18:02 -0500
Received: by bke11 with SMTP id 11so3569985bke.19
        for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 15:18:01 -0800 (PST)
Message-ID: <4ECED0A6.40607@gmail.com>
Date: Fri, 25 Nov 2011 00:17:58 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: [RFC/PATCH 2/3] v4l: Document integer menu controls
References: <20111124161228.GA29342@valkosipuli.localdomain> <1322151172-5362-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1322151172-5362-2-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2011 05:12 PM, Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
> ---
>   Documentation/DocBook/media/v4l/compat.xml         |   10 +++++
>   Documentation/DocBook/media/v4l/v4l2.xml           |    7 ++++
>   .../DocBook/media/v4l/vidioc-queryctrl.xml         |   39 +++++++++++++++++++-
>   3 files changed, 54 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index b68698f..569efd1 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2379,6 +2379,16 @@ that used it. It was originally scheduled for removal in 2.6.35.
>         </orderedlist>
>       </section>
> 
> +<section>
> +<title>V4L2 in Linux 3.3</title>
> +<orderedlist>
> +<listitem>
> +	<para>Added integer menus, the new type will be
> +	  V4L2_CTRL_TYPE_INTEGER_MENU.</para>
> +</listitem>
> +</orderedlist>
> +</section>
> +
>       <section id="other">
>         <title>Relation of V4L2 to other Linux multimedia APIs</title>
> 
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 2ab365c..affe1ba 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -128,6 +128,13 @@ structs, ioctls) must be noted in more detail in the history chapter
>   applications. -->
> 
>         <revision>
> +	<revnumber>3.3</revnumber>
> +	<date>2011-11-24</date>
> +	<authorinitials>sa</authorinitials>
> +	<revremark>Added V4L2_CTRL_TYPE_INTEGER_MENU.</revremark>
> +</revision>
> +
> +<revision>
>   	<revnumber>3.2</revnumber>
>   	<date>2011-08-26</date>
>   	<authorinitials>hv</authorinitials>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> index 0ac0057..049cd46 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> @@ -215,11 +215,12 @@ the array to zero.</entry>
> 
>       <table pgwide="1" frame="none" id="v4l2-querymenu">
>         <title>struct<structname>v4l2_querymenu</structname></title>
> -<tgroup cols="3">
> +<tgroup cols="4">
>   	&cs-str;
>   	<tbody valign="top">
>   	<row>
>   	<entry>__u32</entry>
> +	<entry></entry>
>   	<entry><structfield>id</structfield></entry>
>   	<entry>Identifies the control, set by the application
>   from the respective&v4l2-queryctrl;
> @@ -227,18 +228,38 @@ from the respective&v4l2-queryctrl;
>   	</row>
>   	<row>
>   	<entry>__u32</entry>
> +	<entry></entry>
>   	<entry><structfield>index</structfield></entry>
>   	<entry>Index of the menu item, starting at zero, set by
>   	    the application.</entry>
>   	</row>
>   	<row>
> +	<entry>union</entry>
> +	<entry></entry>
> +	<entry></entry>
> +	<entry></entry>
> +	</row>
> +	<row>
> +	<entry></entry>
>   	<entry>__u8</entry>
>   	<entry><structfield>name</structfield>[32]</entry>
>   	<entry>Name of the menu item, a NUL-terminated ASCII
> -string. This information is intended for the user.</entry>
> +string. This information is intended for the user. This field is valid
> +for<constant>V4L2_CTRL_FLAG_MENU</constant>  type controls.</entry>
> +	</row>
> +	<row>
> +	<entry></entry>
> +	<entry>__s64</entry>
> +	<entry><structfield>value</structfield></entry>
> +	<entry>
> +              Value of the integer menu item. This field is valid for
> +<constant>V4L2_CTRL_FLAG_INTEGER_MENU</constant>  type
> +              controls.
> +</entry>
>   	</row>
>   	<row>
>   	<entry>__u32</entry>
> +	<entry></entry>
>   	<entry><structfield>reserved</structfield></entry>
>   	<entry>Reserved for future extensions. Drivers must set
>   the array to zero.</entry>
> @@ -292,6 +313,20 @@ the menu items can be enumerated with the
>   <constant>VIDIOC_QUERYMENU</constant>  ioctl.</entry>
>   	</row>
>   	<row>
> +	<entry><constant>V4L2_CTRL_TYPE_INTEGER_MENU</constant></entry>
> +	<entry>&ge; 0</entry>
> +	<entry>1</entry>
> +	<entry>N-1</entry>
> +	<entry>
> +              The control has a menu of N choices. The names of the
> +              menu items can be enumerated with the

Shouldn't it be something along the lines of "The integer values of
the menu items can be enumerated..." ?

> +<constant>VIDIOC_QUERYMENU</constant>  ioctl. This is
> +              similar to<constant>V4L2_CTRL_TYPE_MENU</constant>
> +              except that instead of integers, the menu items are
> +              signed 64-bit integers.
> +</entry>
> +	</row>
> +	<row>
>   	<entry><constant>V4L2_CTRL_TYPE_BITMASK</constant></entry>
>   	<entry>0</entry>
>   	<entry>n/a</entry>


-- 
Regards,
Sylwester
