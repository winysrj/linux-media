Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55343 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844AbcF0LCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 07:02:24 -0400
Subject: Re: [PATCH v5 1/9] [media] v4l2-core: Add support for touch devices
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466633313-15339-2-git-send-email-nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <77b0a3e6-a493-e83b-f40b-a63e6dd2d210@xs4all.nl>
Date: Mon, 27 Jun 2016 13:02:13 +0200
MIME-Version: 1.0
In-Reply-To: <1466633313-15339-2-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/23/2016 12:08 AM, Nick Dyer wrote:
> Some touch controllers send out touch data in a similar way to a
> greyscale frame grabber.
> 
> Use a new device prefix v4l-touch for these devices, to stop generic
> capture software from treating them as webcams.
> 
> Add formats:
> - V4L2_TCH_FMT_DELTA_TD16 for signed 16-bit touch deltas
> - V4L2_TCH_FMT_DELTA_TD08 for signed 16-bit touch deltas
> - V4L2_TCH_FMT_TU16 for unsigned 16-bit touch data
> - V4L2_TCH_FMT_TU08 for unsigned 8-bit touch data
> 
> This support will be used by:
> * Atmel maXTouch (atmel_mxt_ts)
> * Synaptics RMI4.
> * sur40
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  Documentation/DocBook/media/v4l/dev-touch.xml      | 53 ++++++++++++++
>  Documentation/DocBook/media/v4l/media-types.xml    |  5 ++
>  .../DocBook/media/v4l/pixfmt-tch-td08.xml          | 66 +++++++++++++++++
>  .../DocBook/media/v4l/pixfmt-tch-td16.xml          | 82 ++++++++++++++++++++++
>  .../DocBook/media/v4l/pixfmt-tch-tu08.xml          | 66 +++++++++++++++++
>  .../DocBook/media/v4l/pixfmt-tch-tu16.xml          | 81 +++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         | 13 ++++
>  Documentation/DocBook/media/v4l/v4l2.xml           |  1 +
>  drivers/media/v4l2-core/v4l2-dev.c                 | 16 ++++-
>  drivers/media/v4l2-core/v4l2-ioctl.c               | 44 ++++++++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c           |  1 +

You forgot drivers/media/v4l2-core/v4l2-compat-ioctl32.c.

For the next version, please place the docbook changes in a separate patch.

>  include/media/v4l2-dev.h                           |  3 +-
>  include/uapi/linux/media.h                         |  2 +
>  include/uapi/linux/videodev2.h                     | 10 +++
>  14 files changed, 439 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/dev-touch.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-tch-td08.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-tch-td16.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-tch-tu08.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-tch-tu16.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/dev-touch.xml b/Documentation/DocBook/media/v4l/dev-touch.xml
> new file mode 100644
> index 0000000..9e36328
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/dev-touch.xml
> @@ -0,0 +1,53 @@
> +<title>Touch Devices</title>
> +
> +<para>Touch devices are accessed through character device special files
> +  named <filename>/dev/v4l-touch0</filename> to
> +  <filename>/dev/v4l-touch255</filename> with major number 81 and
> +  dynamically allocated minor numbers 0 to 255.</para>
> +
> +<section>
> +  <title>Overview</title>
> +
> +  <para>Sensors may be Optical, or Projected Capacitive touch (PCT).</para>
> +
> +  <para>Processing is required to analyse the raw data and produce input
> +    events. In some systems, this may be performed on the ASIC and the raw data
> +    is purely a side-channel for diagnostics or tuning. In other systems, the
> +    ASIC is a simple analogue front end device which delivers touch data at
> +    high rate, and any touch processing must be done on the host.</para>
> +
> +  <para>For capacitive touch sensing, the touchscreen is composed of an array
> +    of horizontal and vertical conductors (alternatively called rows/columns,
> +    X/Y lines, or tx/rx). Mutual Capacitance measured is at the nodes where the
> +    conductors cross. Alternatively, Self Capacitance measures the signal from
> +    each column and row independently.</para>
> +
> +  <para>A touch input may be determined by comparing the raw capacitance
> +    measurement to a no-touch reference (or "baseline") measurement:</para>
> +
> +  <para>Delta = Raw - Reference</para>
> +
> +  <para>The reference measurement takes account of variations in the
> +    capacitance across the touch sensor matrix, for example
> +    manufacturing irregularities, environmental or edge effects.</para>
> +</section>
> +
> +<section>
> +  <title>Querying Capabilities</title>
> +
> +  <para>Devices supporting the touch interface set the
> +    <constant>V4L2_CAP_VIDEO_CAPTURE</constant> flag in the

