Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:35105 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZBCIyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 03:54:33 -0500
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Tue, 3 Feb 2009 14:24:20 +0530
Subject: RE: [PATCH] Documentation update for New V4L2 ioctls for OMAP
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02F54203EE@dbde02.ent.ti.com>
In-Reply-To: <200902030834.21248.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Please find my comment below.

Regards,
Hardik Shah

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, February 03, 2009 1:04 PM
> To: Shah, Hardik
> Cc: linux-media@vger.kernel.org; Jadav, Brijesh R; Nagalla, Hari; Hiremath,
> Vaibhav
> Subject: Re: [PATCH] Documentation update for New V4L2 ioctls for OMAP
> 
> On Tuesday 03 February 2009 07:30:14 Hardik Shah wrote:
> > 1.  Added documentation for VIDIOC_COLOR_S_SPACE_CONV and
> > VIDIOC_G_COLOR_SPACE_CONV
> > 2.  Added documentation for new CID V4L2_CID_ROTATION and
> > V4L2_CID_BG_COLOR
> 
> See comments below.
> 
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > Signed-off-by: Hari Nagalla <hnagalla@ti.com>
> > Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> >  Makefile                       |    4 +
> >  controls.sgml                  |   12 +++-
> >  v4l2.sgml                      |    1 +
> >  vidioc-g-color-space-conv.sgml |  182
> > ++++++++++++++++++++++++++++++++++++++++ 4 files changed, 198
> > insertions(+), 1 deletions(-)
> >  create mode 100644 vidioc-g-color-space-conv.sgml
> >
> > diff --git a/Makefile b/Makefile
> > index 9a13c91..b76b4a7 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -67,6 +67,7 @@ SGMLS = \
> >  	vidioc-g-audio.sgml \
> >  	vidioc-g-audioout.sgml \
> >  	vidioc-dbg-g-chip-ident.sgml \
> > +	vidioc-g-color-space-conv.sgml \
> >  	vidioc-g-crop.sgml \
> >  	vidioc-g-ctrl.sgml \
> >  	vidioc-g-enc-index.sgml \
> > @@ -156,6 +157,7 @@ IOCTLS = \
> >  	VIDIOC_ENUM_FRAMESIZES \
> >  	VIDIOC_G_AUDIO \
> >  	VIDIOC_G_AUDOUT \
> > +	VIDIOC_G_COLOR_SPACE_CONV \
> >  	VIDIOC_G_CROP \
> >  	VIDIOC_G_CTRL \
> >  	VIDIOC_G_ENC_INDEX \
> > @@ -186,6 +188,7 @@ IOCTLS = \
> >  	VIDIOC_STREAMON \
> >  	VIDIOC_S_AUDIO \
> >  	VIDIOC_S_AUDOUT \
> > +	VIDIOC_S_COLOR_SPACE_CONV \
> >  	VIDIOC_S_CROP \
> >  	VIDIOC_S_CTRL \
> >  	VIDIOC_S_EXT_CTRLS \
> > @@ -249,6 +252,7 @@ STRUCTS = \
> >  	v4l2_capability \
> >  	v4l2_captureparm \
> >  	v4l2_clip \
> > +	v4l2_color_space_conv \
> >  	v4l2_control \
> >  	v4l2_crop \
> >  	v4l2_cropcap \
> > diff --git a/controls.sgml b/controls.sgml
> > index 0df57dc..c9ef5e8 100644
> > --- a/controls.sgml
> > +++ b/controls.sgml
> > @@ -272,10 +272,20 @@ minimum value disables backlight
> > compensation.</entry> <entry>Enable the color killer (&ie; force a black
> > &amp; white image in case of a weak video signal).</entry> </row>
> >  	  <row>
> > +	    <entry><constant>V4L2_CID_ROTATION</constant></entry>
> > +	    <entry>integer</entry>
> > +	    <entry>Rotates the image by specified angle.</entry>
> 
> Please specify the units. How does this affect other ioctls like
> VIDIOC_S_FMT when it comes to width/height settings? Depending on how this
> works the VIDIOC_S_FMT documentation might have to refer back to this
> control as well.
> 
> > +	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_CID_BG_COLOR</constant></entry>
> > +	    <entry>integer</entry>
> > +	    <entry>Sets the background color on the current output
> > device</entry> +	  </row>
> 
> How is the color specified? RGB? YUV? See the V4L2_CID_MPEG_VIDEO_MUTE_YUV
> control description on how to specify the color format exactly.
> 
> > +	  <row>
> >  	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
> >  	    <entry></entry>
> >  	    <entry>End of the predefined control IDs (currently
> > -<constant>V4L2_CID_COLOR_KILLER</constant> + 1).</entry>
> > +<constant>V4L2_CID_BG_COLOR</constant> + 1).</entry>
> >  	  </row>
> >  	  <row>
> >  	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
> > diff --git a/v4l2.sgml b/v4l2.sgml
> > index 9f43b6d..f9f0986 100644
> > --- a/v4l2.sgml
> > +++ b/v4l2.sgml
> > @@ -435,6 +435,7 @@ available here: <ulink
> > url="http://linuxtv.org/downloads/video4linux/API/V4L2_AP &sub-querystd;
> >      &sub-reqbufs;
> >      &sub-s-hw-freq-seek;
> > +    &sub-g-color-space-conv;
> >      &sub-streamon;
> >      <!-- End of ioctls. -->
> >      &sub-mmap;
> > diff --git a/vidioc-g-color-space-conv.sgml
> > b/vidioc-g-color-space-conv.sgml new file mode 100644
> > index 0000000..a24ae4c
> > --- /dev/null
> > +++ b/vidioc-g-color-space-conv.sgml
> > @@ -0,0 +1,182 @@
> > +<refentry id="vidioc-g-color-space-conv">
> > +  <refmeta>
> > +    <refentrytitle>ioctl VIDIOC_S_COLOR_SPACE_CONV,
> > VIDIOC_G_COLOR_SPACE_CONV</refentrytitle> +    &manvol;
> > +  </refmeta>
> > +
> > +  <refnamediv>
> > +    <refname>VIDIOC_S_COLOR_SPACE_CONV</refname>
> > +    <refname>VIDIOC_G_COLOR_SPACE_CONV</refname>
> > +    <refpurpose>Get or Set the color space conversion matrix
> > </refpurpose> +  </refnamediv>
> > +
> > +  <refsynopsisdiv>
> > +    <funcsynopsis>
> > +      <funcprototype>
> > +	<funcdef>int <function>ioctl</function></funcdef>
> > +	<paramdef>int <parameter>fd</parameter></paramdef>
> > +	<paramdef>int <parameter>request</parameter></paramdef>
> > +	<paramdef>struct v4l2_color_space_conv
> > +*<parameter>argp</parameter></paramdef>
> > +      </funcprototype>
> > +    </funcsynopsis>
> > +  </refsynopsisdiv>
> > +
> > +  <refsect1>
> > +    <title>Arguments</title>
> > +
> > +    <variablelist>
> > +      <varlistentry>
> > +	<term><parameter>fd</parameter></term>
> > +	<listitem>
> > +	  <para>&fd;</para>
> > +	</listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +	<term><parameter>request</parameter></term>
> > +	<listitem>
> > +	  <para>VIDIOC_G_COLOR_SPACE_CONV, VIDIOC_S_COLOR_SPACE_CONV</para>
> > +	</listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +	<term><parameter>argp</parameter></term>
> > +	<listitem>
> > +	  <para></para>
> > +	</listitem>
> > +      </varlistentry>
> > +    </variablelist>
> > +  </refsect1>
> > +
> > +  <refsect1>
> > +    <title>Description</title>
> > +
> > +    <para>This ioctl is used to set the color space conversion matrix.
> > +Few Video hardware has a programmable color space conversion matrix
> > which +converts the data from one color space to other color space
> > +typically from YUV or UYVY to RGB and vice versa.
> 
> 'UYVY' is not a colorspace, it's a pixelformat. You probably want to say
> something like: 'SMPTE170M or sRGB'.
[Shah, Hardik] I agree. I will change this.
> 
> > Normally hardware has
> > +default value for the conversion matrix but application may need to tune
> > that. +    </para>
> > +	<para>Typical color conversion matrix looks like</para>
> > +
> > +	<formalpara>
> > +	    <title>Typical color space conversion matrix equation.</title>
> > +		<para>
> > +		<informaltable frame="none">
> > +		<tgroup cols="15" align="center">
> > +		  <colspec align="left" colwidth="1*">
> > +		  <tbody valign="top">
> > +		    <row>
> > +		      <entry>|</entry>
> > +		      <entry>O<subscript>0</subscript></entry>
> > +		      <entry>|</entry>
> > +		      <entry></entry>
> > +			  <entry></entry>
> > +			  <entry></entry>
> > +		      <entry>|</entry>
> > +			  <entry>C<subscript>0,0</subscript></entry>
> > +		      <entry>C<subscript>0,1</subscript></entry>
> > +		      <entry>C<subscript>0,2</subscript></entry>
> > +		      <entry>|</entry>
> > +		      <entry></entry>
> > +			  <entry>|</entry>
> > +		      <entry>Of<subscript>0</subscript></entry>
> > +		      <entry>|</entry>
> > +		    </row>
> > +		    <row>
> > +		      <entry>|</entry>
> > +		      <entry>O<subscript>1</subscript></entry>
> > +		      <entry>|</entry>
> > +		      <entry></entry>
> > +			  <entry>=</entry>
> > +			  <entry>K</entry>
> > +		      <entry>|</entry>
> > +			  <entry>C<subscript>1,0</subscript></entry>
> > +		      <entry>C<subscript>1,1</subscript></entry>
> > +		      <entry>C<subscript>1,2</subscript></entry>
> > +		      <entry>|</entry>
> > +		      <entry>*</entry>
> > +			  <entry>|</entry>
> > +		      <entry>Of<subscript>1</subscript></entry>
> > +		      <entry>|</entry>
> > +		    </row>
> > +			 <row>
> > +		      <entry>|</entry>
> > +		      <entry>O<subscript>2</subscript></entry>
> > +		      <entry>|</entry>
> > +		      <entry></entry>
> > +			  <entry></entry>
> > +			  <entry></entry>
> > +		      <entry>|</entry>
> > +			  <entry>C<subscript>2,0</subscript></entry>
> > +		      <entry>C<subscript>2,1</subscript></entry>
> > +		      <entry>C<subscript>2,2</subscript></entry>
> > +		      <entry>|</entry>
> > +		      <entry></entry>
> > +			  <entry>|</entry>
> > +		      <entry>Of<subscript>2</subscript></entry>
> > +		      <entry>|</entry>
> > +		    </row>
> > +		  </tbody>
> > +		</tgroup>
> > +		</informaltable>
> > +		</para>
> > +	  </formalpara>
> > +
> > +	<para>Where Ci,j are the coefficients, K is the constant factor and
> > +Ofi is the  offsets.  All the hardware may not allow modifying
> > +all of these parameters.</para>
> > +
> > +	<para>To set values for the color conversion matrix, applications call
> > +<constant>VIDIOC_S_COLOR_SPACE_CONV</constant> with the pointer to a
> > +<structname>v4l2_color_space_conv</structname> structure.  Driver
> > +checks and updates the parameters in the hardware. To get the values
> > +applications call <constant>VIDIOC_G_COLOR_SPACE_CONV</constant> with a
> > pointer +to <structname>v4l2_color_space_conv</structname> and driver
> > will fill the +structure with appropriate values.</para>
> 
> What is the precision of the coefficients? (e.g. 8, 16, 32 bits?)
[Shah, Hardik] Currently on omap the coefficient precison is 11 bit.  
> 
> How do you know if not all parameters can be modified? Is this a problem at
> all or can we assume that using this ioctl means you know what the hardware
> is anyway?
[Shah, Hardik] Currently OMAP allows modification of only coefficients but I am not sure about any  other hardware which allows modification of any other parameters like offsets and constants which appears in the conversion equation.  That's why I kept all the parameters as programmable.  
> 
> How does this relate to the colorspace field in v4l2_pix_format and
> VIDIOC_S_FMT?
[Shah, Hardik] color space conversion is internal to the hardware.  Hardware can take any pixel format irrespective of the color space conversion matrix.  But OMAP requires the final data that is given to the compositor in the form of RGB only.  For this if the pixel format is YUV or UYVY than it needs to be converted to RGB before giving it to the compositor.  So this matrix will convert the YUV to RGB using the programmed coefficients.

