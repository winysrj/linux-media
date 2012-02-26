Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:50535 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2BZVmn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 16:42:43 -0500
Message-ID: <4F4AA73B.1050206@iki.fi>
Date: Sun, 26 Feb 2012 23:42:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 09/33] v4l: Add subdev selections documentation
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-9-git-send-email-sakari.ailus@iki.fi> <1423212.0qmDccT8PT@avalon>
In-Reply-To: <1423212.0qmDccT8PT@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Many thanks for the comments!

Laurent Pinchart wrote:
> On Monday 20 February 2012 03:56:48 Sakari Ailus wrote:
>> Add documentation for V4L2 subdev selection API. This changes also
>> experimental V4L2 subdev API so that scaling now works through selection API
>> only.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> 
>> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
>> b/Documentation/DocBook/media/v4l/dev-subdev.xml index 0916a73..9d5e7da
>> 100644
>> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
>> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> 
> [snip]
> 
>> +      <para>Scaling operation changes the size of the image by scaling
>> +      it to new dimensions. Some sub-devices support it. The scaled
>> +      size (width and height) is represented by &v4l2-rect;. In the
>> +      case of scaling, top and left will always be zero. Scaling is
>> +      configured using &sub-subdev-g-selection; and
>> +      <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTIVE</constant> selection
>> +      target on the sink pad of the subdev. The scaling is performed
>> +      related to the width and height of the crop rectangle on the
>> +      subdev's sink pad.</para>
> 
> I'm not sure if that would be very clear for readers who are not yet familiar 
> with the API. What about the following text instead ?
> 
> "The scaling operation changes the size of the image by scaling it to new 
> dimensions. The scaling ratio isn't specified explicitly, but is implied from 
> the original and scaled image sizes. Both sizes are represented by &v4l2-
> rect;.
> 
> Scaling support is optional. When supported by a subdev, the crop rectangle on 
> the subdev's sink pad is scaled to the size configured using &VIDIOC-SUBDEV-G-
> SELECTION; and <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTIVE</constant> selection 
> target on the same pad. If the subdev supports scaling but no composing, the 
> top and left values are not used and must always be set to zero."
> 
> (note that &sub-subdev-g-selection; has been replaced with &VIDIOC-SUBDEV-G-
> SELECTION;)
> 
> I would also move this text after the sink pad crop description to follow the 
> order in which operations are applied by subdevs.

I'm fine with that change, so I did it. However, I won't replace
&sub-subdev-g-selection; with &VIDIOC-SUBDEV-G-SELECTION; simply because
it won't work:

dev-subdev.xml:310: parser error : Entity 'VIDIOC-SUBDEV-G-SELECTION'
not defined
      size configured using &VIDIOC-SUBDEV-G-SELECTION; and

It's beyond me why not; similar references are being used elsewhere with
otherwise equivalent definitions. Perhaps the name is just too long?
That's the only difference I could think of: xmlto typically segfaults
on errors so I wouldn't be surprised of something so simple.

>> +      <para>As for pad formats, drivers store try and active
>> +      rectangles for the selection targets of ACTIVE type <xref
>> +      linkend="v4l2-subdev-selection-targets">.</xref></para>
>> +
>> +      <para>On sink pads, cropping is applied relatively to the
>> +      current pad format. The pad format represents the image size as
>> +      received by the sub-device from the previous block in the
>> +      pipeline, and the crop rectangle represents the sub-image that
>> +      will be transmitted further inside the sub-device for
>> +      processing.</para>
>> +
>> +      <para>On source pads, cropping is similar to sink pads, with the
>> +      exception that the source size from which the cropping is
>> +      performed, is the COMPOSE rectangle on the sink pad. In both
>> +      sink and source pads, the crop rectangle must be entirely
>> +      containted inside the source image size for the crop
>> +      operation.</para>
>> +
>> +      <para>The drivers should always use the closest possible
>> +      rectangle the user requests on all selection targets, unless
>> +      specificly told otherwise<xref
>> +      linkend="v4l2-subdev-selection-flags">.</xref></para>
>> +    </section>
>> +
>> +    <section>
>> +      <title>Types of selection targets</title>
>> +
>> +      <section>
>> +	<title>ACTIVE targets</title>
>> +
>> +	<para>ACTIVE targets reflect the actual hardware configuration
>> +	at any point of time.</para>
>> +      </section>
>> +
>> +      <section>
>> +	<title>BOUNDS targets</title>
>> +
>> +	<para>BOUNDS targets is the smallest rectangle within which
>> +	contains all valid ACTIVE rectangles.
> 
> s/within which/that/ ?