And the V4L2_CAP_TOUCH flag, right?

> +    <structfield>capabilities</structfield> field of &v4l2-capability;
> +    returned by the &VIDIOC-QUERYCAP; ioctl.</para>
> +
> +  <para>At least one of the read/write, streaming or asynchronous I/O methods

Change to:

"At least one of the read/write or streaming I/O methods"

Asynchronous I/O was never implemented. We really need to remove this old stuff
from the spec.

> +    must be supported.</para>
> +</section>
> +
> +<section>
> +  <title>Data Format Negotiation</title>
> +
> +  <para> A touch device may support <link linkend="rw">read/write</link>
> +    and/or streaming (<link linkend="mmap">memory mapping</link> or
> +    <link linkend="userp">user pointer</link>) I/O.</para>

dma-buf isn't mentioned here.

> +</section>
> diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
> index 5e3f20f..fb957c7 100644
> --- a/Documentation/DocBook/media/v4l/media-types.xml
> +++ b/Documentation/DocBook/media/v4l/media-types.xml
> @@ -202,6 +202,11 @@
>  	    <entry>typically, /dev/swradio?</entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>MEDIA_INTF_T_V4L_TOUCH</constant></entry>
> +	    <entry>Device node interface for Touch device (V4L)</entry>
> +	    <entry>typically, /dev/v4l-touch?</entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>MEDIA_INTF_T_ALSA_PCM_CAPTURE</constant></entry>
>  	    <entry>Device node interface for ALSA PCM Capture</entry>
>  	    <entry>typically, /dev/snd/pcmC?D?c</entry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-tch-td08.xml b/Documentation/DocBook/media/v4l/pixfmt-tch-td08.xml
> new file mode 100644
> index 0000000..2483eb0
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-tch-td08.xml
> @@ -0,0 +1,66 @@
> +<refentry id="V4L2-TCH-FMT-DELTA-TD08">
> +  <refmeta>
> +    <refentrytitle>V4L2_TCH_FMT_DELTA_TD08 ('TD08')</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +  <refnamediv>
> +    <refname><constant>V4L2_TCH_FMT_DELTA_TD08</constant></refname>
> +    <refpurpose>8-bit signed Touch Delta</refpurpose>
> +  </refnamediv>
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>This format represents delta data from a touch controller</para>
> +
> +    <para>Delta values may range from -128 to 127. Typically the values
> +      will vary through a small range depending on whether the sensor is
> +      touched or not. The full value may be seen if one of the
> +      touchscreen nodes has a fault or the line is not connected.</para>
> +
> +    <example>
> +      <title><constant>V4L2_TCH_FMT_DELTA_TD08</constant> 4 &times; 4
> +        node matrix</title>
> +
> +      <formalpara>
> +        <title>Byte Order.</title>
> +        <para>Each cell is one byte.
> +          <informaltable frame="none">
> +            <tgroup cols="5" align="center">
> +              <colspec align="left" colwidth="2*" />
> +              <tbody valign="top">
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;0:</entry>
> +                  <entry>D'<subscript>00</subscript></entry>
> +                  <entry>D'<subscript>01</subscript></entry>
> +                  <entry>D'<subscript>02</subscript></entry>
> +                  <entry>D'<subscript>03</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;4:</entry>
> +                  <entry>D'<subscript>10</subscript></entry>
> +                  <entry>D'<subscript>11</subscript></entry>
> +                  <entry>D'<subscript>12</subscript></entry>
> +                  <entry>D'<subscript>13</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;8:</entry>
> +                  <entry>D'<subscript>20</subscript></entry>
> +                  <entry>D'<subscript>21</subscript></entry>
> +                  <entry>D'<subscript>22</subscript></entry>
> +                  <entry>D'<subscript>23</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;12:</entry>
> +                  <entry>D'<subscript>30</subscript></entry>
> +                  <entry>D'<subscript>31</subscript></entry>
> +                  <entry>D'<subscript>32</subscript></entry>
> +                  <entry>D'<subscript>33</subscript></entry>
> +                </row>
> +              </tbody>
> +            </tgroup>
> +          </informaltable>
> +        </para>
> +      </formalpara>
> +    </example>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-tch-td16.xml b/Documentation/DocBook/media/v4l/pixfmt-tch-td16.xml
> new file mode 100644
> index 0000000..72f6245
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-tch-td16.xml
> @@ -0,0 +1,82 @@
> +<refentry id="V4L2-TCH-FMT-DELTA-TD16">
> +  <refmeta>
> +    <refentrytitle>V4L2_TCH_FMT_DELTA_TD16 ('TD16')</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +  <refnamediv>
> +    <refname><constant>V4L2_TCH_FMT_DELTA_TD16</constant></refname>
> +    <refpurpose>16-bit signed Touch Delta</refpurpose>
> +  </refnamediv>
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>This format represents delta data from a touch controller</para>
> +
> +    <para>Delta values may range from -32768 to 32767. Typically the values
> +      will vary through a small range depending on whether the sensor is
> +      touched or not. The full value may be seen if one of the
> +      touchscreen nodes has a fault or the line is not connected.</para>
> +
> +    <example>
> +      <title><constant>V4L2_TCH_FMT_DELTA_TD16</constant> 4 &times; 4
> +        node matrix</title>
> +
> +      <formalpara>
> +        <title>Byte Order.</title>
> +        <para>Each cell is one byte.
> +          <informaltable frame="none">
> +            <tgroup cols="9" align="center">
> +              <colspec align="left" colwidth="2*" />
> +              <tbody valign="top">
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;0:</entry>
> +                  <entry>D'<subscript>00low</subscript></entry>
> +                  <entry>D'<subscript>00high</subscript></entry>
> +                  <entry>D'<subscript>01low</subscript></entry>
> +                  <entry>D'<subscript>01high</subscript></entry>
> +                  <entry>D'<subscript>02low</subscript></entry>
> +                  <entry>D'<subscript>02high</subscript></entry>
> +                  <entry>D'<subscript>03low</subscript></entry>
> +                  <entry>D'<subscript>03high</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;8:</entry>
> +                  <entry>D'<subscript>10low</subscript></entry>
> +                  <entry>D'<subscript>10high</subscript></entry>
> +                  <entry>D'<subscript>11low</subscript></entry>
> +                  <entry>D'<subscript>11high</subscript></entry>
> +                  <entry>D'<subscript>12low</subscript></entry>
> +                  <entry>D'<subscript>12high</subscript></entry>
> +                  <entry>D'<subscript>13low</subscript></entry>
> +                  <entry>D'<subscript>13high</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;16:</entry>
> +                  <entry>D'<subscript>20low</subscript></entry>
> +                  <entry>D'<subscript>20high</subscript></entry>
> +                  <entry>D'<subscript>21low</subscript></entry>
> +                  <entry>D'<subscript>21high</subscript></entry>
> +                  <entry>D'<subscript>22low</subscript></entry>
> +                  <entry>D'<subscript>22high</subscript></entry>
> +                  <entry>D'<subscript>23low</subscript></entry>
> +                  <entry>D'<subscript>23high</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;24:</entry>
> +                  <entry>D'<subscript>30low</subscript></entry>
> +                  <entry>D'<subscript>30high</subscript></entry>
> +                  <entry>D'<subscript>31low</subscript></entry>
> +                  <entry>D'<subscript>31high</subscript></entry>
> +                  <entry>D'<subscript>32low</subscript></entry>
> +                  <entry>D'<subscript>32high</subscript></entry>
> +                  <entry>D'<subscript>33low</subscript></entry>
> +                  <entry>D'<subscript>33high</subscript></entry>
> +                </row>
> +              </tbody>
> +            </tgroup>
> +          </informaltable>
> +        </para>
> +      </formalpara>
> +    </example>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-tch-tu08.xml b/Documentation/DocBook/media/v4l/pixfmt-tch-tu08.xml
> new file mode 100644
> index 0000000..4547670
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-tch-tu08.xml
> @@ -0,0 +1,66 @@
> +<refentry id="V4L2-TCH-FMT-TU08">
> +  <refmeta>
> +    <refentrytitle>V4L2_TCH_FMT_TU08 ('TU08')</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +  <refnamediv>
> +    <refname><constant>V4L2_TCH_FMT_U08</constant></refname>

