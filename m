Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:39957 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753782AbeGENwF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:52:05 -0400
Received: by mail-qk0-f182.google.com with SMTP id b129-v6so4487427qke.7
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:52:04 -0700 (PDT)
Message-ID: <849d57db07c1c1825f0d215a7e55682d36dd2298.camel@ndufresne.ca>
Subject: Re: Video capturing
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Oleh Kravchenko <oleg@kaa.org.ua>
Cc: DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Thu, 05 Jul 2018 09:52:02 -0400
In-Reply-To: <b1e0a06c-ee55-252a-ded5-22b421e2a7e5@kaa.org.ua>
References: <7a41465a-483b-9ce5-4e8f-1f005e2060f9@kaa.org.ua>
         <CAKQmDh-ALkK+6HkzN1SjXgeoGsZNUZYkb__N4063M7U5aRsAnw@mail.gmail.com>
         <b1e0a06c-ee55-252a-ded5-22b421e2a7e5@kaa.org.ua>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 05 juillet 2018 à 16:35 +0300, Oleh Kravchenko a écrit :
> Hello Nicolas,
> 
> On 05.07.18 15:57, Nicolas Dufresne wrote:
> > 
> > 
> > Le jeu. 5 juil. 2018 05:28, Oleh Kravchenko <oleg@kaa.org.ua
> > <mailto:oleg@kaa.org.ua>> a écrit :
> > 
> >     Hello!
> > 
> >     Yesterday I tried to capture video from old game console (PAL)
> > and
> >     got an image like this
> >     https://www.kaa.org.ua/images/EvromediaUSBFullHybridFullHD/mpla
> > yer_nes.png
> > 
> > 
> > Can you describe how this image was captured ? Can you give some
> > details about your tv tuner? Do you also use GStreamer on RPi?
> 
> I have those TV tuners:
>     AVerTV Hybrid Express Slim HC81R
>     Evromedia USB Full Hybrid Full HD
>     Astrometa T2hybrid
> 
> Here examples with mplayer and mpv:
>     mplayer tv:///1 -tv
> width=720:height=576:adevice=hw.2:alsa=1:amode=0:forceaudio=1:immedia
> temode=0:norm=pal
>     mpv tv:///1 --tv-width=720 --tv-height=576 --tv-adevice=hw.2
> --tv-alsa --tv-amode=0 --tv-forceaudio=yes --tv-immediatemode=no
> --tv-norm=pal

And do you get the same with GStreamer ?

gst-launch-1.0 v4l2src device=/dev/video1 norm=PAL ! videoconvert ! autovideosink

> 
> I didn't use GStreamer on RPi, because in my case RPi is a source of
> video signal for TV tuner.
> 
> > 
> > 
> > 
> >     I tried different TV norms, but no success.
> >     At the same time that video console works fine with my TV!
> >     My TV tuners works fine with Nokia N900 (PAL, NTSC), Raspberry
> > Pi
> >     (PAL),
> >     PlayStation 3 (PAL).
> > 
> >     Any idea what it can be?
> > 
> >     PS:
> >     By the way, is allowed to send screenshots and photos as
> >     attachments in
> >     this mail list?
> > 
> >     -- 
> >     Best regards,
> >     Oleh Kravchenko
> > 
> > 
> 
> 
