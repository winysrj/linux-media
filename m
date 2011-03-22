Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58235 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1CVQLG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 12:11:06 -0400
Received: by iwn34 with SMTP id 34so7598659iwn.19
        for <linux-media@vger.kernel.org>; Tue, 22 Mar 2011 09:11:05 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Mar 2011 17:11:04 +0100
Message-ID: <AANLkTimdFVDLLz2o9Fb2OJM2EsJ9R9q-xKAP63g9uSi+@mail.gmail.com>
Subject: OMAP3 ISP outputs 5555 5555 5555 5555 ...
From: Bastian Hecht <hechtb@googlemail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Jones <michael.jones@matrix-vision.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello omap isp devs,

maybe you can help me, I am a bit desperate with my current cam problem:

I use a ov5642 chip and get only 0x55 in my data output when I use a
camclk > 1 MHz. With 1 MHz data rate from the camera chip to the omap
all works (well the colorspace is strange - it's greenish, but that is
not my main concern).
I looked up the data on the oscilloscope and all flanks seem to be
fine at the isp. Very clear cuts with 4 MHz and 10MHz. Also the data
pins are flickering fine. Looks like a picture.

I found that the isp stats module uses 0x55 as a magic number but I
don't see why it should confuse my readout.

I use 2592x1944 raw bayer output via the ccdc. Next to the logical
right config I tried all possible configurations of vs/hs active high
and low on camera and isp. The isp gets the vs flanks right as the
images come out in time (sometimes it misses 1 frame).

Anyone of you had this behaviour before?

Thanks so much for reading this,

Bastian Hecht
