Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:46467 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab2EESxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 14:53:00 -0400
Date: Sat, 5 May 2012 20:54:09 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: gspca zc3xx - JPEG quality / frame overflow
Message-ID: <20120505205409.312e271f@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I quickly looked at your patches about the changes for the JPEG
quality, and I have some remarks.

Indeed, as I don't have any zc3xx webcam nor a lot of documentation
about the zc3xx bridge, my information come only from USB trace
analysis, and I am not sure there are fully valid.

- the register 08 always have values 0..3 (bits 0 and 1). I never saw
  the bits 2 or 3 set when the frame transfer regulation is active.

- when frame overflows occur or disappear, the register 07 is always
  updated before the register 08. There are bug fixes about the setting
  of the registers 07 and 08 in my gspca test tarball 2.15.17.

- as it is (read the register 11 every 100 ms), the work queue is
  usefull when there is no polling of the snapshot button, because the
  frame overflow is reported as the bit 0 in the forth byte (data[3])
  of the interrupt messages.

  In fact, in the traces I have, only the webcams which don't do button
  polling by interrupt messages have to read the register 11. Why only
  when the sensor is hv7131r or pas202b? I don't know. But with gspca,
  the polling is always active when CONFIG_INPUT is defined.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