Ack.

>> It may not be possible
>> +	to set the ACTIVE rectangle as large as the BOUNDS rectangle,
>> +	however.</para>
> 
> What about
> 
> "The BOUNDS rectangle might not itself be a valid ACTIVE rectangle when all 
> possible ACTIVE pixels do not form a rectangular shape (e.g. cross-shaped or 
> round sensors)."

There are cases where the active size is limited, even if it's
rectangular. I can add the above case there, sure, if you think such
devices exist --- I've never heard of nor seen them. Some sensors are
documented to be cross-shaped but the only thing separating these from
the rest is that the manufacturer doesn't guarantee the quality of the
pixels in the corners. At least on those I've seen. You can still
capture the full pixel matrix.

>> +      </section>
>>
>> -      <para>Cropping behaviour on output pads is not defined.</para>
>> +    </section>
>> +
>> +    <section>
>> +      <title>Order of configuration and format propagation</title>
>> +
>> +      <para>Inside subdevs, the order of image processing steps will
>> +      always be from the sink pad towards the source pad. This is also
>> +      reflected in the order in which the configuration must be
>> +      performed by the user: the changes made will be propagated to
>> +      any subsequent stages. If this behaviour is not desired, the
>> +      user must set
>> +      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag.
> 
> Could you explain what happens when V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG is set ? 
> Just stating that it doesn't follow the propagation behaviour previously 
> described could be understood in many different ways.

Good point. How about this:

"This flag causes that no propagation of the changes are allowed in any
circumstances. This may also lead the accessed rectangle not being
changed at all, depending on the properties of the underlying hardware.
Some drivers may not support this flag."

>> The
>> +      coordinates to a step always refer to the active size of the
>> +      previous step. The exception to this rule is the source compose
>> +      rectangle, which refers to the sink compose bounds rectangle ---
>> +      if it is supported by the hardware.</para>
>> +
>> +      <orderedlist>
>> +	<listitem>Sink pad format. The user configures the sink pad
>> +	format. This format defines the parameters of the image the
>> +	entity receives through the pad for further processing.</listitem>
>> +
>> +	<listitem>Sink pad active crop selection. The sink pad crop
>> +	defines the performed to the sink pad format.</listitem>
> 
> s/defines the/defines the cropping/ ?

Fixed.

>> +
>> +	<listitem>Sink pad active compose selection. The size of the
>> +	sink pad compose rectangle defines the scaling ratio compared
>> +	to the size of the sink pad crop rectangle. The location of
>> +	the compose rectangle specifies the location of the active
>> +	sink compose rectangle in the sink compose bounds
>> +	rectangle.</listitem>
>> +
>> +	<listitem>Source pad active crop selection. Crop on the source
>> +	pad defines crop performed to the image in the sink compose
>> +	bounds rectangle.</listitem>
>> +
>> +	<listitem>Source pad format. The source pad format defines the
>> +	output pixel format of the subdev, as well as the other
>> +	parameters with the exception of the image width and height.
>> +	Width and height are defined by the size of the source pad
>> +	active crop selection.</listitem>
>> +      </orderedlist>
>> +
>> +      <para>Accessing any of the above rectangles not supported by the
>> +      subdev will return <constant>EINVAL</constant>.
> 
> Do drivers have to support BOUNDS rectangles for every ACTIVE rectangle they 
> support (and the other way around) ? If so, I think it should be specified.

I think the answer to that should be "yes", albeit this hasn't been
discussed previously. I see no reason not to support equivalent BOUNDS
rectangles.

I'll change the documentation to state that.

> Is EINVAL returned for any other error case in the selection API ? If so, it 
> might make enumeration of the supported rectangles difficult.

