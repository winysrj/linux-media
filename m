Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43253 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab1BWV04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 16:26:56 -0500
Received: by eyx24 with SMTP id 24so1478531eyx.19
        for <linux-media@vger.kernel.org>; Wed, 23 Feb 2011 13:26:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102240255.00946.Vivek.Periaraj@gmail.com>
References: <201102240116.18770.Vivek.Periaraj@gmail.com>
	<AANLkTi=ipU6gqoQZ4T25ErCGapvoT-Q8vx+mriQj=tji@mail.gmail.com>
	<201102240255.00946.Vivek.Periaraj@gmail.com>
Date: Wed, 23 Feb 2011 16:26:54 -0500
Message-ID: <AANLkTikNiEKZNVs1DGDvuLR0r+XTWLgi03nbk=272fqj@mail.gmail.com>
Subject: Re: Hauppauge WinTV USB 2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Vivek Periaraj <vivek.periaraj@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 23, 2011 at 4:25 PM, Vivek Periaraj
<vivek.periaraj@gmail.com> wrote:
> Hi Devin,
>
> Thanks for the reply!
>
> Like you advised, I took the latest code and started building it as mentioned
> in this link --> http://linuxtv.org/wiki/index.php/Trident_TM6000 but getting
> this error:
>
> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-core.c: In function
> 'tm6000_init_analog_mode':
> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-core.c:339: warning: ISO C90
> forbids mixed declarations and code
>  CC [M]  /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-i2c.o
>  CC [M]  /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.o
> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c: In function
> 'tm6000_uninit_isoc':
> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c:522: error: implicit
> declaration of function 'usb_free_coherent'
> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c: In function
> 'tm6000_prepare_isoc':
> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c:612: error: implicit
> declaration of function 'usb_alloc_coherent'
<snip>

Questions like this should be directed to the mailing list and not me
personally, where any number of people can help you out with basic
build problems.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
