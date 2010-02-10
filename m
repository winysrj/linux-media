Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f200.google.com ([209.85.210.200]:50208 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab0BJVLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 16:11:14 -0500
Received: by yxe38 with SMTP id 38so465314yxe.4
        for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 13:11:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B731A10.9000108@redhat.com>
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com>
	<f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com>
	<f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com>
	<f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com>
	<4B731A10.9000108@redhat.com>
From: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
Date: Wed, 10 Feb 2010 15:04:41 -0600
Message-ID: <f535cc5a1002101304j76efd298p7f8040511ff2b2e1@mail.gmail.com>
Subject: Re: Want to help in MSI TV VOX USB 2.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The above messages seem ok, but I never tried to use tvtime with xinerama.
> This used to be a very good application, but it is not maintained anymore.
> Not sure if it works fine with newer xorg versions with xinerama. Also,
> by default, tvtime enables channel signal detection, but several tuners
> don't provide it. So, you need to disable it, in order for tvtime to work.

Thank for the tip, but makes no difference.

> I suggest you to try mplayer instead. I'm not sure what video standard is
> used in Costa Rica, nor what channel frequency list.

As noted on the first mail, NTSC, same as US
(http://es.wikipedia.org/wiki/Archivo:NTSC-PAL-SECAM.svg)

> So, you may need to adjust the parameters bellow. For NTSC and 6 MHz channels, the command syntax
> is:
>
> mplayer -tv driver=v4l2:device=/dev/video0:norm=PAL-M:chanlist=us-bcast tv://

PAL-M? It should not be NTSC something?  Anyway, I'll try that later.

>> [At this point the application freezes in a black screen, nothing can
>> be done on the GUI]
>
> Maybe due to the lack of signal.
Maybe, but I don't think so. When the device is detected but has no
signal TVTime reacts correctly, in this case it freezes, it can't even
get closed.
What about the "Wait on channel: videobuf_waiton" thing?

> Cheers,
> Mauro

Thank for your help.
