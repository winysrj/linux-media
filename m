Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppp250-191.static.internode.on.net ([203.122.250.191]:56856
	"EHLO wiggum.skunkworks.net.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755689AbZE0Dym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 23:54:42 -0400
Message-ID: <4A1CB353.7020906@symons.net.au>
Date: Wed, 27 May 2009 12:58:19 +0930
From: Ant <ant@symons.net.au>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: hermann pitton <hermann-pitton@arcor.de>,
	Martin Dauskardt <martin.dauskardt@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
References: <200905210909.43333.martin.dauskardt@gmx.de>	 <1243287953.3744.93.camel@pc07.localdom.local>	 <1243298465.3703.8.camel@pc07.localdom.local>	 <200905262221.31409.martin.dauskardt@gmx.de>	 <1243383329.6682.27.camel@pc07.localdom.local> <1243389830.4046.52.camel@palomino.walls.org>
In-Reply-To: <1243389830.4046.52.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> Hermann,
>
> There is an FQ1216LME MK3 data sheet here:
>
> http://dl.ivtvdriver.org/datasheets/tuners/FQ1216LME%20Mk3.pdf
>
> Is it safe to assume that the MK5 is not very different from the MK3?
>   
I am no expert on the subject, but I found this reference to the MK3 vs MK5:

http://www.nxp.com/acrobat_download/other/products/rf/fq_mk5.pdf

Where it says

"The FQ1200 MK5 family is identical in footprint to the
FQ1200 MK3 series, ensuring a quick drop-in replacement."

If the MK5 family is designed as a drop in replacement for the MK3 
family, I would think there is a good chance it functions exactly the same.

Anthony


