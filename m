Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:35930 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab0GMTNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jul 2010 15:13:17 -0400
Date: Tue, 13 Jul 2010 21:13:45 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Baker <kyleabaker@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
Message-ID: <20100713211345.43caeabb@tele>
In-Reply-To: <AANLkTimku962Cm_7glThtq3X3jZiwmHSWOYzc2d3WLBl@mail.gmail.com>
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
	<20100712132100.1b4072b9@tele>
	<AANLkTimku962Cm_7glThtq3X3jZiwmHSWOYzc2d3WLBl@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Jul 2010 19:01:51 -0400
Kyle Baker <kyleabaker@gmail.com> wrote:

> These do fix the audio problem,  but they may not be good for other
> Sensor OV7660 devices. I am not sure how to identify only my model
> here, but that may be ideal for a better patch. I wonder if this patch
> would also be needed for the VX-3000 model?

Hi Kyle,

Thanks for the patch, but it is more complex. In fact, only the bridge
sn9c105 may do audio stream and the sensor ov7660 is used with other
bridges (the VX3000 is the same as the VX1000 and contains the sn9c105
and the ov7660).

In the new gspca test version (2.9.52), I modified the driver for it
checks the audio device. If present, the bandwidth is reduced and for
the sn9c105, the bit 0x04 of the GPIO register is always set (I hope
that the audio connection is done in the same way by all manufacturer!).

May you check it?

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
