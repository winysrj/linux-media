Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45822 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428AbcGHKXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 06:23:17 -0400
Subject: Re: [PATCH v3 3/9] DocBook/v4l: Add compressed video formats used on
 MT8173 codec driver
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-2-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-3-git-send-email-tiffany.lin@mediatek.com>
 <1464611363-14936-4-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5a793171-24a7-4e9e-8bfd-f668c789f8e0@xs4all.nl>
Date: Fri, 8 Jul 2016 12:23:11 +0200
MIME-Version: 1.0
In-Reply-To: <1464611363-14936-4-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2016 02:29 PM, Tiffany Lin wrote:
> Add V4L2_PIX_FMT_MT21 documentation
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  Documentation/DocBook/media/v4l/pixfmt.xml |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 5a08aee..d40e0ce 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -1980,6 +1980,12 @@ array. Anything what's in between the UYVY lines is JPEG data and should be
>  concatenated to form the JPEG stream. </para>
>  </entry>
>  	  </row>
> +	  <row id="V4L2_PIX_FMT_MT21">
> +	    <entry><constant>V4L2_PIX_FMT_MT21</constant></entry>
> +	    <entry>'MT21'</entry>
> +	    <entry>Compressed two-planar YVU420 format used by Mediatek MT8173
> +	    codec driver.</entry>

Can you give a few more details? The encoder driver doesn't seem to produce this
format, so who is creating this? Where is this format documented?

Regards,

	Hans

> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> 
