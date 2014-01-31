Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3334 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaAaIFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 03:05:23 -0500
Message-ID: <52EB5934.60103@xs4all.nl>
Date: Fri, 31 Jan 2014 09:05:08 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] DocBook: V4L: add V4L2_SDR_FMT_CU8 - 'CU08'
References: <1391139409-11737-1-git-send-email-crope@iki.fi>
In-Reply-To: <1391139409-11737-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On 01/31/2014 04:36 AM, Antti Palosaari wrote:
> Document V4L2_SDR_FMT_CU8 SDR format.
> It is complex unsigned 8-bit IQ sample. Used by software defined
> radio devices.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  .../DocBook/media/v4l/pixfmt-sdr-cu08.xml          | 44 ++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |  2 +
>  2 files changed, 46 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
> new file mode 100644
> index 0000000..2d80104
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
> @@ -0,0 +1,44 @@
> +<refentry id="V4L2-SDR-FMT-CU08">
> +  <refmeta>
> +    <refentrytitle>V4L2_SDR_FMT_CU8 ('CU08')</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +    <refnamediv>
> +      <refname>
> +        <constant>V4L2_SDR_FMT_CU8</constant>
> +      </refname>
> +      <refpurpose>Complex unsigned 8-bit IQ sample</refpurpose>
> +    </refnamediv>
> +    <refsect1>
> +      <title>Description</title>
> +      <para>
> +This format contains sequence of complex number samples. Each complex number
> +consist two parts, called In-phase and Quadrature (IQ). Both I and Q are
> +represented as a 8 bit unsigned number. I value comes first and Q value after
> +that.
> +      </para>
> +    <example>
> +      <title><constant>V4L2_SDR_FMT_CU8</constant> 1 sample</title>
> +      <formalpara>
> +        <title>Byte Order.</title>
> +        <para>Each cell is one byte.
> +          <informaltable frame="none">
> +            <tgroup cols="2" align="center">
> +              <colspec align="left" colwidth="2*" />
> +              <tbody valign="top">
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;0:</entry>
> +                  <entry>I'<subscript>0</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;1:</entry>
> +                  <entry>Q'<subscript>0</subscript></entry>
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
> index f586d34..40adcb8 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -817,6 +817,8 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
>      <para>These formats are used for <link linkend="sdr">SDR Capture</link>
>  interface only.</para>
>  
> +    &sub-sdr-cu08;
> +
>    </section>
>  
>    <section id="pixfmt-reserved">
> 
