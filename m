Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:47294 "HELO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751041AbZIVVrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 17:47:10 -0400
Received: by an-out-0708.google.com with SMTP id d14so63811and.3
        for <linux-media@vger.kernel.org>; Tue, 22 Sep 2009 14:47:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <781723be0909221420l7e955a54p9d713d821ba737da@mail.gmail.com>
References: <781723be0909221420l7e955a54p9d713d821ba737da@mail.gmail.com>
From: "Dreher, Eric" <eric@dreher-associates.com>
Date: Tue, 22 Sep 2009 16:40:56 -0500
Message-ID: <781723be0909221440w5969c21ai5e190936a64fd84@mail.gmail.com>
Subject: Fwd: ATI HDTV Wonder not always recognized
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am need of opinions on whether this is a driver or motherboard issue
(or something else).

I originally had an ATI HDTV Wonder card working perfectly along with
a PVR-150 in my two PCI slots of a Asus M2NPV-VM motherboard.
Driver for the HDTV Wonder is cx88_dvb, and the PVR, ivtv

The PVR-150 recently started to deteriorate with a poor picture
quality ( I can describe more if relevant).  So I purchased a
replacement PVR-150 and popped into place.  The new PVR-150 worked
without a hitch itself.  But...the HDTV Wonder isn't even recognized.
Does not show up in lspci.  "modprobe cx88_dvb" reports "no such
device"

I have tried swapping PCI slots with no luck, replaced the old PVR-150
with no luck.

But the HDTV Wonder is recognized in one slot only with the other slot
empty.  So I can currently run with either card, but not both.

Motherboard has the most recent firmware.  I've updated Ubuntu to 9.10
and v4l-dvb drivers to most recent 0.0.7.  (No noticable difference
from 0.0.6 as far as what I need).

Is my logic correct in blaming the motherboard?  Any suggestions?

Thanks,
Eric
