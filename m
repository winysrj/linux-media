Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:26033 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab2AOV2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 16:28:01 -0500
Message-ID: <4F1344D9.9000104@maxwell.research.nokia.com>
Date: Sun, 15 Jan 2012 23:27:53 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 08/17] v4l: Image source control class
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <201201150243.05381.laurent.pinchart@ideasonboard.com> <4F132C82.9060105@maxwell.research.nokia.com> <201201152100.47343.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201152100.47343.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Sunday 15 January 2012 20:44:02 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>>> On Saturday 14 January 2012 21:51:31 Sakari Ailus wrote:
>>>> Laurent Pinchart wrote:
>>>>> On Tuesday 20 December 2011 21:28:00 Sakari Ailus wrote:
>>>>>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>>>>>
>>>>>> Add image source control class. This control class is intended to
>>>>>> contain low level controls which deal with control of the image
>>>>>> capture process --- the A/D converter in image sensors, for example.
>>>>>>
>>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>>>>> ---
>>>>>>
>>>>>>  Documentation/DocBook/media/v4l/controls.xml       |  101
>>>>>>  +++++++++++++++++ .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml      
>>>>>>  |
>>>>>>  
>>>>>>     6 +
>>>>>>  
>>>>>>  drivers/media/video/v4l2-ctrls.c                   |   10 ++
>>>>>>  include/linux/videodev2.h                          |   10 ++
>>>>>>  4 files changed, 127 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>>>>>> b/Documentation/DocBook/media/v4l/controls.xml index 3bc5ee8..69ede83
>>>>>> 100644
>>>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>>>>> @@ -3356,6 +3356,107 @@ interface and may change in the future.</para>
>>>>>>
>>>>>>        </table>
>>>>>>      
>>>>>>      </section>
>>>>>>
>>>>>> +
>>>>>> +    <section id="image-source-controls">
>>>>>> +      <title>Image Source Control Reference</title>
>>>>>> +
>>>>>> +      <note>
>>>>>> +	<title>Experimental</title>
>>>>>> +
>>>>>> +	<para>This is an <link
>>>>>> +	linkend="experimental">experimental</link> interface and may
>>>>>> +	change in the future.</para>
>>>>>> +      </note>
>>>>>> +
>>>>>> +      <para>
>>>>>> +	The Image Source control class is intended for low-level
>>>>>> +	control of image source devices such as image sensors. The
>>>>>> +	devices feature an analogue to digital converter and a bus
>>>>>
>>>>> Is the V4L2 documentation written in US or UK English ? US uses analog,
>>>>> UK uses analogue. Analog would be shorter in control names.
>>>>
>>>> Both appear to be used, but the US English appears to be more commonly
>>>> used. I guess it's mostly chosen by whatever happened to be used by the
>>>> author of the patch. I prefer UK spelling which you might have noticed
>>>> already. :-)
>>>
>>> Yes I have. I haven't checked whether V4L2 prefers the UK or US spelling.
>>> I'll trust you on that.
>>
>> I have checked and most seem to have used US spelling. If you wish me to
>> change it, I can do that.
> 
> As you (and others) wish.
> 
>>>> I remember there was a discussion on this topic years ago within the
>>>> kernel community but I don't remember how it ended up with... LWN.net
>>>> appears to remember better than I do, but by a quick check I can't find
>>>> any definitive conclusion.
>>>>
>>>> <URL:http://lwn.net/Articles/44262/>
>>>> <URL:http://lkml.org/lkml/2003/8/7/245>
>>>>
>>>>>> +	transmitter to transmit the image data out of the device.
>>>>>> +      </para>
>>>>>> +
>>>>>> +      <table pgwide="1" frame="none" id="image-source-control-id">
>>>>>> +      <title>Image Source Control IDs</title>
>>>>>> +
>>>>>> +      <tgroup cols="4">
>>>>>> +	<colspec colname="c1" colwidth="1*" />
>>>>>> +	<colspec colname="c2" colwidth="6*" />
>>>>>> +	<colspec colname="c3" colwidth="2*" />
>>>>>> +	<colspec colname="c4" colwidth="6*" />
>>>>>> +	<spanspec namest="c1" nameend="c2" spanname="id" />
>>>>>> +	<spanspec namest="c2" nameend="c4" spanname="descr" />
>>>>>> +	<thead>
>>>>>> +	  <row>
>>>>>> +	    <entry spanname="id" align="left">ID</entry>
>>>>>> +	    <entry align="left">Type</entry>
>>>>>> +	  </row><row rowsep="1"><entry spanname="descr"
>>>>>> align="left">Description</entry> +	  </row>
>>>>>> +	</thead>
>>>>>> +	<tbody valign="top">
>>>>>> +	  <row><entry></entry></row>
>>>>>> +	  <row>
>>>>>> +	    <entry
>>>>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_CLASS</constant></entry>
>>>>>> +
>>>>>>
>>>>>>   <entry>class</entry>
>>>>>>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry spanname="descr">The IMAGE_SOURCE class
>>>>>> descriptor.</entry> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry
>>>>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_VBLANK</constant></entry
>>>>>>> +
>>>>>>
>>>>>>    <entry>integer</entry>
>>>>>>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry spanname="descr">Vertical blanking. The idle
>>>>>> +	    preriod after every frame during which no image data is
>>>>>
>>>>> s/preriod/period/
>>>>>
>>>>>> +	    produced. The unit of vertical blanking is a line. Every
>>>>>> +	    line has length of the image width plus horizontal
>>>>>> +	    blanking at the pixel clock specified by struct
>>>>>> +	    v4l2_mbus_framefmt <xref linkend="v4l2-mbus-framefmt"
>>>>>> +	    />.</entry>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry
>>>>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_HBLANK</constant></entry
>>>>>>> +
>>>>>>
>>>>>>    <entry>integer</entry>
>>>>>>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry spanname="descr">Horizontal blanking. The idle
>>>>>> +	    preriod after every line of image data during which no
>>>>>
>>>>> s/preriod/period/
>>>>>
>>>>>> +	    image data is produced. The unit of horizontal blanking is
>>>>>> +	    pixels.</entry>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry
>>>>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_LINK_FREQ</constant></en
>>>>>> tr y> +	    <entry>integer menu</entry>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry spanname="descr">Image source's data bus frequency.
>>>>>
>>>>> What's the frequency unit ? Sample/second ?
>>>>
>>>> Hz --- that's the unit of frequency. I fixed that in the new version.
>>>
>>> Is the user supposed to compute the pixel clock from this information ?
>>> That's what the text below seems to imply.
>>
>> Apparently I have forgotten to update this in the new patchset. But yes,
>> these factors do define it. The sensors' internal clock tree will be
>> involved and calculation is non-trivial. This is why we also have the
>> PIXEL_RATE control --- where I will refer to in the next patchset.
> 
> How is the sensor clock tree involved ? My understanding is that it will 
> define the data bus frequency based on the sensor input clock, but the bus 
> data rate shouldn't be influenced by the clock tree for a given bus frequency.