Should be V4L2_TCH_FMT_TU08, right?

> +    <refpurpose>8-bit unsigned raw touch data</refpurpose>
> +  </refnamediv>
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>This format represents unsigned 8-bit data from a touch
> +      controller.</para>
> +
> +    <para>This may be used for output for raw and reference data. Values may
> +      range from 0 to 255</para>

Missing period at the end of the line.

> +
> +    <example>
> +      <title><constant>V4L2_TCH_FMT_U08</constant> 4 &times; 4

V4L2_TCH_FMT_TU08

> +        node matrix</title>
> +
> +      <formalpara>
> +        <title>Byte Order.</title>
> +        <para>Each cell is one byte.
> +          <informaltable frame="none">
> +            <tgroup cols="5" align="center">
> +              <colspec align="left" colwidth="2*" />
> +              <tbody valign="top">
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;0:</entry>
> +                  <entry>R'<subscript>00</subscript></entry>
> +                  <entry>R'<subscript>01</subscript></entry>
> +                  <entry>R'<subscript>02</subscript></entry>
> +                  <entry>R'<subscript>03</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;4:</entry>
> +                  <entry>R'<subscript>10</subscript></entry>
> +                  <entry>R'<subscript>11</subscript></entry>
> +                  <entry>R'<subscript>12</subscript></entry>
> +                  <entry>R'<subscript>13</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;8:</entry>
> +                  <entry>R'<subscript>20</subscript></entry>
> +                  <entry>R'<subscript>21</subscript></entry>
> +                  <entry>R'<subscript>22</subscript></entry>
> +                  <entry>R'<subscript>23</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;12:</entry>
> +                  <entry>R'<subscript>30</subscript></entry>
> +                  <entry>R'<subscript>31</subscript></entry>
> +                  <entry>R'<subscript>32</subscript></entry>
> +                  <entry>R'<subscript>33</subscript></entry>
> +                </row>
> +              </tbody>
> +            </tgroup>
> +          </informaltable>
> +        </para>
> +      </formalpara>
> +
> +    </example>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-tch-tu16.xml b/Documentation/DocBook/media/v4l/pixfmt-tch-tu16.xml
> new file mode 100644
> index 0000000..13d9444
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-tch-tu16.xml
> @@ -0,0 +1,81 @@
> +<refentry id="V4L2-TCH-FMT-TU16">
> +  <refmeta>
> +    <refentrytitle>V4L2_TCH_FMT_TU16 ('TU16')</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +  <refnamediv>
> +    <refname><constant>V4L2_TCH_FMT_U16</constant></refname>

