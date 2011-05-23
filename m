Return-path: <mchehab@pedra>
Received: from nm27-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.232]:21081 "HELO
	nm27-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753722Ab1EWDBk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 23:01:40 -0400
Message-ID: <180987.84653.qm@web112003.mail.gq1.yahoo.com>
Date: Sun, 22 May 2011 20:01:40 -0700 (PDT)
From: Chris Rodley <carlighting@yahoo.co.nz>
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Error when using media-ctl as below with v2 mt9p031 driver from Javier and latest media-ctl version.
Is there a patch I missed to add different formats - or maybe my command is wrong?

# ./media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]

# ./media-ctl -v -f '"mt9p031 2-0048":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Setting up format SGRBG8 320x240 on pad mt9p031 2-0048/0
Unable to set format: Invalid argument (-22)
 
I also tried:
./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
./media-ctl -f '"mt9p031 2-0048":0[SGRBG10 752x480 (1,5)/752x480], "OMAP3 ISP CCDC":0[SGRBG8 752x480], "OMAP3 ISP CCDC":1[SGRBG8 752x480]'

With the same result.

Cheers,
Chris
