Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2191 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814AbZE0GA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 02:00:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
Date: Wed, 27 May 2009 07:59:05 +0200
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org
References: <200905210909.43333.martin.dauskardt@gmx.de> <1243298465.3703.8.camel@pc07.localdom.local> <200905262221.31409.martin.dauskardt@gmx.de>
In-Reply-To: <200905262221.31409.martin.dauskardt@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905270759.05283.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 26 May 2009 22:21:31 Martin Dauskardt wrote:
> I should add that the picture quality is with all tested tuner types
> worse than with my PVR250/350. I don't know if a PVR150 is in generally
> worse than a PVR250. I can't call it really noisy, but in german I would
> say the picture is a little bit "grobkörnig". It really needs a temporal
> filter setting of value 8 or more, while my other PVR cards have a nice
> quality even with value 0.

It's always been my impression that the saa7115/msp3400 combo is superior to 
the cx2584x. I can't prove it, but the PVR150 picture quality is never as 
sharp as what I get with my PVR350.

Regards,

	Hans

> I will test whatever you guys want me to test :-)  But I am not a
> programmer, so I need detailled instructions what to patch.
>
> My next step will be testing an older v4l2 with an 2.6.27 kernel to see
> if the audio problem still exists.



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
