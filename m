Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2006 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZC3LxF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 07:53:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hardik Shah <hardik.shah@ti.com>
Subject: Re: [PATCH 1/3] Documentation for new V4L2 CIDs added.
Date: Mon, 30 Mar 2009 13:52:57 +0200
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Brijesh Jadav <brijesh.j@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
References: <1237526389-13835-1-git-send-email-hardik.shah@ti.com>
In-Reply-To: <1237526389-13835-1-git-send-email-hardik.shah@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903301352.58079.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hardik,

OK, so it took a little longer than a week. So sue me :-)

Here is the review:On Friday 20 March 2009 06:19:49 Hardik Shah wrote:
> 1. Updated for V4L2_CID_BG_COLOR
> 2. Updated for V4L2_CID_ROTATION
> Both of the above are discussed in length with community
> 3. Updated for new flags and capability field added
> to v4l2_frame buffer structure.
> 
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  v4l2-spec/controls.sgml      |   19 ++++++++++++++++++-
>  v4l2-spec/vidioc-g-fbuf.sgml |   19 +++++++++++++++++++
>  2 files changed, 37 insertions(+), 1 deletions(-)
> 
> diff --git a/v4l2-spec/controls.sgml b/v4l2-spec/controls.sgml
> index 477a970..79e2c28 100644
> --- a/v4l2-spec/controls.sgml
> +++ b/v4l2-spec/controls.sgml
> @@ -281,10 +281,27 @@ minimum value disables backlight compensation.</entry>
>  <constant>V4L2_COLORFX_SEPIA</constant> (2).</entry>
>  	  </row>
>  	  <row>
> + 	    <entry><constant>V4L2_CID_ROTATION</constant></entry>
> + 	    <entry>integer</entry>
> + 	    <entry>Rotates the image by specified angle. Common angles are 90, 270,
> +and 180. Rotating the image to 90 and 270 will reverse the height and width of
> +the display window.  Its is necessary to set the new height and width of the picture

Typo: 'Its' -> 'It'

> +using S_FMT ioctl see <xref linkend="vidioc-g-fmt"> according to the rotation angle selected</entry>
> + 	  </row>
> + 	  <row>
> + 	    <entry><constant>V4L2_CID_BG_COLOR</constant></entry>
> + 	    <entry>integer</entry>
> + 	    <entry>Sets the background color on the current output device.

Typo: 'on' -> 'of'

> +Background color needs to be specified in the RGB24 format.  The supplied 32
> +bit value is intepreted as Bits 0-7 Red color information, Bits 8-15 Green color
> +information, Bits 16-23 Blue color information and Bits 24-31 must be
> +zero.</entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
>  	    <entry></entry>
>  	    <entry>End of the predefined control IDs (currently
> -<constant>V4L2_CID_COLORFX</constant> + 1).</entry>
> +<constant>V4L2_CID_BG_COLOR</constant> + 1).</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
> diff --git a/v4l2-spec/vidioc-g-fbuf.sgml b/v4l2-spec/vidioc-g-fbuf.sgml
> index 6781b53..27d1e29 100644
> --- a/v4l2-spec/vidioc-g-fbuf.sgml
> +++ b/v4l2-spec/vidioc-g-fbuf.sgml
> @@ -336,6 +336,13 @@ alpha value. Alpha blending makes no sense for destructive overlays.</entry>
>  inverted alpha channel of the framebuffer or VGA signal. Alpha
>  blending makes no sense for destructive overlays.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_FBUF_CAP_SRC_CHROMAKEY</constant></entry>
> +	    <entry>0x0080</entry>
> +	    <entry>The device supports source chorma keying. Framebuffer

Typo: chorma -> chroma

> +images will be replaced by the video images.  Exactly
> +opposite of <constant>V4L2_FBUF_CAP_CHROMAKEY</constant></entry>

Hmm. This is a bit obscure. CAP_CHROMAKEY means that framebuffer pixels with
the chromakey color are replaced by video pixels. CAP_SRC_CHROMAKEY means
that video pixels with the chromakey color are replaced by the framebuffer
pixels. At least the way I read it this is the opposite of what you wrote.

It pays to be very precise here since it can get confusing very quickly.

> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> @@ -411,6 +418,18 @@ images, but with an inverted alpha value. The blend function is:
>  output = framebuffer pixel * (1 - alpha) + video pixel * alpha. The
>  actual alpha depth depends on the framebuffer pixel format.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_FBUF_FLAG_SRC_CHROMAKEY</constant></entry>
> +	    <entry>0x0040</entry>
> +	    <entry>Use chroma-keying. The chroma-key color is

Write: 'Use source chroma-keying.' to prevent confusion with
V4L2_FBUF_FLAG_CHROMAKEY.

> +determined by the <structfield>chromakey</structfield> field of
> +&v4l2-window; and negotiated with the &VIDIOC-S-FMT; ioctl, see <xref
> +linkend="overlay"> and <xref linkend="osd">.
> +Since any one of the chorma keying can be active at a time as both

Typo: chorma -> chroma

> +of them are exactly opposite same <structfield>chromakey</structfield>

Typo: 'opposite same' -> 'opposite the same'

> +field of &v4l2-window; can be used to set the chroma key for source
> +keying also.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> --
> 1.5.6

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
