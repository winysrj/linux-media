Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51503 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1CXOiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 10:38:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
Date: Thu, 24 Mar 2011 15:38:42 +0100
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1300976395-23826-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1300976395-23826-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103241538.43283.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

On Thursday 24 March 2011 15:19:54 Sylwester Nawrocki wrote:
> Add V4L2_MBUS_FMT_JPEG_1X8 format and the corresponding Docbook
> documentation.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> 
> Hi all,
> 
> I would like to propose and addition of JPEG format to the list
> of media bus formats. The requirement of this format had already
> been discussed in the past [1], [2].
> This patch adds relevant entry in v4l2-mediabus.h header and
> the documentation. Initially I have added only bus width information
> to the format code. I am not sure what other information could be
> included. I am open to suggestions if anyone knows about any other
> requirements.
> 
> JPEG format on media bus is, among others, required for Samsung
> S5P MIPI CSI receiver [3] and M-5MOLS camera drivers [4].
> 
> Comments are welcome!
> 
> --
> Regards,
> Sylwester Nawrocki,
> Samsung Poland R&D Center
> 
> [1] http://www.spinics.net/lists/linux-media/msg27980.html
> [2] http://www.spinics.net/lists/linux-media/msg28651.html
> [3] http://www.spinics.net/lists/linux-samsung-soc/msg03807.html
> [4] http://lwn.net/Articles/433836/
> ---
>  Documentation/DocBook/v4l/subdev-formats.xml |   45
> ++++++++++++++++++++++++++ include/linux/v4l2-mediabus.h                | 
>   3 ++
>  2 files changed, 48 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/subdev-formats.xml
> b/Documentation/DocBook/v4l/subdev-formats.xml index b5376e2..60a6fe2
> 100644
> --- a/Documentation/DocBook/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/v4l/subdev-formats.xml
> @@ -2463,5 +2463,50 @@
>  	</tgroup>
>        </table>
>      </section>
> +
> +    <section>
> +      <title>JPEG Compressed Formats</title>
> +
> +      <para>Those data formats are used to transfer arbitrary byte-based
> image +	data obtained from JPEG compression process. The format code
> +	is made of the following information.
> +	<itemizedlist>
> +	  <listitem>The bus width in bits.</listitem>
> +	</itemizedlist>
> +
> +	<para>For instance, a format where bus width is 8 bits will be named
> +	  <constant>V4L2_MBUS_FMT_JPEG_1X8</constant>.
> +	</para>
> +
> +      </para>
> +
> +      <para>The following table lists existing JPEG compressed
> formats.</para> +
> +      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-jpeg">
> +	<title>JPEG Formats</title>
> +	<tgroup cols="23">
> +	  <colspec colname="id" align="left" />
> +	  <colspec colname="code" align="left"/>
> +	  <colspec colname="remarks" align="left"/>
> +	  <thead>
> +	    <row>
> +	      <entry>Identifier</entry>
> +	      <entry>Code</entry>
> +	      <entry>Remarks</entry>
> +	    </row>
> +	  </thead>
> +	  <tbody valign="top">
> +	    <row id="V4L2-MBUS-FMT-JPEG-1X8">
> +	      <entry>V4L2_MBUS_FMT_JPEG_1X8</entry>
> +	      <entry>0x4001</entry>
> +	      <entry> This format shall be used for of transmission of JPEG
> +		data over MIPI CSI-2 bus with User Defined 8-bit Data types.

JPEG formats are not limited to MIPI, some parallel sensors can transmit JPEG 
as well.

> +	      </entry>
> +	    </row>
> +
> +	  </tbody>
> +	</tgroup>
> +      </table>
> +    </section>
>    </section>
>  </section>
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 7054a7a..15d6cda 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -86,6 +86,9 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
>  	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
>  	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
> +
> +	/* JPEG compressed formats - next is 0x4002 */
> +	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
>  };
> 
>  /**

-- 
Regards,

Laurent Pinchart
