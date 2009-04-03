Return-path: <linux-media-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:45211 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937102AbZDCUyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 16:54:33 -0400
Message-ID: <49D67781.6030807@gmail.com>
Date: Fri, 03 Apr 2009 22:54:25 +0200
From: =?UTF-8?B?RXJpayBBbmRyw6lu?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Anders Blomdell <anders.blomdell@control.lth.se>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Thomas Kaiser <v4l@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>,
	Thomas Champagne <lafeuil@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>,
	Richard Case <rich@racitup.com>
Subject: Re: topro 6800 driver
References: <5ec8ebd50903271106n14f0e2b7m1495ef135be0cd90@mail.gmail.com>	 <49CD2868.9080502@kaiser-linux.li> <5ec8ebd50903311144h316c7e3bmd30ce2c3d5a268ee@mail.gmail.com> <49D4EAB2.4090206@control.lth.se> <49D66C83.6000700@control.lth.se>
In-Reply-To: <49D66C83.6000700@control.lth.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Anders Blomdell wrote:
> New version attached, handles both 640x480 and 320x240, corrected gamma table.
> 
> Seems to work OK with mplayer, vlc and https://launchpad.net/python-v4l2-capture
> 
>  vlc v4l2://dev/video0:width=320:height=240
>  vlc v4l2://dev/video0:width=640:height=480
> 
> Jean-Francois: feel free to add this to gspca if it lives up to your standards,
> otherwise tell me what needs to be changed.
> 
> Best regards
> 
> /Anders
> 
> 

Hi Anders,

Before submitting a driver, please make sure it passes the
checkpatch.pl script found in the linux/scripts/ folder.
When I checked the tp6800.c file I got about ~4300 errors.
This is due to that the file isn't using the indentation used by
code in the linux tree.

If you first run the Lindent script (found in the same folder) about
23 errors pop up that need to be corrected. Beware though that
Lindent sometimes screw up lines so manual inspection of the code is
needed.

Best regards, / hälsningar,
Erik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknWd4EACgkQN7qBt+4UG0E8LgCfQYON+qQJS7gOjnmF8BqUuuW8
M8YAoJJroBbk2CXBS+z6qCL6ZU41EOXy
=RBZP
-----END PGP SIGNATURE-----
