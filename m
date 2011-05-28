Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39108 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1E1NtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 09:49:15 -0400
Received: by eyx24 with SMTP id 24so946733eyx.19
        for <linux-media@vger.kernel.org>; Sat, 28 May 2011 06:49:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE0F47E.1060509@iki.fi>
References: <1306445141.14462.0.camel@porites>
	<4DDEDB0E.30108@iki.fi>
	<201105281604.48018.remi@remlab.net>
	<4DE0F47E.1060509@iki.fi>
Date: Sat, 28 May 2011 09:49:14 -0400
Message-ID: <BANLkTi==NH1WOmCOg63=Uhw_Hj-6+dYR9A@mail.gmail.com>
Subject: Re: PCTV nanoStick T2 290e support - Thank you!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Steve Kerrison <steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, May 28, 2011, Antti Palosaari <crope@iki.fi> wrote:
> On 05/28/2011 04:04 PM, Rémi Denis-Courmont wrote:
>
> By the way, what is the V4L2 device node supposed to be? I don't suppose the
> hardware supports analog nor hardware decoding!? Is it just a left over from
> the em28xx driver?
>
>
> Yes. Totally useless for digital only em287x series, em288x is digital + analog.
>
> Device hangs if not rmmod drivers before unplug and in my understanding there is some suspicion it is analog audio. Devin may know more.

Indeed, just never got around to refactoring the driver a bit to not
create the video device node for em287x based devices.  I did do the
work though for the VBI and ALSA nodes.  It's actually a bit tricky
and there was a risk of a regression due to the GPIO setup, so I have
to test it with all the 287x devices before it can go in.

The rmmod node has nothing to do with the ALSA stuff.  It's a general
module dependency problem which Jarod Wilson volunteered to
investigate earlier in the week.

Devin

> regards,
> Antti
>
> --
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
