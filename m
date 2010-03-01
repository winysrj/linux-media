Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:35302 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0CAJAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 04:00:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH 1/3] add feedback LED control
Date: Mon, 1 Mar 2010 10:01:27 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
References: <4B8A2158.6020701@freemail.hu>
In-Reply-To: <4B8A2158.6020701@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003011001.30603.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Márton,

On Sunday 28 February 2010 08:55:04 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> On some webcams a feedback LED can be found. This LED usually shows
> the state of streaming mode: this is the "Auto" mode. The LED can
> be programmed to constantly switched off state (e.g. for power saving
> reasons, preview mode) or on state (e.g. the application shows motion
> detection or "on-air").
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -r d8fafa7d88dc linux/Documentation/DocBook/v4l/controls.xml
> --- a/linux/Documentation/DocBook/v4l/controls.xml	Thu Feb 18 19:02:51 
2010
> +0100 +++ b/linux/Documentation/DocBook/v4l/controls.xml	Sun Feb 28
> 08:41:17 2010 +0100 @@ -311,6 +311,17 @@
>  Applications depending on particular custom controls should check the
>  driver name and version, see <xref linkend="querycap" />.</entry>
>  	  </row>
> +	  <row id="v4l2-led">
> +	    <entry><constant>V4L2_CID_LED</constant></entry>
> +	    <entry>enum</entry>
> +	    <entry>Controls the feedback LED on the camera. In auto mode
> +the LED is on when the streaming is active. The LED is off when not
> streaming. +The LED can be also turned on and off independent from
> streaming. +Possible values for <constant>enum v4l2_led</constant> are:
> +<constant>V4L2_CID_LED_AUTO</constant> (0),
> +<constant>V4L2_CID_LED_ON</constant> (1) and
> +<constant>V4L2_CID_LED_OFF</constant> (2).</entry>
> +	  </row>

There's more than just auto, on and off. On Logitech webcams, LEDs can be 
configured to blink as well.

>  	</tbody>
>        </tgroup>
>      </table>
> diff -r d8fafa7d88dc linux/Documentation/DocBook/v4l/videodev2.h.xml
> --- a/linux/Documentation/DocBook/v4l/videodev2.h.xml	Thu Feb 18 19:02:51
> 2010 +0100 +++ b/linux/Documentation/DocBook/v4l/videodev2.h.xml	Sun Feb
> 28 08:41:17 2010 +0100 @@ -1024,8 +1024,14 @@
> 
>  #define V4L2_CID_ROTATE                         (V4L2_CID_BASE+34)
>  #define V4L2_CID_BG_COLOR                       (V4L2_CID_BASE+35)
> +#define V4L2_CID_LED                            (V4L2_CID_BASE+36)
> +enum v4l2_led {
> +        V4L2_LED_AUTO           = 0,
> +        V4L2_LED_ON             = 1,
> +        V4L2_LED_OFF            = 2,
> +};
>  /* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+36)
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+37)
> 
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE                      (V4L2_CTRL_CLASS_MPEG |
> 0x900) diff -r d8fafa7d88dc linux/drivers/media/video/v4l2-common.c
> --- a/linux/drivers/media/video/v4l2-common.c	Thu Feb 18 19:02:51 2010
> +0100 +++ b/linux/drivers/media/video/v4l2-common.c	Sun Feb 28 08:41:17
> 2010 +0100 @@ -349,6 +349,12 @@
>  		"75 useconds",
>  		NULL,
>  	};
> +	static const char *led[] = {
> +		"Auto",
> +		"On",
> +		"Off",
> +		NULL,
> +	};
> 
>  	switch (id) {
>  		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> @@ -389,6 +395,8 @@
>  			return colorfx;
>  		case V4L2_CID_TUNE_PREEMPHASIS:
>  			return tune_preemphasis;
> +		case V4L2_CID_LED:
> +			return led;
>  		default:
>  			return NULL;
>  	}
> @@ -434,6 +442,7 @@
>  	case V4L2_CID_COLORFX:			return "Color Effects";
>  	case V4L2_CID_ROTATE:			return "Rotate";
>  	case V4L2_CID_BG_COLOR:			return "Background color";
> +	case V4L2_CID_LED:			return "Feedback LED";
> 
>  	/* MPEG controls */
>  	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
> @@ -575,6 +584,7 @@
>  	case V4L2_CID_EXPOSURE_AUTO:
>  	case V4L2_CID_COLORFX:
>  	case V4L2_CID_TUNE_PREEMPHASIS:
> +	case V4L2_CID_LED:
>  		qctrl->type = V4L2_CTRL_TYPE_MENU;
>  		step = 1;
>  		break;
> diff -r d8fafa7d88dc linux/include/linux/videodev2.h
> --- a/linux/include/linux/videodev2.h	Thu Feb 18 19:02:51 2010 +0100
> +++ b/linux/include/linux/videodev2.h	Sun Feb 28 08:41:17 2010 +0100
> @@ -1030,8 +1030,14 @@
> 
>  #define V4L2_CID_ROTATE				(V4L2_CID_BASE+34)
>  #define V4L2_CID_BG_COLOR			(V4L2_CID_BASE+35)
> +#define V4L2_CID_LED				(V4L2_CID_BASE+36)
> +enum v4l2_led {
> +	V4L2_LED_AUTO		= 0,
> +	V4L2_LED_ON		= 1,
> +	V4L2_LED_OFF		= 2,
> +};

enums shouldn't be used in kernelspace <-> userspace APIs, as their size is 
not stable across ARM ABIs. In this case it won't matter much, the enum not 
being part of any structure. If someone creates a new ioctl that uses enum 
v4l2_led as one field of its structure argument, things will break.

>  /* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+36)
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+37)
> 
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

-- 
Regards,

Laurent Pinchart
