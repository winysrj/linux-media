Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4978 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3LUMo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 07:44:56 -0500
Message-ID: <52B58D36.4070007@xs4all.nl>
Date: Sat, 21 Dec 2013 13:44:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v5 11/12] DocBook: Software Defined Radio Interface
References: <1387518594-11609-1-git-send-email-crope@iki.fi> <1387518594-11609-12-git-send-email-crope@iki.fi>
In-Reply-To: <1387518594-11609-12-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More nits...

On 12/20/2013 06:49 AM, Antti Palosaari wrote:
> Document V4L2 SDR interface.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/compat.xml       | 10 +++
>  Documentation/DocBook/media/v4l/dev-sdr.xml      | 99 ++++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/io.xml           |  6 ++
>  Documentation/DocBook/media/v4l/v4l2.xml         |  1 +
>  Documentation/DocBook/media/v4l/vidioc-g-fmt.xml |  6 ++
>  5 files changed, 122 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/dev-sdr.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 0c7195e..85fb864 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2523,6 +2523,16 @@ that used it. It was originally scheduled for removal in 2.6.35.
>        </orderedlist>
>      </section>
>  
> +    <section>
> +      <title>V4L2 in Linux 3.14</title>
> +      <orderedlist>
> +        <listitem>
> +	  <para>Added Software Defined Radio (SDR) Interface.
> +	  </para>
> +        </listitem>
> +      </orderedlist>
> +    </section>
> +
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
>  
> diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
> new file mode 100644
> index 0000000..3caf44d
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
> @@ -0,0 +1,99 @@
> +  <title>Software Defined Radio Interface (SDR)</title>
> +
> +  <para>
> +SDR is an abbreviation of Software Defined Radio, the radio device
> +which uses application software for modulation or demodulation. That interface

s/That/This/

> +is intended for controlling and data streaming of such devices.
> +  </para>
> +
> +  <para>
> +SDR devices are accessed through character device special files named
> +<filename>/dev/swradio0</filename> to <filename>/dev/swradio255</filename>
> +with major number 81 and dynamically allocated minor numbers 0 to 255.
> +  </para>
> +
> +  <section>
> +    <title>Querying Capabilities</title>
> +
> +    <para>
> +Devices supporting the SDR receiver interface set the
> +<constant>V4L2_CAP_SDR_CAPTURE</constant> and
> +<constant>V4L2_CAP_TUNER</constant> flag in the
> +<structfield>capabilities</structfield> field of &v4l2-capability;
> +returned by the &VIDIOC-QUERYCAP; ioctl. That flag means device has

s/device has/the device has an/

> +Analog to Digital Converter (ADC), which is mandatory element for SDR receiver.

s/is/is a/
s/SDR/the SDR/

> +At least one of the read/write, streaming or asynchronous I/O methods must
> +be supported.
> +    </para>
> +  </section>
> +
> +  <section>
> +    <title>Supplemental Functions</title>
> +
> +    <para>
> +SDR devices can support <link linkend="control">controls</link>, and must
> +support the <link linkend="tuner">tuner</link> ioctls. Tuner ioctls are used
> +for setting ADC sampling rate (sampling frequency) and possible RF tuner

s/ADC/the ADC/
s/RF/the RF/

> +frequency.
> +    </para>
> +
> +    <para>
> +<constant>V4L2_TUNER_ADC</constant> is used as a tuner type when ADC is in
> +question and <constant>V4L2_TUNER_RF</constant> is used as a tuner type when
> +RF tuner is in question. Possible RF tuner index number is always next one
> +from the ADC index number. Normally ADC tuner is #0 and RF tuner is #1.
> +    </para>

I would rewrite this paragraph. How about:

The <constant>V4L2_TUNER_ADC</constant> tuner type is used for ADC tuners, and
the <constant>V4L2_TUNER_RF</constant> is used for RF tuners. The tuner index
of the RF tuner (if any) must always follow the ADC tuner index. Normally the
ADC tuner is #0 and the RF tuner is #1.

> +
> +    <para>
> +<constant>VIDIOC_S_HW_FREQ_SEEK</constant> ioctl is not supported.

Replace by:

The &VIDIOC-S-HW-FREQ-SEEK; ioctl is not supported.