Good point. There are two other reasons to return EINVAL and those are
invalid parameters in either pad or which fields. I think that should be
fine. I'd keep it EINVAL.

Alternatively we could use e.g. ENOENT.

What do you think?

>> Any rectangle
>> +      referring to a previous unsupported rectangle coordinates will
>> +      instead refer to the previous supported rectangle. For example,
>> +      if sink crop is not supported, the compose selection will refer
>> +      to the sink pad format dimensions instead.</para>
> 
> Should we add a list of the rectangles a subdev must/should/can support for 
> the different possible use cases ?

I think this should be rather obvious with the examples and the
statement on BOUNDS rectangles. Such a list, if we make it very
detailed, will be unnecessarily redundant and will soon become
out-of-date. In principle I don't like redundancy whether it's code or
documentation. It easily leads to contradictions.

If it turns out it'll be needed we can easily add it later on.

>> +      <figure id="subdev-image-processing-crop">
>> +	<title>Image processing in subdevs: simple crop example</title>
>> +	<mediaobject>
>> +	  <imageobject>
>> +	    <imagedata fileref="subdev-image-processing-crop.svg"
>> +	    format="SVG" scale="200" />
>> +	  </imageobject>
>> +	</mediaobject>
>> +      </figure>
>> +
>> +      <para>In the above example, the subdev supports cropping on its
>> +      sink pad. To configure it, the user sets the media bus format on
>> +      the subdev's sink pad. Now the active crop rectangle can be set
>> +      on the sink pad --- the location and size of this rectangle
>> +      reflect the location and size of a rectangle to be cropped from
>> +      the sink format. The size of the sink crop rectangle will also
>> +      be the size of the format of the subdev's source pad.</para>
>> +
>> +      <figure id="subdev-image-processing-scaling-multi-source">
>> +	<title>Image processing in subdevs: scaling with multiple sources</title>
>> +	<mediaobject>
>> +	  <imageobject>
>> +	    <imagedata fileref="subdev-image-processing-scaling-multi-source.svg"
>> +	    format="SVG" scale="200" />
>> +	  </imageobject>
>> +	</mediaobject>
>> +      </figure>
>> +
>> +      <para>In this example, the subdev is capable of first cropping,
>> +      then scaling and finally cropping for two source pads
>> +      individually from the resulting scaled image. The location of
>> +      the scaled image in the cropped image is ignored in sink compose
>> +      target. Both of the locations of the source crop rectangles
>> +      refer to the sink scaling rectangle, independently cropping an
>> +      area at location specified by the source crop rectangle from
>> +      it.</para>
>> +
>> +      <figure id="subdev-image-processing-full">
>> +	<title>Image processing in subdevs: scaling and composition
>> +	with multiple sinks and sources</title>
>> +	<mediaobject>
>> +	  <imageobject>
>> +	    <imagedata fileref="subdev-image-processing-full.svg"
>> +	    format="SVG" scale="200" />
>> +	  </imageobject>
>> +	</mediaobject>
>> +      </figure>
>> +
>> +      <para>The subdev driver supports two sink pads and two source
>> +      pads. The images from both of the sink pads are individually
>> +      cropped, then scaled and further composed on the composition
>> +      bounds rectangle. From that, two independent streams are cropped
>> +      and sent out of the subdev from the source pads.</para>
>>
>>      </section>
>> +
>>    </section>
>>
>>    &sub-subdev-formats;
> 
> [snip]
> 
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
>> b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml new file
>> mode 100644
>> index 0000000..033077a
>> --- /dev/null
>> +++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
>> @@ -0,0 +1,222 @@
>> +<refentry id="vidioc-subdev-g-selection">
>> +  <refmeta>
>> +    <refentrytitle>ioctl VIDIOC_SUBDEV_G_SELECTION,
>> VIDIOC_SUBDEV_S_SELECTION</refentrytitle> +    &manvol;
>> +  </refmeta>
>> +
>> +  <refnamediv>
>> +    <refname>VIDIOC_SUBDEV_G_SELECTION</refname>
>> +    <refname>VIDIOC_SUBDEV_S_SELECTION</refname>
>> +    <refpurpose>Get or set selection rectangles on a subdev
>> pad</refpurpose> +  </refnamediv>
>> +
>> +  <refsynopsisdiv>
>> +    <funcsynopsis>
>> +      <funcprototype>
>> +	<funcdef>int <function>ioctl</function></funcdef>
>> +	<paramdef>int <parameter>fd</parameter></paramdef>
>> +	<paramdef>int <parameter>request</parameter></paramdef>
>> +	<paramdef>struct v4l2_subdev_selection
>> *<parameter>argp</parameter></paramdef> +      </funcprototype>
>> +    </funcsynopsis>
>> +  </refsynopsisdiv>
>> +
>> +  <refsect1>
>> +    <title>Arguments</title>
>> +
>> +    <variablelist>
>> +      <varlistentry>
>> +	<term><parameter>fd</parameter></term>
>> +	<listitem>
>> +	  <para>&fd;</para>
>> +	</listitem>
>> +      </varlistentry>
>> +      <varlistentry>
>> +	<term><parameter>request</parameter></term>
>> +	<listitem>
>> +	  <para>VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION</para>
>> +	</listitem>
>> +      </varlistentry>
>> +      <varlistentry>
>> +	<term><parameter>argp</parameter></term>
>> +	<listitem>
>> +	  <para></para>
>> +	</listitem>
>> +      </varlistentry>
>> +    </variablelist>
>> +  </refsect1>
>> +
>> +  <refsect1>
>> +    <title>Description</title>
>> +
>> +    <note>
>> +      <title>Experimental</title>
>> +      <para>This is an <link linkend="experimental">experimental</link>
>> +      interface and may change in the future.</para>
>> +    </note>
> 
> I think you forgot to add the subdev selection API to the list of experimental 
> APIs.

