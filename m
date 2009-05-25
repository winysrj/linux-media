Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39725 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751519AbZEYTeh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 15:34:37 -0400
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: Andy Walls <awalls@radix.net>
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
Date: Mon, 25 May 2009 21:34:43 +0200
Cc: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org
References: <200905210909.43333.martin.dauskardt@gmx.de> <1242901704.3166.8.camel@palomino.walls.org> <1243038686.3164.34.camel@palomino.walls.org>
In-Reply-To: <1243038686.3164.34.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252134.43249.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> #define TUNER_PHILIPS_FQ1216ME          24      /* you must actively select 
B/G/D/K, I, L, L` */
> #define TUNER_PHILIPS_FQ1216AME_MK4     56      /* Hauppauge PVR-150 PAL */
> 
> #define TUNER_PHILIPS_FM1216ME_MK3      38
> 
> #define TUNER_PHILIPS_FMD1216ME_MK3     63
> #define TUNER_PHILIPS_FMD1216MEX_MK3    78
> #define TUNER_PHILIPS_FM1216MK5         79
> 
> Could the user try one of those, starting with the FQ1216 tuner numbers
> (24 and 56), to see if one of them works?  For the FQ1261LME MK3,
> tveeprom has the FM1216ME_MK3 tuner number (38).
> 

I have this card now at home for testing. First results:

#define TUNER_PHILIPS_FQ1216ME		24	/* you must actively select B/G/D/K, I, L, 
Result: only static

#define TUNER_PHILIPS_FM1216ME_MK3	38
result: picture + sound o.k.

#define TUNER_PHILIPS_FQ1216AME_MK4	56	/* Hauppauge PVR-150 PAL */
result: picture o.k., but no sound

#define TUNER_PHILIPS_FMD1216ME_MK3	63
result: picture + sound o.k.

#define TUNER_PHILIPS_FMD1216MEX_MK3	78
result: picture + sound o.k.

#define TUNER_PHILIPS_FM1216MK5         79
result: picture o.k. , but audio disappears every few seconds (for about 1-2 
seconds, then comes back) 

tuner type 63 and 79 are Hybrid tuners. This is fore sure an analogue-only 
tuner. The sticker says "Multi-PAL", and according to VIDIOC_ENUMSTD  it 
supports PAL, PAL-BG and PAL-H. 

So I think 38 is right. Any suggestions for further tests?
