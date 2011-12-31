Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44283 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1LaOm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 09:42:58 -0500
Received: by eekc4 with SMTP id c4so14322879eek.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 06:42:57 -0800 (PST)
Message-ID: <4EFF1F6B.2090009@gmail.com>
Date: Sat, 31 Dec 2011 15:42:51 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl
Subject: Re: [RFC 2/3] v4l: Image source control class
References: <20111201143044.GI29805@valkosipuli.localdomain> <1323876147-18107-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1323876147-18107-2-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thanks for the patch.

On 12/14/2011 04:22 PM, Sakari Ailus wrote:
> Add image source control class. This control class is intended to contain
> low level controls which deal with control of the image capture process ---
> the A/D converter in image sensors, for example.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/controls.xml       |  101 ++++++++++++++++++++
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    6 +
>  drivers/media/video/v4l2-ctrls.c                   |   10 ++
>  include/linux/videodev2.h                          |   10 ++
>  4 files changed, 127 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 3bc5ee8..69ede83 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -3356,6 +3356,107 @@ interface and may change in the future.</para>
>        </table>
>  
>      </section>
> +
> +    <section id="image-source-controls">
> +      <title>Image Source Control Reference</title>
> +
> +      <note>
> +	<title>Experimental</title>
> +
> +	<para>This is an <link
> +	linkend="experimental">experimental</link> interface and may
> +	change in the future.</para>
> +      </note>
> +
> +      <para>
> +	The Image Source control class is intended for low-level
> +	control of image source devices such as image sensors. The
> +	devices feature an analogue to digital converter and a bus
> +	transmitter to transmit the image data out of the device.
> +      </para>
> +
> +      <table pgwide="1" frame="none" id="image-source-control-id">
> +      <title>Image Source Control IDs</title>
> +
> +      <tgroup cols="4">
> +	<colspec colname="c1" colwidth="1*" />
> +	<colspec colname="c2" colwidth="6*" />
> +	<colspec colname="c3" colwidth="2*" />
> +	<colspec colname="c4" colwidth="6*" />
> +	<spanspec namest="c1" nameend="c2" spanname="id" />
> +	<spanspec namest="c2" nameend="c4" spanname="descr" />
> +	<thead>
> +	  <row>
> +	    <entry spanname="id" align="left">ID</entry>
> +	    <entry align="left">Type</entry>
> +	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
> +	  </row>
> +	</thead>
> +	<tbody valign="top">
> +	  <row><entry></entry></row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_CLASS</constant></entry>
> +	    <entry>class</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">The IMAGE_SOURCE class descriptor.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_VBLANK</constant></entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Vertical blanking. The idle
> +	    preriod after every frame during which no image data is

s/preriod/period

> +	    produced. The unit of vertical blanking is a line. Every
> +	    line has length of the image width plus horizontal
> +	    blanking at the pixel clock specified by struct
> +	    v4l2_mbus_framefmt <xref linkend="v4l2-mbus-framefmt"
> +	    />.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_HBLANK</constant></entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Horizontal blanking. The idle
> +	    preriod after every line of image data during which no

s/preriod/period

> +	    image data is produced. The unit of horizontal blanking is
> +	    pixels.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_LINK_FREQ</constant></entry>
> +	    <entry>integer menu</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Image source's data bus frequency.
> +	    Together with the media bus pixel code, bus type (clock
> +	    cycles per sample), the data bus frequency defines the
> +	    pixel clock. <xref linkend="v4l2-mbus-framefmt" /> The
> +	    frame rate can be calculated from the pixel clock, image
> +	    width and height and horizontal and vertical blanking. The
> +	    frame rate control is performed by selecting the desired
> +	    horizontal and vertical blanking.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN</constant></entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Analogue gain is gain affecting
> +	    all colour components in the pixel matrix. The gain
> +	    operation is performed in the analogue domain before A/D
> +	    conversion.
> +	    </entry>
> +	  </row>
> +	  <row><entry></entry></row>
> +	</tbody>
> +      </tgroup>
> +      </table>
> +
> +    </section>
> +
>  </section>
>  
>    <!--
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> index 5122ce8..250c1cf 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> @@ -257,6 +257,12 @@ These controls are described in <xref
>  These controls are described in <xref
>  		linkend="flash-controls" />.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_CTRL_CLASS_IMAGE_SOURCE</constant></entry>
> +	    <entry>0x9d0000</entry> <entry>The class containing image
> +	    source controls. These controls are described in <xref
> +	    linkend="image-source-controls" />.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 083bb79..da1ec52 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -606,6 +606,12 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_FLASH_CHARGE:		return "Charge";
>  	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
>  
> +	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image source controls";
> +	case V4L2_CID_IMAGE_SOURCE_VBLANK:	return "Vertical blanking";

