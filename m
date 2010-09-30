Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:58983 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab0I3JkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 05:40:15 -0400
Message-ID: <4CA45AFC.2080807@iki.fi>
Date: Thu, 30 Sep 2010 12:40:12 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
References: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr> <1285795123-11046-2-git-send-email-yann.morin.1998@anciens.enib.fr>
In-Reply-To: <1285795123-11046-2-git-send-email-yann.morin.1998@anciens.enib.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 09/30/2010 12:18 AM, Yann E. MORIN wrote:
> The AVerTV Red HD+ (A850T) is basically the same as the existing
> AVerTV Volar Black HD 9A850), but is specific to the french market.
>
> This is a collection of information gathered from the french support
> forums for Ubuntu, which I tried to properly format:
>    http://forum.ubuntu-fr.org/viewtopic.php?pid=3322825

>   	/* AverMedia AVerTV Volar Black HD (A850) device have bad EEPROM
> -	   content :-( Override some wrong values here. */
> +	   content :-( Override some wrong values here. Ditto for the
> +	   AVerTV Red HD+ (A850T) device. */
>   	if (le16_to_cpu(udev->descriptor.idVendor) == USB_VID_AVERMEDIA&&
> -	    le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850) {
> +	    ((le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850) ||
> +	     (le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850T))) {
>   		deb_info("%s: AverMedia A850: overriding config\n", __func__);
>   		/* disable dual mode */
>   		af9015_config.dual_mode = 0;

Are you sure it does also have such bad eeprom content? Is that really 
needed? What it happens without this hack?


>   				.name = "AverMedia AVerTV Volar Black HD " \
> -					"(A850)",
> -				.cold_ids = {&af9015_usb_table[20], NULL},
> +					"(A850) / AVerTV Volar Red HD+ (A850T)",
> +				.cold_ids = {&af9015_usb_table[20],
> +					&af9015_usb_table[33], NULL},

Add new entry for that device (and leave A850 as untouched).

Antti
-- 
http://palosaari.fi/
