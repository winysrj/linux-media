Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56086 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab1L1N4B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 08:56:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH 2/4] v4l: Add V4L2_CID_SCENEMODE menu control
Date: Wed, 28 Dec 2011 14:56:04 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <1325053428-2626-3-git-send-email-riverful.kim@samsung.com>
In-Reply-To: <1325053428-2626-3-git-send-email-riverful.kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112281456.05515.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wednesday 28 December 2011 07:23:46 HeungJun, Kim wrote:
> It adds the new CID for setting Scenemode. This CID is provided as
> menu type using the following items:
> enum v4l2_scenemode {
> 	V4L2_SCENEMODE_NONE = 0,
> 	V4L2_SCENEMODE_NORMAL = 1,
> 	V4L2_SCENEMODE_PORTRAIT = 2,
> 	V4L2_SCENEMODE_LANDSCAPE = 3,
> 	V4L2_SCENEMODE_SPORTS = 4,
> 	V4L2_SCENEMODE_PARTY_INDOOR = 5,
> 	V4L2_SCENEMODE_BEACH_SNOW = 6,
> 	V4L2_SCENEMODE_SUNSET = 7,
> 	V4L2_SCENEMODE_DAWN_DUSK = 8,
> 	V4L2_SCENEMODE_FALL = 9,
> 	V4L2_SCENEMODE_NIGHT = 10,
> 	V4L2_SCENEMODE_AGAINST_LIGHT = 11,
> 	V4L2_SCENEMODE_FIRE = 12,
> 	V4L2_SCENEMODE_TEXT = 13,
> 	V4L2_SCENEMODE_CANDLE = 14,
> };
> 
> Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |   88
> ++++++++++++++++++++++++++ drivers/media/video/v4l2-ctrls.c             | 
>  21 ++++++
>  include/linux/videodev2.h                    |   19 ++++++
>  3 files changed, 128 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml index 350c138..afe1845
> 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2879,6 +2879,94 @@ it one step further. This is a write-only
> control.</entry> </row>
>  	  <row><entry></entry></row>
> 
> +	  <row id="v4l2-scenemode">
> +	    <entry
> spanname="id"><constant>V4L2_CID_SCENEMODE</constant>&nbsp;</entry> +	   
> <entry>enum&nbsp;v4l2_scenemode</entry>
> +	  </row><row><entry spanname="descr">This control sets
> +	  the camera's scenemode, and it is provided by the type of
> +	  the enum values. The "None" mode means the status
> +	  when scenemode algorithm is not activated, like after booting time.
> +	  On the other hand, the "Normal" mode means the scenemode algorithm
> +	  is activated on the normal mode.</entry>

What low-level parameters do the scene mode control ? How does it interact 
with the related controls ?

> +	  </row>
> +	  <row>
> +	    <entrytbl spanname="descr" cols="2">
> +	      <tbody valign="top">
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_NONE</constant>&nbsp;</entry>
> +		  <entry>Scenemode None.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_NORMAL</constant>&nbsp;</entry>
> +		  <entry>Scenemode Normal.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_PORTRAIT</constant>&nbsp;</entry>
> +		  <entry>Scenemode Portrait.</entry>

Could you please describe the scene modes in more details ?

> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_LANDSCAPE</constant>&nbsp;</entry>
> +		  <entry>Scenemode Landscape.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_SPORTS</constant>&nbsp;</entry>
> +		  <entry>Scenemode Sports.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_PARTY_INDOOR</constant>&nbsp;</entry>
> +		  <entry>Scenemode Party Indoor.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_BEACH_SNOW</constant>&nbsp;</entry>
> +		  <entry>Scenemode Beach Snow.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_SUNSET</constant>&nbsp;</entry>
> +		  <entry>Scenemode Beach Snow.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_DAWN_DUSK</constant>&nbsp;</entry>
> +		  <entry>Scenemode Dawn Dusk.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_FALL</constant>&nbsp;</entry>
> +		  <entry>Scenemode Fall.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_NIGHT</constant>&nbsp;</entry>
> +		  <entry>Scenemode Night.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_AGAINST_LIGHT</constant>&nbsp;</entry>
> +		  <entry>Scenemode Against Light.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_FIRE</constant>&nbsp;</entry>
> +		  <entry>Scenemode Fire.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_TEXT</constant>&nbsp;</entry>
> +		  <entry>Scenemode Text.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_SCENEMODE_CANDLE</constant>&nbsp;</entry>
> +		  <entry>Scenemode Candle.</entry>
> +		</row>
> +	      </tbody>
> +	    </entrytbl>
> +	  </row>
> +	  <row><entry></entry></row>
> +
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry> +	   
> <entry>boolean</entry>
> +	  </row><row><entry spanname="descr">Prevent video from being acquired
> +by the camera. When this control is set to <constant>TRUE</constant> (1),
> no +image can be captured by the camera. Common means to enforce privacy
> are +mechanical obturation of the sensor and firmware image processing,
> but the +device is not restricted to these methods. Devices that implement
> the privacy +control must support read access and may support write
> access.</entry> +	  </row>
>  	  <row>
>  	    <entry
> spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
> <entry>boolean</entry>

-- 
Regards,

Laurent Pinchart