nit: have you considered making it "Blanking, horizontal"

> +	case V4L2_CID_IMAGE_SOURCE_HBLANK:	return "Horizontal blanking";

and "Blanking, vertical" ?

> +	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:	return "Link frequency";
> +	case V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN: return "Analogue gain";
> +
>  	default:
>  		return NULL;
>  	}
> @@ -694,6 +700,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>  		*type = V4L2_CTRL_TYPE_MENU;
>  		break;
> +	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:
> +		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
> +		break;
>  	case V4L2_CID_RDS_TX_PS_NAME:
>  	case V4L2_CID_RDS_TX_RADIO_TEXT:
>  		*type = V4L2_CTRL_TYPE_STRING;
> @@ -703,6 +712,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_MPEG_CLASS:
>  	case V4L2_CID_FM_TX_CLASS:
>  	case V4L2_CID_FLASH_CLASS:
> +	case V4L2_CID_IMAGE_SOURCE_CLASS:
>  		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
>  		/* You can neither read not write these */
>  		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 9633c69..0f8f904 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1080,6 +1080,7 @@ struct v4l2_ext_controls {
>  #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
>  #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
>  #define V4L2_CTRL_CLASS_FLASH 0x009c0000	/* Camera flash controls */
> +#define V4L2_CTRL_CLASS_IMAGE_SOURCE 0x009d0000	/* Image source flash controls */
>  
>  #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
>  #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
> @@ -1690,6 +1691,15 @@ enum v4l2_flash_strobe_source {
>  #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
>  #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
>  
> +/* Image source controls */
> +#define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE | 0x900)
> +#define V4L2_CID_IMAGE_SOURCE_CLASS		(V4L2_CTRL_CLASS_IMAGE_SOURCE | 1)
> +
> +#define V4L2_CID_IMAGE_SOURCE_VBLANK		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 1)
> +#define V4L2_CID_IMAGE_SOURCE_HBLANK		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 2)
> +#define V4L2_CID_IMAGE_SOURCE_LINK_FREQ		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 3)
> +#define V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN	(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 4)

Since these are really low level controls, do you think we could shorten
the class name a bit, i.e. make it V4L2_CID_IMG_SRC_CLASS ? :)


Somehow I'm getting the misterious error again when compiling after this
patch is applied (and others from you last series of 17, xmlto version
0.0.23, perl, v5.10.1):

8<--------------------

  HTML    Documentation/DocBook/media_api.html
warning: failed to load external entity
"/home/snawrocki/linux-media/media_tree/Documentation/DocBook/vidioc-subdev-g-selection.xml"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The problem is in patch "v4l: Add selections documentation." [1].
Somehow file vidioc-subdev-g-selection.xml doesn't get copied to
Documentation/DocBook/ directory. When I copy it manually it compiles
fine. I'm looking now at Documentation/DocBook/Makefile to find the
reason of that.

/home/snawrocki/linux-media/media_tree/Documentation/DocBook/dev-subdev.xml:295:
parser error : Failure to process entity sub-subdev-g-selection
      configured using &sub-subdev-g-selection; and
                                               ^
/home/snawrocki/linux-media/media_tree/Documentation/DocBook/dev-subdev.xml:295:
parser error : Entity 'sub-subdev-g-selection' not defined
      configured using &sub-subdev-g-selection; and
                                               ^
/home/snawrocki/linux-media/media_tree/Documentation/DocBook/dev-subdev.xml:369:
parser error : chunk is not well balanced

^
/home/snawrocki/linux-media/media_tree/Documentation/DocBook/v4l2.xml:456:
parser error : Failure to process entity sub-dev-subdev
    <section id="subdev"> &sub-dev-subdev; </section>
                                          ^
/home/snawrocki/linux-media/media_tree/Documentation/DocBook/v4l2.xml:456:
parser error : Entity 'sub-dev-subdev' not defined
    <section id="subdev"> &sub-dev-subdev; </section>
                                          ^
/usr/bin/xmlto: line 576: 27987 Segmentation fault      "$XSLTPROC_PATH"
$XSLTOPTS -o "$XSLT_PROCESSED" "$STYLESHEET" "$INPUT_FILE"
/bin/cp: cannot stat `*.*htm*': No such file or directory
make[1]: *** [Documentation/DocBook/media_api.html] Error 1
make: *** [htmldocs] Error 2

------------------>8

[1]. http://patchwork.linuxtv.org/patch/8923/

-- 
Thanks,
Sylwester
