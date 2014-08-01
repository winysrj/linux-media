Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1868 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHAPKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 11:10:15 -0400
Message-ID: <53DBADBD.7060407@xs4all.nl>
Date: Fri, 01 Aug 2014 17:09:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jean-Marc VOLLE <jean-marc.volle@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Divneil Rai WADHAWAN <divneil.wadhawan@st.com>
Subject: Re: [PATCH] ITU BT2020 support in v4l2_colorspace
References: <1406905371-17609-1-git-send-email-jean-marc.volle@st.com>
In-Reply-To: <1406905371-17609-1-git-send-email-jean-marc.volle@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/01/2014 05:02 PM, Jean-Marc VOLLE wrote:
> From: vollejm <jean-marc.volle@st.com>
> 
> UHD video content may be encoded using a new color space (BT2020). This patch
> adds it to the  v4l2_colorspace enum

I'm not opposed to this, but have you actually seen video streams with this
colorspace?

More to the point, this colorspace is only valid for 10 and 12 bit deep colors
(something that should be documented as well), and I don't think we even have PIX_FMT
defines for that. Are there plans to add support for that?

Regards,

	Hans

> 
> 
> Signed-off-by: <jean-marc.volle@st.com>
> ---
>  Documentation/DocBook/media/v4l/biblio.xml | 10 ++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml | 14 ++++++++++++++
>  include/uapi/linux/videodev2.h             |  4 ++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
> index d2eb79e..d3930cf 100644
> --- a/Documentation/DocBook/media/v4l/biblio.xml
> +++ b/Documentation/DocBook/media/v4l/biblio.xml
> @@ -117,6 +117,16 @@ url="http://www.itu.ch">http://www.itu.ch</ulink>)</corpauthor>
>        <title>ITU-R Recommendation BT.1119 "625-line
>  television Wide Screen Signalling (WSS)"</title>
>      </biblioentry>
> +    <biblioentry id="itu2020">
> +      <abbrev>ITU&nbsp;BT.2020</abbrev>
> +      <authorgroup>
> +	<corpauthor>International Telecommunication Union (<ulink
> +url="http://www.itu.ch">http://www.itu.ch</ulink>)</corpauthor>
> +      </authorgroup>
> +      <title>ITU-R Recommendation BT.2020 "Parameter values for
> +	      ultra-high definition television systems for production
> +	      and international programme exchange"</title>
> +    </biblioentry>
>  
>      <biblioentry id="jfif">
>        <abbrev>JFIF</abbrev>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 91dcbc8..f0c70dd 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -599,6 +599,20 @@ are still clamped to [0;255].</para>
>  1.099&nbsp;I<superscript>0.45</superscript>&nbsp;-&nbsp;0.099&nbsp;for&nbsp;0.018&nbsp;&lt;&nbsp;I</entry>
>  	    <entry spanname="spam">n/a</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_COLORSPACE_BT2020</constant></entry>
> +	    <entry>9</entry>
> +	    <entry>BT2020, see <xref linkend="itu2020" /></entry>
> +	    <entry>x&nbsp;=&nbsp;0.708, y&nbsp;=&nbsp;0.292</entry>
> +	    <entry>x&nbsp;=&nbsp;0.170, y&nbsp;=&nbsp;0.797</entry>
> +	    <entry>x&nbsp;=&nbsp;0.131, y&nbsp;=&nbsp;0.046</entry>
> +	    <entry>x&nbsp;=&nbsp;0.3127, y&nbsp;=&nbsp;0.3290,
> +	    Illuminant D<subscript>65</subscript></entry>
> +	    <entry>see <xref linkend="itu2020" /></entry>
> +	    <entry>see <xref linkend="itu2020" /></entry>
> +	    <entry>see <xref linkend="itu2020" /></entry>
> +	    <entry>see <xref linkend="itu2020" /></entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 168ff50..6af06e1 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -197,6 +197,10 @@ enum v4l2_colorspace {
>  
>  	/* For RGB colourspaces, this is probably a good start. */
>  	V4L2_COLORSPACE_SRGB          = 8,
> +
> +	/* UHD BT2020 colorspace */
> +	V4L2_COLORSPACE_BT2020          = 9,
> +
>  };
>  
>  enum v4l2_priority {
> 

