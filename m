Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1652 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956Ab2D0KM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 06:12:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 01/13] V4L: Extend V4L2_CID_COLORFX with more image effects
Date: Fri, 27 Apr 2012 12:12:09 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, sungchun.kang@samsung.com,
	subash.ramaswamy@linaro.org
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com> <1335520386-20835-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1335520386-20835-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204271212.09323.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester!

On Friday, April 27, 2012 11:52:54 Sylwester Nawrocki wrote:
> This patch adds definition of additional color effects:
>  - V4L2_COLORFX_AQUA,
>  - V4L2_COLORFX_ART_FREEZE,
>  - V4L2_COLORFX_SILHOUETTE,
>  - V4L2_COLORFX_SOLARIZATION,
>  - V4L2_COLORFX_ANTIQUE,
>  - V4L2_COLORFX_ARBITRARY_CBCR.
> 
> The control's type in the documentation is changed from 'enum' to 'menu'
> - V4L2_CID_COLORFX has always been a menu, not an integer type control.
> 
> The V4L2_COLORFX_ARBITRARY_CBCR option enables custom color effects,
> which are impossible or impractical to define as menu items. The
> V4L2_CID_BLUE_BALANCE and V4L2_CID_RED_BALANCE controls allow in this
> case to configure the Cb, Cr coefficients.

So this just hijacks the RED/BLUE_BALANCE controls for a different purpose?
If I understand this 'effect' correctly it just replaces the Cb and Cr
coefficients with fixed values, basically giving you a B&W picture (the Y
coefficient), except that it is really a 'Black&FixedColor' picture.

I think you should add a new control for setting this. V4L2_CID_COLORFX_COLOR
or something.

Regards,

	Hans

> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/compat.xml   |   10 +++
>  Documentation/DocBook/media/v4l/controls.xml |   92 ++++++++++++++++++++++----
>  Documentation/DocBook/media/v4l/v4l2.xml     |    5 +-
>  drivers/media/video/v4l2-ctrls.c             |    6 ++
>  include/linux/videodev2.h                    |   26 +++++---
>  5 files changed, 114 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 87339b2..a6a9c5c 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2422,6 +2422,16 @@ details.</para>
>  	  &VIDIOC-SUBDEV-G-SELECTION; and
>  	  &VIDIOC-SUBDEV-S-SELECTION;.</para>
>          </listitem>
> +        <listitem>
> +	  <para> Added <constant>V4L2_COLORFX_ANTIQUE</constant>,
> +	  <constant>V4L2_COLORFX_ART_FREEZE</constant>,
> +	  <constant>V4L2_COLORFX_AQUA</constant>,
> +	  <constant>V4L2_COLORFX_SILHOUETTE</constant>,
> +	  <constant>V4L2_COLORFX_SOLARIZATION</constant>,
> +	  <constant>V4L2_COLORFX_VIVID</constant> and
> +	  <constant>V4L2_COLORFX_ARBITRARY_CBCR</constant> menu items
> +to the <constant>V4L2_CID_COLORFX</constant> control.</para>
> +        </listitem>
>        </orderedlist>
>      </section>
>  
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 5038a3a..8b604b0 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -284,19 +284,85 @@ minimum value disables backlight compensation.</entry>
>  	  </row>
>  	  <row id="v4l2-colorfx">
>  	    <entry><constant>V4L2_CID_COLORFX</constant></entry>
> -	    <entry>enum</entry>
> -	    <entry>Selects a color effect. Possible values for
> -<constant>enum v4l2_colorfx</constant> are:
> -<constant>V4L2_COLORFX_NONE</constant> (0),
> -<constant>V4L2_COLORFX_BW</constant> (1),
> -<constant>V4L2_COLORFX_SEPIA</constant> (2),
> -<constant>V4L2_COLORFX_NEGATIVE</constant> (3),
> -<constant>V4L2_COLORFX_EMBOSS</constant> (4),
> -<constant>V4L2_COLORFX_SKETCH</constant> (5),
> -<constant>V4L2_COLORFX_SKY_BLUE</constant> (6),
> -<constant>V4L2_COLORFX_GRASS_GREEN</constant> (7),
> -<constant>V4L2_COLORFX_SKIN_WHITEN</constant> (8) and
> -<constant>V4L2_COLORFX_VIVID</constant> (9).</entry>
> +	    <entry>menu</entry>
> +	    <entry>Selects a color effect. The following values are defined:
> +	    </entry>
> +	  </row><row>
> +	  <entry></entry>
> +	  <entry></entry>
> +	    <entrytbl spanname="descr" cols="2">
> +	      <tbody valign="top">
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_NONE</constant>&nbsp;</entry>
> +		  <entry>Color effect is disabled.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_ANTIQUE</constant>&nbsp;</entry>
> +		  <entry>An aging (old photo) effect.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_ART_FREEZE</constant>&nbsp;</entry>
> +		  <entry>Frost color effect.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_AQUA</constant>&nbsp;</entry>
> +		  <entry>Water color, cool tone.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_BW</constant>&nbsp;</entry>
> +		  <entry>Black and white.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_EMBOSS</constant>&nbsp;</entry>
> +		  <entry>Emboss, the highlights and shadows replace light/dark boundaries
> +		  and low contrast areas are set to a gray background.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_GRASS_GREEN</constant>&nbsp;</entry>
> +		  <entry>Grass green.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_NEGATIVE</constant>&nbsp;</entry>
> +		  <entry>Negative.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_SEPIA</constant>&nbsp;</entry>
> +		  <entry>Sepia tone.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_SKETCH</constant>&nbsp;</entry>
> +		  <entry>Sketch.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_SKIN_WHITEN</constant>&nbsp;</entry>
> +		  <entry>Skin whiten.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_SKY_BLUE</constant>&nbsp;</entry>
> +		  <entry>Sky blue.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_SOLARIZATION</constant>&nbsp;</entry>
> +		  <entry>Solarization, the image is partially reversed in tone,
> +		  only color values above or below a certain threshold are inverted.
> +		  </entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_SILHOUETTE</constant>&nbsp;</entry>
> +		  <entry>Silhouette (outline).</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_VIVID</constant>&nbsp;</entry>
> +		  <entry>Vivid colors.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_COLORFX_ARBITRARY_CBCR</constant>&nbsp;</entry>
> +		  <entry>Arbitrary chroma components. The Cb, Cr coefficients
> +are determined by <constant>V4L2_CID_BLUE_BALANCE</constant> and <constant>
> +V4L2_CID_RED_BALANCE</constant> control respectively.</entry>
> +		</row>
> +	      </tbody>
> +	    </entrytbl>
>  	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_CID_ROTATE</constant></entry>
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index fbf808d..e4e65d0 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -141,9 +141,10 @@ applications. -->
>        <revision>
>  	<revnumber>3.5</revnumber>
>  	<date>2012-04-02</date>
> -	<authorinitials>sa</authorinitials>
> +	<authorinitials>sa, sn</authorinitials>
>  	<revremark>Added V4L2_CTRL_TYPE_INTEGER_MENU and V4L2 subdev
> -	    selections API.
> +	    selections API. Corrected and extended the V4L2_CID_COLORFX
> +	    control description.
>  	</revremark>
>        </revision>
>  
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index c93a979..25132ec 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -241,6 +241,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Grass Green",
>  		"Skin Whiten",
>  		"Vivid",
> +		"Aqua",
> +		"Art Freeze",
> +		"Silhouette",
> +		"Solarization",
> +		"Antique",
> +		"Arbitrary Cb/Cr",
>  		NULL
>  	};
>  	static const char * const tune_preemphasis[] = {
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 5a09ac3..764f300 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1241,16 +1241,22 @@ enum v4l2_power_line_frequency {
>  #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
>  #define V4L2_CID_COLORFX			(V4L2_CID_BASE+31)
>  enum v4l2_colorfx {
> -	V4L2_COLORFX_NONE	= 0,
> -	V4L2_COLORFX_BW		= 1,
> -	V4L2_COLORFX_SEPIA	= 2,
> -	V4L2_COLORFX_NEGATIVE = 3,
> -	V4L2_COLORFX_EMBOSS = 4,
> -	V4L2_COLORFX_SKETCH = 5,
> -	V4L2_COLORFX_SKY_BLUE = 6,
> -	V4L2_COLORFX_GRASS_GREEN = 7,
> -	V4L2_COLORFX_SKIN_WHITEN = 8,
> -	V4L2_COLORFX_VIVID = 9,
> +	V4L2_COLORFX_NONE			= 0,
> +	V4L2_COLORFX_BW				= 1,
> +	V4L2_COLORFX_SEPIA			= 2,
> +	V4L2_COLORFX_NEGATIVE			= 3,
> +	V4L2_COLORFX_EMBOSS			= 4,
> +	V4L2_COLORFX_SKETCH			= 5,
> +	V4L2_COLORFX_SKY_BLUE			= 6,
> +	V4L2_COLORFX_GRASS_GREEN		= 7,
> +	V4L2_COLORFX_SKIN_WHITEN		= 8,
> +	V4L2_COLORFX_VIVID			= 9,
> +	V4L2_COLORFX_AQUA			= 10,
> +	V4L2_COLORFX_ART_FREEZE			= 11,
> +	V4L2_COLORFX_SILHOUETTE			= 12,
> +	V4L2_COLORFX_SOLARIZATION		= 13,
> +	V4L2_COLORFX_ANTIQUE			= 14,
> +	V4L2_COLORFX_ARBITRARY_CBCR		= 15,
>  };
>  #define V4L2_CID_AUTOBRIGHTNESS			(V4L2_CID_BASE+32)
>  #define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+33)
> 
