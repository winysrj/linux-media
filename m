Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39954 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1BFXIu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Feb 2011 18:08:50 -0500
Received: by eye27 with SMTP id 27so2029279eye.19
        for <linux-media@vger.kernel.org>; Sun, 06 Feb 2011 15:08:48 -0800 (PST)
Message-ID: <4D4F29FD.9090505@gmail.com>
Date: Mon, 07 Feb 2011 00:08:45 +0100
From: Marc Coevoet <sintsixtus@gmail.com>
MIME-Version: 1.0
To: Dave Johansen <davejohansen@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
In-Reply-To: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Op 06-02-11 23:46, Dave Johansen schreef:
> I am trying to resurrect my MythBuntu system with a DViCO FusionHDTV7
> Dual Express. I had previously had some issues with trying to get
> channels working in MythTV (
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg03846.html
> ), but now it locks up with MythBuntu 10.10 when I scan for channels
> in MythTV and also with the scan command line utility.
>
> Here's the output from scan:
>
> scan /usr/share/dvb/atsc/us-ATSC-
> center-frequencies-8VSB
> scanning us-ATSC-center-frequencies-8VSB
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>> tune to: 189028615:8VSB
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x1ffb
>
> Any ideas/suggestions on how I can get this to work?
>

I've had this kind of problems on a pc with mixed usb1.1 and usb2.0 ports.

Put it on the usb2.0

Marc


-- 
What's on Shortwave guide: choose an hour, go!
http://shortwave.tk
700+ Radio Stations on SW http://swstations.tk
300+ languages on SW http://radiolanguages.tk
