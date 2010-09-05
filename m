Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:16205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab0IEHvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 03:51:12 -0400
Message-ID: <4C834D46.5030801@redhat.com>
Date: Sun, 05 Sep 2010 09:56:54 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] LED control
References: <20100904131048.6ca207d1@tele>
In-Reply-To: <20100904131048.6ca207d1@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi all,

On 09/04/2010 01:10 PM, Jean-Francois Moine wrote:
> Some media devices may have one or many lights (LEDs, illuminators,
> lamps..). This patch makes them controlable by the applications.
>
> Signed-off-by: Jean-Francois Moine<moinejf@free.fr>
>
> -- Ken ar c'hentañ | ** Breizh ha Linux atav! ** Jef | http://moinejf.free.fr/
>
>
> led.patch
>
>
> diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
> index 8408caa..c9b8ca5 100644
> --- a/Documentation/DocBook/v4l/controls.xml
> +++ b/Documentation/DocBook/v4l/controls.xml
> @@ -312,6 +312,13 @@ minimum value disables backlight compensation.</entry>
>   	information and bits 24-31 must be zero.</entry>
>   	</row>
>   	<row>
> +	<entry><constant>V4L2_CID_LEDS</constant></entry>
> +	<entry>integer</entry>
> +	<entry>Switch on or off the LED(s) or illuminator(s) of the device.
> +	    The control type and values depend on the driver and may be either
> +	    a single boolean (0: off, 1:on) or the index in a menu type.</entry>
> +	</row>

I think that using one control for both status leds (which is what we are usually
talking about) and illuminator(s) is a bad idea. I'm fine with standardizing these,
but can we please have 2 CID's one for status lights and one for the led. Esp, as I
can easily see us supporting a microscope in the future where the microscope itself
or other devices with the same bridge will have a status led, so then we will need
2 separate controls anyways.

Regards,

Hans
