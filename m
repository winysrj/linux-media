Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60712 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2BDSmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 13:42:53 -0500
Received: by eekc14 with SMTP id c14so1613071eek.19
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2012 10:42:51 -0800 (PST)
Message-ID: <4F2D7C28.6010909@gmail.com>
Date: Sat, 04 Feb 2012 19:42:48 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: Re: [PATCH v2 09/31] v4l: Image source control class
References: <20120202235231.GC841@valkosipuli.localdomain> <1328226891-8968-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1328226891-8968-9-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/03/2012 12:54 AM, Sakari Ailus wrote:
> Add image source control class. This control class is intended to contain
> low level controls which deal with control of the image capture process ---
> the A/D converter in image sensors, for example.
> 
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
> ---
>   Documentation/DocBook/media/v4l/controls.xml       |   86 ++++++++++++++++++++
>   .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    6 ++
>   drivers/media/video/v4l2-ctrls.c                   |    7 ++
>   include/linux/videodev2.h                          |    9 ++
>   4 files changed, 108 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index a1be378..6842e80 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -3379,4 +3379,90 @@ interface and may change in the future.</para>
>         </table>
> 
>       </section>
> +
> +<section id="image-source-controls">
> +<title>Image Source Control Reference</title>
> +
> +<note>
> +	<title>Experimental</title>
> +
> +	<para>This is an<link
> +	linkend="experimental">experimental</link>  interface and may
> +	change in the future.</para>
> +</note>
> +
> +<para>
> +	The Image Source control class is intended for low-level
> +	control of image source devices such as image sensors. The
> +	devices feature an analogue to digital converter and a bus
> +	transmitter to transmit the image data out of the device.
> +</para>
> +
> +<table pgwide="1" frame="none" id="image-source-control-id">
> +<title>Image Source Control IDs</title>
> +
> +<tgroup cols="4">
> +	<colspec colname="c1" colwidth="1*" />
> +	<colspec colname="c2" colwidth="6*" />
> +	<colspec colname="c3" colwidth="2*" />
> +	<colspec colname="c4" colwidth="6*" />
> +	<spanspec namest="c1" nameend="c2" spanname="id" />
> +	<spanspec namest="c2" nameend="c4" spanname="descr" />
> +	<thead>
> +	<row>
> +	<entry spanname="id" align="left">ID</entry>
> +	<entry align="left">Type</entry>
> +	</row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
> +	</row>
> +	</thead>
> +	<tbody valign="top">
> +	<row><entry></entry></row>
> +	<row>
> +	<entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_CLASS</constant></entry>
> +	<entry>class</entry>
> +	</row>
> +	<row>
> +	<entry spanname="descr">The IMAGE_SOURCE class descriptor.</entry>
> +	</row>
> +	<row>
> +	<entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_VBLANK</constant></entry>
> +	<entry>integer</entry>
> +	</row>
> +	<row>
> +	<entry spanname="descr">Vertical blanking. The idle
> +	    preriod after every frame during which no image data is
> +	    produced. The unit of vertical blanking is a line. Every
> +	    line has length of the image width plus horizontal
> +	    blanking at the pixel clock specified by struct
> +	    v4l2_mbus_framefmt<xref linkend="v4l2-mbus-framefmt"

The pixel clock is no longer specified by struct v4l2_mbus_framefmt, it's
now determined by V4L2_CID_IMAGE_PROC_LINK_FREQ controls, right ?

When you drop the class name from the control names, it is perhaps better
to just use V4L2_CID_LINK_FREQUENCY name.

> +	    />.</entry>
> +	</row>
> +	<row>
> +	<entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_HBLANK</constant></entry>
> +	<entry>integer</entry>
> +	</row>
> +	<row>
> +	<entry spanname="descr">Horizontal blanking. The idle
> +	    preriod after every line of image data during which no

s/preriod/period

> +	    image data is produced. The unit of horizontal blanking is
> +	    pixels.</entry>
> +	</row>
> +	<row>
> +	<entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN</constant></entry>
> +	<entry>integer</entry>
> +	</row>
> +	<row>
> +	<entry spanname="descr">Analogue gain is gain affecting
> +	    all colour components in the pixel matrix. The gain
> +	    operation is performed in the analogue domain before A/D
> +	    conversion.
> +	</entry>
> +	</row>
> +	<row><entry></entry></row>
> +	</tbody>
> +</tgroup>
> +</table>
> +
> +</section>
> +
>   </section>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> index b17a7aa..f420034 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> @@ -265,6 +265,12 @@ These controls are described in<xref
>   These controls are described in<xref
>   		linkend="flash-controls" />.</entry>
>   	</row>
> +	<row>
> +	<entry><constant>V4L2_CTRL_CLASS_IMAGE_SOURCE</constant></entry>
> +	<entry>0x9d0000</entry>  <entry>The class containing image
> +	    source controls. These controls are described in<xref
> +	    linkend="image-source-controls" />.</entry>
> +	</row>
>   	</tbody>
>         </tgroup>
>       </table>
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 139ba42..37249b7 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -607,6 +607,12 @@ const char *v4l2_ctrl_get_name(u32 id)
>   	case V4L2_CID_FLASH_CHARGE:		return "Charge";
>   	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
> 
> +	/* Image source controls */
> +	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image source controls";
> +	case V4L2_CID_IMAGE_SOURCE_VBLANK:	return "Vertical blanking";
> +	case V4L2_CID_IMAGE_SOURCE_HBLANK:	return "Horizontal blanking";
> +	case V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN: return "Analogue gain";

All words in control descriptions need to be capitalized. :-)

--

Regards,
Sylwester
