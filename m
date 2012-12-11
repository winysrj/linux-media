Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47786 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753634Ab2LKVeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 16:34:09 -0500
Date: Tue, 11 Dec 2012 23:34:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC 2/2] V4L: Add V4L2_CID_AUTO_FOCUS_AREA control
Message-ID: <20121211213404.GC3747@valkosipuli.retiisi.org.uk>
References: <1355147019-25375-1-git-send-email-a.hajda@samsung.com>
 <1355147019-25375-3-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355147019-25375-3-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej and Sylwester,

Thanks for the patch!

On Mon, Dec 10, 2012 at 02:43:39PM +0100, Andrzej Hajda wrote:
> From: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> Add control for automatic focus area selection.
> This control determines the area of the frame that the camera uses
> for automatic focus.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/compat.xml   |    9 +++--
>  Documentation/DocBook/media/v4l/controls.xml |   47 +++++++++++++++++++++++++-
>  Documentation/DocBook/media/v4l/v4l2.xml     |    7 ++++
>  drivers/media/v4l2-core/v4l2-ctrls.c         |   10 ++++++
>  include/uapi/linux/v4l2-controls.h           |    6 ++++
>  5 files changed, 76 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 4fdf6b5..e8b53da 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2452,8 +2452,9 @@ that used it. It was originally scheduled for removal in 2.6.35.
>  	  <constant>V4L2_CID_3A_LOCK</constant>,
>  	  <constant>V4L2_CID_AUTO_FOCUS_START</constant>,
>  	  <constant>V4L2_CID_AUTO_FOCUS_STOP</constant>,
> -	  <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant> and
> -	  <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant>.
> +	  <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant>,
> +	  <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant> and
> +	  <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>.
>  	  </para>
>          </listitem>
>        </orderedlist>
> @@ -2586,6 +2587,10 @@ ioctls.</para>
>  	  <para>Vendor and device specific media bus pixel formats.
>  	    <xref linkend="v4l2-mbus-vendor-spec-fmts" />.</para>
>          </listitem>
> +        <listitem>
> +	  <para><link linkend="v4l2-auto-focus-area"><constant>
> +	  V4L2_CID_AUTO_FOCUS_AREA</constant></link> control.</para>
> +        </listitem>
>        </itemizedlist>
>      </section>
>  
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 7fe5be1..9d4af8a 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -3347,6 +3347,51 @@ use its minimum possible distance for auto focus.</entry>
>  	  </row>
>  	  <row><entry></entry></row>
>  
> +	  <row id="v4l2-auto-focus-area">
> +	    <entry spanname="id">
> +	      <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>&nbsp;</entry>
> +	    <entry>enum&nbsp;v4l2_auto_focus_area</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Determines the area of the frame that
> +the camera uses for automatic focus. The corresponding coordinates of the
> +focusing spot or rectangle can be specified and queried using the selection API.
> +To change the auto focus region of interest applications first select required
> +mode of this control and then set the rectangle or spot coordinates by means
> +of the &VIDIOC-SUBDEV-S-SELECTION; or &VIDIOC-S-SELECTION; ioctl. In order to
> +trigger again a one shot auto focus with same coordinates applications should
> +use the <constant>V4L2_CID_AUTO_FOCUS_START </constant> control. Or alternatively

Extra space above.                            ^

> +invoke a &VIDIOC-SUBDEV-S-SELECTION; or a &VIDIOC-S-SELECTION; ioctl again.

How about requiring explicit V4L2_CID_AUTO_FOCUS_START? If you need to
specify several AF selection windows, then on which one do you start the
algorithm? A bitmask control explicitly telling which ones are active would
also be needed --- but that's for the future. I think now we just need to
ascertain we don't make that difficult. :-)

> +In the latter case the new pixel coordinates are applied to hardware only when
> +the focus area control was set to
> +<constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>.</entry>
> +	  </row>
> +	  <row>
> +	    <entrytbl spanname="descr" cols="2">
> +	      <tbody valign="top">
> +		<row>
> +		  <entry><constant>V4L2_AUTO_FOCUS_AREA_ALL</constant>&nbsp;</entry>
> +		  <entry>Normal auto focus, the focusing area extends over the
> +entire frame.</entry>

Does this need to be explicitly specified? Shouldn't the user just choose
the largest possible AF window instead? I'd even expect that the AF window
might span the whole frame by default (up to driver, hardware etc.).

> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>&nbsp;</entry>
> +		  <entry>The auto focus region of interest is determined by the
> +<constant>V4L2_SEL_TGT_AUTO_FOCUS</constant> selection rectangle.</entry>

It's not strictly required in documentation (and that shows) but it'd be
nice to align the paragraphs at equal indentation.

> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION</constant>&nbsp;</entry>
> +		  <entry>The auto focus region of interest is determined
> +by an object (e.g. face) detection engine.</entry>
> +		</row>
> +	      </tbody>
> +	    </entrytbl>
> +	  </row>
> +	  <row><entry spanname="descr">
> +	    This is an <link linkend="experimental">experimental</link>
> +control and may change in the future.</entry>
> +	  </row>
> +	  <row><entry></entry></row>
> +
>  	  <row>
>  	    <entry spanname="id"><constant>V4L2_CID_ZOOM_ABSOLUTE</constant>&nbsp;</entry>
>  	    <entry>integer</entry>
> @@ -3986,7 +4031,7 @@ interface and may change in the future.</para>
>  
>            <table pgwide="1" frame="none" id="flash-control-id">
>            <title>Flash Control IDs</title>
> -    
> +
>            <tgroup cols="4">
>      	<colspec colname="c1" colwidth="1*" />
>      	<colspec colname="c2" colwidth="6*" />
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 10ccde9..1477540 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -140,6 +140,13 @@ structs, ioctls) must be noted in more detail in the history chapter
>  applications. -->
>  
>        <revision>
> +	<revnumber>3.9</revnumber>
> +	<date>2012-12-10</date>
> +	<authorinitials>sn</authorinitials>
> +	<revremark>Added V4L2_CID_AUTO_FOCUS_AREA control.</revremark>
> +      </revision>
> +
> +      <revision>
>  	<revnumber>3.6</revnumber>
>  	<date>2012-07-02</date>
>  	<authorinitials>hv</authorinitials>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index f6ee201..9cdf4b8 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -236,6 +236,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Spot",
>  		NULL
>  	};
> +	static const char * const camera_auto_focus_area[] = {
> +		"All",
> +		"Rectangle",
> +		"Object Detection",
> +		NULL
> +	};
>  	static const char * const camera_auto_focus_range[] = {
>  		"Auto",
>  		"Normal",
> @@ -497,6 +503,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return camera_exposure_auto;
>  	case V4L2_CID_EXPOSURE_METERING:
>  		return camera_exposure_metering;
> +	case V4L2_CID_AUTO_FOCUS_AREA:
> +		return camera_auto_focus_area;
>  	case V4L2_CID_AUTO_FOCUS_RANGE:
>  		return camera_auto_focus_range;
>  	case V4L2_CID_COLORFX:
> @@ -732,6 +740,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_AUTO_FOCUS_STOP:		return "Auto Focus, Stop";
>  	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
>  	case V4L2_CID_AUTO_FOCUS_RANGE:		return "Auto Focus, Range";
> +	case V4L2_CID_AUTO_FOCUS_AREA:		return "Auto Focus, Area";
>  
>  	/* FM Radio Modulator control */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> @@ -881,6 +890,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_MPEG_STREAM_TYPE:
>  	case V4L2_CID_MPEG_STREAM_VBI_FMT:
>  	case V4L2_CID_EXPOSURE_AUTO:
> +	case V4L2_CID_AUTO_FOCUS_AREA:
>  	case V4L2_CID_AUTO_FOCUS_RANGE:
>  	case V4L2_CID_COLORFX:
>  	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index f56c945..0eb1c1a 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -683,6 +683,12 @@ enum v4l2_auto_focus_range {
>  	V4L2_AUTO_FOCUS_RANGE_INFINITY		= 3,
>  };
>  
> +#define V4L2_CID_AUTO_FOCUS_AREA		(V4L2_CID_CAMERA_CLASS_BASE+32)
> +enum v4l2_auto_focus_area {
> +	V4L2_AUTO_FOCUS_AREA_ALL		= 0,
> +	V4L2_AUTO_FOCUS_AREA_RECTANGLE		= 1,
> +	V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION	= 2,

How about using #defines? It's easier for the user space when it can just
test #ifdef instead of relying on interesting hacks such as those in VLC
source in modules/access/v4l2/v4l2.h.

You can easily either provide a substitute or just not compile in the
feature.

> +};
>  
>  /* FM Modulator class control IDs */
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