Fixed.

>> +    <para>The selections are used to configure various image
>> +    processing functionality performed by the subdevs which affect the
>> +    image size. This currently includes cropping, scaling and
>> +    composition.</para>
>> +
>> +    <para>The selection API replaces <link
>> +    linkend="vidioc-subdev-g-crop">the old subdev crop API</link>. All
>> +    the function of the crop API, and more, are supported by the
>> +    selections API.</para>
>> +
>> +    <para>See <xref linkend="subdev"></xref> for
>> +    more information on how each selection target affects the image
>> +    processing pipeline inside the subdevice.</para>
>> +
>> +    <section>
>> +      <title>Types of selection targets</title>
>> +
>> +      <para>The are four types of selection targets: active, default,
>> +      bounds and padding.
> 
> You don't define any default or padding selection target, should these be 
> removed here ?

These are leftovers from earlier versions of the patch. Removed.

I also corrected the BOUNDS description below.

>> The ACTIVE targets are the targets which
>> +      configure the hardware. The BOUNDS target will return the
>> +      maximum width and height of the target.</para>
>> +    </section>
>> +
>> +    <section>
>> +      <title>Discovering supported features</title>
>> +
>> +      <para>To discover which targets are supported, the user can
>> +      perform <constant>VIDIOC_SUBDEV_G_SELECTION</constant> on them.
>> +      Any unsupported target will return
>> +      <constant>EINVAL</constant>.</para>
>> +    </section>
>> +
>> +    <table pgwide="1" frame="none" id="v4l2-subdev-selection-targets">
>> +      <title>V4L2 subdev selection targets</title>
>> +      <tgroup cols="3">
>> +        &cs-def;
>> +	<tbody valign="top">
>> +	  <row>
>> +	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE</constant></entry>
>> +	    <entry>0x0000</entry>
>> +	    <entry>Active crop. Defines the cropping
>> +	    performed by the processing step.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS</constant></entry>
>> +	    <entry>0x0002</entry>
>> +	    <entry>Bounds of the crop rectangle.</entry>
>> +	  </row>
>> +	  <row>
>> +	    
> <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE</constant></entry>
>> +	    <entry>0x0100</entry>
>> +	    <entry>Active compose rectangle. Used to configure scaling
>> +	    on sink pads and composition on source pads.</entry>
>> +	  </row>
>> +	  <row>
>> +	    
> <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
>> +	    <entry>0x0102</entry>
>> +	    <entry>Bounds of the compose rectangle.</entry>
>> +	  </row>
>> +	</tbody>
>> +      </tgroup>
>> +    </table>
>> +
>> +    <table pgwide="1" frame="none" id="v4l2-subdev-selection-flags">
>> +      <title>V4L2 subdev selection flags</title>
>> +      <tgroup cols="3">
>> +        &cs-def;
>> +	<tbody valign="top">
>> +	  <row>
>> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_GE</constant></entry>
>> +	    <entry>(1 &lt;&lt; 0)</entry>
>> +	    <entry>Suggest the driver it should choose greater or
>> +	    equal rectangle (in size) than was requested.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant></entry>
>> +	    <entry>(1 &lt;&lt; 1)</entry>
>> +	    <entry>Suggest the driver it should choose lesser or
>> +	    equal rectangle (in size) than was requested.</entry>
>> +	  </row>
> 
> Those two flags are only briefly described here, could you add a more detailed 
> description either here or in Documentation/DocBook/media/v4l/dev-subdev.xml ?

