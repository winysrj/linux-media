Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZCNMSP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 08:18:15 -0400
Date: Sat, 14 Mar 2009 09:17:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] LED control
Message-ID: <20090314091747.21153855@pedra.chehab.org>
In-Reply-To: <20090314125923.4229cd93@free.fr>
References: <20090314125923.4229cd93@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Mar 2009 12:59:23 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> +	    <entry><constant>V4L2_CID_LEDS</constant></entry>
> +	    <entry>integer</entry>
> +	    <entry>Switch on or off the LEDs or illuminators of the device.
> +In the control value, each LED may be coded in one bit (0: off, 1: on) or in
> +many bits (light intensity).</entry>
> +	  </row>
> +	  <row>

The idea of having some sort of control over the LEDs is interesting, but we
should have a better way of controlling it. If the LED may have more than one
bit, maybe the better would be to create more than one CID entry. Something like:

V4L2_CID_LED_POWER	- for showing that the camera is being used
V4L2_CID_LED_LIGHT	- for normal white light
V4L2_CID_LED_INFRARED	- for dark light, using infrared
...

This way a driver can enumberate what kind of leds are available, and get the
power intensity range for each individual one.

Cheers,
Mauro
