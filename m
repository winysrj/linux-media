Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:40954 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0JGRnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 13:43:19 -0400
Date: Thu, 7 Oct 2010 19:44:01 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca, audio and ov534: regression.
Message-ID: <20101007194401.4a327081@tele>
In-Reply-To: <20101006165337.9c60bb95.ospite@studenti.unina.it>
References: <20101006123321.baade0a4.ospite@studenti.unina.it>
	<20101006134855.43879d74@tele>
	<20101006160441.6ee9583d.ospite@studenti.unina.it>
	<20101006165337.9c60bb95.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 6 Oct 2010 16:53:37 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> > PS3 Eye audio is working with linux-2.6.33.7 it is broken in
> > linux-2.6.35.7 already, I'll try to further narrow down the
> > interval. Ah, alsamixer doesn't work even when the device is OK in
> > pulseaudio... 
> 
> I was wrong, the audio part works even in 2.6.36-rc6 but _only_ when
> the webcam is plugged in from boot, could this have to do with the
> order gspca and snd-usb-audio are loaded?

Hi Antonio,

If you still have a kernel 2.6.33, may you try my test version (tarball
in my web page)? As it contain only the gspca stuff, this may tell if
the problem is in gspca or elsewhere in the kernel.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
