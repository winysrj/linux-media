Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:50955
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZL2SMq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 13:12:46 -0500
Message-ID: <4B3A4698.4080705@wilsonet.com>
Date: Tue, 29 Dec 2009 13:12:40 -0500
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Jarod Wilson <jarod@redhat.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: imon driver for SoundGraph iMON/Antec Veris IR
 devices
References: <20091228051155.GA14301@redhat.com> <20091229164856.GA29476@bicker>
In-Reply-To: <20091229164856.GA29476@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/29/2009 12:01 PM, Dan Carpenter wrote:
>
> I ran smatch (http://repo.or.cz/w/smatch.git) on it and there are
> some bugs worth fixing.
>
> drivers/input/misc/imon.c +331 free_imon_context(7) error: dereferencing freed memory 'context'
> Move the debug line earlier.
>
> drivers/input/misc/imon.c +1812 imon_probe(216) error: dereferencing undefined:  'context->idev'
> drivers/input/misc/imon.c +1876 imon_probe(280) error: dereferencing undefined:  'context->touch'
> The allocation func can return NULL.  They probably won't fail in real
> life, but it will slightly annoy every person checking running smatch
> over the entire kernel (me).
>
> drivers/input/misc/imon.c +1979 imon_probe(383) error: double unlock 'mutex:&context->lock'
> drivers/input/misc/imon.c +1983 imon_probe(387) error: double unlock 'mutex:&context->lock'
> It sometimes unlocks both before and after the goto.

Yeah, I think I've actually already fixed every one of these problems in 
the past 24 hours (a few just a few minutes ago), stay tuned for a 
repost, hopefully later today. :)

Thanks much,

-- 
Jarod Wilson
jarod@wilsonet.com
