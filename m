Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2LXPQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 10:16:51 -0500
Date: Mon, 24 Dec 2012 13:16:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: module parameter prefer_bulk ?
Message-ID: <20121224131625.128de19c@redhat.com>
In-Reply-To: <50D83BB2.4070308@googlemail.com>
References: <50D83BB2.4070308@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 24 Dec 2012 12:25:38 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Hi Mauro,
> 
> now that we prefer bulk transfers for webcams and isoc transfers for TV,
> I wonder if prefer_bulk is still a good name for this module parameter.
> What about something like 'usb_mode', 'usb_xfer_mode' or
> 'frame_xfer_mode' with 0=auto, 1=prefer isoc, 2=prefer bulk ?

while keeping it as-is is not bad, IMHO, we can change it if people prefer
renaming it.

usb_xfer_mode sounds good for me. Feel free to submit a patch if you want.

It should be noticed that we can change it while it was not upstreamed. 

With regards to the range, we generally use -1 for "auto" (at least, we do
that on several other places).

-- 

Cheers,
Mauro