Uh, I was referring to the  pixel array. On the CSI-2 receiver, there
are also factors like data bus width, bits-per-pixel and lane count that
affect the pixel rate on the bus. I don't think the user should be
required to know about them.

> Computing the pixel rate from the bus frequency isn't trivial and shouldn't be 
> done by userspace if my understanding is correct. Documenting all this clearly 
> would probably help :-)

The idea is that by defining all these factors one can query the real
pixel rate from the pixel array. That pixel rate will be constant as
long as all the above parameters are. Then blanking can be changed to
lower the frame rate (taking the policy decisions at the same time).

I guess I could put it in a more clear way.

>>>>>> +	    Together with the media bus pixel code, bus type (clock
>>>>>> +	    cycles per sample), the data bus frequency defines the
>>>>>> +	    pixel clock. <xref linkend="v4l2-mbus-framefmt" /> The
>>>>>> +	    frame rate can be calculated from the pixel clock, image
>>>>>> +	    width and height and horizontal and vertical blanking. The
>>>>>> +	    frame rate control is performed by selecting the desired
>>>>>> +	    horizontal and vertical blanking.
>>>>>> +	    </entry>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry
>>>>>> spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN</constant>
>>>>>> </ en try> +	    <entry>integer</entry>
>>>>>> +	  </row>
>>>>>> +	  <row>
>>>>>> +	    <entry spanname="descr">Analogue gain is gain affecting
>>>>>> +	    all colour components in the pixel matrix. The gain
>>>>>> +	    operation is performed in the analogue domain before A/D
>>>>>> +	    conversion.
>>>>>
>>>>> Should we define one gain per color component ?
>>>>
>>>> I think that in the end we may need up to six analogue gains:
>>>>
>>>> - Gain for all components
>>>
>>> Many sensors that provide per-component gains also provide a global gain
>>> control that sets the four component gains. I'm not sure how (and if) we
>>> should handle that.
>>
>> If it directly affects all of them, I don't think we should support it.
>> But if it's independent of the colour-specific ones, then, sure, it
>> should be supported.
> 
> It directly affects them. It's a shortcut. Maybe the R, G and B gain controls 
> should then be put in a cluster, and if the user sets them to the same value 
> the driver would optimize I2C communication by using the global gain control.

