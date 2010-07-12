Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:41118 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab0GLIRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 04:17:48 -0400
Date: Mon, 12 Jul 2010 10:18:02 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Baker <kyleabaker@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
Message-ID: <20100712101802.08527e82@tele>
In-Reply-To: <AANLkTinnNhJ-DoFWfU8U5NuTj_p48SefYzWWAxZqiUb-@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 11 Jul 2010 17:18:53 -0400
Kyle Baker <kyleabaker@gmail.com> wrote:

> Is the previous maintainer, Michel Xhaard, still working on this
> driver at all? I wonder if he might be able to help identify the
> problem or narrow it down.
> 
> Which function is called when I open Cheese or other video
> applications? Initializing the webcam appears to be correct, however,
> sd_start() or the one that starts the video capture appears to be
> toggling or changing some setting. If I knew of a way, I would insert
> more debug messages to help pinpoint the place where the microphone
> breaks along with some boolean to show that its working or not.

Hi,

Michel Xhaard gave me all the gspca stuff and stopped working on it two
years ago. He did not even tell me which of his webcams were working
with gspca v2...

The video capture is started in sd_start(). Checking all sequences
again, I found that the GPIO is also set near line 1752. May you comment
it and test?

	msleep(100);
//	reg_w1(gspca_dev, 0x02, 0x62);
	break;

Otherwise, here is a way to know the exact bad USB exchange.

First, in sonixj.c, add a long delay in the register write functions
just before the debug messages:
- line 1350

	msleep(1000);					// add this
	PDEBUG(D_USBO, "reg_w1 [%04x] = %02x", value, data);

- line 1365

	msleep(1000);					// add this
	PDEBUG(D_USBO, "reg_w [%04x] = %02x %02x ..",
		value, buffer[0], buffer[1]);

After installation, connect the webcam and set the gspca debug level to
0xcf:
	echo 0xcf > /sys/module/gspca_main/parameters/debug

Check if the webcam microphone is working, and look at the kernel
messages by:
	tail -f /var/log/messages

Then, start the video capture. You should see each USB exchange in the
'tail' window. When the audio stops, the bad exchange is the one just
printed...

If the audio stopped before any exchange, this could mean that something
went wrong when setting the alternate setting or on URB creation.

BTW, your webcam is connected to a USB 1.1 port with the driver
ohci_hcd. Have you some USB 2.0 port that you could use?

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
