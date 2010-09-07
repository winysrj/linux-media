Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:63149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab0IGHKk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Sep 2010 03:10:40 -0400
Message-ID: <4C85E6CC.6010100@redhat.com>
Date: Tue, 07 Sep 2010 09:16:28 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Illuminators and status LED controls
References: <20100906201105.4029d7e7@tele>
In-Reply-To: <20100906201105.4029d7e7@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

Looks good to me.

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

On 09/06/2010 08:11 PM, Jean-Francois Moine wrote:
> Hi,
>
> This new proposal cancels the previous 'LED control' patch.
>
> Cheers.
>
> -- Ken ar c'hentañ | ** Breizh ha Linux atav! ** Jef | http://moinejf.free.fr/
>
>
> led.patch
>
>
> Some media devices (microscopes) may have one or many illuminators,
> and most webcams have a status LED which is normally on when capture is active.
> This patch makes them controlable by the applications.
>
> Signed-off-by: Jean-Francois Moine<moinejf@free.fr>
>
> diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
> index 8408caa..77f87ad 100644
> --- a/Documentation/DocBook/v4l/controls.xml
> +++ b/Documentation/DocBook/v4l/controls.xml
> @@ -312,10 +312,27 @@ minimum value disables backlight compensation.</entry>
>   	information and bits 24-31 must be zero.</entry>
>   	</row>
>   	<row>
> +	<entry><constant>V4L2_CID_ILLUMINATORS</constant></entry>
> +	<entry>integer</entry>
> +	<entry>Switch on or off the illuminator(s) of the device
> +		(usually a microscope).
> +	    The control type and values depend on the driver and may be either
> +	    a single boolean (0: off, 1:on) or defined by a menu type.</entry>
> +	</row>
> +	<row id="v4l2_status_led">
> +	<entry><constant>V4L2_CID_STATUS_LED</constant></entry>
> +	<entry>integer</entry>
> +	<entry>Set the status LED behaviour. Possible values for
> +<constant>enum v4l2_status_led</constant>  are:
> +<constant>V4L2_STATUS_LED_AUTO</constant>  (0),
> +<constant>V4L2_STATUS_LED_ON</constant>  (1),
> +<constant>V4L2_STATUS_LED_OFF</constant>  (2).</entry>
> +	</row>
> +	<row>
>   	<entry><constant>V4L2_CID_LASTP1</constant></entry>
>   	<entry></entry>
>   	<entry>End of the predefined control IDs (currently
> -<constant>V4L2_CID_BG_COLOR</constant>  + 1).</entry>
> +<constant>V4L2_CID_STATUS_LED</constant>  + 1).</entry>
>   	</row>
>   	<row>
>   	<entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 61490c6..75e8869 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1045,8 +1045,16 @@ enum v4l2_colorfx {
>
>   #define V4L2_CID_CHROMA_GAIN                    (V4L2_CID_BASE+36)
>
> +#define V4L2_CID_ILLUMINATORS			(V4L2_CID_BASE+37)
> +#define V4L2_CID_STATUS_LED			(V4L2_CID_BASE+38)
> +enum v4l2_status_led {
> +	V4L2_STATUS_LED_AUTO	= 0,
> +	V4L2_STATUS_LED_ON	= 1,
> +	V4L2_STATUS_LED_OFF	= 2,
> +};
> +
>   /* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+37)
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+39)
>
>   /*  MPEG-class control IDs defined by V4L2 */
>   #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
