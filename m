Return-path: <linux-media-owner@vger.kernel.org>
Received: from moh2-ve3.go2.pl ([193.17.41.208]:40039 "EHLO moh2-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1IWVPz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 17:15:55 -0400
Received: from moh2-ve3.go2.pl (unknown [10.0.0.208])
	by moh2-ve3.go2.pl (Postfix) with ESMTP id 01962373FB6
	for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 23:15:54 +0200 (CEST)
Received: from unknown (unknown [10.0.0.42])
	by moh2-ve3.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 23:15:53 +0200 (CEST)
Message-ID: <4E7CF707.7060800@o2.pl>
Date: Fri, 23 Sep 2011 23:15:51 +0200
From: Maciej Szmigiero <mhej@o2.pl>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Martin Wilks <m.wilks@technisat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Arnaud Lacombe <lacombar@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sven Barth <pascaldragon@googlemail.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH]Medion 95700 analog video support
References: <4E63C8A0.7030702@o2.pl> <CAOcJUbzXKVoOsfLA+YewyfDKmxuX0PgB8mWdfG49ArdS1fpyfA@mail.gmail.com> <4E7CDEB1.9090901@infradead.org> <CAOcJUby0dK_sjhTB3HEfdxkc9rsWU9KkZ=2B4O=Tcn4E90AE2w@mail.gmail.com> <c651371a-b2c4-4e95-bbb3-5b97a8b7281e@email.android.com>
In-Reply-To: <c651371a-b2c4-4e95-bbb3-5b97a8b7281e@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 23.09.2011 23:06, Andy Walls pisze:
> Michael Krufky <mkrufky@linuxtv.org> wrote:
> 
> The cx25840 part of the patch breaks ivtv, IIRC.  The patch really need to add board specific configuration and behavior to cx25840.  I'll have time tomorrow late afternoon to properly reviw and comment.
> 
> Regards,
> Andy

Have you already narrowed it down which part of the cx25840 patch breaks ivtv -
maybe it is setting the defaults at init or change to check for plain I2C instead of SMBus?

Best regards,
Maciej Szmigiero
