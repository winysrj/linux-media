Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:53600 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaAHOaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 09:30:02 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ300LFX6Y15Z80@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 09:30:01 -0500 (EST)
Date: Wed, 08 Jan 2014 12:29:57 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 13/22] [media] em28xx: initialize audio latter
Message-id: <20140108122957.4ec25f91@samsung.com>
In-reply-to: <52CC3297.4020706@googlemail.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
 <1388832951-11195-14-git-send-email-m.chehab@samsung.com>
 <52C94207.1050101@googlemail.com> <20140105111750.353b5916@samsung.com>
 <52CC3297.4020706@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 07 Jan 2014 18:00:07 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 05.01.2014 14:17, schrieb Mauro Carvalho Chehab:
> > Em Sun, 05 Jan 2014 12:29:11 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> >>> Better to first write the GPIOs of the input mux, before initializing
> >>> the audio.
> >> Why are you making this change ?
> >>

...

> Let's not walk needlessly into the same trap with yet another piece of code.

Good point. I'll drop this one.

Regards,
Mauro
