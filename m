Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab0H0BcZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 21:32:25 -0400
Message-ID: <4C7715B6.2060308@redhat.com>
Date: Thu, 26 Aug 2010 22:32:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: ir_codes_dibusb_table : please make table length a constant
References: <AANLkTi=-ai2mZHiEmiEpKq9A-CifSPQDagrE03gDqpHv@mail.gmail.com> <AANLkTikZD32LC12bT9wPBQ5+uO3Msd8Sw5Cwkq5y3bkB@mail.gmail.com> <4C581BB6.7000303@redhat.com> <AANLkTi=i57wxwOEEEm4dXydpmePrhS11MYqVCW+nz=XB@mail.gmail.com> <AANLkTikMHF6pjqznLi5qWHtc9kFk7jb1G1KmeKsvfLKg@mail.gmail.com> <AANLkTim=ggkFgLZPqAKOzUv54NCMzxXYCropm_2XYXeX@mail.gmail.com> <AANLkTik7sWGM+x0uOr734=M=Ux1KsXQ9JJNqF98oN7-t@mail.gmail.com> <4C7425C9.1010908@hoogenraad.net> <AANLkTinA1r87W+4J=MRV5i6M6BD-c+KTWnYqyBd7WCQA@mail.gmail.com> <4C74B78B.3020101@hoogenraad.net> <AANLkTim3bq6h-oFY+TKoog-TKOzQ-w4MR0CVdcL4OjcD@mail.gmail.com> <4C75FF0B.3060500@hoogenraad.net> <4C760F5F.8000801@hoogenraad.net>
In-Reply-To: <4C760F5F.8000801@hoogenraad.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 26-08-2010 03:53, Jan Hoogenraad escreveu:
> During debugging a driver, I found that at least in
> 
> linux/drivers/media/dvb/dvb-usb/dibusb-mc.c   
> the length of ir_codes_dibusb_table was referring to an older version.
> This may have caused memory overrun problems
> 
> I have fixed this in my branch in
> linux/drivers/media/dvb/dvb-usb/dibusb.h
>  with a
> #define IR_CODES_DIBUSB_TABLE_LEN 111
> 
> http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/rev/549b40b69fa4
> 
> I agree this is not the nicest solution, but at at least would reduce some problems.
> I am not sure on how to create a patch for this ?
> Should I make a new branch in the HG archive ?
> 
> I suggest to replate the 111-s into IR_CODES_DIBUSB_TABLE_LEN in the files below as well:
> 
>     * drivers/media/dvb/dvb-usb/dibusb-common.c:
>           o line 330
>           o line 459
>     * drivers/media/dvb/dvb-usb/dibusb-mb.c:
>           o line 215
>           o line 299
>           o line 363
>           o line 420
>     * drivers/media/dvb/dvb-usb/dibusb.h, line 127
> 
The proper solution is to migrate dibusb to use the new ir-core way, just like we did at
drivers/media/dvb/dvb-usb/dib0700_devices.c:

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=d700226902a62a3b6f3563782d569c0e2af74397
http://git.linuxtv.org/media_tree.git?a=commitdiff;h=5af935cc96a291f90799bf6a2587d87329a91699
http://git.linuxtv.org/media_tree.git?a=commitdiff;h=72b393106bddc9f0a1ab502b4c8c5793a0441a30

Cheers,
Mauro
