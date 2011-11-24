Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38645 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1KXLJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 06:09:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH/RFC 1/2] v4l: Add a global color alpha control
Date: Thu, 24 Nov 2011 12:09:09 +0100
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	m.szyprowski@samsung.com, jonghun.han@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1322131997-26195-1-git-send-email-s.nawrocki@samsung.com> <1322131997-26195-2-git-send-email-s.nawrocki@samsung.com> <201111241200.45479.hverkuil@xs4all.nl>
In-Reply-To: <201111241200.45479.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111241209.12377.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Hans,

On Thursday 24 November 2011 12:00:45 Hans Verkuil wrote:
> On Thursday, November 24, 2011 11:53:16 Sylwester Nawrocki wrote:
> > This control is intended for video capture or memory-to-memory
> > devices that are capable of setting up the alpha conponent to
> > some arbitrary value.
> > The V4L2_CID_COLOR_ALPHA control allows to set the alpha channel
> > globally to a value in range from 0 to 255.
> > 
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > 
> >  Documentation/DocBook/media/v4l/controls.xml       |   20
> >  ++++++++++++++------ .../DocBook/media/v4l/pixfmt-packed-rgb.xml       
> >  |    7 +++++-- drivers/media/video/v4l2-ctrls.c                   |   
> >  7 +++++++ include/linux/videodev2.h                          |    6
> >  +++--- 4 files changed, 29 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > b/Documentation/DocBook/media/v4l/controls.xml index 3bc5ee8..7f99222
> > 100644
> > --- a/Documentation/DocBook/media/v4l/controls.xml
> > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > @@ -324,12 +324,6 @@ minimum value disables backlight
> > compensation.</entry>
> > 
> >  		(usually a microscope).</entry>
> >  		
> >  	  </row>
> >  	  <row>
> > 
> > -	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
> > -	    <entry></entry>
> > -	    <entry>End of the predefined control IDs (currently
> > -<constant>V4L2_CID_ILLUMINATORS_2</constant> + 1).</entry>
> > -	  </row>
> > -	  <row>
> > 
> >  	    <entry><constant>V4L2_CID_MIN_BUFFERS_FOR_CAPTURE</constant></entry
> >  	    > <entry>integer</entry>
> >  	    <entry>This is a read-only control that can be read by the
> >  	    application
> > 
> > @@ -345,6 +339,20 @@ and used as a hint to determine the number of OUTPUT
> > buffers to pass to REQBUFS.
> > 
> >  The value is the minimum number of OUTPUT buffers that is necessary for
> >  hardware to work.</entry>
> >  
> >  	  </row>
> > 
> > +	  <row id="v4l2-color-alpha">
> > +	    <entry><constant>V4L2_CID_COLOR_ALPHA</constant></entry>
> > +	    <entry>integer</entry>
> > +	    <entry> Sets the color alpha component on the capture device. It is
> > +	    applicable to any pixel formats that contain the alpha component,
> > +	    e.g. <link linkend="rgb-formats">packed RGB image formats</link>.
> > +	    </entry>

As the alpha value is global, isn't it applicable to formats with no alpha 
component as well ?

> > +	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
> > +	    <entry></entry>
> > +	    <entry>End of the predefined control IDs (currently
> > +	      <constant>V4L2_CID_COLOR_ALPHA</constant> + 1).</entry>
> > +	  </row>
> > 
> >  	  <row>
> >  	  
> >  	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
> >  	    <entry></entry>
> > 
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> > b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml index
> > 4db272b..da4c360 100644
> > --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> > @@ -428,8 +428,11 @@ colorspace
> > <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
> > 
> >      <para>Bit 7 is the most significant bit. The value of a = alpha
> >  
> >  bits is undefined when reading from the driver, ignored when writing
> >  to the driver, except when alpha blending has been negotiated for a
> > 
> > -<link linkend="overlay">Video Overlay</link> or <link
> > -linkend="osd">Video Output Overlay</link>.</para>
> > +<link linkend="overlay">Video Overlay</link> or <link linkend="osd">
> > +Video Output Overlay</link> or when global alpha has been configured
> > +for a <link linkend="capture">Video Capture</link> by means of
> > +<link linkend="v4l2-color-alpha"> <constant>V4L2_CID_COLOR_ALPHA
> > +</constant> </link> control.</para>
> > 
> >      <example>
> >      
> >        <title><constant>V4L2_PIX_FMT_BGR24</constant> 4 &times; 4 pixel
> > 
> > diff --git a/drivers/media/video/v4l2-ctrls.c
> > b/drivers/media/video/v4l2-ctrls.c index 5552f81..bd90955 100644
> > --- a/drivers/media/video/v4l2-ctrls.c
> > +++ b/drivers/media/video/v4l2-ctrls.c
> > @@ -466,6 +466,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> > 
> >  	case V4L2_CID_ILLUMINATORS_2:		return "Illuminator 2";
> >  	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:	return "Minimum Number of
> >  	Capture Buffers"; case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return
> >  	"Minimum Number of Output Buffers";
> > 
> > +	case V4L2_CID_COLOR_ALPHA:		return "Color Alpha";
> 
> I prefer CID_ALPHA_COLOR and string "Alpha Color". I think it is more
> natural than the other way around.

I'm not too found of "color" in the name. Is the alpha value considered as a 
color ?

> Other than that I'm OK with this.
> 
> Regards,
> 
> 	Hans
> 
> >  	/* MPEG controls */
> >  	/* Keep the order of the 'case's the same as in videodev2.h! */
> > 
> > @@ -714,6 +715,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> > v4l2_ctrl_type *type,
> > 
> >  		/* Max is calculated as RGB888 that is 2^24 */
> >  		*max = 0xFFFFFF;
> >  		break;
> > 
> > +	case V4L2_CID_COLOR_ALPHA:
> > +		*type = V4L2_CTRL_TYPE_INTEGER;
> > +		*step = 1;
> > +		*min = 0;
> > +		*max = 0xff;
> > +		break;
> > 
> >  	case V4L2_CID_FLASH_FAULT:
> >  		*type = V4L2_CTRL_TYPE_BITMASK;
> >  		break;
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 4b752d5..42192c1 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1204,10 +1204,10 @@ enum v4l2_colorfx {
> > 
> >  #define V4L2_CID_MIN_BUFFERS_FOR_CAPTURE	(V4L2_CID_BASE+39)
> >  #define V4L2_CID_MIN_BUFFERS_FOR_OUTPUT		(V4L2_CID_BASE+40)
> > 
> > -/* last CID + 1 */
> > -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+41)
> > +#define V4L2_CID_COLOR_ALPHA			(V4L2_CID_BASE+41)
> > 
> > -/* Minimum number of buffer neede by the device */
> > +/* last CID + 1 */
> > +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+42)
> > 
> >  /*  MPEG-class control IDs defined by V4L2 */
> >  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

-- 
Regards,

Laurent Pinchart
