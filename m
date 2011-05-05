Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab1EELLP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 07:11:15 -0400
Message-ID: <4DC285C4.4000409@redhat.com>
Date: Thu, 05 May 2011 08:11:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>, tomekbu@op.pl,
	Steven Stoth <stoth@kernellabs.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?B?SGVybsOhbiBPcmRpYWxlcw==?= <h.ordiales@gmail.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: Patches still pending at linux-media queue (18 patches)
References: <4DC2207B.5030700@redhat.com> <c3c9cb1f-6198-440a-956f-11d07c3f4504@email.android.com>
In-Reply-To: <c3c9cb1f-6198-440a-956f-11d07c3f4504@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 07:13, Andy Walls escreveu:
> 
> Mauro,
> 
> Since the original cx18 mmap() patch was commited, the cx18 mmap() cleanup patch is definitely needed: the YUV stream can lose frame alignment without it.
> 
> I took a quick look at the cx18 mmap() cleanup patch:
> 
> Acked-by: Andy Walls <awalls@md.metrocast.net>
> 
> The cx18 version bump patch is trivial:
> 
> Acked-by: Andy Walls <awalls@md.metrocast.net>

Ok, thank you!

Applied both.

Mauro.