> +    </para>
> +  </section>
> +
> +  <section>
> +    <title>Data Format Negotiation</title>
> +
> +    <para>
> +SDR capture device uses <link linkend="format">format</link> ioctls to select

s/SDR/The SDR/
s/uses/uses the/

> +capture format. Both sampling resolution and data streaming format are bind

s/capture/the capture/
s/sampling/the sampling/
s/data/the data/
s/bind/bound/

> +to that selectable format. In addition to basic

s/selectable/selected/
s/basic/the basic/

> +<link linkend="format">format</link> ioctls, the
> +<constant>VIDIOC_ENUM_FMT</constant> ioctl must be supported too.

Use '&VIDIOC-ENUM-FMT;' instead.

> +    </para>
> +
> +    <para>
> +To use <link linkend="format">format</link> ioctls applications set the

s/use/use the/

> +<structfield>type</structfield> field of a &v4l2-format; to
> +<constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant> and use the &v4l2-format-sdr;
> +<structfield>sdr</structfield> member of the <structfield>fmt</structfield>
> +union as needed per desired operation.

s/per/per the/

> +Currently there is only <structfield>pixelformat</structfield> field of
> +&v4l2-format-sdr; used. Content of that field is data format V4L2 fourcc code.

Replace with:

"Currently only the <structfield>pixelformat</structfield> field of
&v4l2-format-sdr; is used. The content of that field is the V4L2 fourcc code of the
data format."

> +    </para>
> +
> +    <table pgwide="1" frame="none" id="v4l2-format-sdr">
> +      <title>struct <structname>v4l2_format_sdr</structname></title>
> +      <tgroup cols="3">
> +        &cs-str;
> +        <tbody valign="top">
> +          <row>
> +            <entry>__u32</entry>
> +            <entry><structfield>pixelformat</structfield></entry>
> +            <entry>little endian four character code (fourcc)</entry>

That's a bit obscure. Look at Table 2.1 (struct v4l2_pix_format) how pixelformat
is described there and copy-and-paste that.

You also need to document the SDR pixelformats that you define.

> +          </row>
> +          <row>
> +            <entry>__u8</entry>
> +            <entry><structfield>reserved[28]</structfield></entry>
> +            <entry>This array is reserved for future extensions.
> +Drivers and applications must set it to zero.</entry>
> +          </row>
> +        </tbody>
> +      </tgroup>
> +    </table>
> +
> +    <para>
> +A SDR device may support <link linkend="rw">read/write</link>

s/A/An/ (because you say Es-Dee-Ar :-) )

> +and/or streaming (<link linkend="mmap">memory mapping</link>
> +or <link linkend="userp">user pointer</link>) I/O.
> +    </para>
> +
> +  </section>
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 2c4c068..1fb11e8 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -1005,6 +1005,12 @@ should set this to 0.</entry>
>  	    <entry>Buffer for video output overlay (OSD), see <xref
>  		linkend="osd" />.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant></entry>
> +	    <entry>11</entry>
> +	    <entry>Buffer for Software Defined Radio (SDR), see <xref
> +		linkend="sdr" />.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 8469fe1..a27fcae 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -529,6 +529,7 @@ and discussions on the V4L mailing list.</revremark>
>      <section id="ttx"> &sub-dev-teletext; </section>
>      <section id="radio"> &sub-dev-radio; </section>
>      <section id="rds"> &sub-dev-rds; </section>
> +    <section id="sdr"> &sub-dev-sdr; </section>
>      <section id="event"> &sub-dev-event; </section>
>      <section id="subdev"> &sub-dev-subdev; </section>
>    </chapter>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
> index ee8f56e..60bf9b2 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
> @@ -172,6 +172,12 @@ capture and output devices.</entry>
>  	  </row>
>  	  <row>
>  	    <entry></entry>
> +	    <entry>&v4l2-format-sdr;</entry>
> +	    <entry><structfield>sdr</structfield></entry>
> +	    <entry>Definition of an SDR format.</entry>

Add a link to the sdr section, same as is done for the other structs in the union.

> +	  </row>
> +	  <row>
> +	    <entry></entry>
>  	    <entry>__u8</entry>
>  	    <entry><structfield>raw_data</structfield>[200]</entry>
>  	    <entry>Place holder for future extensions.</entry>
> 

I'm missing the documentation for the new SDR capability flag in querycap.

Regards,

	Hans
