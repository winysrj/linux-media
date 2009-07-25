Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:55296 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZGYIlV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 04:41:21 -0400
Date: Sat, 25 Jul 2009 10:41:12 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: hugh@canonical.com, linux-media@vger.kernel.org
Subject: Re: Lenovo webcam problem which using gspca's vc032x driver
Message-ID: <20090725104112.6187dd48@tele>
In-Reply-To: <91b198a70907232325p4ad94fc5n680ccb7e06daa65e@mail.gmail.com>
References: <91b198a70907100305t762a4596r734e44f7f4f88bc3@mail.gmail.com>
 <91b198a70907130042y6594a96do8634eebdfef8ba5c@mail.gmail.com>
 <91b198a70907162030l760bd7c5r32daaf6823c1dbe6@mail.gmail.com>
 <20090717043225.4c786455@pedra.chehab.org>
 <20090717124431.1bd3ea43@free.fr>
 <91b198a70907200004y5418796dkbf491d2cae877fb7@mail.gmail.com>
 <20090720105325.26f2ae1a@free.fr>
 <91b198a70907201918l68435905u1ad590144d664a29@mail.gmail.com>
 <91b198a70907220215t14d509e7u8b33623cecafa26f@mail.gmail.com>
 <20090723114758.49a7026c@tele>
 <91b198a70907232325p4ad94fc5n680ccb7e06daa65e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Acelan Kao,

I got news from a person who has the sensor mi1320_soc and had a
vertical flip problem. She found that the sensor register 0x20 sets the
image flips: bit 0 = vertical, bit 1 = horizontal.

Comparing the sequences of the mi1310_soc, the bit 0 is inverted in the
sxga (0x0303 instead of 0x0302). May you change it and see if the image
is normal? (line ~ 706  {0x20, 0x03, 0x03, 0xbb}, -> 0x03, 0x02)

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
