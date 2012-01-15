Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58070 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2AOUAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 15:00:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 08/17] v4l: Image source control class
Date: Sun, 15 Jan 2012 21:00:46 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <201201150243.05381.laurent.pinchart@ideasonboard.com> <4F132C82.9060105@maxwell.research.nokia.com>
In-Reply-To: <4F132C82.9060105@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201152100.47343.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 15 January 2012 20:44:02 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Saturday 14 January 2012 21:51:31 Sakari Ailus wrote:
> >> Laurent Pinchart wrote:
> >>> On Tuesday 20 December 2011 21:28:00 Sakari Ailus wrote:
> >>>> From: Sakari Ailus <sakari.ailus@iki.fi>
> >>>> 
> >>>> Add image source control class. This control class is intended to
> >>>> contain low level controls which deal with control of the image
> >>>> capture process --- the A/D converter in image sensors, for example.
> >>>> 
> >>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >>>> ---
> >>>> 
> >>>>  Documentation/DocBook/media/v4l/controls.xml       |  101
> >>>>  +++++++++++++++++ .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml      
> >>>>  |
> >>>>  
> >>>>     6 +
> >>>>  
> >>>>  drivers/media/video/v4l2-ctrls.c                   |   10 ++
> >>>>  include/linux/videodev2.h                          |   10 ++
> >>>>  4 files changed, 127 insertions(+), 0 deletions(-)
> >>>> 
> >>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> >>>> b/Documentation/DocBook/media/v4l/controls.xml index 3bc5ee8..69ede83
> >>>> 100644
> >>>> --- a/Documentation/DocBook/media/v4l/controls.xml
> >>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
> >>>> @@ -3356,6 +3356,107 @@ interface and may change in the future.</para>
> >>>> 
> >>>>        </table>
> >>>>      
> >>>>      </section>
> >>>> 
> >>>> +
> >>>> +    <section id="image-source-controls">
> >>>> +      <title>Image Source Control Reference</title>
> >>>> +
> >>>> +      <note>
> >>>> +	<title>Experimental</title>
> >>>> +
> >>>> +	<para>This is an <link
> >>>> +	linkend="experimental">experimental</link> interface and may
> >>>> +	change in the future.</para>
> >>>> +      </note>
> >>>> +
> >>>> +      <para>
> >>>> +	The Image Source control class is intended for low-level
> >>>> +	control of image source devices such as image sensors. The
> >>>> +	devices feature an analogue to digital converter and a bus
> >>> 
> >>> Is the V4L2 documentation written in US or UK English ? US uses analog,
> >>> UK uses analogue. Analog would be shorter in control names.
> >> 
> >> Both appear to be used, but the US English appears to be more commonly
> >> used. I guess it's mostly chosen by whatever happened to be used by the
> >> author of the patch. I prefer UK spelling which you might have noticed
> >> already. :-)
> > 
> > Yes I have. I haven't checked whether V4L2 prefers the UK or US spelling.
> > I'll trust you on that.
> 
> I have checked and most seem to have used US spelling. If you wish me to
> change it, I can do that.

As you (and others) wish.