Added:

            " Albeit the driver may choose a lesser size,
	    it will only do so due to hardware limitations. Without
	    this flag (and
	    <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant>) the
	    behaviour is to choose the closest possible
	    rectangle."

Does that cover your understanding of a more detailed description? :-)

>> +	  <row>
>> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant></entry>
>> +	    <entry>(1 &lt;&lt; 2)</entry>
>> +	    <entry>The configuration should not be propagated to any
>> +	    further processing steps. If this flag is not given, the
>> +	    configuration is propagated inside the subdevice to all
>> +	    further processing steps.</entry>
>> +	  </row>
>> +	</tbody>
>> +      </tgroup>
>> +    </table>
>> +
>> +    <table pgwide="1" frame="none" id="v4l2-subdev-selection">
>> +      <title>struct <structname>v4l2_subdev_selection</structname></title>
>> +      <tgroup cols="3">
>> +        &cs-str;
>> +	<tbody valign="top">
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>which</structfield></entry>
>> +	    <entry>Active or try selection, from
>> +	    &v4l2-subdev-format-whence;.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>pad</structfield></entry>
>> +	    <entry>Pad number as reported by the media framework.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>target</structfield></entry>
>> +	    <entry>Target selection rectangle. See
>> +	    <xref linkend="v4l2-subdev-selection-targets">.</xref>.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>flags</structfield></entry>
>> +	    <entry>Flags. See
>> +	    <xref linkend="v4l2-subdev-selection-flags">.</xref></entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>&v4l2-rect;</entry>
>> +	    <entry><structfield>rect</structfield></entry>
>> +	    <entry>Crop rectangle boundaries, in pixels.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>reserved</structfield>[8]</entry>
>> +	    <entry>Reserved for future extensions. Applications and drivers must
>> +	    set the array to zero.</entry>
>> +	  </row>
>> +	</tbody>
>> +      </tgroup>
>> +    </table>
>> +
>> +  </refsect1>
>> +
>> +  <refsect1>
>> +    &return-value;
>> +
>> +    <variablelist>
>> +      <varlistentry>
>> +	<term><errorcode>EBUSY</errorcode></term>
>> +	<listitem>
>> +	  <para>The selection rectangle can't be changed because the
>> +	  pad is currently busy. This can be caused, for instance, by
>> +	  an active video stream on the pad. The ioctl must not be
>> +	  retried without performing another action to fix the problem
>> +	  first. Only returned by
>> +	  <constant>VIDIOC_SUBDEV_S_SELECTION</constant></para>
>> +	</listitem>
>> +      </varlistentry>
>> +      <varlistentry>
>> +	<term><errorcode>EINVAL</errorcode></term>
>> +	<listitem>
>> +	  <para>The &v4l2-subdev-selection;
>> +	  <structfield>pad</structfield> references a non-existing
>> +	  pad, the <structfield>which</structfield> field references a
>> +	  non-existing format, or the selection target is not
>> +	  supported on the given subdev pad.</para>
>> +	</listitem>
>> +      </varlistentry>
>> +    </variablelist>
>> +  </refsect1>
>> +</refentry>

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
