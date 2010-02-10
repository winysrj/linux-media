Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:27919 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab0BJUzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 15:55:43 -0500
Received: by fg-out-1718.google.com with SMTP id e21so14484fga.1
        for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 12:55:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B731A10.9000108@redhat.com>
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com>
	 <f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com>
	 <f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com>
	 <f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com>
	 <4B731A10.9000108@redhat.com>
Date: Wed, 10 Feb 2010 15:55:41 -0500
Message-ID: <829197381002101255x2af2776ftd1c7a7d32584946@mail.gmail.com>
Subject: Re: Want to help in MSI TV VOX USB 2.0
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Carlos Jenkins <carlos.jenkins.perez@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 10, 2010 at 3:41 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The above messages seem ok, but I never tried to use tvtime with xinerama.
> This used to be a very good application, but it is not maintained anymore.
> Not sure if it works fine with newer xorg versions with xinerama. Also,
> by default, tvtime enables channel signal detection, but several tuners
> don't provide it. So, you need to disable it, in order for tvtime to work.
>
> I suggest you to try mplayer instead. I'm not sure what video standard is
> used in Costa Rica, nor what channel frequency list. So, you may need to
> adjust the parameters bellow. For NTSC and 6 MHz channels, the command syntax
> is:
>
> mplayer -tv driver=v4l2:device=/dev/video0:norm=PAL-M:chanlist=us-bcast tv://
>
>> [At this point the application freezes in a black screen, nothing can
>> be done on the GUI]
>
> Maybe due to the lack of signal.

Does the device even have a tuner?  I had assumed all the em2862
reference designs just did s-video and composite capture.  This one is
a bit different than the others though, since it has a tvp5150 as
opposed to a saa7113.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
