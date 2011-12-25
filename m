Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33787 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1LYKzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 05:55:38 -0500
Received: by wibhm6 with SMTP id hm6so3944572wib.19
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 02:55:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF6F84C.3000307@redhat.com>
References: <4EF67721.9050102@unixsol.org>
	<4EF6DD91.2030800@iki.fi>
	<4EF6F84C.3000307@redhat.com>
Date: Sun, 25 Dec 2011 12:55:35 +0200
Message-ID: <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com>
Subject: Re: DVB-S2 multistream support
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Georgi Chorbadzhiyski <gf@unixsol.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 25, 2011 at 12:17 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

> That's said, the approach there assumes that just one mis can be filtered. I'm wandering
> if it wouldn't be better to use the same approach taken inside dvb-core for PIP filtering.

i'm not sure that i understand correctly what you mean, but i can't
see way how to filter more that one mis stream at the same time,
because their id is stored in the bbheader. so, even if we assume it's
possible to send two ids for filtering to the hardware and then it
outputs ts packets from both of them there is still no way to know
which ts packet to which mis stream belongs, because the bbheader is
stripped inside the demodulator before the data are outputted. in fact
if you don't set any id for filtering to mis capable hardware then
usually it outputs the ts packets from all of the streams and that's
why the outputted stream looks corrupted, because it contains ts
packets from all mis streams and that's why you what to set id for
filtering to the hardware in the first place - to make it output ts
packets just from one selected stream. however, if dvb-core has
support for bbframes like the following unfortunately lost work:

http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022217.html

then instead setting mis filtering in the hardware you can force it to
output bbframes (at least currently all mis capable hardware is
supposed to be able to output bbframes) and then filter all streams in
the software, which would be significantly more flexible, because that
way all streams can be filtered and used in the same time.
