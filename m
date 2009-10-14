Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63240 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbZJNOMZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 10:12:25 -0400
Received: by fxm27 with SMTP id 27so11637590fxm.17
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 07:11:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091014160626.70db928b@ieee.org>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
	 <20091014122550.7c84bba5@ieee.org>
	 <829197380910140612t726251d6y7cff3873587101b4@mail.gmail.com>
	 <20091014160626.70db928b@ieee.org>
Date: Wed, 14 Oct 2009 10:11:48 -0400
Message-ID: <829197380910140711l7624c0c8va474156f712580a4@mail.gmail.com>
Subject: Re: em28xx DVB modeswitching change: call for testers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Giuseppe Borzi <gborzi@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 14, 2009 at 10:06 AM, Giuseppe Borzi <gborzi@gmail.com> wrote:
> Hello Devin,
> I did as you suggested. Unplugged the stick reboot and plug it again.
> And just to be sure I did it two times. Now the device works, but it is
> unable to change channel. That is to say, when I use the command "vlc
> channels.conf" it tunes to the first station in the channel file and
> can't change it. Other apps (xine, kaffeine) that seems to change to
> the latest channel don't work at all. The dmesg output after plugging
> the driver is in attach. In dmesg I noticed lines like this
>
> [drm] TV-14: set mode NTSC 480i 0
>
> I suppose this hasn't anything to do with the analog audio problem, but
> just to be sure I ask you. Also, using arecord/aplay for analog audio I
> get an "underrun" error message
>
> arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -
> Recording WAVE 'stdin' : Signed 16 bit Little Endian, Rate 32000 Hz,
> Stereo Playing WAVE 'stdin' : Signed 16 bit Little Endian, Rate 32000
> Hz, Stereo underrun!!! (at least -1255527098942.108 ms long)
>
> Cheers.

Ok, let me look at the code and see what I can figure out.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
