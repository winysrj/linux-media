Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab2HMSDC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 14:03:02 -0400
Message-ID: <5029414E.7000809@redhat.com>
Date: Mon, 13 Aug 2012 15:02:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] DocBook validation fixes
References: <201208121402.37719.hverkuil@xs4all.nl>
In-Reply-To: <201208121402.37719.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-08-2012 09:02, Hans Verkuil escreveu:
> More validation fixes as reported by xmllint.
> 
> There are still three xmllint errors remaining after this patch regarding SVG file support.

How are you running xmllint? It could be useful to have a make target
(if it doesn't have it yet), in order for developers (and for me, when
checking patches) to run it.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/Makefile               |    2 +-
>  Documentation/DocBook/media/dvb/dvbproperty.xml    |   20 +++++++++---------
>  Documentation/DocBook/media/dvb/frontend.xml       |   20 ++++++++++--------
>  Documentation/DocBook/media/v4l/controls.xml       |    4 +++-
>  Documentation/DocBook/media/v4l/dev-subdev.xml     |   20 +++++++++---------
>  .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |    3 +--
>  Documentation/DocBook/media/v4l/selection-api.xml  |   22 ++++++++++----------
>  .../DocBook/media/v4l/vidioc-g-selection.xml       |    9 ++++----
>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |    2 ++
>  .../media/v4l/vidioc-subdev-g-selection.xml        |    8 +++----
>  10 files changed, 57 insertions(+), 53 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
> index 3625209..9b7e4c5 100644
> --- a/Documentation/DocBook/media/Makefile
> +++ b/Documentation/DocBook/media/Makefile
> @@ -300,7 +300,7 @@ $(MEDIA_OBJ_DIR)/media-entities.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
>  	@(								\
>  	for ident in $(IOCTLS) ; do					\
>  	  entity=`echo $$ident | tr _ -` ;				\
> -	  id=`grep "<refname>$$ident" $(MEDIA_OBJ_DIR)/vidioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
> +	  id=`grep "<refname>$$ident" $(MEDIA_OBJ_DIR)/vidioc-*.xml $(MEDIA_OBJ_DIR)/media-ioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
>  	  echo "<!ENTITY $$entity \"<link"				\
>  	    "linkend='$$id'><constant>$$ident</constant></link>\">"	\
>  	  >>$@ ;							\
> diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
> index bb4777a..8adab98 100644
> --- a/Documentation/DocBook/media/dvb/dvbproperty.xml
> +++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
> @@ -567,33 +567,33 @@ typedef enum fe_delivery_system {
>  			<title><constant>DTV_ATSCMH_RS_FRAME_MODE</constant></title>
>  			<para>RS frame mode.</para>
>  			<para>Possible values are:</para>
> -		  <section id="atscmh-rs-frame-mode">
> +		  <para id="atscmh-rs-frame-mode">
>  <programlisting>
>  typedef enum atscmh_rs_frame_mode {
>  	ATSCMH_RSFRAME_PRI_ONLY  = 0,
>  	ATSCMH_RSFRAME_PRI_SEC   = 1,
>  } atscmh_rs_frame_mode_t;
>  </programlisting>
> -		  </section>
> +		  </para>
>  		</section>
>  		<section id="DTV-ATSCMH-RS-FRAME-ENSEMBLE">
>  			<title><constant>DTV_ATSCMH_RS_FRAME_ENSEMBLE</constant></title>
>  			<para>RS frame ensemble.</para>
>  			<para>Possible values are:</para>
> -		  <section id="atscmh-rs-frame-ensemble">
> +		  <para id="atscmh-rs-frame-ensemble">
>  <programlisting>
>  typedef enum atscmh_rs_frame_ensemble {
>  	ATSCMH_RSFRAME_ENS_PRI   = 0,
>  	ATSCMH_RSFRAME_ENS_SEC   = 1,
>  } atscmh_rs_frame_ensemble_t;
>  </programlisting>
> -		  </section>
> +		  </para>
>  		</section>
>  		<section id="DTV-ATSCMH-RS-CODE-MODE-PRI">
>  			<title><constant>DTV_ATSCMH_RS_CODE_MODE_PRI</constant></title>
>  			<para>RS code mode (primary).</para>
>  			<para>Possible values are:</para>
> -		  <section id="atscmh-rs-code-mode">
> +		  <para id="atscmh-rs-code-mode">
>  <programlisting>
>  typedef enum atscmh_rs_code_mode {
>  	ATSCMH_RSCODE_211_187    = 0,
> @@ -601,7 +601,7 @@ typedef enum atscmh_rs_code_mode {
>  	ATSCMH_RSCODE_235_187    = 2,
>  } atscmh_rs_code_mode_t;
>  </programlisting>
> -		  </section>
> +		  </para>
>  		</section>
>  		<section id="DTV-ATSCMH-RS-CODE-MODE-SEC">
>  			<title><constant>DTV_ATSCMH_RS_CODE_MODE_SEC</constant></title>
> @@ -619,27 +619,27 @@ typedef enum atscmh_rs_code_mode {
>  			<title><constant>DTV_ATSCMH_SCCC_BLOCK_MODE</constant></title>
>  			<para>Series Concatenated Convolutional Code Block Mode.</para>
>  			<para>Possible values are:</para>
> -		  <section id="atscmh-sccc-block-mode">
> +		  <para id="atscmh-sccc-block-mode">
>  <programlisting>
>  typedef enum atscmh_sccc_block_mode {
>  	ATSCMH_SCCC_BLK_SEP      = 0,
>  	ATSCMH_SCCC_BLK_COMB     = 1,
>  } atscmh_sccc_block_mode_t;
>  </programlisting>
> -		  </section>
> +		  </para>
>  		</section>
>  		<section id="DTV-ATSCMH-SCCC-CODE-MODE-A">
>  			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_A</constant></title>
>  			<para>Series Concatenated Convolutional Code Rate.</para>
>  			<para>Possible values are:</para>
> -		  <section id="atscmh-sccc-code-mode">
> +		  <para id="atscmh-sccc-code-mode">
>  <programlisting>
>  typedef enum atscmh_sccc_code_mode {
>  	ATSCMH_SCCC_CODE_HLF     = 0,
>  	ATSCMH_SCCC_CODE_QTR     = 1,
>  } atscmh_sccc_code_mode_t;
>  </programlisting>
> -		  </section>
> +		  </para>
>  		</section>
>  		<section id="DTV-ATSCMH-SCCC-CODE-MODE-B">
>  			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_B</constant></title>
> diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
> index 81082fb..418f197 100644
> --- a/Documentation/DocBook/media/dvb/frontend.xml
> +++ b/Documentation/DocBook/media/dvb/frontend.xml
> @@ -238,7 +238,7 @@ and to add newer delivery systems.</para>
>  <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> instead, in
>  order to be able to support the newer System Delivery like  DVB-S2, DVB-T2,
>  DVB-C2, ISDB, etc.</para>
> -<para>All kinds of parameters are combined as an union in the FrontendParameters structure:</para>
> +<para>All kinds of parameters are combined as an union in the FrontendParameters structure:
>  <programlisting>
>  struct dvb_frontend_parameters {
>  	uint32_t frequency;     /&#x22C6; (absolute) frequency in Hz for QAM/OFDM &#x22C6;/
> @@ -251,12 +251,13 @@ struct dvb_frontend_parameters {
>  		struct dvb_vsb_parameters  vsb;
>  	} u;
>  };
> -</programlisting>
> +</programlisting></para>
>  <para>In the case of QPSK frontends the <constant>frequency</constant> field specifies the intermediate
>  frequency, i.e. the offset which is effectively added to the local oscillator frequency (LOF) of
>  the LNB. The intermediate frequency has to be specified in units of kHz. For QAM and
>  OFDM frontends the <constant>frequency</constant> specifies the absolute frequency and is given in Hz.
>  </para>
> +
>  <section id="dvb-qpsk-parameters">
>  <title>QPSK parameters</title>
>  <para>For satellite QPSK frontends you have to use the <constant>dvb_qpsk_parameters</constant> structure:</para>
> @@ -321,8 +322,8 @@ itself.
>  <section id="fe-code-rate-t">
>  <title>frontend code rate</title>
>  <para>The possible values for the <constant>fec_inner</constant> field used on
> -<link refend="dvb-qpsk-parameters"><constant>struct dvb_qpsk_parameters</constant></link> and
> -<link refend="dvb-qam-parameters"><constant>struct dvb_qam_parameters</constant></link> are:
> +<link linkend="dvb-qpsk-parameters"><constant>struct dvb_qpsk_parameters</constant></link> and
> +<link linkend="dvb-qam-parameters"><constant>struct dvb_qam_parameters</constant></link> are:
>  </para>
>  <programlisting>
>  typedef enum fe_code_rate {
> @@ -347,9 +348,9 @@ detection.
>  <section id="fe-modulation-t">
>  <title>frontend modulation type for QAM, OFDM and VSB</title>
>  <para>For cable and terrestrial frontends, e. g. for
> -<link refend="dvb-qam-parameters"><constant>struct dvb_qpsk_parameters</constant></link>,
> -<link refend="dvb-ofdm-parameters"><constant>struct dvb_qam_parameters</constant></link> and
> -<link refend="dvb-vsb-parameters"><constant>struct dvb_qam_parameters</constant></link>,
> +<link linkend="dvb-qam-parameters"><constant>struct dvb_qpsk_parameters</constant></link>,
> +<link linkend="dvb-ofdm-parameters"><constant>struct dvb_qam_parameters</constant></link> and
> +<link linkend="dvb-vsb-parameters"><constant>struct dvb_qam_parameters</constant></link>,
>  it needs to specify the quadrature modulation mode which can be one of the following:
>  </para>
>  <programlisting>
> @@ -370,8 +371,8 @@ it needs to specify the quadrature modulation mode which can be one of the follo
>   } fe_modulation_t;
>  </programlisting>
>  </section>
> -<para>Finally, there are several more parameters for OFDM:
> -</para>
> +<section>
> +<title>More OFDM parameters</title>
>  <section id="fe-transmit-mode-t">
>  <title>Number of carriers per channel</title>
>  <programlisting>
> @@ -427,6 +428,7 @@ typedef enum fe_hierarchy {
>   } fe_hierarchy_t;
>  </programlisting>
>  </section>
> +</section>
>  
>  </section>
>  
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index b0964fb..a5f9a7f 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -3721,6 +3721,8 @@ interface and may change in the future.</para>
>  
>        </section>
>  
> +      <section>
> +      <title></title>

>        <table pgwide="1" frame="none" id="flash-control-id">

Hmm... empty title here, with just one table? That looked weird, and could be
creating some harm at the section indexe.

>        <title>Flash Control IDs</title>
>  
> @@ -3942,7 +3944,7 @@ interface and may change in the future.</para>
>  	  <row><entry></entry></row>
>  	</tbody>
>        </tgroup>
> -      </table>
> +      </table></section>
>      </section>
>  
>      <section id="jpeg-controls">
> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
> index a3d9dd0..d15aaf8 100644
> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> @@ -374,29 +374,29 @@
>        rectangle --- if it is supported by the hardware.</para>
>  
>        <orderedlist>
> -	<listitem>Sink pad format. The user configures the sink pad
> +	<listitem><para>Sink pad format. The user configures the sink pad
>  	format. This format defines the parameters of the image the
> -	entity receives through the pad for further processing.</listitem>
> +	entity receives through the pad for further processing.</para></listitem>
>  
> -	<listitem>Sink pad actual crop selection. The sink pad crop
> -	defines the crop performed to the sink pad format.</listitem>
> +	<listitem><para>Sink pad actual crop selection. The sink pad crop
> +	defines the crop performed to the sink pad format.</para></listitem>
>  
> -	<listitem>Sink pad actual compose selection. The size of the
> +	<listitem><para>Sink pad actual compose selection. The size of the
>  	sink pad compose rectangle defines the scaling ratio compared
>  	to the size of the sink pad crop rectangle. The location of
>  	the compose rectangle specifies the location of the actual
>  	sink compose rectangle in the sink compose bounds
> -	rectangle.</listitem>
> +	rectangle.</para></listitem>
>  
> -	<listitem>Source pad actual crop selection. Crop on the source
> +	<listitem><para>Source pad actual crop selection. Crop on the source
>  	pad defines crop performed to the image in the sink compose
> -	bounds rectangle.</listitem>
> +	bounds rectangle.</para></listitem>
>  
> -	<listitem>Source pad format. The source pad format defines the
> +	<listitem><para>Source pad format. The source pad format defines the
>  	output pixel format of the subdev, as well as the other
>  	parameters with the exception of the image width and height.
>  	Width and height are defined by the size of the source pad
> -	actual crop selection.</listitem>
> +	actual crop selection.</para></listitem>
>        </orderedlist>
>  
>        <para>Accessing any of the above rectangles not supported by the
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> index 8eace3e..2d3f0b1a 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
> @@ -22,8 +22,7 @@
>  	with 10 bits per colour compressed to 8 bits each, using DPCM
>  	compression. DPCM, differential pulse-code modulation, is lossy.
>  	Each colour component consumes 8 bits of memory. In other respects
> -	this format is similar to <xref
> -	linkend="pixfmt-srggb10">.</xref></para>
> +	this format is similar to <xref linkend="pixfmt-srggb10" />.</para>
>  
>        </refsect1>
>      </refentry>
> diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
> index e7ed507..4c238ce 100644
> --- a/Documentation/DocBook/media/v4l/selection-api.xml
> +++ b/Documentation/DocBook/media/v4l/selection-api.xml
> @@ -40,6 +40,7 @@ cropping and composing rectangles have the same size.</para>
>      <section>
>        <title>Selection targets</title>
>  
> +      <para>
>        <figure id="sel-targets-capture">
>  	<title>Cropping and composing targets</title>
>  	<mediaobject>
> @@ -52,12 +53,12 @@ cropping and composing rectangles have the same size.</para>
>  	  </textobject>
>  	</mediaobject>
>        </figure>
> +      </para>
>  
> +      <para>See <xref linkend="v4l2-selection-targets" /> for more
> +    information.</para>
>      </section>
>  
> -    See <xref linkend="v4l2-selection-targets" /> for more
> -    information.
> -
>    <section>
>  
>    <title>Configuration</title>
> @@ -216,18 +217,17 @@ composing and cropping operations by setting the appropriate targets.  The V4L2
>  API lacks any support for composing to and cropping from an image inside a
>  memory buffer.  The application could configure a capture device to fill only a
>  part of an image by abusing V4L2 API.  Cropping a smaller image from a larger
> -one is achieved by setting the field <structfield>
> -&v4l2-pix-format;::bytesperline </structfield>.  Introducing an image offsets
> -could be done by modifying field <structfield> &v4l2-buffer;::m:userptr
> -</structfield> before calling <constant> VIDIOC_QBUF </constant>. Those
> +one is achieved by setting the field
> +&v4l2-pix-format;<structfield>::bytesperline</structfield>.  Introducing an image offsets
> +could be done by modifying field &v4l2-buffer;<structfield>::m_userptr</structfield>
> +before calling <constant> VIDIOC_QBUF </constant>. Those
>  operations should be avoided because they are not portable (endianness), and do
>  not work for macroblock and Bayer formats and mmap buffers.  The selection API
>  deals with configuration of buffer cropping/composing in a clear, intuitive and
>  portable way.  Next, with the selection API the concepts of the padded target
> -and constraints flags are introduced.  Finally, <structname> &v4l2-crop;
> -</structname> and <structname> &v4l2-cropcap; </structname> have no reserved
> -fields. Therefore there is no way to extend their functionality.  The new
> -<structname> &v4l2-selection; </structname> provides a lot of place for future
> +and constraints flags are introduced.  Finally, &v4l2-crop; and &v4l2-cropcap;
> +have no reserved fields. Therefore there is no way to extend their functionality.
> +The new &v4l2-selection; provides a lot of place for future
>  extensions.  Driver developers are encouraged to implement only selection API.
>  The former cropping API would be simulated using the new one. </para>
>  
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> index f76d8a6..b11ec75 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> @@ -152,12 +152,10 @@ satisfactory parameters have been negotiated. If constraints flags have to be
>  violated at then ERANGE is returned. The error indicates that <emphasis> there
>  exist no rectangle </emphasis> that satisfies the constraints.</para>
>  
> -  </refsect1>
> -
>    <para>Selection targets and flags are documented in <xref
>    linkend="v4l2-selections-common"/>.</para>
>  
> -    <section>
> +    <para>
>        <figure id="sel-const-adjust">
>  	<title>Size adjustments with constraint flags.</title>
>  	<mediaobject>
> @@ -170,9 +168,9 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
>  	  </textobject>
>  	</mediaobject>
>        </figure>
> -    </section>
> +    </para>
>  
> -  <refsect1>
> +  <para>
>      <table pgwide="1" frame="none" id="v4l2-selection">
>        <title>struct <structname>v4l2_selection</structname></title>
>        <tgroup cols="3">
> @@ -208,6 +206,7 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
>  	</tbody>
>        </tgroup>
>      </table>
> +  </para>
>    </refsect1>
>  
>    <refsect1>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> index 77ff5be..6a821a6 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> @@ -155,6 +155,8 @@ or no buffers have been allocated yet, or the
>  <structfield>userptr</structfield> or
>  <structfield>length</structfield> are invalid.</para>
>  	</listitem>
> +      </varlistentry>
> +      <varlistentry>
>  	<term><errorcode>EIO</errorcode></term>
>  	<listitem>
>  	  <para><constant>VIDIOC_DQBUF</constant> failed due to an
> diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> index f33cc81..1ba9e99 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> @@ -69,23 +69,22 @@
>      more information on how each selection target affects the image
>      processing pipeline inside the subdevice.</para>
>  
> -    <section>
> +    <refsect2>
>        <title>Types of selection targets</title>
>  
>        <para>There are two types of selection targets: actual and bounds. The
>        actual targets are the targets which configure the hardware. The BOUNDS
>        target will return a rectangle that contain all possible actual
>        rectangles.</para>
> -    </section>
> +    </refsect2>
>  
> -    <section>
> +    <refsect2>
>        <title>Discovering supported features</title>
>  
>        <para>To discover which targets are supported, the user can
>        perform <constant>VIDIOC_SUBDEV_G_SELECTION</constant> on them.
>        Any unsupported target will return
>        <constant>EINVAL</constant>.</para>
> -    </section>
>  
>      <para>Selection targets and flags are documented in <xref
>      linkend="v4l2-selections-common"/>.</para>
> @@ -132,6 +131,7 @@
>  	</tbody>
>        </tgroup>
>      </table>
> +    </refsect2>
>  
>    </refsect1>
>  
> 

