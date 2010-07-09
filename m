Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:44270 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab0GISCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 14:02:51 -0400
Date: Fri, 9 Jul 2010 20:03:12 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Baker <kyleabaker@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
Message-ID: <20100709200312.755e8069@tele>
In-Reply-To: <AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele>
	<AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele>
	<AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele>
	<AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 8 Jul 2010 18:54:41 -0400
Kyle Baker <kyleabaker@gmail.com> wrote:

> My conclusion, reducing "gspca_dev->nbalt" by values 1-5 apparently
> fix the bandwidth issue and don't alter the video input. However, they
> also do not correct the issue where the microphone breaks and becomes
> disabled.

OK. So, this means that the sonixj driver sets something in the webcam
which prevents the audio to run. I don't see anything but the GPIO.

I have no ms-win trace from your webcam. May you do it? I just need the
connection and one second of streaming with a USB sniffer in text mode
as sniffbin.

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
