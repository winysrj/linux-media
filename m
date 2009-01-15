Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp111.rog.mail.re2.yahoo.com ([206.190.37.1]:40417 "HELO
	smtp111.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754464AbZAOFBi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 00:01:38 -0500
Message-ID: <496EC328.7040004@rogers.com>
Date: Thu, 15 Jan 2009 00:01:28 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: hermann pitton <hermann-pitton@arcor.de>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
References: <496A9485.7060808@gmail.com> <496D6CF6.6030005@rogers.com> <200901140837.43282.hverkuil@xs4all.nl> <200901141924.41026.hverkuil@xs4all.nl>
In-Reply-To: <200901141924.41026.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> OK, I couldn't help myself and went ahead and tested it. It seems fine, 
> so please test my tree: 
>
> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7134
>
> Let me know if it works. 

Hi Hans,

It didn't work.  No analog reception on either RF input.  (as Mauro
noted, DVB is unaffected; it still works).

dmesg output looks right:

tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)

I tried backing out of the modules and then reloading them, but no
change.  (including after fresh build or after rebooting)

