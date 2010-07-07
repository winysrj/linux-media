Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:44767 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab0GGJFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 05:05:54 -0400
Date: Wed, 7 Jul 2010 11:06:13 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Baker <kyleabaker@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
Message-ID: <20100707110613.18be4215@tele>
In-Reply-To: <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele>
	<AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 7 Jul 2010 02:57:54 -0400
Kyle Baker <kyleabaker@gmail.com> wrote:

> If the microphone works when used alone (with the sound recorder
> application) and video works in Cheese, why would they not work
> together at the same time?
> 
> I'm looking through the sonixj.c code to see if I can find where its
> breaking, but I'm not very experienced in C.
> 
> I've been trying to get this worked out for a year, so if there is
> anything I can do to help fix this bug let me know. This is a fairly
> common webcam, so it would be great to see this resolved soon.
> 
> What is the current priority of this bug?

The video and audio don't work at the same time because the video is
opened before the audio and it takes all the USB bandwidth.

The problem is in the main gspca.c, not in sonixj.c. It may fixed using
a lower alternate setting. To check it, you may add the following lines:

	if (dev->config->desc.bNumInterfaces != 1)
		gspca_dev->nbalt -= 1;
after
	gspca_dev->nbalt = intf->num_altsetting;
in the function gspca_dev_probe() of gspca.c.

If it still does not work, change "-= 1" to "-= 2" or "-= 3" (there are
8 alternate settings in your webcam).

For a correct fix, the exact video bandwidth shall be calculated and I
could not find yet time enough to do the job and people to test it...

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
