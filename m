Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:38251 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab0GKNtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jul 2010 09:49:45 -0400
Date: Sun, 11 Jul 2010 15:50:08 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Baker <kyleabaker@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
Message-ID: <20100711155008.1f8f583f@tele>
In-Reply-To: <AANLkTikrKBpRSI6wVdMO3tSYPhm1CECFGeNiyJdzTa03@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 10 Jul 2010 22:30:58 -0400
Kyle Baker <kyleabaker@gmail.com> wrote:

> Is this change from 0x40 to 0x44 intended to fix the "bad interface"
> messages as well as the mic becoming disabled? Also, is a reboot after
> installing these drivers and changes required? I'm only curious
> because it takes so much longer to test changes.

The change from 0x40 to 0x44 is applied to the GPIO register of the
SN9C105 which is the bridge of the webcam. I was thinking that some
values of this register could break the audio input. It does not seem
so.

The "bad interface" messages are printed when the audio interfaces are
called by HAL for probe by the video driver. This is not an error.
I will remove this message in the next version.

Rebooting after installing a new version of a module is not needed. The
module may be removed from memory by 'rmmod'. In your case, when
updating sonixj, you just need to unplug the webcam, do
"rmmod gspca_sonixj" and replug the webcam.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
