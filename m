Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43720 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0HPC75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Aug 2010 22:59:57 -0400
Received: by iwn7 with SMTP id 7so1202182iwn.19
        for <linux-media@vger.kernel.org>; Sun, 15 Aug 2010 19:59:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C664723.9070303@gmail.com>
References: <4C664723.9070303@gmail.com>
Date: Sun, 15 Aug 2010 22:59:56 -0400
Message-ID: <AANLkTine4xDHhTqeEWUNypCc0t0MksUpKeLuFCJ+-EW-@mail.gmail.com>
Subject: Re: Error building v4l
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

On Sat, Aug 14, 2010 at 3:34 AM, Andrea.Amorosi76@gmail.com
<Andrea.Amorosi76@gmail.com> wrote:
> Building the v4l, I obtain the following error:
>
>
> home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c: In function
> 'mceusb_dev_probe':
> /home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c:923: error:
> implicit declaration of function 'usb_alloc_coherent'
> /home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c:923:
> warning: assignment makes pointer from integer without a cast
> /home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.c:1003: error:
> implicit declaration of function 'usb_free_coherent'
> make[3]: ***
> [/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l/mceusb.o] Error 1
> make[2]: ***
> [_module_/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-24-generic'
> make[1]: *** [default] Errore 2
> make[1]: uscita dalla directory
> «/home/andreak/src/v4l-dvb-src/v4l-dvb-main/v4l-dvb/v4l»
> make: *** [all] Errore 2
>
> My system is a Kubuntu 10.04 amd64 with kernel 2.6.32-24-generic #39-Ubuntu
> SMP Wed Jul 28 05:14:15 UTC 2010 x86_64 GNU/Linux
>
> How can I solve?

Please download the new patches available and try again.

Cheers
Douglas