> >> I remember there was a discussion on this topic years ago within the
> >> kernel community but I don't remember how it ended up with... LWN.net
> >> appears to remember better than I do, but by a quick check I can't find
> >> any definitive conclusion.
> >> 
> >> <URL:http://lwn.net/Articles/44262/>
> >> <URL:http://lkml.org/lkml/2003/8/7/245>
> >> 
> >>>> +	transmitter to transmit the image data out of the device.
> >>>> +      </para>
> >>>> +
> >>>> +      <table pgwide="1" frame="none" id="image-source-control-id">
> >>>> +      <title>Image Source Control IDs</title>
> >>>> +
> >>>> +      <tgroup cols="4">
> >>>> +	<colspec colname="c1" colwidth="1*" />
> >>>> +	<colspec colname="c2" colwidth="6*" />
> >>>> +	<colspec colname="c3" colwidth="2*" />
> >>>> +	<colspec colname="c4" colwidth="6*" />
> >>>> +	<spanspec namest="c1" nameend="c2" spanname="id" />
> >>>> +	<spanspec namest="c2" nameend="c4" spanname="descr" />
> >>>> +	<thead>
> >>>> +	  <row>
> >>>> +	    <entry spanname="id" align="left">ID</entry>
> >>>> +	    <entry align="left">Type</entry>
> >>>> +	  </row><row rowsep="1"><entry spanname="descr"
> >>>> align="left">Description</entry> +	  </row>
> >>>> +	</thead>
> >>>> +	<tbody valign="top">
> >>>> +	  <row><entry></entry></row>
> >>>> +	  <row>
> >>>> +	    <entry
> >>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_CLASS</constant></entry>
> >>>> +
> >>>> 
> >>>>   <entry>class</entry>
> >>>> 
> >>>> +	  </row>
> >>>> +	  <row>
> >>>> +	    <entry spanname="descr">The IMAGE_SOURCE class
> >>>> descriptor.</entry> +	  </row>
> >>>> +	  <row>
> >>>> +	    <entry
> >>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_VBLANK</constant></entry
> >>>> > +
> >>>> 
> >>>>    <entry>integer</entry>
> >>>> 
> >>>> +	  </row>
> >>>> +	  <row>
> >>>> +	    <entry spanname="descr">Vertical blanking. The idle
> >>>> +	    preriod after every frame during which no image data is
> >>> 
> >>> s/preriod/period/
> >>> 
> >>>> +	    produced. The unit of vertical blanking is a line. Every
> >>>> +	    line has length of the image width plus horizontal
> >>>> +	    blanking at the pixel clock specified by struct
> >>>> +	    v4l2_mbus_framefmt <xref linkend="v4l2-mbus-framefmt"
> >>>> +	    />.</entry>
> >>>> +	  </row>
> >>>> +	  <row>
> >>>> +	    <entry
> >>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_HBLANK</constant></entry
> >>>> > +
> >>>> 
> >>>>    <entry>integer</entry>
> >>>> 
> >>>> +	  </row>
> >>>> +	  <row>
> >>>> +	    <entry spanname="descr">Horizontal blanking. The idle
> >>>> +	    preriod after every line of image data during which no
> >>> 
> >>> s/preriod/period/
> >>> 
> >>>> +	    image data is produced. The unit of horizontal blanking is
> >>>> +	    pixels.</entry>
> >>>> +	  </row>
> >>>> +	  <row>
> >>>> +	    <entry
> >>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_LINK_FREQ</constant></en
> >>>> tr y> +	    <entry>integer menu</entry>
> >>>> +	  </row>
> >>>> +	  <row>
> >>>> +	    <entry spanname="descr">Image source's data bus frequency.
> >>> 
> >>> What's the frequency unit ? Sample/second ?
> >> 
> >> Hz --- that's the unit of frequency. I fixed that in the new version.
> > 
> > Is the user supposed to compute the pixel clock from this information ?
> > That's what the text below seems to imply.
> 
> Apparently I have forgotten to update this in the new patchset. But yes,
> these factors do define it. The sensors' internal clock tree will be
> involved and calculation is non-trivial. This is why we also have the
> PIXEL_RATE control --- where I will refer to in the next patchset.

How is the sensor clock tree involved ? My understanding is that it will 
define the data bus frequency based on the sensor input clock, but the bus 
data rate shouldn't be influenced by the clock tree for a given bus frequency.

Computing the pixel rate from the bus frequency isn't trivial and shouldn't be 
done by userspace if my understanding is correct. Documenting all this clearly 
would probably help :-)

> >>>> +	    Together with the media bus pixel code, bus type (clock
> >>>> +	    cycles per sample), the data bus frequency defines the
> >>>> +	    pixel clock. <xref linkend="v4l2-mbus-framefmt" /> The
> >>>> +	    frame rate can be calculated from the pixel clock, image
> >>>> +	    width and height and horizontal and vertical blanking. The
> >>>> +	    frame rate control is performed by selecting the desired
> >>>> +	    horizontal and vertical blanking.
> >>>> +	    </entry>
> >>>> +	  </row>
> >>>> +	  <row>
> >>>> +	    <entry
> >>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN</constant>
> >>>> </ en try> +	    <entry>integer</entry>
> >>>> +	  </row>
> >>>> +	  <row>
> >>>> +	    <entry spanname="descr">Analogue gain is gain affecting
> >>>> +	    all colour components in the pixel matrix. The gain
> >>>> +	    operation is performed in the analogue domain before A/D
> >>>> +	    conversion.
> >>> 
> >>> Should we define one gain per color component ?
> >> 
> >> I think that in the end we may need up to six analogue gains:
> >> 
> >> - Gain for all components
> > 
> > Many sensors that provide per-component gains also provide a global gain
> > control that sets the four component gains. I'm not sure how (and if) we
> > should handle that.
> 
> If it directly affects all of them, I don't think we should support it.
> But if it's independent of the colour-specific ones, then, sure, it
> should be supported.

It directly affects them. It's a shortcut. Maybe the R, G and B gain controls 
should then be put in a cluster, and if the user sets them to the same value 
the driver would optimize I2C communication by using the global gain control.

