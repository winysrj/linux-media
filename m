Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59842 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750969AbZEWH1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 03:27:04 -0400
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: Andy Walls <awalls@radix.net>
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
Date: Sat, 23 May 2009 09:27:08 +0200
Cc: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org
References: <200905210909.43333.martin.dauskardt@gmx.de> <1242901704.3166.8.camel@palomino.walls.org> <1243038686.3164.34.camel@palomino.walls.org>
In-Reply-To: <1243038686.3164.34.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905230927.08564.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

> Martin,
> 
> I don't see tuner type 81 in the list in tuners.h.  I do see:
> 
> 
> #define TUNER_PHILIPS_FQ1216ME          24      /* you must actively select 
B/G/D/K, I, L, L` */
> #define TUNER_PHILIPS_FQ1216AME_MK4     56      /* Hauppauge PVR-150 PAL */
> 
> #define TUNER_PHILIPS_FM1216ME_MK3      38
> 
> #define TUNER_PHILIPS_FMD1216ME_MK3     63
> #define TUNER_PHILIPS_FMD1216MEX_MK3    78
> #define TUNER_PHILIPS_FM1216MK5         79

ah, sorry. I looked into hauppauge_tuner[] from tveeprom.c and also misread 
the internal number 80 as 81:

	/* 80-89 */
	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FQ1216LME MK3"},

> 
> Could the user try one of those, starting with the FQ1216 tuner numbers
> (24 and 56), to see if one of them works?  For the FQ1261LME MK3,
> tveeprom has the FM1216ME_MK3 tuner number (38).

I hope to get in contact with him this weekend. There is another problems with 
the application which must be solved before, but I am sure we will found out 
the right tuner type at the end.

Greets,
Martin
