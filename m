Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab2DZNZM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 09:25:12 -0400
Message-ID: <4F994CA8.8060200@redhat.com>
Date: Thu, 26 Apr 2012 10:24:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com>, <201204152353103757288@gmail.com>, <201204201601166255937@gmail.com>, <4F9130BB.8060107@iki.fi>, <201204211045557968605@gmail.com>, <4F958640.9010404@iki.fi>, <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com> <201204262103053283195@gmail.com>
In-Reply-To: <201204262103053283195@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-04-2012 10:03, nibble.max escreveu:

> Hello,
> I finish the following works.
> 1)split the montage dvb-s2 frontend into tuner and demodulator files.

Send this patch first. As both tuner and demod drivers were written by
Konstantin, just make sure to preserve the existing copyrights as-is.

After having this patch approved/merged, we can dig into the next ones.

> 2)Fix the issues as Mauro addressed before.
> 3)Pass scripts/checkpatch.pl check.
> So what is the next step for me?
> Is there any schedule of Konstantin's work?
> Br,
> Max
> 

Thanks!
Mauro
