Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:32832 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab0GLLUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 07:20:34 -0400
Date: Mon, 12 Jul 2010 13:21:00 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Baker <kyleabaker@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
Message-ID: <20100712132100.1b4072b9@tele>
In-Reply-To: <AANLkTinUHyTHt78ihMHy8dzz0kfPvUMBXKreRmuM-cYW@mail.gmail.com>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele>
	<AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele>
	<AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele>
	<AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
	<20100709200312.755e8069@tele>
	<AANLkTikxIJxuQiV_7PqPA5C6ZU5XhhmmQ3hAbIwWsrPT@mail.gmail.com>
	<20100710113616.1ed63ebc@tele>
	<AANLkTikrKBpRSI6wVdMO3tSYPhm1CECFGeNiyJdzTa03@mail.gmail.com>
	<20100711155008.1f8f583f@tele>
	<AANLkTinnNhJ-DoFWfU8U5NuTj_p48SefYzWWAxZqiUb-@mail.gmail.com>
	<20100712101802.08527e82@tele>
	<AANLkTinUHyTHt78ihMHy8dzz0kfPvUMBXKreRmuM-cYW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Jul 2010 05:28:15 -0400
Kyle Baker <kyleabaker@gmail.com> wrote:

> Here is the exchange from plugging in my webcam until I quit Cheese.
> The point that the mic quits is at
> "[  224.692515] sonixj-2.9.51: reg_w1 [0002] = 62"
> as far as I can tell. I hope this sheds some light on the issue.
> Repeating this several times appears to show the same values each
> time, so it may be a GPIO setting that is incorrect. I don't
> understand the driver code as intricately as you.

Fine job! The register 02 is the GPIO register. It seems the audio does
not work when the bit 0x04 is not set. I am working on the driver for
the other webcams, but you may patch it yourself removing the register
02 settings at lines 1752, 2320 and 2321 of sonixj.c.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