A cluster would be fine, I guess. But on some other hardware the
all-component gain could be independent of the per-component ones.

...

>>>>>> @@ -694,6 +700,9 @@ void v4l2_ctrl_fill(u32 id, const char **name,
>>>>>> enum
>>>>>>
>>>>>> v4l2_ctrl_type *type, case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>>>>>>  		*type = V4L2_CTRL_TYPE_MENU;
>>>>>>  		break;
>>>>>>
>>>>>> +	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:
>>>>>> +		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
>>>>>> +		break;
>>>>>
>>>>> Will this always be an integer menu control, or can you foresee cases
>>>>> where the range would be continuous ?
>>>>
>>>> Good question. On some hardware this definitely is an integer menu, but
>>>> hardware may exist where more selections would be available.
>>>>
>>>> However, on e.g. the SMIA++ sensor the calculation of the clock tree
>>>> values depends heavily on the selected link rate. Choosing a wrong link
>>>> rate may yield to the clock tree calculation to fail. So the driver
>>>> likely would need to enforce some rules which values are allowed. That
>>>> might prove unfeasible --- already the PLL code in the SMIA++ driver is
>>>> relatively complex.
>>>>
>>>> I don't see much benefit in being able to specify this freely.
>>>
>>> For SMIA++, definitely not. For other sensors, I don't know.
>>
>> At least one Aptina sensor had a clock tree which basically had a few
>> dividers and a multiplier. The same restrictions apply.
>>
>>>> AFAIR the conclusion was that controls may only have one type when the
>>>> control framework was written.
>>>
>>> Yes, but I'm not sure whether that's a good conclusion :-)
>>
>> It allows you to assume a type for controls, whether that's good or not.
>>
>> This could be one use case for that, but I don't really see much
>> advantage in (attepmpting) to support fully free sensor link frequency
>> configuration.
> 
> Who will then be responsible for creating the list of available frequencies ?

That would be the one who defines also the other board specific
parameters such as the number of lanes. The link frequency has to fill
several requirements, and some of that is policy whereas some is not.

Things to consider are system memory bus data rate, CSI-2 receiver's (or
ISP's) memory access priority compared to other users, maximum pixel
rate of the CSI-2 receiver (and also that of the ISP, if the CSI-2
receiver is part of it), sensor's external clock frequency and
properties of the sensor clock tree (the frequency must be achievable
using the available PLL divisors and multipliers) and at least on some
boards, also system's EMC requirements.

I don't think the above list is exhaustive.

For example, on OMAP 3[67]xx based boards it could make sense to define
data rates which can produce pixel rates close to 500 MHz and 250 MHz
which correspond to the maximum speed of the CSI-2 receiver and the ISP
(100 Mp/s) with two lanes (CSI-2 transfers 2 bits for every clock cycle).

One could also define the highest operating point to be less than that,
which would likely have an effect to the desired link frequencies. 34xx
has smaller maximum ISP data rate, so if you connect the same sensor to
that you'll likely want to change the supported link rate(s).

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
