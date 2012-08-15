Return-path: <linux-media-owner@vger.kernel.org>
Received: from d154113.artnet.pl ([37.28.154.113]:43277 "EHLO pseudon.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2HOLaI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 07:30:08 -0400
Message-ID: <502B8077.3040700@maciej.szmigiero.name>
Date: Wed, 15 Aug 2012 12:56:55 +0200
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Andy Walls <awalls@md.metrocast.net>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Martin Wilks <m.wilks@technisat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sven Barth <pascaldragon@googlemail.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH]Medion 95700 analog video support
References: <4E63C8A0.7030702@o2.pl>  <CAOcJUbzXKVoOsfLA+YewyfDKmxuX0PgB8mWdfG49ArdS1fpyfA@mail.gmail.com>  <4E7CDEB1.9090901@infradead.org>  <CAOcJUby0dK_sjhTB3HEfdxkc9rsWU9KkZ=2B4O=Tcn4E90AE2w@mail.gmail.com>  <c651371a-b2c4-4e95-bbb3-5b97a8b7281e@email.android.com>  <4E7CF707.7060800@o2.pl> <1316895712.12899.84.camel@palomino.walls.org>  <4E80F080.7030500@o2.pl> <1317081213.2345.13.camel@palomino.walls.org> <4E88B797.2020104@o2.pl> <50298F27.7020707@redhat.com>
In-Reply-To: <50298F27.7020707@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 14.08.2012 01:35, Mauro Carvalho Chehab pisze:
> Em 02-10-2011 16:12, Maciej Szmigiero escreveu:
>> Updated patch with Andy's suggestion to make changes to cx25840 driver
>> conditional on platform_data flag and fixed few typos.
>> Reverted changes to cx25840 driver VBI code - will think of them when
>> we have VBI implemented in cxusb and, by extension, a way to test them.
>>
>> Also fixed small chroma bug with S-Video input.
>>
>> This still needs the patch for v4l2-device.c::v4l2_device_unregister
>> applied first.
>>
>> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
> 
> 
> This patch is stil on my queue, not sure why it wasn't applied (probably
> because I was waiting for Andy/Michael's ack):
> 	http://patchwork.linuxtv.org/patch/8048/
> 
> Is it ok to apply? If so, could you please rebase it. It doesn't apply
> anymore, due to the MFE changes at dvb-usb. It shouldn't be hard to fix,
> as it should be just parameter names.
> 
> Regards,
> Mauro
> 

Hello Mauro,

I will dust off the device, rebase and retest the patch as soon as have
some spare time (should happen in 2-3 weeks).

Best regards,
Maciej Szmigiero
