Return-path: <mchehab@pedra>
Received: from psmtp31.wxs.nl ([195.121.247.33]:43483 "EHLO psmtp31.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab0HZGxV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 02:53:21 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp31.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L7Q00ARIZ4WQX@psmtp31.wxs.nl> for linux-media@vger.kernel.org;
 Thu, 26 Aug 2010 08:53:21 +0200 (CEST)
Date: Thu, 26 Aug 2010 08:53:19 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: ir_codes_dibusb_table : please make table length a constant
In-reply-to: <4C75FF0B.3060500@hoogenraad.net>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4C760F5F.8000801@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <AANLkTi=-ai2mZHiEmiEpKq9A-CifSPQDagrE03gDqpHv@mail.gmail.com>
 <AANLkTikZD32LC12bT9wPBQ5+uO3Msd8Sw5Cwkq5y3bkB@mail.gmail.com>
 <4C581BB6.7000303@redhat.com>
 <AANLkTi=i57wxwOEEEm4dXydpmePrhS11MYqVCW+nz=XB@mail.gmail.com>
 <AANLkTikMHF6pjqznLi5qWHtc9kFk7jb1G1KmeKsvfLKg@mail.gmail.com>
 <AANLkTim=ggkFgLZPqAKOzUv54NCMzxXYCropm_2XYXeX@mail.gmail.com>
 <AANLkTik7sWGM+x0uOr734=M=Ux1KsXQ9JJNqF98oN7-t@mail.gmail.com>
 <4C7425C9.1010908@hoogenraad.net>
 <AANLkTinA1r87W+4J=MRV5i6M6BD-c+KTWnYqyBd7WCQA@mail.gmail.com>
 <4C74B78B.3020101@hoogenraad.net>
 <AANLkTim3bq6h-oFY+TKoog-TKOzQ-w4MR0CVdcL4OjcD@mail.gmail.com>
 <4C75FF0B.3060500@hoogenraad.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

During debugging a driver, I found that at least in

linux/drivers/media/dvb/dvb-usb/dibusb-mc.c	
the length of ir_codes_dibusb_table was referring to an older version.
This may have caused memory overrun problems

I have fixed this in my branch in
linux/drivers/media/dvb/dvb-usb/dibusb.h
  with a
#define IR_CODES_DIBUSB_TABLE_LEN 111

http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/rev/549b40b69fa4

I agree this is not the nicest solution, but at at least would reduce 
some problems.
I am not sure on how to create a patch for this ?
Should I make a new branch in the HG archive ?

I suggest to replate the 111-s into IR_CODES_DIBUSB_TABLE_LEN in the 
files below as well:

     * drivers/media/dvb/dvb-usb/dibusb-common.c:
           o line 330
           o line 459
     * drivers/media/dvb/dvb-usb/dibusb-mb.c:
           o line 215
           o line 299
           o line 363
           o line 420
     * drivers/media/dvb/dvb-usb/dibusb.h, line 127

-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
