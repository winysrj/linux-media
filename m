Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:42771 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502AbZEYW0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 18:26:13 -0400
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
From: hermann pitton <hermann-pitton@arcor.de>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Mike Isely <isely@isely.net>
In-Reply-To: <200905252204.24321.martin.dauskardt@gmx.de>
References: <200905210909.43333.martin.dauskardt@gmx.de>
	 <1243038686.3164.34.camel@palomino.walls.org>
	 <200905252134.43249.martin.dauskardt@gmx.de>
	 <200905252204.24321.martin.dauskardt@gmx.de>
Content-Type: text/plain
Date: Tue, 26 May 2009 00:14:45 +0200
Message-Id: <1243289685.3744.101.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 25.05.2009, 22:04 +0200 schrieb Martin Dauskardt:
> Am Montag, 25. Mai 2009 21:34:43 schrieb Martin Dauskardt:
> 
> > #define TUNER_PHILIPS_FM1216MK5         79
> > result: picture o.k. , but audio disappears every few seconds (for about 1-2 
> > seconds, then comes back) 
> 
> correction: This is not a problem of tuner type 79. It happens also with tuner 
> type 38. Sometimes the audio is also muted after the start of the 
> application. Only switching to another input and back brings the audio back.
> 
> I am beginning to wonder if this problem may be related to a similar problem 
> with the PVRUSB2:
> http://www.isely.net/pipermail/pvrusb2/2009-May/002331.html
> 
> If there is a problem with the new v4l2 sub-device mechanism, it seems to be 
> more specific to some devices than to others. With my PVR350 I didn't notice 
> such problems - although I remember that in **very** rare cases the audio 
> fails after a channel switch.  
> 
> Greets, 
> Martin
> 

Ah, good to know. You better stay around 2.6.28 for testing tuners then.

I have reported already difficult to debug bugs on 2.6.29 with _some_
devices and others on the same driver still work. I have again verified
that they for sure do work on 2.6.30-rc2-git4 yesterday.

Cheers,
Hermann

(ivtv list removed, re-add if appropriate)

