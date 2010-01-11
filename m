Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0AKAlt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 19:41:49 -0500
Message-ID: <4B4A73C9.5000702@infradead.org>
Date: Sun, 10 Jan 2010 22:41:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Muralidharan Karicheri <mkaricheri@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: building v4l-dvb - compilation error
References: <A69FA2915331DC488A831521EAE36FE40162D43370@dlee06.ent.ti.com>	 <4B48DC34.1080500@infradead.org> <55a3e0ce1001100554l76a8b7ccl42afdbc37498410a@mail.gmail.com>
In-Reply-To: <55a3e0ce1001100554l76a8b7ccl42afdbc37498410a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Muralidharan Karicheri wrote:
> Mauro,
> 
> I ran the build using my ubunto linux box at home and it has succeeded
> the build.
>>> make[2]: Leaving directory `/usr/src/kernels/2.6.9-55.0.12.EL-smp-i686'
>> The minimum supported version by the backport is 2.6.16.
> Hmm. Does that means, the build is using the kernel source code
> natively available at /usr/src/kernel. Is there a way to force it use
> a specific kernel source code?

Yes:
	make release DIR=<some dir>

After that, all subsequent compilations will use the new dir, provided
that you don't do a make distclean.

Cheers,
Mauro.