TU16.

> +    <refpurpose>16-bit unsigned raw touch data</refpurpose>
> +  </refnamediv>
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>This format represents unsigned 16-bit data from a touch
> +      controller.</para>
> +
> +    <para>This may be used for output for raw and reference data. Values may
> +      range from 0 to 65535</para>

Missing period.

> +
> +    <example>
> +      <title><constant>V4L2_TCH_FMT_U16</constant> 4 &times; 4

TU16

> +        node matrix</title>
> +
> +      <formalpara>
> +        <title>Byte Order.</title>
> +        <para>Each cell is one byte.
> +          <informaltable frame="none">
> +            <tgroup cols="9" align="center">
> +              <colspec align="left" colwidth="2*" />
> +              <tbody valign="top">
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;0:</entry>
> +                  <entry>R'<subscript>00low</subscript></entry>
> +                  <entry>R'<subscript>00high</subscript></entry>
> +                  <entry>R'<subscript>01low</subscript></entry>
> +                  <entry>R'<subscript>01high</subscript></entry>
> +                  <entry>R'<subscript>02low</subscript></entry>
> +                  <entry>R'<subscript>02high</subscript></entry>
> +                  <entry>R'<subscript>03low</subscript></entry>
> +                  <entry>R'<subscript>03high</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;8:</entry>
> +                  <entry>R'<subscript>10low</subscript></entry>
> +                  <entry>R'<subscript>10high</subscript></entry>
> +                  <entry>R'<subscript>11low</subscript></entry>
> +                  <entry>R'<subscript>11high</subscript></entry>
> +                  <entry>R'<subscript>12low</subscript></entry>
> +                  <entry>R'<subscript>12high</subscript></entry>
> +                  <entry>R'<subscript>13low</subscript></entry>
> +                  <entry>R'<subscript>13high</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;16:</entry>
> +                  <entry>R'<subscript>20low</subscript></entry>
> +                  <entry>R'<subscript>20high</subscript></entry>
> +                  <entry>R'<subscript>21low</subscript></entry>
> +                  <entry>R'<subscript>21high</subscript></entry>
> +                  <entry>R'<subscript>22low</subscript></entry>
> +                  <entry>R'<subscript>22high</subscript></entry>
> +                  <entry>R'<subscript>23low</subscript></entry>
> +                  <entry>R'<subscript>23high</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;24:</entry>
> +                  <entry>R'<subscript>30low</subscript></entry>
> +                  <entry>R'<subscript>30high</subscript></entry>
> +                  <entry>R'<subscript>31low</subscript></entry>
> +                  <entry>R'<subscript>31high</subscript></entry>
> +                  <entry>R'<subscript>32low</subscript></entry>
> +                  <entry>R'<subscript>32high</subscript></entry>
> +                  <entry>R'<subscript>33low</subscript></entry>
> +                  <entry>R'<subscript>33high</subscript></entry>
> +                </row>
> +              </tbody>
> +            </tgroup>
> +          </informaltable>
> +        </para>
> +      </formalpara>
> +    </example>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 5a08aee..509248a 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -1754,6 +1754,19 @@ interface only.</para>
>  
>    </section>
>  
> +  <section id="tch-formats">
> +    <title>Touch Formats</title>
> +
> +    <para>These formats are used for <link linkend="touch">Touch Sensor</link>
> +interface only.</para>
> +
> +    &sub-tch-td16;
> +    &sub-tch-td08;
> +    &sub-tch-tu16;
> +    &sub-tch-tu08;
> +
> +  </section>
> +
>    <section id="pixfmt-reserved">
>      <title>Reserved Format Identifiers</title>
>  
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 42e626d..b577de2 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -605,6 +605,7 @@ and discussions on the V4L mailing list.</revremark>
>      <section id="radio"> &sub-dev-radio; </section>
>      <section id="rds"> &sub-dev-rds; </section>
>      <section id="sdr"> &sub-dev-sdr; </section>
> +    <section id="touch"> &sub-dev-touch; </section>
>      <section id="event"> &sub-dev-event; </section>
>      <section id="subdev"> &sub-dev-subdev; </section>
>    </chapter>
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 70b559d..31f34fa 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -529,6 +529,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
>  	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
> +	bool is_touch = vdev->vfl_type == VFL_TYPE_TOUCH;
>  
>  	bitmap_zero(valid_ioctls, BASE_VIDIOC_PRIVATE);
>  
> @@ -573,7 +574,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
>  		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
>  
> -	if (is_vid) {
> +	if (is_vid || is_touch) {
>  		/* video specific ioctls */
>  		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||
>  			       ops->vidioc_enum_fmt_vid_cap_mplane ||
> @@ -662,7 +663,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
>  	}
>  
> -	if (is_vid || is_vbi || is_sdr) {
> +	if (is_vid || is_vbi || is_sdr || is_touch) {
>  		/* ioctls valid for video, vbi or sdr */
>  		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
>  		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
> @@ -675,7 +676,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  		SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
>  	}
>  
> -	if (is_vid || is_vbi) {
> +	if (is_vid || is_vbi || is_touch) {
>  		/* ioctls valid for video or vbi */
>  		if (ops->vidioc_s_std)
>  			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
> @@ -751,6 +752,10 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  		intf_type = MEDIA_INTF_T_V4L_SWRADIO;
>  		vdev->entity.function = MEDIA_ENT_F_IO_SWRADIO;
>  		break;
> +	case VFL_TYPE_TOUCH:
> +		intf_type = MEDIA_INTF_T_V4L_TOUCH;
> +		vdev->entity.function = MEDIA_ENT_F_IO_TOUCH;
> +		break;
>  	case VFL_TYPE_RADIO:
>  		intf_type = MEDIA_INTF_T_V4L_RADIO;
>  		/*
> @@ -845,6 +850,8 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>   *	%VFL_TYPE_SUBDEV - A subdevice
>   *
>   *	%VFL_TYPE_SDR - Software Defined Radio
> + *
> + *	%VFL_TYPE_TOUCH - A touch sensor
>   */
>  int __video_register_device(struct video_device *vdev, int type, int nr,
>  		int warn_if_nr_in_use, struct module *owner)
> @@ -888,6 +895,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>  		/* Use device name 'swradio' because 'sdr' was already taken. */
>  		name_base = "swradio";
>  		break;
> +	case VFL_TYPE_TOUCH:
> +		name_base = "v4l-touch";
> +		break;
>  	default:
>  		printk(KERN_ERR "%s called with unknown type: %d\n",
>  		       __func__, type);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 28e5be2..3f00c67 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -155,6 +155,7 @@ const char *v4l2_type_names[] = {
>  	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE] = "vid-out-mplane",
>  	[V4L2_BUF_TYPE_SDR_CAPTURE]        = "sdr-cap",
>  	[V4L2_BUF_TYPE_SDR_OUTPUT]         = "sdr-out",
> +	[V4L2_BUF_TYPE_TOUCH_CAPTURE]      = "tch-cap",

This buf-type isn't documented anywhere.

Why is it here at all? The atmel driver uses VIDEO_CAPTURE. Is it old code?

>  };
>  EXPORT_SYMBOL(v4l2_type_names);
>  
> @@ -255,6 +256,7 @@ static void v4l_print_format(const void *arg, bool write_only)
>  	switch (p->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +	case V4L2_BUF_TYPE_TOUCH_CAPTURE:
>  		pix = &p->fmt.pix;
>  		pr_cont(", width=%u, height=%u, "
>  			"pixelformat=%c%c%c%c, field=%s, "
> @@ -924,6 +926,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>  	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
>  	bool is_vbi = vfd->vfl_type == VFL_TYPE_VBI;
>  	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> +	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  
> @@ -981,6 +984,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>  		if (is_sdr && is_tx && ops->vidioc_g_fmt_sdr_out)
>  			return 0;
>  		break;
> +	case V4L2_BUF_TYPE_TOUCH_CAPTURE:
> +		if (is_tch && is_rx && ops->vidioc_g_fmt_vid_cap)
> +			return 0;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -1243,6 +1250,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
>  	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
>  	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
> +	case V4L2_TCH_FMT_DELTA_TD16:	descr = "16-bit signed deltas"; break;
> +	case V4L2_TCH_FMT_DELTA_TD08:	descr = "8-bit signed deltas"; break;
> +	case V4L2_TCH_FMT_TU16:		descr = "16-bit unsigned touch data"; break;
> +	case V4L2_TCH_FMT_TU08:		descr = "8-bit unsigned touch data"; break;
>  
>  	default:
>  		/* Compressed formats */
> @@ -1309,6 +1320,7 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
>  	struct video_device *vfd = video_devdata(file);
>  	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
>  	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> +	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  	int ret = -EINVAL;
> @@ -1349,6 +1361,11 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, arg);
>  		break;
> +	case V4L2_BUF_TYPE_TOUCH_CAPTURE:
> +		if (unlikely(!is_rx || !is_tch || !ops->vidioc_enum_fmt_vid_cap))
> +			break;
> +		ret = ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
> +		break;
>  	}
>  	if (ret == 0)
>  		v4l_fill_fmtdesc(p);
> @@ -1362,6 +1379,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  	struct video_device *vfd = video_devdata(file);
>  	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
>  	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> +	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  	int ret;
> @@ -1447,6 +1465,14 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_g_fmt_sdr_out))
>  			break;
>  		return ops->vidioc_g_fmt_sdr_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_TOUCH_CAPTURE:
> +		if (unlikely(!is_rx || !is_tch || !ops->vidioc_g_fmt_vid_cap))
> +			break;
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> +		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
> +		/* just in case the driver zeroed it again */
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> +		return ret;

This will need some more work:

The documentation has to be specific about what to do with the v4l2_pix_format
fields that make no sense for touch. I propose:

field: always FIELD_NONE
colorspace: always COLORSPACE_RAW
flags: always 0
ycbcr_enc/quantization/xfer_func: always 0 (aka DEFAULT)

(the handling of priv remains unchanged).

I think this should actually be set in the v4l2-ioctl code for BUF_TYPE_TOUCH_CAPTURE.

>  	}
>  	return -EINVAL;
>  }
> @@ -1458,6 +1484,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  	struct video_device *vfd = video_devdata(file);
>  	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
>  	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> +	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  	int ret;
> @@ -1534,6 +1561,14 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_s_fmt_sdr_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_TOUCH_CAPTURE:
> +		if (unlikely(!is_rx || !is_tch || !ops->vidioc_s_fmt_vid_cap))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.pix);
> +		ret = ops->vidioc_s_fmt_vid_cap(file, fh, arg);
> +		/* just in case the driver zeroed it again */
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> +		return ret;
>  	}
>  	return -EINVAL;
>  }
> @@ -1545,6 +1580,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  	struct video_device *vfd = video_devdata(file);
>  	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
>  	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
> +	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  	int ret;
> @@ -1618,6 +1654,14 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_try_fmt_sdr_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_TOUCH_CAPTURE:
> +		if (unlikely(!is_rx || !is_tch || !ops->vidioc_try_fmt_vid_cap))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.pix);
> +		ret = ops->vidioc_try_fmt_vid_cap(file, fh, arg);
> +		/* just in case the driver zeroed it again */
> +		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> +		return ret;
>  	}
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 0b1b8c7..6221084 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -554,6 +554,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +	case V4L2_BUF_TYPE_TOUCH_CAPTURE:
>  		requested_sizes[0] = f->fmt.pix.sizeimage;
>  		break;
>  	case V4L2_BUF_TYPE_VBI_CAPTURE:
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 25a3190..a2bbf1c 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -25,7 +25,8 @@
>  #define VFL_TYPE_RADIO		2
>  #define VFL_TYPE_SUBDEV		3
>  #define VFL_TYPE_SDR		4
> -#define VFL_TYPE_MAX		5
> +#define VFL_TYPE_TOUCH		5
> +#define VFL_TYPE_MAX		6
>  
>  /* Is this a receiver, transmitter or mem-to-mem? */
>  /* Ignored for VFL_TYPE_SUBDEV. */
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index df59ede..81dbfec 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -77,6 +77,7 @@ struct media_device_info {
>  #define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 0x01001)
>  #define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 0x01002)
>  #define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 0x01003)
> +#define MEDIA_ENT_F_IO_TOUCH		(MEDIA_ENT_F_BASE + 0x01004)
>  
>  /*
>   * Analog TV IF-PLL decoders
> @@ -297,6 +298,7 @@ struct media_links_enum {
>  #define MEDIA_INTF_T_V4L_RADIO  (MEDIA_INTF_T_V4L_BASE + 2)
>  #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
>  #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
> +#define MEDIA_INTF_T_V4L_TOUCH	(MEDIA_INTF_T_V4L_BASE + 5)
>  
>  #define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
>  #define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 8f95191..7e19782 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -143,6 +143,7 @@ enum v4l2_buf_type {
>  	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
>  	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
>  	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
> +	V4L2_BUF_TYPE_TOUCH_CAPTURE        = 13,
>  	/* Deprecated, do not use */
>  	V4L2_BUF_TYPE_PRIVATE              = 0x80,
>  };
> @@ -440,6 +441,8 @@ struct v4l2_capability {
>  #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>  #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
>  
> +#define V4L2_CAP_TOUCH			0x00100000  /* Is a touch device */
> +
>  #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
>  
>  /*
> @@ -633,6 +636,12 @@ struct v4l2_pix_format {
>  #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
>  #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
>  
> +/* Touch formats - used for Touch devices */
> +#define V4L2_TCH_FMT_DELTA_TD16	v4l2_fourcc('T', 'D', '1', '6') /* 16-bit signed deltas */
> +#define V4L2_TCH_FMT_DELTA_TD08	v4l2_fourcc('T', 'D', '0', '8') /* 8-bit signed deltas */
> +#define V4L2_TCH_FMT_TU16	v4l2_fourcc('T', 'U', '1', '6') /* 16-bit unsigned touch data */
> +#define V4L2_TCH_FMT_TU08	v4l2_fourcc('T', 'U', '0', '8') /* 8-bit unsigned touch data */
> +
>  /* priv field value to indicates that subsequent fields are valid. */
>  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
>  
> @@ -1399,6 +1408,7 @@ struct v4l2_input {
>  /*  Values for the 'type' field */
>  #define V4L2_INPUT_TYPE_TUNER		1
>  #define V4L2_INPUT_TYPE_CAMERA		2
> +#define V4L2_INPUT_TYPE_TOUCH		3
>  
>  /* field 'status' - general */
>  #define V4L2_IN_ST_NO_POWER    0x00000001  /* Attached device is off */
> 

Regards,

	Hans
