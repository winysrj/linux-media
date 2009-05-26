Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50431 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753231AbZEZUVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 16:21:20 -0400
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
Date: Tue, 26 May 2009 22:21:31 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@radix.net>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org
References: <200905210909.43333.martin.dauskardt@gmx.de> <1243287953.3744.93.camel@pc07.localdom.local> <1243298465.3703.8.camel@pc07.localdom.local>
In-Reply-To: <1243298465.3703.8.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905262221.31409.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I should add that the picture quality is with all tested tuner types worse 
than with my PVR250/350. I don't know if a PVR150 is in generally worse than 
a PVR250. I can't call it really noisy, but in german I would say the picture 
is a little bit "grobkörnig". It really needs a temporal filter setting of 
value 8 or more, while my other PVR cards have a nice quality even with value 
0. 

I will test whatever you guys want me to test :-)  But I am not a programmer, 
so I need detailled instructions what to patch.

My next step will be testing an older v4l2 with an 2.6.27 kernel to see if the 
audio problem still exists.
