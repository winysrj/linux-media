Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3603 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZAOH1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 02:27:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: CityK <cityk@rogers.com>
Subject: Re: KWorld ATSC 115 all static
Date: Thu, 15 Jan 2009 08:27:39 +0100
Cc: hermann pitton <hermann-pitton@arcor.de>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
References: <496A9485.7060808@gmail.com> <200901141924.41026.hverkuil@xs4all.nl> <496EC328.7040004@rogers.com>
In-Reply-To: <496EC328.7040004@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901150827.40100.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 15 January 2009 06:01:28 CityK wrote:
> Hans Verkuil wrote:
> > OK, I couldn't help myself and went ahead and tested it. It seems
> > fine, so please test my tree:
> >
> > http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7134
> >
> > Let me know if it works.
>
> Hi Hans,
>
> It didn't work.  No analog reception on either RF input.  (as Mauro
> noted, DVB is unaffected; it still works).
>
> dmesg output looks right:
>
> tuner-simple 1-0061: creating new instance
> tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual
> in)
>
> I tried backing out of the modules and then reloading them, but no
> change.  (including after fresh build or after rebooting)

Can you give the full dmesg output? Also, is your board suppossed to 
have a tda9887 as well?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
