Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:36771 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab0KATOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Nov 2010 15:14:35 -0400
Date: Mon, 1 Nov 2010 20:15:47 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: Webcam driver not working: drivers/media/video/gspca/ov519.c
 device 05a9:4519
Message-ID: <20101101201547.47fd0d4c@tele>
In-Reply-To: <AANLkTikZPmJWebfpU2yLpvMygqhzfAKZYL7rTCG45K3b@mail.gmail.com>
References: <AANLkTikZPmJWebfpU2yLpvMygqhzfAKZYL7rTCG45K3b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 31 Oct 2010 15:16:40 +0200
Anca Emanuel <anca.emanuel@gmail.com> wrote:

> After this patch,
	[snip]
> I get:
> [  182.680032] usb 8-1: new full speed USB device using uhci_hcd and
> address 3 [  182.875331] gspca: probing 05a9:4519
> [  183.064309] ov519: I2C synced in 0 attempt(s)
> [  183.064314] ov519: starting OV7xx0 configuration
> [  183.076312] ov519: Sensor is an OV7660
	[snip]
> But only a green screen in Cheese. Logs attached.

Hi Emanuel,

The sensor ov7660 has not the same registers as the ov7670, so, your
webcam could not work.

To make it work, I need a USB trace done with ms-windows. May you do it?

In a first step, I need the webcam connection and no more than one
second of streaming at the maximum resolution.

Please, use a sniffer which creates text files like sniffbin.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
