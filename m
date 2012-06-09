Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:57203 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775Ab2FIObh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jun 2012 10:31:37 -0400
Received: from [209.86.224.39] (helo=elwamui-little.atl.sa.earthlink.net)
	by elasmtp-junco.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <sitten74490@mypacks.net>)
	id 1SdMhU-0002FC-Ig
	for linux-media@vger.kernel.org; Sat, 09 Jun 2012 10:31:36 -0400
Message-ID: <17385433.1339252296523.JavaMail.root@elwamui-little.atl.sa.earthlink.net>
Date: Sat, 9 Jun 2012 10:31:36 -0400 (GMT-04:00)
From: sitten74490@mypacks.net
To: linux-media@vger.kernel.org
Subject: Re: hdpvr lockup with audio dropouts
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----Original Message-----
>From: Devin Heitmueller <dheitmueller@kernellabs.com>
>Sent: Jun 7, 2012 8:45 PM
>To: sitten74490@mypacks.net
>Cc: linux-media@vger.kernel.org
>Subject: Re: hdpvr lockup with audio dropouts
>
>On Thu, Jun 7, 2012 at 7:53 PM,  <sitten74490@mypacks.net> wrote:
>> Apparently there is a known issue where the HD-PVR cannot handle the loss of audio signal over SPDIF while recording.  If this happens, the unit locks up requiring it to be power cycled before it can be used again. This behavior can easily be reproduced by pulling the SPDIF cable during recording.  My question is this:  are there any changes that could be made to the hdpvr driver that would make it more tolerant of brief audio dropouts?
>
>Does it do this under Windows?  If it does, then call Hauppauge and
>get them to fix it (and if that results in a firmware fix, then it
>will help Linux too).  If it works under Windows, then we know it's
>some sort of driver issue which would be needed.
>
>It's always good when it's readily reproducible.  :-)
>
>Devin

Well, I tested it in Windows and no, the HD-PVR does not lock up when the audio signal is lost.  It does pause, but when the signal comes back it resumes playing normally.  So if I understand you correctly, this would most likely be a Linux driver bug rather than a firmware problem.


