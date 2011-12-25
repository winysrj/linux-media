Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab1LYLSY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 06:18:24 -0500
Message-ID: <4EF7066C.4070806@redhat.com>
Date: Sun, 25 Dec 2011 09:18:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	Georgi Chorbadzhiyski <gf@unixsol.org>,
	linux-media@vger.kernel.org
Subject: Re: DVB-S2 multistream support
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi> <4EF6F84C.3000307@redhat.com> <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com>
In-Reply-To: <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25-12-2011 08:55, Konstantin Dimitrov wrote:
> On Sun, Dec 25, 2011 at 12:17 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> 
>> That's said, the approach there assumes that just one mis can be filtered. I'm wandering
>> if it wouldn't be better to use the same approach taken inside dvb-core for PIP filtering.
> 
> i'm not sure that i understand correctly what you mean, but i can't
> see way how to filter more that one mis stream at the same time,
> because their id is stored in the bbheader. so, even if we assume it's
> possible to send two ids for filtering to the hardware and then it
> outputs ts packets from both of them there is still no way to know
> which ts packet to which mis stream belongs, because the bbheader is
> stripped inside the demodulator before the data are outputted. in fact
> if you don't set any id for filtering to mis capable hardware then
> usually it outputs the ts packets from all of the streams and that's
> why the outputted stream looks corrupted, because it contains ts
> packets from all mis streams and that's why you what to set id for
> filtering to the hardware in the first place - to make it output ts
> packets just from one selected stream. however, if dvb-core has
> support for bbframes like the following unfortunately lost work:
> 
> http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022217.html

Yes, I'm meaning something like what it was described there. I think
that the code written by Christian were never submitted upstream.

> then instead setting mis filtering in the hardware you can force it to
> output bbframes (at least currently all mis capable hardware is
> supposed to be able to output bbframes) and then filter all streams in
> the software, which would be significantly more flexible, because that
> way all streams can be filtered and used in the same time.

While your hardware supports filtering only one MIS, other hardware may
support more. Anyway, it makes sense to add a software filter, and to
add a way to deliver the mis information to userspace, if more than one
mis is filtered.

Regards,
Mauro
