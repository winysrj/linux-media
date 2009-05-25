Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48874 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751373AbZEYUEU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 16:04:20 -0400
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: Andy Walls <awalls@radix.net>
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
Date: Mon, 25 May 2009 22:04:24 +0200
Cc: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org,
	Mike Isely <isely@isely.net>
References: <200905210909.43333.martin.dauskardt@gmx.de> <1243038686.3164.34.camel@palomino.walls.org> <200905252134.43249.martin.dauskardt@gmx.de>
In-Reply-To: <200905252134.43249.martin.dauskardt@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252204.24321.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, 25. Mai 2009 21:34:43 schrieb Martin Dauskardt:

> #define TUNER_PHILIPS_FM1216MK5         79
> result: picture o.k. , but audio disappears every few seconds (for about 1-2 
> seconds, then comes back) 

correction: This is not a problem of tuner type 79. It happens also with tuner 
type 38. Sometimes the audio is also muted after the start of the 
application. Only switching to another input and back brings the audio back.

I am beginning to wonder if this problem may be related to a similar problem 
with the PVRUSB2:
http://www.isely.net/pipermail/pvrusb2/2009-May/002331.html

If there is a problem with the new v4l2 sub-device mechanism, it seems to be 
more specific to some devices than to others. With my PVR350 I didn't notice 
such problems - although I remember that in **very** rare cases the audio 
fails after a channel switch.  

Greets, 
Martin

