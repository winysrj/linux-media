Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:51999 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbZG0CuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jul 2009 22:50:09 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1498263qwh.37
        for <linux-media@vger.kernel.org>; Sun, 26 Jul 2009 19:50:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090725104112.6187dd48@tele>
References: <91b198a70907100305t762a4596r734e44f7f4f88bc3@mail.gmail.com>
	 <20090717043225.4c786455@pedra.chehab.org>
	 <20090717124431.1bd3ea43@free.fr>
	 <91b198a70907200004y5418796dkbf491d2cae877fb7@mail.gmail.com>
	 <20090720105325.26f2ae1a@free.fr>
	 <91b198a70907201918l68435905u1ad590144d664a29@mail.gmail.com>
	 <91b198a70907220215t14d509e7u8b33623cecafa26f@mail.gmail.com>
	 <20090723114758.49a7026c@tele>
	 <91b198a70907232325p4ad94fc5n680ccb7e06daa65e@mail.gmail.com>
	 <20090725104112.6187dd48@tele>
Date: Mon, 27 Jul 2009 10:43:01 +0800
Message-ID: <91b198a70907261943w25ac350cu5b5bb947a96f8727@mail.gmail.com>
Subject: Re: Lenovo webcam problem which using gspca's vc032x driver
From: AceLan Kao <acelan.kao@canonical.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: hugh@canonical.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Jean-Francois,

I put the USB snoop log here
http://people.canonical.com/~acelan/bugs/lp310760/UsbSnoop_{1,2,3,4,89}.log.gz
The utility, USB Snoop, seems to have some problem with the camera
preview utility, so the log may not so complete.
And the dmslog is the USB traffic in binary form, you can read all USB
traffic from dmslog by hexdump the files.

Best regards,
AceLan Kao.

2009/7/25 Jean-Francois Moine <moinejf@free.fr>:
> Hi Acelan Kao,
>
> I got news from a person who has the sensor mi1320_soc and had a
> vertical flip problem. She found that the sensor register 0x20 sets the
> image flips: bit 0 = vertical, bit 1 = horizontal.
>
> Comparing the sequences of the mi1310_soc, the bit 0 is inverted in the
> sxga (0x0303 instead of 0x0302). May you change it and see if the image
> is normal? (line ~ 706  {0x20, 0x03, 0x03, 0xbb}, -> 0x03, 0x02)
>
> Best regards.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>



-- 
Chia-Lin Kao(AceLan)
http://blog.acelan.idv.tw/
E-Mail: acelan.kaoATcanonical.com (s/AT/@/)
