Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:60150 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0E2SXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 14:23:19 -0400
Date: Sat, 29 May 2010 20:24:25 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-media@vger.kernel.org
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
Message-ID: <20100529202425.75b4ff56@tele>
In-Reply-To: <201005291909.33593.linux@rainbow-software.org>
References: <201005291909.33593.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 29 May 2010 19:09:32 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:

> I got a MD80-clone camera based on SPCA1527A chip. It's webcam-like
> camera with battery and microSD slot and can record video on its own.
> It has two USB modes - mass storage (USB ID 04fc:0171) and webcam
> mode (USB ID 04fc:1528). This chip seems to be used in many other SD
> card cameras too.
> 
> The webcam mode is not supported by gspca so I captured some data to 
> (hopefully) make support in gspca possible. There seems to be 3
> interfaces:

Hello Ondrej,

I got your ms-win traces, thank you. The commands seem simple enough,
but I don't know yet the compression algorithm of the images. I will
have a look at this on next week. May you tell me if there are other
resolutions than 320x240 and, also, what are the webcam controls?

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
