Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:8148 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbZHDHQx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 03:16:53 -0400
Received: by fg-out-1718.google.com with SMTP id e12so623153fga.17
        for <linux-media@vger.kernel.org>; Tue, 04 Aug 2009 00:16:52 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 4 Aug 2009 09:16:52 +0200
Message-ID: <8527bc070908040016x5d5ad15bk8c2ef6e99678f9e9@mail.gmail.com>
Subject: Noisy video with Avermedia AVerTV Digi Volar X HD (AF9015) and
	mythbuntu 9.04
From: Cyril Hansen <cyril.hansen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I am trying to solve a noisy video issue with my new avermedia stick
(AF9015). I am receiving french DVB signal, both SD and HD. Viewing SD
is annoying, with the occasional video and audio quirk, and HD is
almost unwatchable.

The same usb stick with another computer and Vista gives a perfect
image with absolutely no error from the same antenna.

Yesterday I tried to update the drivers from the mercurial tree with no change.

I noticed that the firmware available from the Net and Mythbuntu for
the chip is quite old (2007 ?), so maybe this is the source of my
problem. I am willing to try to use usbsnoop and the firmware cutter
from
 http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/
if nobody has done it with a recent windows driver.


I haven't found any parameter for the module dvb_usb_af9015 : Are they
any than can be worth to try to fix my issue ?


Thank you in advance,

Cyril Hansen
