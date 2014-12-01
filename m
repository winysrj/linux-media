Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:35410 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbaLAJEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 04:04:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 4/9] DocBook media: rewrite the Colorspace chapter
Date: Mon,  1 Dec 2014 10:03:48 +0100
Message-Id: <1417424633-15781-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417424633-15781-1-git-send-email-hverkuil@xs4all.nl>
References: <1417424633-15781-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The colorspace chapter in the V4L2 Specification was always poorly
written. This patch rewrites it, documenting the new Y'CbCr encoding
and quantization defines and going into much more detail with respect
to how colorspaces are used and what it all means.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/biblio.xml |   85 ++
 Documentation/DocBook/media/v4l/pixfmt.xml | 1274 +++++++++++++++++++++-------
 2 files changed, 1052 insertions(+), 307 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index d2eb79e..7ff01a2 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -178,6 +178,75 @@ Signal - NTSC for Studio Applications"</title>
 1125-Line High-Definition Production"</title>
     </biblioentry>
 
+    <biblioentry id="srgb">
+      <abbrev>sRGB</abbrev>
+      <authorgroup>
+	<corpauthor>International Electrotechnical Commission
+(<ulink url="http://www.iec.ch">http://www.iec.ch</ulink>)</corpauthor>
+      </authorgroup>
+      <title>IEC 61966-2-1 ed1.0 "Multimedia systems and equipment - Colour measurement
+and management - Part 2-1: Colour management - Default RGB colour space - sRGB"</title>
+    </biblioentry>
+
+    <biblioentry id="sycc">
+      <abbrev>sYCC</abbrev>
+      <authorgroup>
+	<corpauthor>International Electrotechnical Commission
+(<ulink url="http://www.iec.ch">http://www.iec.ch</ulink>)</corpauthor>
+      </authorgroup>
+      <title>IEC 61966-2-1-am1 ed1.0 "Amendment 1 - Multimedia systems and equipment - Colour measurement
+and management - Part 2-1: Colour management - Default RGB colour space - sRGB"</title>
+    </biblioentry>
+
+    <biblioentry id="xvycc">
+      <abbrev>xvYCC</abbrev>
+      <authorgroup>
+	<corpauthor>International Electrotechnical Commission
+(<ulink url="http://www.iec.ch">http://www.iec.ch</ulink>)</corpauthor>
+      </authorgroup>
+      <title>IEC 61966-2-4 ed1.0 "Multimedia systems and equipment - Colour measurement
+and management - Part 2-4: Colour management - Extended-gamut YCC colour space for video
+applications - xvYCC"</title>
+    </biblioentry>
+
+    <biblioentry id="adobergb">
+      <abbrev>AdobeRGB</abbrev>
+      <authorgroup>
+	<corpauthor>Adobe Systems Incorporated (<ulink url="http://www.adobe.com">http://www.adobe.com</ulink>)</corpauthor>
+      </authorgroup>
+      <title>Adobe&copy; RGB (1998) Color Image Encoding Version 2005-05</title>
+    </biblioentry>
+
+    <biblioentry id="oprgb">
+      <abbrev>opRGB</abbrev>
+      <authorgroup>
+	<corpauthor>International Electrotechnical Commission
+(<ulink url="http://www.iec.ch">http://www.iec.ch</ulink>)</corpauthor>
+      </authorgroup>
+      <title>IEC 61966-2-5 "Multimedia systems and equipment - Colour measurement
+and management - Part 2-5: Colour management - Optional RGB colour space - opRGB"</title>
+    </biblioentry>
+
+    <biblioentry id="itu2020">
+      <abbrev>ITU&nbsp;BT.2020</abbrev>
+      <authorgroup>
+	<corpauthor>International Telecommunication Union (<ulink
+url="http://www.itu.ch">http://www.itu.ch</ulink>)</corpauthor>
+      </authorgroup>
+      <title>ITU-R Recommendation BT.2020 (08/2012) "Parameter values for ultra-high
+definition television systems for production and international programme exchange"
+</title>
+    </biblioentry>
+
+    <biblioentry id="tech3213">
+      <abbrev>EBU&nbsp;Tech&nbsp;3213</abbrev>
+      <authorgroup>
+	<corpauthor>European Broadcast Union (<ulink
+url="http://www.ebu.ch">http://www.ebu.ch</ulink>)</corpauthor>
+      </authorgroup>
+      <title>E.B.U. Standard for Chromaticity Tolerances for Studio Monitors"</title>
+    </biblioentry>
+
     <biblioentry id="iec62106">
       <abbrev>IEC&nbsp;62106</abbrev>
       <authorgroup>
@@ -266,4 +335,20 @@ in the frequency range from 87,5 to 108,0 MHz</title>
       <subtitle>Version 1, Revision 2</subtitle>
     </biblioentry>
 
+    <biblioentry id="poynton">
+      <abbrev>poynton</abbrev>
+      <authorgroup>
+	<corpauthor>Charles Poynton</corpauthor>
+      </authorgroup>
+      <title>Digital Video and HDTV, Algorithms and Interfaces</title>
+    </biblioentry>
+
+    <biblioentry id="colimg">
+      <abbrev>colimg</abbrev>
+      <authorgroup>
+	<corpauthor>Erik Reinhard et al.</corpauthor>
+      </authorgroup>
+      <title>Color Imaging: Fundamentals and Applications</title>
+    </biblioentry>
+
   </bibliography>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index df5b23d..ccf6053 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -296,343 +296,1003 @@ in the 2-planar version or with each component in its own buffer in the
   <section id="colorspaces">
     <title>Colorspaces</title>
 
-    <para>[intro]</para>
+    <para>'Color' is a very complex concept and depends on physics, chemistry and
+biology. Just because you have three numbers that describe the 'red', 'green'
+and 'blue' components of the color of a pixel does not mean that you can accurately
+display that color. A colorspace defines what it actually <emphasis>means</emphasis>
+to have an RGB value of e.g. (255,&nbsp;0,&nbsp;0). That is, which color should be
+reproduced on the screen in a perfectly calibrated environment.</para>
 
-    <!-- See proposal by Billy Biggs, video4linux-list@redhat.com
-on 11 Oct 2002, subject: "Re: [V4L] Re: v4l2 api", and
-http://vektor.theorem.ca/graphics/ycbcr/ and
-http://www.poynton.com/notes/colour_and_gamma/ColorFAQ.html -->
+    <para>In order to do that we first need to have a good definition of
+color, i.e. some way to uniquely and unambiguously define a color so that someone
+else can reproduce it. Human color vision is trichromatic since the human eye has
+color receptors that are sensitive to three different wavelengths of light. Hence
+the need to use three numbers to describe color. Be glad you are not a mantis shrimp
+as those are sensitive to 12 different wavelengths, so instead of RGB we would be
+using the ABCDEFGHIJKL colorspace...</para>
 
-    <para>
-      <variablelist>
-	<varlistentry>
-	  <term>Gamma Correction</term>
-	  <listitem>
-	    <para>[to do]</para>
-	    <para>E'<subscript>R</subscript> = f(R)</para>
-	    <para>E'<subscript>G</subscript> = f(G)</para>
-	    <para>E'<subscript>B</subscript> = f(B)</para>
-	  </listitem>
-	</varlistentry>
-	<varlistentry>
-	  <term>Construction of luminance and color-difference
-signals</term>
-	  <listitem>
-	    <para>[to do]</para>
-	    <para>E'<subscript>Y</subscript> =
-Coeff<subscript>R</subscript> E'<subscript>R</subscript>
-+ Coeff<subscript>G</subscript> E'<subscript>G</subscript>
-+ Coeff<subscript>B</subscript> E'<subscript>B</subscript></para>
-	    <para>(E'<subscript>R</subscript> - E'<subscript>Y</subscript>) = E'<subscript>R</subscript>
-- Coeff<subscript>R</subscript> E'<subscript>R</subscript>
-- Coeff<subscript>G</subscript> E'<subscript>G</subscript>
-- Coeff<subscript>B</subscript> E'<subscript>B</subscript></para>
-	    <para>(E'<subscript>B</subscript> - E'<subscript>Y</subscript>) = E'<subscript>B</subscript>
-- Coeff<subscript>R</subscript> E'<subscript>R</subscript>
-- Coeff<subscript>G</subscript> E'<subscript>G</subscript>
-- Coeff<subscript>B</subscript> E'<subscript>B</subscript></para>
-	  </listitem>
-	</varlistentry>
-	<varlistentry>
-	  <term>Re-normalized color-difference signals</term>
-	  <listitem>
-	    <para>The color-difference signals are scaled back to unity
-range [-0.5;+0.5]:</para>
-	    <para>K<subscript>B</subscript> = 0.5 / (1 - Coeff<subscript>B</subscript>)</para>
-	    <para>K<subscript>R</subscript> = 0.5 / (1 - Coeff<subscript>R</subscript>)</para>
-	    <para>P<subscript>B</subscript> =
-K<subscript>B</subscript> (E'<subscript>B</subscript> - E'<subscript>Y</subscript>) =
-  0.5 (Coeff<subscript>R</subscript> / Coeff<subscript>B</subscript>) E'<subscript>R</subscript>
-+ 0.5 (Coeff<subscript>G</subscript> / Coeff<subscript>B</subscript>) E'<subscript>G</subscript>
-+ 0.5 E'<subscript>B</subscript></para>
-	    <para>P<subscript>R</subscript> =
-K<subscript>R</subscript> (E'<subscript>R</subscript> - E'<subscript>Y</subscript>) =
-  0.5 E'<subscript>R</subscript>
-+ 0.5 (Coeff<subscript>G</subscript> / Coeff<subscript>R</subscript>) E'<subscript>G</subscript>
-+ 0.5 (Coeff<subscript>B</subscript> / Coeff<subscript>R</subscript>) E'<subscript>B</subscript></para>
-	  </listitem>
-	</varlistentry>
-	<varlistentry>
-	  <term>Quantization</term>
-	  <listitem>
-	    <para>[to do]</para>
-	    <para>Y' = (Lum. Levels - 1) &middot; E'<subscript>Y</subscript> + Lum. Offset</para>
-	    <para>C<subscript>B</subscript> = (Chrom. Levels - 1)
-&middot; P<subscript>B</subscript> + Chrom. Offset</para>
-	    <para>C<subscript>R</subscript> = (Chrom. Levels - 1)
-&middot; P<subscript>R</subscript> + Chrom. Offset</para>
-	    <para>Rounding to the nearest integer and clamping to the range
-[0;255] finally yields the digital color components Y'CbCr
-stored in YUV images.</para>
-	  </listitem>
-	</varlistentry>
-      </variablelist>
-    </para>
-
-    <example>
-      <title>ITU-R Rec. BT.601 color conversion</title>
-
-      <para>Forward Transformation</para>
-
-      <programlisting>
-int ER, EG, EB;         /* gamma corrected RGB input [0;255] */
-int Y1, Cb, Cr;         /* output [0;255] */
-
-double r, g, b;         /* temporaries */
-double y1, pb, pr;
-
-int
-clamp (double x)
-{
-	int r = x;      /* round to nearest */
-
-	if (r &lt; 0)         return 0;
-	else if (r &gt; 255)  return 255;
-	else               return r;
-}
-
-r = ER / 255.0;
-g = EG / 255.0;
-b = EB / 255.0;
-
-y1  =  0.299  * r + 0.587 * g + 0.114  * b;
-pb  = -0.169  * r - 0.331 * g + 0.5    * b;
-pr  =  0.5    * r - 0.419 * g - 0.081  * b;
-
-Y1 = clamp (219 * y1 + 16);
-Cb = clamp (224 * pb + 128);
-Cr = clamp (224 * pr + 128);
-
-/* or shorter */
-
-y1 = 0.299 * ER + 0.587 * EG + 0.114 * EB;
-
-Y1 = clamp ( (219 / 255.0)                    *       y1  + 16);
-Cb = clamp (((224 / 255.0) / (2 - 2 * 0.114)) * (EB - y1) + 128);
-Cr = clamp (((224 / 255.0) / (2 - 2 * 0.299)) * (ER - y1) + 128);
-      </programlisting>
-
-      <para>Inverse Transformation</para>
-
-      <programlisting>
-int Y1, Cb, Cr;         /* gamma pre-corrected input [0;255] */
-int ER, EG, EB;         /* output [0;255] */
-
-double r, g, b;         /* temporaries */
-double y1, pb, pr;
-
-int
-clamp (double x)
-{
-	int r = x;      /* round to nearest */
-
-	if (r &lt; 0)         return 0;
-	else if (r &gt; 255)  return 255;
-	else               return r;
-}
-
-y1 = (Y1 - 16) / 219.0;
-pb = (Cb - 128) / 224.0;
-pr = (Cr - 128) / 224.0;
-
-r = 1.0 * y1 + 0     * pb + 1.402 * pr;
-g = 1.0 * y1 - 0.344 * pb - 0.714 * pr;
-b = 1.0 * y1 + 1.772 * pb + 0     * pr;
-
-ER = clamp (r * 255); /* [ok? one should prob. limit y1,pb,pr] */
-EG = clamp (g * 255);
-EB = clamp (b * 255);
-      </programlisting>
-    </example>
-
-    <table pgwide="1" id="v4l2-colorspace" orient="land">
-      <title>enum v4l2_colorspace</title>
-      <tgroup cols="11" align="center">
-	<colspec align="left" />
-	<colspec align="center" />
-	<colspec align="left" />
-	<colspec colname="cr" />
-	<colspec colname="cg" />
-	<colspec colname="cb" />
-	<colspec colname="wp" />
-	<colspec colname="gc" />
-	<colspec colname="lum" />
-	<colspec colname="qy" />
-	<colspec colname="qc" />
-	<spanspec namest="cr" nameend="cb" spanname="chrom" />
-	<spanspec namest="qy" nameend="qc" spanname="quant" />
-	<spanspec namest="lum" nameend="qc" spanname="spam" />
+    <para>Color exists only in the eye and brain and is the result of how strongly
+color receptors are stimulated. This is based on the Spectral
+Power Distribution (SPD) which is a graph showing the intensity (radiant power)
+of the light at wavelengths covering the visible spectrum as it enters the eye.
+The science of colorimetry is about the relationship between the SPD and color as
+perceived by the human brain.</para>
+
+    <para>Since the human eye has only three color receptors it is perfectly
+possible that different SPDs will result in the same stimulation of those receptors
+and are perceived as the same color, even though the SPD of the light is
+different.</para>
+
+   <para>In the 1920s experiments were devised to determine the relationship
+between SPDs and the perceived color and that resulted in the CIE 1931 standard
+that defines spectral weighting functions that model the perception of color.
+Specifically that standard defines functions that can take an SPD and calculate
+the stimulus for each color receptor. After some further mathematical transforms
+these stimuli are known as the <emphasis>CIE XYZ tristimulus</emphasis> values
+and these X, Y and Z values describe a color as perceived by a human unambiguously.
+These X, Y and Z values are all in the range [0&hellip;1].</para>
+
+   <para>The Y value in the CIE XYZ colorspace corresponds to luminance. Often
+the CIE XYZ colorspace is transformed to the normalized CIE xyY colorspace:</para>
+
+   <para>x = X / (X + Y + Z)</para>
+   <para>y = Y / (X + Y + Z)</para>
+
+   <para>The x and y values are the chromaticity coordinates and can be used to
+define a color without the luminance component Y. It is very confusing to
+have such similar names for these colorspaces. Just be aware that if colors
+are specified with lower case 'x' and 'y', then the CIE xyY colorspace is
+used. Upper case 'X' and 'Y' refer to the CIE XYZ colorspace. Also, y has nothing
+to do with luminance. Together x and y specify a color, and Y the luminance.
+That is really all you need to remember from a practical point of view. At
+the end of this section you will find reading resources that go into much more
+detail if you are interested.
+</para>
+
+   <para>A monitor or TV will reproduce colors by emitting light at three
+different wavelengths, the combination of which will stimulate the color receptors
+in the eye and thus cause the perception of color. Historically these wavelengths
+were defined by the red, green and blue phosphors used in the displays. These
+<emphasis>color primaries</emphasis> are part of what defines a colorspace.</para>
+
+    <para>Different display devices will have different primaries and some
+primaries are more suitable for some display technologies than others. This has
+resulted in a variety of colorspaces that are used for different display
+technologies or uses. To define a colorspace you need to define the three
+color primaries (these are typically defined as x,&nbsp;y chromaticity coordinates
+from the CIE xyY colorspace) but also the white reference: that is the color obtained
+when all three primaries are at maximum power. This determines the relative power
+or energy of the primaries. This is usually chosen to be close to daylight which has
+been defined as the CIE D65 Illuminant.</para>
+
+    <para>To recapitulate: the CIE XYZ colorspace uniquely identifies colors.
+Other colorspaces are defined by three chromaticity coordinates defined in the
+CIE xyY colorspace. Based on those a 3x3 matrix can be constructed that
+transforms CIE XYZ colors to colors in the new colorspace.
+</para>
+
+    <para>Both the CIE XYZ and the RGB colorspace that are derived from the
+specific chromaticity primaries are linear colorspaces. But neither the eye,
+nor display technology is linear. Doubling the values of all components in
+the linear colorspace will not be perceived as twice the intensity of the color.
+So each colorspace also defines a transfer function that takes a linear color
+component value and transforms it to the non-linear component value, which is a
+closer match to the non-linear performance of both the eye and displays. Linear
+component values are denoted RGB, non-linear are denoted as R'G'B'. In general
+colors used in graphics are all R'G'B', except in openGL which uses linear RGB.
+Special care should be taken when dealing with openGL to provide linear RGB colors
+or to use the built-in openGL support to apply the inverse transfer function.</para>
+
+    <para>The final piece that defines a colorspace is a function that
+transforms non-linear R'G'B' to non-linear Y'CbCr. This function is determined
+by the so-called luma coefficients. There may be multiple possible Y'CbCr
+encodings allowed for the same colorspace. Many encodings of color
+prefer to use luma (Y') and chroma (CbCr) instead of R'G'B'. Since the human
+eye is more sensitive to differences in luminance than in color this encoding
+allows one to reduce the amount of color information compared to the luma
+data. Note that the luma (Y') is unrelated to the Y in the CIE XYZ colorspace.
+Also note that Y'CbCr is often called YCbCr or YUV even though these are
+strictly speaking wrong.</para>
+
+    <para>Sometimes people confuse Y'CbCr as being a colorspace. This is not
+correct, it is just an encoding of an R'G'B' color into luma and chroma
+values. The underlying colorspace that is associated with the R'G'B' color
+is also associated with the Y'CbCr color.</para>
+
+    <para>The final step is how the RGB, R'G'B' or Y'CbCr values are
+quantized. The CIE XYZ colorspace where X, Y and Z are in the range
+[0&hellip;1] describes all colors that humans can perceive, but the transform to
+another colorspace will produce colors that are outside the [0&hellip;1] range.
+Once clamped to the [0&hellip;1] range those colors can no longer be reproduced
+in that colorspace. This clamping is what reduces the extent or gamut of the
+colorspace. How the range of [0&hellip;1] is translated to integer values in the
+range of [0&hellip;255] (or higher, depending on the color depth) is called the
+quantization. This is <emphasis>not</emphasis> part of the colorspace
+definition. In practice RGB or R'G'B' values are full range, i.e. they
+use the full [0&hellip;255] range. Y'CbCr values on the other hand are limited
+range with Y' using [16&hellip;235] and Cb and Cr using [16&hellip;240].</para>
+
+    <para>Unfortunately, in some cases limited range RGB is also used
+where the components use the range [16&hellip;235]. And full range Y'CbCr also exists
+using the [0&hellip;255] range.</para>
+
+    <para>In order to correctly interpret a color you need to know the
+quantization range, whether it is R'G'B' or Y'CbCr, the used Y'CbCr encoding
+and the colorspace.
+From that information you can calculate the corresponding CIE XYZ color
+and map that again to whatever colorspace your display device uses.</para>
+
+    <para>The colorspace definition itself consists of the three
+chromaticity primaries, the white reference chromaticity, a transfer
+function and the luma coefficients needed to transform R'G'B' to Y'CbCr. While
+some colorspace standards correctly define all four, quite often the colorspace
+standard only defines some, and you have to rely on other standards for
+the missing pieces. The fact that colorspaces are often a mix of different
+standards also led to very confusing naming conventions where the name of
+a standard was used to name a colorspace when in fact that standard was
+part of various other colorspaces as well.</para>
+
+    <para>If you want to read more about colors and colorspaces, then the
+following resources are useful: <xref linkend="poynton" /> is a good practical
+book for video engineers, <xref linkend="colimg" /> has a much broader scope and
+describes many more aspects of color (physics, chemistry, biology, etc.).
+The <ulink url="http://www.brucelindbloom.com">http://www.brucelindbloom.com</ulink>
+website is an excellent resource, especially with respect to the mathematics behind
+colorspace conversions. The wikipedia <ulink url="http://en.wikipedia.org/wiki/CIE_1931_color_space#CIE_xy_chromaticity_diagram_and_the_CIE_xyY_color_space">CIE 1931 colorspace</ulink> article
+is also very useful.</para>
+  </section>
+
+  <section>
+    <title>Defining Colorspaces in V4L2</title>
+    <para>In V4L2 colorspaces are defined by three values. The first is the colorspace
+identifier (&v4l2-colorspace;) which defines the chromaticities, the transfer
+function, the default Y'CbCr encoding and the default quantization method. The second
+is the Y'CbCr encoding identifier (&v4l2-ycbcr-encoding;) to specify non-standard
+Y'CbCr encodings and the third is the quantization identifier (&v4l2-quantization;)
+to specify non-standard quantization methods. Most of the time only the colorspace
+field of &v4l2-pix-format; or &v4l2-pix-format-mplane; needs to be filled in. Note
+that the default R'G'B' quantization is always full range for all colorspaces,
+so this won't be mentioned explicitly for each colorspace description.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-colorspace">
+      <title>V4L2 Colorspaces</title>
+      <tgroup cols="2" align="left">
+	&cs-def;
 	<thead>
 	  <row>
-	    <entry morerows="1">Identifier</entry>
-	    <entry morerows="1">Value</entry>
-	    <entry morerows="1">Description</entry>
-	    <entry spanname="chrom">Chromaticities<footnote>
-		<para>The coordinates of the color primaries are
-given in the CIE system (1931)</para>
-	      </footnote></entry>
-	    <entry morerows="1">White Point</entry>
-	    <entry morerows="1">Gamma Correction</entry>
-	    <entry morerows="1">Luminance E'<subscript>Y</subscript></entry>
-	    <entry spanname="quant">Quantization</entry>
-	  </row>
-	  <row>
-	    <entry>Red</entry>
-	    <entry>Green</entry>
-	    <entry>Blue</entry>
-	    <entry>Y'</entry>
-	    <entry>Cb, Cr</entry>
+	    <entry>Identifier</entry>
+	    <entry>Details</entry>
 	  </row>
 	</thead>
 	<tbody valign="top">
 	  <row>
 	    <entry><constant>V4L2_COLORSPACE_SMPTE170M</constant></entry>
-	    <entry>1</entry>
-	    <entry>NTSC/PAL according to <xref linkend="smpte170m" />,
-<xref linkend="itu601" /></entry>
-	    <entry>x&nbsp;=&nbsp;0.630, y&nbsp;=&nbsp;0.340</entry>
-	    <entry>x&nbsp;=&nbsp;0.310, y&nbsp;=&nbsp;0.595</entry>
-	    <entry>x&nbsp;=&nbsp;0.155, y&nbsp;=&nbsp;0.070</entry>
-	    <entry>x&nbsp;=&nbsp;0.3127, y&nbsp;=&nbsp;0.3290,
-	    Illuminant D<subscript>65</subscript></entry>
-	    <entry>E' = 4.5&nbsp;I&nbsp;for&nbsp;I&nbsp;&le;0.018,
-1.099&nbsp;I<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;0.018&nbsp;&lt;&nbsp;I</entry>
-	    <entry>0.299&nbsp;E'<subscript>R</subscript>
-+&nbsp;0.587&nbsp;E'<subscript>G</subscript>
-+&nbsp;0.114&nbsp;E'<subscript>B</subscript></entry>
-	    <entry>219&nbsp;E'<subscript>Y</subscript>&nbsp;+&nbsp;16</entry>
-	    <entry>224&nbsp;P<subscript>B,R</subscript>&nbsp;+&nbsp;128</entry>
+	    <entry>See <xref linkend="col-smpte-170m" />.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_COLORSPACE_SMPTE240M</constant></entry>
-	    <entry>2</entry>
-	    <entry>1125-Line (US) HDTV, see <xref
-linkend="smpte240m" /></entry>
-	    <entry>x&nbsp;=&nbsp;0.630, y&nbsp;=&nbsp;0.340</entry>
-	    <entry>x&nbsp;=&nbsp;0.310, y&nbsp;=&nbsp;0.595</entry>
-	    <entry>x&nbsp;=&nbsp;0.155, y&nbsp;=&nbsp;0.070</entry>
-	    <entry>x&nbsp;=&nbsp;0.3127, y&nbsp;=&nbsp;0.3290,
-	    Illuminant D<subscript>65</subscript></entry>
-	    <entry>E' = 4&nbsp;I&nbsp;for&nbsp;I&nbsp;&le;0.0228,
-1.1115&nbsp;I<superscript>0.45</superscript>&nbsp;-&nbsp;0.1115&nbsp;for&nbsp;0.0228&nbsp;&lt;&nbsp;I</entry>
-	    <entry>0.212&nbsp;E'<subscript>R</subscript>
-+&nbsp;0.701&nbsp;E'<subscript>G</subscript>
-+&nbsp;0.087&nbsp;E'<subscript>B</subscript></entry>
-	    <entry>219&nbsp;E'<subscript>Y</subscript>&nbsp;+&nbsp;16</entry>
-	    <entry>224&nbsp;P<subscript>B,R</subscript>&nbsp;+&nbsp;128</entry>
+	    <entry><constant>V4L2_COLORSPACE_REC709</constant></entry>
+	    <entry>See <xref linkend="col-rec709" />.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_COLORSPACE_REC709</constant></entry>
-	    <entry>3</entry>
-	    <entry>HDTV and modern devices, see <xref
-linkend="itu709" /></entry>
-	    <entry>x&nbsp;=&nbsp;0.640, y&nbsp;=&nbsp;0.330</entry>
-	    <entry>x&nbsp;=&nbsp;0.300, y&nbsp;=&nbsp;0.600</entry>
-	    <entry>x&nbsp;=&nbsp;0.150, y&nbsp;=&nbsp;0.060</entry>
-	    <entry>x&nbsp;=&nbsp;0.3127, y&nbsp;=&nbsp;0.3290,
-	    Illuminant D<subscript>65</subscript></entry>
-	    <entry>E' = 4.5&nbsp;I&nbsp;for&nbsp;I&nbsp;&le;0.018,
-1.099&nbsp;I<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;0.018&nbsp;&lt;&nbsp;I</entry>
-	    <entry>0.2125&nbsp;E'<subscript>R</subscript>
-+&nbsp;0.7154&nbsp;E'<subscript>G</subscript>
-+&nbsp;0.0721&nbsp;E'<subscript>B</subscript></entry>
-	    <entry>219&nbsp;E'<subscript>Y</subscript>&nbsp;+&nbsp;16</entry>
-	    <entry>224&nbsp;P<subscript>B,R</subscript>&nbsp;+&nbsp;128</entry>
+	    <entry><constant>V4L2_COLORSPACE_SRGB</constant></entry>
+	    <entry>See <xref linkend="col-srgb" />.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_COLORSPACE_BT878</constant></entry>
-	    <entry>4</entry>
-	    <entry>Broken Bt878 extents<footnote>
-		<para>The ubiquitous Bt878 video capture chip
-quantizes E'<subscript>Y</subscript> to 238 levels, yielding a range
-of Y' = 16 &hellip; 253, unlike Rec. 601 Y' = 16 &hellip;
-235. This is not a typo in the Bt878 documentation, it has been
-implemented in silicon. The chroma extents are unclear.</para>
-	      </footnote>, <xref linkend="itu601" /></entry>
-	    <entry>?</entry>
-	    <entry>?</entry>
-	    <entry>?</entry>
-	    <entry>?</entry>
-	    <entry>?</entry>
-	    <entry>0.299&nbsp;E'<subscript>R</subscript>
-+&nbsp;0.587&nbsp;E'<subscript>G</subscript>
-+&nbsp;0.114&nbsp;E'<subscript>B</subscript></entry>
-	    <entry><emphasis>237</emphasis>&nbsp;E'<subscript>Y</subscript>&nbsp;+&nbsp;16</entry>
-	    <entry>224&nbsp;P<subscript>B,R</subscript>&nbsp;+&nbsp;128 (probably)</entry>
+	    <entry><constant>V4L2_COLORSPACE_ADOBERGB</constant></entry>
+	    <entry>See <xref linkend="col-adobergb" />.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_COLORSPACE_BT2020</constant></entry>
+	    <entry>See <xref linkend="col-bt2020" />.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_COLORSPACE_SMPTE240M</constant></entry>
+	    <entry>See <xref linkend="col-smpte-240m" />.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_COLORSPACE_470_SYSTEM_M</constant></entry>
-	    <entry>5</entry>
-	    <entry>M/NTSC<footnote>
-		<para>No identifier exists for M/PAL which uses
-the chromaticities of M/NTSC, the remaining parameters are equal to B and
-G/PAL.</para>
-	      </footnote> according to <xref linkend="itu470" />, <xref
-		linkend="itu601" /></entry>
-	    <entry>x&nbsp;=&nbsp;0.67, y&nbsp;=&nbsp;0.33</entry>
-	    <entry>x&nbsp;=&nbsp;0.21, y&nbsp;=&nbsp;0.71</entry>
-	    <entry>x&nbsp;=&nbsp;0.14, y&nbsp;=&nbsp;0.08</entry>
-	    <entry>x&nbsp;=&nbsp;0.310, y&nbsp;=&nbsp;0.316, Illuminant C</entry>
-	    <entry>?</entry>
-	    <entry>0.299&nbsp;E'<subscript>R</subscript>
-+&nbsp;0.587&nbsp;E'<subscript>G</subscript>
-+&nbsp;0.114&nbsp;E'<subscript>B</subscript></entry>
-	    <entry>219&nbsp;E'<subscript>Y</subscript>&nbsp;+&nbsp;16</entry>
-	    <entry>224&nbsp;P<subscript>B,R</subscript>&nbsp;+&nbsp;128</entry>
+	    <entry>See <xref linkend="col-sysm" />.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_COLORSPACE_470_SYSTEM_BG</constant></entry>
-	    <entry>6</entry>
-	    <entry>625-line PAL and SECAM systems according to <xref
-linkend="itu470" />, <xref linkend="itu601" /></entry>
-	    <entry>x&nbsp;=&nbsp;0.64, y&nbsp;=&nbsp;0.33</entry>
-	    <entry>x&nbsp;=&nbsp;0.29, y&nbsp;=&nbsp;0.60</entry>
-	    <entry>x&nbsp;=&nbsp;0.15, y&nbsp;=&nbsp;0.06</entry>
-	    <entry>x&nbsp;=&nbsp;0.313, y&nbsp;=&nbsp;0.329,
-Illuminant D<subscript>65</subscript></entry>
-	    <entry>?</entry>
-	    <entry>0.299&nbsp;E'<subscript>R</subscript>
-+&nbsp;0.587&nbsp;E'<subscript>G</subscript>
-+&nbsp;0.114&nbsp;E'<subscript>B</subscript></entry>
-	    <entry>219&nbsp;E'<subscript>Y</subscript>&nbsp;+&nbsp;16</entry>
-	    <entry>224&nbsp;P<subscript>B,R</subscript>&nbsp;+&nbsp;128</entry>
+	    <entry>See <xref linkend="col-sysbg" />.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_COLORSPACE_JPEG</constant></entry>
-	    <entry>7</entry>
-	    <entry>JPEG Y'CbCr, see <xref linkend="jfif" />, <xref linkend="itu601" /></entry>
-	    <entry>?</entry>
-	    <entry>?</entry>
-	    <entry>?</entry>
-	    <entry>?</entry>
-	    <entry>?</entry>
-	    <entry>0.299&nbsp;E'<subscript>R</subscript>
-+&nbsp;0.587&nbsp;E'<subscript>G</subscript>
-+&nbsp;0.114&nbsp;E'<subscript>B</subscript></entry>
-	    <entry>256&nbsp;E'<subscript>Y</subscript>&nbsp;+&nbsp;16<footnote>
-		<para>Note JFIF quantizes
-Y'P<subscript>B</subscript>P<subscript>R</subscript> in range [0;+1] and
-[-0.5;+0.5] to <emphasis>257</emphasis> levels, however Y'CbCr signals
-are still clamped to [0;255].</para>
-	      </footnote></entry>
-	    <entry>256&nbsp;P<subscript>B,R</subscript>&nbsp;+&nbsp;128</entry>
+	    <entry>See <xref linkend="col-jpeg" />.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="v4l2-ycbcr-encoding">
+      <title>V4L2 Y'CbCr Encodings</title>
+      <tgroup cols="2" align="left">
+	&cs-def;
+	<thead>
+	  <row>
+	    <entry>Identifier</entry>
+	    <entry>Details</entry>
 	  </row>
+	</thead>
+	<tbody valign="top">
 	  <row>
-	    <entry><constant>V4L2_COLORSPACE_SRGB</constant></entry>
-	    <entry>8</entry>
-	    <entry>[?]</entry>
-	    <entry>x&nbsp;=&nbsp;0.640, y&nbsp;=&nbsp;0.330</entry>
-	    <entry>x&nbsp;=&nbsp;0.300, y&nbsp;=&nbsp;0.600</entry>
-	    <entry>x&nbsp;=&nbsp;0.150, y&nbsp;=&nbsp;0.060</entry>
-	    <entry>x&nbsp;=&nbsp;0.3127, y&nbsp;=&nbsp;0.3290,
-	    Illuminant D<subscript>65</subscript></entry>
-	    <entry>E' = 4.5&nbsp;I&nbsp;for&nbsp;I&nbsp;&le;0.018,
-1.099&nbsp;I<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;0.018&nbsp;&lt;&nbsp;I</entry>
-	    <entry spanname="spam">n/a</entry>
+	    <entry><constant>V4L2_YCBCR_ENC_DEFAULT</constant></entry>
+	    <entry>Use the default Y'CbCr encoding as defined by the colorspace.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_YCBCR_ENC_601</constant></entry>
+	    <entry>Use the BT.601 Y'CbCr encoding.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_YCBCR_ENC_709</constant></entry>
+	    <entry>Use the Rec. 709 Y'CbCr encoding.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_YCBCR_ENC_XV601</constant></entry>
+	    <entry>Use the extended gamut xvYCC BT.601 encoding.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_YCBCR_ENC_XV709</constant></entry>
+	    <entry>Use the extended gamut xvYCC Rec. 709 encoding.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_YCBCR_ENC_SYCC</constant></entry>
+	    <entry>Use the extended gamut sYCC encoding.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_YCBCR_ENC_BT2020</constant></entry>
+	    <entry>Use the default non-constant luminance BT.2020 Y'CbCr encoding.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_YCBCR_ENC_BT2020_CONST_LUM</constant></entry>
+	    <entry>Use the constant luminance BT.2020 Yc'CbcCrc encoding.</entry>
 	  </row>
 	</tbody>
       </tgroup>
     </table>
+
+    <table pgwide="1" frame="none" id="v4l2-quantization">
+      <title>V4L2 Quantization Methods</title>
+      <tgroup cols="2" align="left">
+	&cs-def;
+	<thead>
+	  <row>
+	    <entry>Identifier</entry>
+	    <entry>Details</entry>
+	  </row>
+	</thead>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_QUANTIZATION_DEFAULT</constant></entry>
+	    <entry>Use the default quantization encoding as defined by the colorspace.
+This is always full range for R'G'B' and usually limited range for Y'CbCr.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_QUANTIZATION_FULL_RANGE</constant></entry>
+	    <entry>Use the full range quantization encoding. I.e. the range [0&hellip;1]
+is mapped to [0&hellip;255] (with possible clipping to [1&hellip;254] to avoid the
+0x00 and 0xff values). Cb and Cr are mapped from [-0.5&hellip;0.5] to [0&hellip;255]
+(with possible clipping to [1&hellip;254] to avoid the 0x00 and 0xff values).</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_QUANTIZATION_LIM_RANGE</constant></entry>
+	    <entry>Use the limited range quantization encoding. I.e. the range [0&hellip;1]
+is mapped to [16&hellip;235]. Cb and Cr are mapped from [-0.5&hellip;0.5] to [16&hellip;240].
+</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+  </section>
+
+  <section>
+    <title>Detailed Colorspace Descriptions</title>
+    <section>
+      <title id="col-smpte-170m">Colorspace SMPTE 170M (<constant>V4L2_COLORSPACE_SMPTE170M</constant>)</title>
+      <para>The <xref linkend="smpte170m" /> standard defines the colorspace used by NTSC and PAL and by SDTV
+in general. The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_601</constant>.
+The default Y'CbCr quantization is limited range. The chromaticities of the primary colors and
+the white reference are:</para>
+      <table frame="none">
+        <title>SMPTE 170M Chromaticities</title>
+        <tgroup cols="3" align="left">
+          &cs-str;
+    	<thead>
+    	  <row>
+    	    <entry>Color</entry>
+    	    <entry>x</entry>
+    	    <entry>y</entry>
+    	  </row>
+    	</thead>
+          <tbody valign="top">
+            <row>
+              <entry>Red</entry>
+              <entry>0.630</entry>
+              <entry>0.340</entry>
+            </row>
+            <row>
+              <entry>Green</entry>
+              <entry>0.310</entry>
+              <entry>0.595</entry>
+            </row>
+            <row>
+              <entry>Blue</entry>
+              <entry>0.155</entry>
+              <entry>0.070</entry>
+            </row>
+            <row>
+              <entry>White Reference (D65)</entry>
+              <entry>0.3127</entry>
+              <entry>0.3290</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+      <para>The red, green and blue chromaticities are also often referred to
+as the SMPTE C set, so this colorspace is sometimes called SMPTE C as well.</para>
+      <variablelist>
+	<varlistentry>
+          <term>The transfer function defined for SMPTE 170M is the same as the
+one defined in Rec. 709. Normally L is in the range [0&hellip;1], but for the extended
+gamut xvYCC encoding values outside that range are allowed.</term>
+	  <listitem>
+            <para>L' = -1.099(-L)<superscript>0.45</superscript>&nbsp;+&nbsp;0.099&nbsp;for&nbsp;L&nbsp;&le;&nbsp;-0.018</para>
+            <para>L' = 4.5L&nbsp;for&nbsp;-0.018&nbsp;&lt;&nbsp;L&nbsp;&lt;&nbsp;0.018</para>
+            <para>L' = 1.099L<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;L&nbsp;&ge;&nbsp;0.018</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = -((L'&nbsp;-&nbsp;0.099)&nbsp;/&nbsp;-1.099)<superscript>1/0.45</superscript>&nbsp;for&nbsp;L'&nbsp;&le;&nbsp;-0.081</para>
+            <para>L = L'&nbsp;/&nbsp;4.5&nbsp;for&nbsp;-0.081&nbsp;&lt;&nbsp;L'&nbsp;&lt;&nbsp;0.081</para>
+            <para>L = ((L'&nbsp;+&nbsp;0.099)&nbsp;/&nbsp;1.099)<superscript>1/0.45</superscript>&nbsp;for&nbsp;L'&nbsp;&ge;&nbsp;0.081</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>The luminance (Y') and color difference (Cb and Cr) are obtained with
+the following <constant>V4L2_YCBCR_ENC_601</constant> encoding:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;0.299R'&nbsp;+&nbsp;0.587G'&nbsp;+&nbsp;0.114B'</para>
+            <para>Cb&nbsp;=&nbsp;-0.169R'&nbsp;-&nbsp;0.331G'&nbsp;+&nbsp;0.5B'</para>
+            <para>Cr&nbsp;=&nbsp;0.5R'&nbsp;-&nbsp;0.419G'&nbsp;-&nbsp;0.081B'</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are
+clamped to the range [-0.5&hellip;0.5]. This conversion to Y'CbCr is identical to the one
+defined in the <xref linkend="itu601" /> standard and this colorspace is sometimes called BT.601 as well, even
+though BT.601 does not mention any color primaries.</para>
+      <para>The default quantization is limited range, but full range is possible although
+rarely seen.</para>
+      <para>The <constant>V4L2_YCBCR_ENC_601</constant> encoding as described above is the
+default for this colorspace, but it can be overridden with <constant>V4L2_YCBCR_ENC_709</constant>,
+in which case the Rec. 709 Y'CbCr encoding is used.</para>
+      <variablelist>
+	<varlistentry>
+      	  <term>The xvYCC 601 encoding (<constant>V4L2_YCBCR_ENC_XV601</constant>, <xref linkend="xvycc" />) is similar
+to the BT.601 encoding, but it allows for R', G' and B' values that are outside the range
+[0&hellip;1]. The resulting Y', Cb and Cr values are scaled and offset:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;(219&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.299R'&nbsp;+&nbsp;0.587G'&nbsp;+&nbsp;0.114B')&nbsp;+&nbsp;(16&nbsp;/&nbsp;255)</para>
+            <para>Cb&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(-0.169R'&nbsp;-&nbsp;0.331G'&nbsp;+&nbsp;0.5B')</para>
+            <para>Cr&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.5R'&nbsp;-&nbsp;0.419G'&nbsp;-&nbsp;0.081B')</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are clamped
+to the range [-0.5&hellip;0.5]. The non-standard xvYCC 709 encoding can also be used by selecting
+<constant>V4L2_YCBCR_ENC_XV709</constant>. The xvYCC encodings always use full range
+quantization.</para>
+    </section>
+
+    <section>
+      <title id="col-rec709">Colorspace Rec. 709 (<constant>V4L2_COLORSPACE_REC709</constant>)</title>
+      <para>The <xref linkend="itu709" /> standard defines the colorspace used by HDTV in general. The default
+Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_709</constant>. The default Y'CbCr quantization is
+limited range. The chromaticities of the primary colors and the white reference are:</para>
+      <table frame="none">
+        <title>Rec. 709 Chromaticities</title>
+        <tgroup cols="3" align="left">
+          &cs-str;
+    	<thead>
+    	  <row>
+    	    <entry>Color</entry>
+    	    <entry>x</entry>
+    	    <entry>y</entry>
+    	  </row>
+    	</thead>
+          <tbody valign="top">
+            <row>
+              <entry>Red</entry>
+              <entry>0.640</entry>
+              <entry>0.330</entry>
+            </row>
+            <row>
+              <entry>Green</entry>
+              <entry>0.300</entry>
+              <entry>0.600</entry>
+            </row>
+            <row>
+              <entry>Blue</entry>
+              <entry>0.150</entry>
+              <entry>0.060</entry>
+            </row>
+            <row>
+              <entry>White Reference (D65)</entry>
+              <entry>0.3127</entry>
+              <entry>0.3290</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+      <para>The full name of this standard is Rec. ITU-R BT.709-5.</para>
+      <variablelist>
+	<varlistentry>
+          <term>Transfer function. Normally L is in the range [0&hellip;1], but for the extended
+gamut xvYCC encoding values outside that range are allowed.</term>
+	  <listitem>
+            <para>L' = -1.099(-L)<superscript>0.45</superscript>&nbsp;+&nbsp;0.099&nbsp;for&nbsp;L&nbsp;&le;&nbsp;-0.018</para>
+            <para>L' = 4.5L&nbsp;for&nbsp;-0.018&nbsp;&lt;&nbsp;L&nbsp;&lt;&nbsp;0.018</para>
+            <para>L' = 1.099L<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;L&nbsp;&ge;&nbsp;0.018</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = -((L'&nbsp;-&nbsp;0.099)&nbsp;/&nbsp;-1.099)<superscript>1/0.45</superscript>&nbsp;for&nbsp;L'&nbsp;&le;&nbsp;-0.081</para>
+            <para>L = L'&nbsp;/&nbsp;4.5&nbsp;for&nbsp;-0.081&nbsp;&lt;&nbsp;L'&nbsp;&lt;&nbsp;0.081</para>
+            <para>L = ((L'&nbsp;+&nbsp;0.099)&nbsp;/&nbsp;1.099)<superscript>1/0.45</superscript>&nbsp;for&nbsp;L'&nbsp;&ge;&nbsp;0.081</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>The luminance (Y') and color difference (Cb and Cr) are obtained with the following
+<constant>V4L2_YCBCR_ENC_709</constant> encoding:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;0.2126R'&nbsp;+&nbsp;0.7152G'&nbsp;+&nbsp;0.0722B'</para>
+            <para>Cb&nbsp;=&nbsp;-0.1146R'&nbsp;-&nbsp;0.3854G'&nbsp;+&nbsp;0.5B'</para>
+            <para>Cr&nbsp;=&nbsp;0.5R'&nbsp;-&nbsp;0.4542G'&nbsp;-&nbsp;0.0458B'</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are
+clamped to the range [-0.5&hellip;0.5].</para>
+      <para>The default quantization is limited range, but full range is possible although
+rarely seen.</para>
+      <para>The <constant>V4L2_YCBCR_ENC_709</constant> encoding described above is the default
+for this colorspace, but it can be overridden with <constant>V4L2_YCBCR_ENC_601</constant>, in which
+case the BT.601 Y'CbCr encoding is used.</para>
+      <variablelist>
+	<varlistentry>
+      	  <term>The xvYCC 709 encoding (<constant>V4L2_YCBCR_ENC_XV709</constant>, <xref linkend="xvycc" />)
+is similar to the Rec. 709 encoding, but it allows for R', G' and B' values that are outside the range
+[0&hellip;1]. The resulting Y', Cb and Cr values are scaled and offset:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;(219&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.2126R'&nbsp;+&nbsp;0.7152G'&nbsp;+&nbsp;0.0722B')&nbsp;+&nbsp;(16&nbsp;/&nbsp;255)</para>
+            <para>Cb&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(-0.1146R'&nbsp;-&nbsp;0.3854G'&nbsp;+&nbsp;0.5B')</para>
+            <para>Cr&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.5R'&nbsp;-&nbsp;0.4542G'&nbsp;-&nbsp;0.0458B')</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are clamped
+to the range [-0.5&hellip;0.5]. The non-standard xvYCC 601 encoding can also be used by
+selecting <constant>V4L2_YCBCR_ENC_XV601</constant>. The xvYCC encodings always use full
+range quantization.</para>
+    </section>
+
+    <section>
+      <title id="col-srgb">Colorspace sRGB (<constant>V4L2_COLORSPACE_SRGB</constant>)</title>
+      <para>The <xref linkend="srgb" /> standard defines the colorspace used by most webcams and computer graphics. The
+default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_SYCC</constant>. The default Y'CbCr quantization
+is full range. The chromaticities of the primary colors and the white reference are:</para>
+      <table frame="none">
+        <title>sRGB Chromaticities</title>
+        <tgroup cols="3" align="left">
+          &cs-str;
+    	<thead>
+    	  <row>
+    	    <entry>Color</entry>
+    	    <entry>x</entry>
+    	    <entry>y</entry>
+    	  </row>
+    	</thead>
+          <tbody valign="top">
+            <row>
+              <entry>Red</entry>
+              <entry>0.640</entry>
+              <entry>0.330</entry>
+            </row>
+            <row>
+              <entry>Green</entry>
+              <entry>0.300</entry>
+              <entry>0.600</entry>
+            </row>
+            <row>
+              <entry>Blue</entry>
+              <entry>0.150</entry>
+              <entry>0.060</entry>
+            </row>
+            <row>
+              <entry>White Reference (D65)</entry>
+              <entry>0.3127</entry>
+              <entry>0.3290</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+      <para>These chromaticities are identical to the Rec. 709 colorspace.</para>
+      <variablelist>
+	<varlistentry>
+          <term>Transfer function. Note that negative values for L are only used by the Y'CbCr conversion.</term>
+	  <listitem>
+            <para>L' = -1.055(-L)<superscript>1/2.4</superscript>&nbsp;+&nbsp;0.055&nbsp;for&nbsp;L&nbsp;&lt;&nbsp;-0.0031308</para>
+            <para>L' = 12.92L&nbsp;for&nbsp;-0.0031308&nbsp;&le;&nbsp;L&nbsp;&le;&nbsp;0.0031308</para>
+            <para>L' = 1.055L<superscript>1/2.4</superscript>&nbsp;-&nbsp;0.055&nbsp;for&nbsp;0.0031308&nbsp;&lt;&nbsp;L&nbsp;&le;&nbsp;1</para>
+	  </listitem>
+	</varlistentry>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = -((-L'&nbsp;+&nbsp;0.055)&nbsp;/&nbsp;1.055)<superscript>2.4</superscript>&nbsp;for&nbsp;L'&nbsp;&lt;&nbsp;-0.04045</para>
+            <para>L = L'&nbsp;/&nbsp;12.92&nbsp;for&nbsp;-0.04045&nbsp;&le;&nbsp;L'&nbsp;&le;&nbsp;0.04045</para>
+            <para>L = ((L'&nbsp;+&nbsp;0.055)&nbsp;/&nbsp;1.055)<superscript>2.4</superscript>&nbsp;for&nbsp;L'&nbsp;&gt;&nbsp;0.04045</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>The luminance (Y') and color difference (Cb and Cr) are obtained with the following
+<constant>V4L2_YCBCR_ENC_SYCC</constant> encoding as defined by <xref linkend="sycc" />:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;0.2990R'&nbsp;+&nbsp;0.5870G'&nbsp;+&nbsp;0.1140B'</para>
+            <para>Cb&nbsp;=&nbsp;-0.1687R'&nbsp;-&nbsp;0.3313G'&nbsp;+&nbsp;0.5B'</para>
+            <para>Cr&nbsp;=&nbsp;0.5R'&nbsp;-&nbsp;0.4187G'&nbsp;-&nbsp;0.0813B'</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are clamped
+to the range [-0.5&hellip;0.5]. The <constant>V4L2_YCBCR_ENC_SYCC</constant> quantization is always
+full range. Although this Y'CbCr encoding looks very similar to the <constant>V4L2_YCBCR_ENC_XV601</constant>
+encoding, it is not. The <constant>V4L2_YCBCR_ENC_XV601</constant> scales and offsets the Y'CbCr
+values before quantization, but this encoding does not do that.</para>
+    </section>
+
+    <section>
+      <title id="col-adobergb">Colorspace Adobe RGB (<constant>V4L2_COLORSPACE_ADOBERGB</constant>)</title>
+      <para>The <xref linkend="adobergb" /> standard defines the colorspace used by computer graphics
+that use the AdobeRGB colorspace. This is also known as the <xref linkend="oprgb" /> standard.
+The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_601</constant>. The default Y'CbCr
+quantization is limited range. The chromaticities of the primary colors and the white reference
+are:</para>
+      <table frame="none">
+        <title>Adobe RGB Chromaticities</title>
+        <tgroup cols="3" align="left">
+          &cs-str;
+    	<thead>
+    	  <row>
+    	    <entry>Color</entry>
+    	    <entry>x</entry>
+    	    <entry>y</entry>
+    	  </row>
+    	</thead>
+          <tbody valign="top">
+            <row>
+              <entry>Red</entry>
+              <entry>0.6400</entry>
+              <entry>0.3300</entry>
+            </row>
+            <row>
+              <entry>Green</entry>
+              <entry>0.2100</entry>
+              <entry>0.7100</entry>
+            </row>
+            <row>
+              <entry>Blue</entry>
+              <entry>0.1500</entry>
+              <entry>0.0600</entry>
+            </row>
+            <row>
+              <entry>White Reference (D65)</entry>
+              <entry>0.3127</entry>
+              <entry>0.3290</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+      <variablelist>
+	<varlistentry>
+          <term>Transfer function:</term>
+	  <listitem>
+            <para>L' = L<superscript>1/2.19921875</superscript></para>
+	  </listitem>
+	</varlistentry>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = L'<superscript>2.19921875</superscript></para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>The luminance (Y') and color difference (Cb and Cr) are obtained with the
+following <constant>V4L2_YCBCR_ENC_601</constant> encoding:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;0.299R'&nbsp;+&nbsp;0.587G'&nbsp;+&nbsp;0.114B'</para>
+            <para>Cb&nbsp;=&nbsp;-0.169R'&nbsp;-&nbsp;0.331G'&nbsp;+&nbsp;0.5B'</para>
+            <para>Cr&nbsp;=&nbsp;0.5R'&nbsp;-&nbsp;0.419G'&nbsp;-&nbsp;0.081B'</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are
+clamped to the range [-0.5&hellip;0.5]. This transform is identical to one defined in
+SMPTE 170M/BT.601. The Y'CbCr quantization is limited range.</para>
+    </section>
+
+    <section>
+      <title id="col-bt2020">Colorspace BT.2020 (<constant>V4L2_COLORSPACE_BT2020</constant>)</title>
+      <para>The <xref linkend="itu2020" /> standard defines the colorspace used by Ultra-high definition
+television (UHDTV). The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_BT2020</constant>.
+The default Y'CbCr quantization is limited range. The chromaticities of the primary colors and
+the white reference are:</para>
+      <table frame="none">
+        <title>BT.2020 Chromaticities</title>
+        <tgroup cols="3" align="left">
+          &cs-str;
+    	<thead>
+    	  <row>
+    	    <entry>Color</entry>
+    	    <entry>x</entry>
+    	    <entry>y</entry>
+    	  </row>
+    	</thead>
+          <tbody valign="top">
+            <row>
+              <entry>Red</entry>
+              <entry>0.708</entry>
+              <entry>0.292</entry>
+            </row>
+            <row>
+              <entry>Green</entry>
+              <entry>0.170</entry>
+              <entry>0.797</entry>
+            </row>
+            <row>
+              <entry>Blue</entry>
+              <entry>0.131</entry>
+              <entry>0.046</entry>
+            </row>
+            <row>
+              <entry>White Reference (D65)</entry>
+              <entry>0.3127</entry>
+              <entry>0.3290</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+      <variablelist>
+	<varlistentry>
+          <term>Transfer function (same as Rec. 709):</term>
+	  <listitem>
+            <para>L' = 4.5L&nbsp;for&nbsp;0&nbsp;&le;&nbsp;L&nbsp;&lt;&nbsp;0.018</para>
+            <para>L' = 1.099L<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;0.018&nbsp;&le;&nbsp;L&nbsp;&le;&nbsp;1</para>
+	  </listitem>
+	</varlistentry>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = L'&nbsp;/&nbsp;4.5&nbsp;for&nbsp;L'&nbsp;&lt;&nbsp;0.081</para>
+            <para>L = ((L'&nbsp;+&nbsp;0.099)&nbsp;/&nbsp;1.099)<superscript>1/0.45</superscript>&nbsp;for&nbsp;L'&nbsp;&ge;&nbsp;0.081</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>The luminance (Y') and color difference (Cb and Cr) are obtained with the
+following <constant>V4L2_YCBCR_ENC_BT2020</constant> encoding:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;0.2627R'&nbsp;+&nbsp;0.6789G'&nbsp;+&nbsp;0.0593B'</para>
+            <para>Cb&nbsp;=&nbsp;-0.1396R'&nbsp;-&nbsp;0.3604G'&nbsp;+&nbsp;0.5B'</para>
+            <para>Cr&nbsp;=&nbsp;0.5R'&nbsp;-&nbsp;0.4598G'&nbsp;-&nbsp;0.0402B'</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are
+clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range.</para>
+      <para>There is also an alternate constant luminance R'G'B' to Yc'CbcCrc
+(<constant>V4L2_YCBCR_ENC_BT2020_CONST_LUM</constant>) encoding:</para>
+      <variablelist>
+	<varlistentry>
+      	  <term>Luma:</term>
+	  <listitem>
+            <para>Yc'&nbsp;=&nbsp;(0.2627R&nbsp;+&nbsp;0.6789G&nbsp;+&nbsp;0.0593B)'</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>B'&nbsp;-&nbsp;Yc'&nbsp;&le;&nbsp;0:</term>
+	  <listitem>
+            <para>Cbc&nbsp;=&nbsp;(B'&nbsp;-&nbsp;Y')&nbsp;/&nbsp;1.9404</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>B'&nbsp;-&nbsp;Yc'&nbsp;&gt;&nbsp;0:</term>
+	  <listitem>
+            <para>Cbc&nbsp;=&nbsp;(B'&nbsp;-&nbsp;Y')&nbsp;/&nbsp;1.5816</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>R'&nbsp;-&nbsp;Yc'&nbsp;&le;&nbsp;0:</term>
+	  <listitem>
+            <para>Crc&nbsp;=&nbsp;(R'&nbsp;-&nbsp;Y')&nbsp;/&nbsp;1.7184</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>R'&nbsp;-&nbsp;Yc'&nbsp;&gt;&nbsp;0:</term>
+	  <listitem>
+            <para>Crc&nbsp;=&nbsp;(R'&nbsp;-&nbsp;Y')&nbsp;/&nbsp;0.9936</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Yc' is clamped to the range [0&hellip;1] and Cbc and Crc are
+clamped to the range [-0.5&hellip;0.5]. The Yc'CbcCrc quantization is limited range.</para>
+    </section>
+
+    <section>
+      <title id="col-smpte-240m">Colorspace SMPTE 240M (<constant>V4L2_COLORSPACE_SMPTE240M</constant>)</title>
+      <para>The <xref linkend="smpte240m" /> standard was an interim standard used during the early days of HDTV (1988-1998).
+It has been superseded by Rec. 709. The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_SMPTE240M</constant>.
+The default Y'CbCr quantization is limited range. The chromaticities of the primary colors and the
+white reference are:</para>
+      <table frame="none">
+        <title>SMPTE 240M Chromaticities</title>
+        <tgroup cols="3" align="left">
+          &cs-str;
+    	<thead>
+    	  <row>
+    	    <entry>Color</entry>
+    	    <entry>x</entry>
+    	    <entry>y</entry>
+    	  </row>
+    	</thead>
+          <tbody valign="top">
+            <row>
+              <entry>Red</entry>
+              <entry>0.630</entry>
+              <entry>0.340</entry>
+            </row>
+            <row>
+              <entry>Green</entry>
+              <entry>0.310</entry>
+              <entry>0.595</entry>
+            </row>
+            <row>
+              <entry>Blue</entry>
+              <entry>0.155</entry>
+              <entry>0.070</entry>
+            </row>
+            <row>
+              <entry>White Reference (D65)</entry>
+              <entry>0.3127</entry>
+              <entry>0.3290</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+      <para>These chromaticities are identical to the SMPTE 170M colorspace.</para>
+      <variablelist>
+	<varlistentry>
+          <term>Transfer function:</term>
+	  <listitem>
+            <para>L' = 4L&nbsp;for&nbsp;0&nbsp;&le;&nbsp;L&nbsp;&lt;&nbsp;0.0228</para>
+            <para>L' = 1.1115L<superscript>0.45</superscript>&nbsp;-&nbsp;0.1115&nbsp;for&nbsp;0.0228&nbsp;&le;&nbsp;L&nbsp;&le;&nbsp;1</para>
+	  </listitem>
+	</varlistentry>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = L'&nbsp;/&nbsp;4&nbsp;for&nbsp;0&nbsp;&le;&nbsp;L'&nbsp;&lt;&nbsp;0.0913</para>
+            <para>L = ((L'&nbsp;+&nbsp;0.1115)&nbsp;/&nbsp;1.1115)<superscript>1/0.45</superscript>&nbsp;for&nbsp;L'&nbsp;&ge;&nbsp;0.0913</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>The luminance (Y') and color difference (Cb and Cr) are obtained with the
+following <constant>V4L2_YCBCR_ENC_SMPTE240M</constant> encoding:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;0.2122R'&nbsp;+&nbsp;0.7013G'&nbsp;+&nbsp;0.0865B'</para>
+            <para>Cb&nbsp;=&nbsp;-0.1161R'&nbsp;-&nbsp;0.3839G'&nbsp;+&nbsp;0.5B'</para>
+            <para>Cr&nbsp;=&nbsp;0.5R'&nbsp;-&nbsp;0.4451G'&nbsp;-&nbsp;0.0549B'</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Yc' is clamped to the range [0&hellip;1] and Cbc and Crc are
+clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range.</para>
+    </section>
+
+    <section>
+      <title id="col-sysm">Colorspace NTSC 1953 (<constant>V4L2_COLORSPACE_470_SYSTEM_M</constant>)</title>
+      <para>This standard defines the colorspace used by NTSC in 1953. In practice this
+colorspace is obsolete and SMPTE 170M should be used instead. The default Y'CbCr encoding
+is <constant>V4L2_YCBCR_ENC_601</constant>. The default Y'CbCr quantization is limited range.
+The chromaticities of the primary colors and the white reference are:</para>
+      <table frame="none">
+        <title>NTSC 1953 Chromaticities</title>
+        <tgroup cols="3" align="left">
+          &cs-str;
+    	<thead>
+    	  <row>
+    	    <entry>Color</entry>
+    	    <entry>x</entry>
+    	    <entry>y</entry>
+    	  </row>
+    	</thead>
+          <tbody valign="top">
+            <row>
+              <entry>Red</entry>
+              <entry>0.67</entry>
+              <entry>0.33</entry>
+            </row>
+            <row>
+              <entry>Green</entry>
+              <entry>0.21</entry>
+              <entry>0.71</entry>
+            </row>
+            <row>
+              <entry>Blue</entry>
+              <entry>0.14</entry>
+              <entry>0.08</entry>
+            </row>
+            <row>
+              <entry>White Reference (C)</entry>
+              <entry>0.310</entry>
+              <entry>0.316</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+      <para>Note that this colorspace uses Illuminant C instead of D65 as the
+white reference. To correctly convert an image in this colorspace to another
+that uses D65 you need to apply a chromatic adaptation algorithm such as the
+Bradford method.</para>
+      <variablelist>
+	<varlistentry>
+          <term>The transfer function was never properly defined for NTSC 1953. The
+Rec. 709 transfer function is recommended in the literature:</term>
+	  <listitem>
+            <para>L' = 4.5L&nbsp;for&nbsp;0&nbsp;&le;&nbsp;L&nbsp;&lt;&nbsp;0.018</para>
+            <para>L' = 1.099L<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;0.018&nbsp;&le;&nbsp;L&nbsp;&le;&nbsp;1</para>
+	  </listitem>
+	</varlistentry>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = L'&nbsp;/&nbsp;4.5&nbsp;for&nbsp;L'&nbsp;&lt;&nbsp;0.081</para>
+            <para>L = ((L'&nbsp;+&nbsp;0.099)&nbsp;/&nbsp;1.099)<superscript>1/0.45</superscript>&nbsp;for&nbsp;L'&nbsp;&ge;&nbsp;0.081</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>The luminance (Y') and color difference (Cb and Cr) are obtained with the
+following <constant>V4L2_YCBCR_ENC_601</constant> encoding:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;0.299R'&nbsp;+&nbsp;0.587G'&nbsp;+&nbsp;0.114B'</para>
+            <para>Cb&nbsp;=&nbsp;-0.169R'&nbsp;-&nbsp;0.331G'&nbsp;+&nbsp;0.5B'</para>
+            <para>Cr&nbsp;=&nbsp;0.5R'&nbsp;-&nbsp;0.419G'&nbsp;-&nbsp;0.081B'</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are
+clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range.
+This transform is identical to one defined in SMPTE 170M/BT.601.</para>
+    </section>
+
+    <section>
+      <title id="col-sysbg">Colorspace EBU Tech. 3213 (<constant>V4L2_COLORSPACE_470_SYSTEM_BG</constant>)</title>
+      <para>The <xref linkend="tech3213" /> standard defines the colorspace used by PAL/SECAM in 1975. In practice this
+colorspace is obsolete and SMPTE 170M should be used instead. The default Y'CbCr encoding
+is <constant>V4L2_YCBCR_ENC_601</constant>. The default Y'CbCr quantization is limited range.
+The chromaticities of the primary colors and the white reference are:</para>
+      <table frame="none">
+        <title>EBU Tech. 3213 Chromaticities</title>
+        <tgroup cols="3" align="left">
+          &cs-str;
+    	<thead>
+    	  <row>
+    	    <entry>Color</entry>
+    	    <entry>x</entry>
+    	    <entry>y</entry>
+    	  </row>
+    	</thead>
+          <tbody valign="top">
+            <row>
+              <entry>Red</entry>
+              <entry>0.64</entry>
+              <entry>0.33</entry>
+            </row>
+            <row>
+              <entry>Green</entry>
+              <entry>0.29</entry>
+              <entry>0.60</entry>
+            </row>
+            <row>
+              <entry>Blue</entry>
+              <entry>0.15</entry>
+              <entry>0.06</entry>
+            </row>
+            <row>
+              <entry>White Reference (D65)</entry>
+              <entry>0.3127</entry>
+              <entry>0.3290</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+      <variablelist>
+	<varlistentry>
+          <term>The transfer function was never properly defined for this colorspace.
+The Rec. 709 transfer function is recommended in the literature:</term>
+	  <listitem>
+            <para>L' = 4.5L&nbsp;for&nbsp;0&nbsp;&le;&nbsp;L&nbsp;&lt;&nbsp;0.018</para>
+            <para>L' = 1.099L<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;0.018&nbsp;&le;&nbsp;L&nbsp;&le;&nbsp;1</para>
+	  </listitem>
+	</varlistentry>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = L'&nbsp;/&nbsp;4.5&nbsp;for&nbsp;L'&nbsp;&lt;&nbsp;0.081</para>
+            <para>L = ((L'&nbsp;+&nbsp;0.099)&nbsp;/&nbsp;1.099)<superscript>1/0.45</superscript>&nbsp;for&nbsp;L'&nbsp;&ge;&nbsp;0.081</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>The luminance (Y') and color difference (Cb and Cr) are obtained with the
+following <constant>V4L2_YCBCR_ENC_601</constant> encoding:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;0.299R'&nbsp;+&nbsp;0.587G'&nbsp;+&nbsp;0.114B'</para>
+            <para>Cb&nbsp;=&nbsp;-0.169R'&nbsp;-&nbsp;0.331G'&nbsp;+&nbsp;0.5B'</para>
+            <para>Cr&nbsp;=&nbsp;0.5R'&nbsp;-&nbsp;0.419G'&nbsp;-&nbsp;0.081B'</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are
+clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range.
+This transform is identical to one defined in SMPTE 170M/BT.601.</para>
+    </section>
+
+    <section>
+      <title id="col-jpeg">Colorspace JPEG (<constant>V4L2_COLORSPACE_JPEG</constant>)</title>
+      <para>This colorspace defines the colorspace used by most (Motion-)JPEG formats. The chromaticities
+of the primary colors and the white reference are identical to sRGB. The Y'CbCr encoding is
+<constant>V4L2_YCBCR_ENC_601</constant> with full range quantization where
+Y' is scaled to [0&hellip;255] and Cb/Cr are scaled to [-128&hellip;128] and
+then clipped to [-128&hellip;127].</para>
+      <para>Note that the JPEG standard does not actually store colorspace information.
+So if something other than sRGB is used, then the driver will have to set that information
+explicitly. Effectively <constant>V4L2_COLORSPACE_JPEG</constant> can be considered to be
+an abbreviation for <constant>V4L2_COLORSPACE_SRGB</constant>, <constant>V4L2_YCBCR_ENC_601</constant>
+and <constant>V4L2_QUANTIZATION_FULL_RANGE</constant>.</para>
+    </section>
+
   </section>
 
   <section id="pixfmt-indexed">
-- 
2.1.3

