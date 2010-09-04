Return-path: <mchehab@localhost>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49581 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026Ab0IDTvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Sep 2010 15:51:04 -0400
Subject: Re: [PATCH] LED control
From: Andy Walls <awalls@md.metrocast.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20100904131048.6ca207d1@tele>
References: <20100904131048.6ca207d1@tele>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 15:50:25 -0400
Message-ID: <1283629825.2060.16.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sat, 2010-09-04 at 13:10 +0200, Jean-Francois Moine wrote:
> Some media devices may have one or many lights (LEDs, illuminators,
> lamps..). This patch makes them controlable by the applications.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Jean-Francois,

Thanks for the proposal.  It looks OK to me.

Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
> index 8408caa..c9b8ca5 100644
> --- a/Documentation/DocBook/v4l/controls.xml
> +++ b/Documentation/DocBook/v4l/controls.xml
> @@ -312,6 +312,13 @@ minimum value disables backlight compensation.</entry>
>             information and bits 24-31 must be zero.</entry>
>           </row>
>           <row>
> +           <entry><constant>V4L2_CID_LEDS</constant></entry>
> +           <entry>integer</entry>
> +           <entry>Switch on or off the LED(s) or illuminator(s) of the device.
> +           The control type and values depend on the driver and may be either
> +           a single boolean (0: off, 1:on) or the index in a menu type.</entry>
> +         </row>
> +         <row>
>             <entry><constant>V4L2_CID_LASTP1</constant></entry>
>             <entry></entry>
>             <entry>End of the predefined control IDs (currently
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 61490c6..3807492 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1045,8 +1045,10 @@ enum v4l2_colorfx {
>  
>  #define V4L2_CID_CHROMA_GAIN                    (V4L2_CID_BASE+36)
>  
> +#define V4L2_CID_LEDS                          (V4L2_CID_BASE+37)
> +
>  /* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+37)
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+38)
>  
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE                     (V4L2_CTRL_CLASS_MPEG | 0x900)
> 

