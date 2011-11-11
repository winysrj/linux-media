Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:54042 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863Ab1KKUy3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 15:54:29 -0500
Message-ID: <5976e2316f3f2c99ee84e8aebeefeceb.squirrel@ssl-webmail-vh.clara.net>
Date: Fri, 11 Nov 2011 20:54:26 -0000
Subject: MAGIX "USB-Videowandler 2" capture device, OEM KWorld UB315
From: markk@clara.co.uk
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a MAGIX USB video capture device, which is bundled with Windows
software and sold as "Rescue Your Videotapes!". The unit has USB ID
1B80:E349. It is an OEM version of the KWorld UB315. The MAGIX Windows
drivers call it "USB-Videowandler 2". A picture is shown here:
  http://www.videomaker.com/content/large_image.php?article_id=14378&filename=1.jpg

The KWorld UB315 Windows driver is available from
	ftp://ftp.kworld.com.tw/kworld/driver/UB315/v5.3.0306.0_080417_WHQL.zip
(But it does not work as-is with the MAGIX product due to the different
USB ID.)

Someone posted to the em28xx mailing list in Feb 2009 that they managed to
get it working without too much trouble:
  http://www.mail-archive.com/em28xx@mcentral.de/msg02006.html
I thought I'd provide some further info since I took mine apart to look at
the chips inside...

Text on PCB:
  UB315_Ver:C
  E169583

- NXP SAA7113H (video decoder)
- eMPIA EM2861 (probably; covered by label but 2861 mentioned in Windows
device manager)
- eMPIA EMP202 (Single-Chip Dual-Channel AC97 Audio Codec for PC Audio
Systems)
- Atmel serial EEPROM
- There is also an LED and a button which can be pressed by the user.


-- Mark