We can chat on IRC if required.  I am already logged in.

> 
> > +
> > +    <table pgwide="1" frame="none" id="v4l2-color-space-conv">
> > +      <title>struct
> > <structname>v4l2_color_space_conv</structname></title> +      <tgroup
> > cols="3">
> > +	&cs-str;
> > +	<tbody valign="top">
> > +	  <row>
> > +	    <entry>__s32</entry>
> > +	    <entry><structfield>coefficients</structfield></entry>
> > +	    <entry>Conversion Matrix coefficeints. It is a array of
> > 3X3.</entry> +	  </row>
> > +	  <row>
> > +	    <entry>__s32</entry>
> > +	    <entry><structfield>const_factor</structfield></entry>
> > +	    <entry>Constant to be multiplied with the conversion
> > matrix.</entry> +	  </row>
> > +	  <row>
> > +	    <entry>__s32</entry>
> > +	    <entry><structfield>offsets</structfield></entry>
> > +	    <entry>Offset for the each entry in color conversion
> > matrix.</entry> +	  </row>
> > +	</tbody>
> > +      </tgroup>
> > +    </table>
> > +  </refsect1>
> > +
> > +  <refsect1>
> > +    &return-value;
> > +
> > +    <variablelist>
> > +      <varlistentry>
> > +	<term><errorcode>EINVAL</errorcode></term>
> > +	<listitem>
> > +	  <para>The hardware doesn't supports color space conversion.</para>
> > +	</listitem>
> > +      </varlistentry>
> > +    </variablelist>
> > +  </refsect1>
> > +</refentry>
> > +
> > +<!--
> > +Local Variables:
> > +mode: sgml
> > +sgml-parent-document: "v4l2.sgml"
> > +indent-tabs-mode: nil
> > +End:
> > +-->
> > --
> > 1.5.6
> 
> Regards,
> 
> 	Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

