Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:37341 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab2FWNiX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 09:38:23 -0400
Message-ID: <16989749.1340458702473.JavaMail.root@elwamui-royal.atl.sa.earthlink.net>
Date: Sat, 23 Jun 2012 09:38:22 -0400 (GMT-04:00)
From: sitten74490@mypacks.net
To: Janne Grunau <janne@jannau.net>
Subject: Re: hdpvr lockup with audio dropouts
Cc: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>On 2012-06-09 10:31:36 -0400, sitten74490@mypacks.net wrote:
>> >
>> >On Thu, Jun 7, 2012 at 7:53 PM,  <sitten74490@mypacks.net> wrote:
>> >> Apparently there is a known issue where the HD-PVR cannot handle the loss
>> >> of audio signal over SPDIF while recording.  If this happens, the unit
>> >> locks up requiring it to be power cycled before it can be used again. This
>> >> behavior can easily be reproduced by pulling the SPDIF cable during
>> >> recording.  My question is this:  are there any changes that could be made
>> >> to the hdpvr driver that would make it more tolerant of brief audio
>> >> dropouts?
>> >
>> >Does it do this under Windows?  If it does, then call Hauppauge and get them
>> >to fix it (and if that results in a firmware fix, then it will help Linux
>> >too).  If it works under Windows, then we know it's some sort of driver
>> >issue which would be needed.
>> >
>> >It's always good when it's readily reproducible.  :-)
>> >
>> 
>> Well, I tested it in Windows and no, the HD-PVR does not lock up when the
>> audio signal is lost.  It does pause, but when the signal comes back it
>> resumes playing normally.  So if I understand you correctly, this would most
>> likely be a Linux driver bug rather than a firmware problem.
>
>Yes, it's a driver bug (although iirc the device locked up when I wrote
>the driver). If you have usb traffic logs from the windows driver I'll
>look at them. If not I'll try to set my hdpvr up in the next days.
>
>Janne

Here's a link to a USB traffic capture I made with USBlyzer (http://www.usblyzer.com/):

https://dl.dropbox.com/u/5664816/hdpvr.ulz

I disconnected the SPDIF cable several seconds into the capture and then reconnected several seconds later.
If you need the capture in a different format, please let me know.  Thanks for your help.

Jonathan