> >> - Blue gain
> >> - Red gain
> >> - Green gain (for both greens)
> >> - Gr gain
> >> - Gb gain
> >> 
> >> It may be debatable whether Gr / Gb gain will always be the same or not.
> >> I'm not fully certain about that. As Hans G. suggested, it might be
> >> possible to go with just one for green.
> > 
> > I'm also unsure about that. Having different gains for the two green
> > components doesn't seem very useful. On the other hand, if we find a use
> > case later, we'll have to break driver ABIs.
> 
> Let's add the gains later on. Now we'll need a single analogue gain for
> all components and that's good for the time being.
> 
> >>>> +	    </entry>
> >>>> +	  </row>
> >>>> +	  <row><entry></entry></row>
> >>>> +	</tbody>
> >>>> +      </tgroup>
> >>>> +      </table>
> >>>> +
> >>>> +    </section>
> >>>> +
> >>>> 
> >>>>  </section>
> >>>>  
> >>>>    <!--
> >>>> 
> >>>> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> >>>> b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml index
> >>>> 5122ce8..250c1cf 100644
> >>>> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> >>>> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> >>>> @@ -257,6 +257,12 @@ These controls are described in <xref
> >>>> 
> >>>>  These controls are described in <xref
> >>>>  
> >>>>  		linkend="flash-controls" />.</entry>
> >>>>  		
> >>>>  	  </row>
> >>>> 
> >>>> +	  <row>
> >>>> +	    
<entry><constant>V4L2_CTRL_CLASS_IMAGE_SOURCE</constant></entry>
> >>>> +	    <entry>0x9d0000</entry> <entry>The class containing image
> >>>> +	    source controls. These controls are described in <xref
> >>>> +	    linkend="image-source-controls" />.</entry>
> >>>> +	  </row>
> >>>> 
> >>>>  	</tbody>
> >>>>  	
> >>>>        </tgroup>
> >>>>      
> >>>>      </table>
> >>>> 
> >>>> diff --git a/drivers/media/video/v4l2-ctrls.c
> >>>> b/drivers/media/video/v4l2-ctrls.c index 083bb79..da1ec52 100644
> >>>> --- a/drivers/media/video/v4l2-ctrls.c
> >>>> +++ b/drivers/media/video/v4l2-ctrls.c
> >>>> @@ -606,6 +606,12 @@ const char *v4l2_ctrl_get_name(u32 id)
> >>>> 
> >>>>  	case V4L2_CID_FLASH_CHARGE:		return "Charge";
> >>>>  	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
> >>>> 
> >>>> +	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image source 
controls";
> >>>> +	case V4L2_CID_IMAGE_SOURCE_VBLANK:	return "Vertical blanking";
> >>>> +	case V4L2_CID_IMAGE_SOURCE_HBLANK:	return "Horizontal blanking";
> >>>> +	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:	return "Link frequency";
> >>>> +	case V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN: return "Analogue gain";
> >>> 
> >>> Please capitalize each word, as done for the other controls.
> >> 
> >> This isn't done for the flash controls either, have you noticed that?
> >> 
> >> Well, I guess I have to admit that they were added by myself. ;-)
> >> 
> >> I can fix this for the next patchset.
> >> 
> >>>>  	default:
> >>>>  		return NULL;
> >>>>  	
> >>>>  	}
> >>>> 
> >>>> @@ -694,6 +700,9 @@ void v4l2_ctrl_fill(u32 id, const char **name,
> >>>> enum
> >>>> 
> >>>> v4l2_ctrl_type *type, case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
> >>>>  		*type = V4L2_CTRL_TYPE_MENU;
> >>>>  		break;
> >>>> 
> >>>> +	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:
> >>>> +		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
> >>>> +		break;
> >>> 
> >>> Will this always be an integer menu control, or can you foresee cases
> >>> where the range would be continuous ?
> >> 
> >> Good question. On some hardware this definitely is an integer menu, but
> >> hardware may exist where more selections would be available.
> >> 
> >> However, on e.g. the SMIA++ sensor the calculation of the clock tree
> >> values depends heavily on the selected link rate. Choosing a wrong link
> >> rate may yield to the clock tree calculation to fail. So the driver
> >> likely would need to enforce some rules which values are allowed. That
> >> might prove unfeasible --- already the PLL code in the SMIA++ driver is
> >> relatively complex.
> >> 
> >> I don't see much benefit in being able to specify this freely.
> > 
> > For SMIA++, definitely not. For other sensors, I don't know.
> 
> At least one Aptina sensor had a clock tree which basically had a few
> dividers and a multiplier. The same restrictions apply.
> 
> >> AFAIR the conclusion was that controls may only have one type when the
> >> control framework was written.
> > 
> > Yes, but I'm not sure whether that's a good conclusion :-)
> 
> It allows you to assume a type for controls, whether that's good or not.
> 
> This could be one use case for that, but I don't really see much
> advantage in (attepmpting) to support fully free sensor link frequency
> configuration.

Who will then be responsible for creating the list of available frequencies ?

-- 
Regards,

Laurent Pinchart
