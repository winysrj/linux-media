Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2115 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaAaIFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 03:05:35 -0500
Message-ID: <52EB5943.90100@xs4all.nl>
Date: Fri, 31 Jan 2014 09:05:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] DocBook: V4L: add V4L2_SDR_FMT_CU16LE - 'CU16'
References: <1391139409-11737-1-git-send-email-crope@iki.fi> <1391139409-11737-2-git-send-email-crope@iki.fi>
In-Reply-To: <1391139409-11737-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On 01/31/2014 04:36 AM, Antti Palosaari wrote:
> Document V4L2_SDR_FMT_CU16LE format.
> It is complex unsigned 16-bit little endian IQ sample. Used by
> software defined radio devices.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  .../DocBook/media/v4l/pixfmt-sdr-cu16le.xml        | 46 ++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |  1 +
>  2 files changed, 47 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
> new file mode 100644
> index 0000000..26288ff
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
> @@ -0,0 +1,46 @@
> +<refentry id="V4L2-SDR-FMT-CU16LE">
> +  <refmeta>
> +    <refentrytitle>V4L2_SDR_FMT_CU16LE ('CU16')</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +    <refnamediv>
> +      <refname>
> +        <constant>V4L2_SDR_FMT_CU16LE</constant>
> +      </refname>
> +      <refpurpose>Complex unsigned 16-bit little endian IQ sample</refpurpose>
> +    </refnamediv>
> +    <refsect1>
> +      <title>Description</title>
> +      <para>
> +This format contains sequence of complex number samples. Each complex number
> +consist two parts, called In-phase and Quadrature (IQ). Both I and Q are
> +represented as a 16 bit unsigned little endian number. I value comes first
> +and Q value after that.
> +      </para>
> +    <example>
> +      <title><constant>V4L2_SDR_FMT_CU16LE</constant> 1 sample</title>
> +      <formalpara>
> +        <title>Byte Order.</title>
> +        <para>Each cell is one byte.
> +          <informaltable frame="none">
> +            <tgroup cols="3" align="center">
> +              <colspec align="left" colwidth="2*" />
> +              <tbody valign="top">
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;0:</entry>
> +                  <entry>I'<subscript>0[7:0]</subscript></entry>
> +                  <entry>I'<subscript>0[15:8]</subscript></entry>
> +                </row>
> +                <row>
> +                  <entry>start&nbsp;+&nbsp;2:</entry>
> +                  <entry>Q'<subscript>0[7:0]</subscript></entry>
> +                  <entry>Q'<subscript>0[15:8]</subscript></entry>
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
> index 40adcb8..f535d9b 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -818,6 +818,7 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
>  interface only.</para>
>  
>      &sub-sdr-cu08;
> +    &sub-sdr-cu16le;
>  
>    </section>
>  
> 
